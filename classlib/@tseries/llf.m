function varargout = llf(X,Range,varargin)
% llf  Local level filter (aka random walk plus white noise) with tunes.
%
% Syntax
% =======
%
%     [T,C,CutOff,Lambda] = llf(X)
%     [T,C,CutOff,Lambda] = llf(X,Range,...)
%
% Syntax with output arguments swapped
% =====================================
%
%     [C,T,CutOff,Lambda] = llf2(X)
%     [C,T,CutOff,Lambda] = llf2(X,Range,...)
%
% Input arguments
% ================
%
% * `X` [ tseries ] - Input tseries object that will be filtered.
%
% * `Range` [ numeric ] - Date range on which the input data will be
% filtered; `Range` can be `Inf`, `[startdata,Inf]`, or `[-Inf,enddate]`;
% if not specifired, `Inf` (i.e. the entire available range of the input
% series) is used.
%
% Output arguments
% =================
%
% * `T` [ tseries ] - Low-frequency (trend) component.
%
% * `C` [ tseries ] - High-frequency (cyclical or gap) component.
%
% * `CutOff` [ numeric ] - Cut-off periodicity; periodicities above the
% cut-off are attributed to trends, periodicities below the cut-off are
% attributed to gaps.
%
% * `Lambda` [ numeric ] - Smoothing parameter actually used; this output
% argument is useful when the option `'cutoff='` is used instead of
% `'lambda='`.
%
% Options
% ========
%
% * `'cutoff='` [ numeric | *empty* ] - Cut-off periodicity in periods
% (depending on the time series frequency); this option can be specified
% instead of `'lambda='`; the smoothing parameter will be then determined
% based on the cut-off periodicity.
%
% * `'cutoffYear='` [ numeric | *empty* ] - Cut-off periodicity in years;
% this option can be specified instead of `'lambda='`; the smoothing
% parameter will be then determined based on the cut-off periodicity.
%
% * `'gamma='` [ numeric | tseries | *1* ] - Weight or weights on the
% deviations of the trend from observations; it only makes sense to use
% this option to make the signal-to-noise ratio time-varying; see the
% optimisation problem below.
%
% * `'drift='` [ numeric | tseries | *`0`* ] - Deterministic drift in the
% trend.
%
% `'infoSet='` [ `1` | *`2`* ] - Information set assumption used in the
% filter: `1` runs a one-sided filter, `2` runs a two-sided filter.
%
% * `'lambda='` [ numeric | *`10 freq`* ] - Smoothing parameter; needs to
% be specified for tseries objects with indeterminate frequency.
%
% * `'level='` [ tseries ] - Time series with soft and hard tunes on the
% level of the trend.
%
% * `'change='` [ tseries ] - Time series with soft and hard tunes on the
% change in the trend.
%
% * `'log='` [ `true` | *`false`* ] - Logarithmise the data before
% filtering, de-logarithmise afterwards.
%
% Description
% ============
%
% The underlying optimisation problem
% ------------------------------------
%
% The function `llf` solves a constrained optimisation problem described by
% the following Lagrangian
% 
% $$\min_{\bar y_t, \omega_t, \sigma_t}
% \underbrace{
% \tsum \lambda \left( \Delta \bar y_t - \delta_t \right)^2
% + \tsum \gamma_t \left( \bar y_t - y_t \right)^2}_\text{Plain local level
% filter with time-varying signal-to-noise ratio} + \cdots$$     $$\cdots +
% \underbrace{\tsum u_t \left( \bar y_t - a_t \right)^2}_\text{Soft level tunes}
% + \underbrace{\tsum v_t \left( \Delta \bar y_t - b_t
% \right)^2}_\text{Soft growth tunes} +
% \underbrace{\tsum \omega_t \left( \bar y_t - c_t \right)}_\text{Hard level tunes}
% + \underbrace{\tsum \sigma_t \left( \Delta \bar y_t - d_t
% \right)}_\text{Hard growth tunes},$$
%
% where
% 
% * $\Delta$ is the first-difference operator;
% * $\lambda$ is a (scalar) smoothing parameter;
% * $y_t$ are user-supplied observations;
% * $\bar y_t$ is the fitted trend;
% * $\delta_t$ is a user-supplied drift, either constant or time-varying,
% enetered in the option `'drift='`;
% * $\gamma_t$ are user-supplied weights to modify the basic
% signal-to-noise ratio over time (the default setting is $\gamma_t=1$),
% entered in the option `'gamma='`;
% * $a_t$ and $u_t$ are soft tunes on the level of the trend and the
% weights associated with these soft level tunes, respectively, entered
% together as complex numbers in the option `'level='`;
% * $b_t$ and $v_t$ are soft tunes on the change in the level of the trend
% and the weights associated with these soft growth tunes, respectively,
% entered together as complex numbers in the option `'growth='`;
% * $c_t$ are hard tunes on the level of the trend, entered as real numbers
% in the option `'level='`;
% * $d_t$ are hard tunes on the change in the level of the trend, entered
% as real numbers in the option `'growth='`;
% * $\omega_t$ are lagrange multipliers on the hard level tunes (note that
% these are computed as part of the optimisation problem, not entered by
% the user);
% * $\sigma_t$ are lagrange multipliers on the hard growth tunes (note that
% these are computed as part of the optimisation problem, not entered by
% the user).
%
% Each of the summations in the above Lagrangian goes over those periods in
% which the respective bracketed terms are defined (observations or tunes
% exist). You can combine any number of any tunes in one run of `llf`,
% including out-of-sample tunes (see below).
%
% How to enter the tunes
% -----------------------
%
% * The soft and hard tunes on the level of the trend are entered as time
% series through the option `'level='`.
%
% * The soft and hard tunes on the change in the trend are entered as time
% series through the option `'change='`.
%
% * In the tseries objects entered through `'level='` and/or `'change='`,
% you can combine any number of hard and soft tune. In each particular
% period, you can obviously specify only a hard tune or only a soft tune.
% You can think of hard tunes as a special case of soft tunes with
% infinitely large weights.
%
% * A hard tune is specified as a plain real number (i.e. a number with a
% zero complex part).
%
% * A soft tune must be entered as a complex number whose real part
% specifies the tune itself, and the imaginary part specifies the *inverse*
% of the weight, i.e. $1/v_t$ or $1/u_t$, on that tune in that period. Note
% that if the weight goes to infinity, the imaginary part becomes zero and
% the tune becomes a hard tune.
%
% Out-of-sample tunes
% --------------------
% 
% Tunes can be imposed also at dates before the first observation of the
% input series, or after the last observation. In other words, the time
% series in `'level='` and/or `'growth='` can have a more extended range
% (at either side) than the filtered input series.
%
% Default smoothing parameters
% ------------------------------
%
% If the user does not specify the smoothing parameter using the
% `'lambda='` option, a default value is used. The default value is based
% on common practice and can be calculated using the date frequency of the
% input time series as `\lambda = 10 \cdot f`, where `f` is the frequency
% (yearly=1, half-yearly=2, quarterly=4, bi-monthly=6, monthly=12). This
% gives the following default values:
%
% * 10 for yearly time series (cut-off periodicity of 19.79 years);
% * 20 for half-yearly time series (cut-off periodicity of 14.02 years);
% * 40 for quarterly time series (cut-off periodicity of 9.92 years);
% * 60 for bi-monthly time series (cut-off periodicity of 8.11 years);
% * 120 for monthly time series (cut-off periodicity of 5.73 years).
%
% Note that there is no default value for data with indeterminate or daily
% frequency: for these types of time series, you must always use the option
% `'lambda=''.
%
% Example
% ========
%

% -IRIS Toolbox.
% -Copyright (c) 2007-2013 IRIS Solutions Team.

% BWF, HPF, LLF

%#ok<*VUNUS>
%#ok<*CTCH>

if ~isempty(varargin) && ~ischar(varargin{1})
    Range = varargin{1};
    varargin(1) = [];
else
    Range = Inf;
end

if isempty(Range)
    varargout{1} = empty(X);
    varargout{2} = empty(X);
    varargout{3} = NaN;
    varargout{4} = NaN;
    return
end

%--------------------------------------------------------------------------

[varargout{1:nargout}] = myfilter(X,Range,1,varargin{:});

end