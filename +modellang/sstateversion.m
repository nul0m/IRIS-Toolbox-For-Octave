% !!  Steady-state version of an equation.
%
% Syntax
% =======
%
%     Equation !! SteadyStateEquation;
%
% Description
% ============
%
% For each transition or measurement equation, you can provide a separate
% steady-state version of it. The steady-state version is used when you run
% the [`sstate`](model/sstate) function. This is useful when you can
% substantially simplify some parts of the dynamic equations, and help
% therefore the numerical solver to achieve faster and more accurate
% results.
%
% Why is a double exclamation point, `!!`, used to start the steady-state
% versions of equations? Because if you associate your model file extension
% with the Matlab editor, anything after an exclamation point is displayed
% red making it easier to spot the steady-state equations.
%
% Example
% ========
%
% The following steady state version will be, of course, valid only in
% stationary models where we can safely remove lags and leads.
%
%     Lambda = Lambda{1}*(1+r)*beta !! r = 1/beta - 1;
%
% Example
% ========
%
%     log(A) = log(A{-1}) + epsilon_a !! A = 1;
%

% -IRIS Toolbox.
% -Copyright (c) 2007-2014 IRIS Solutions Team.
