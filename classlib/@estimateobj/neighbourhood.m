function [d,FigH,AxH,ObjH,LikH,EstH,BH] ...
    = neighbourhood(This,POS,Pct,varargin)
% neighbourhood  Evaluate the local behaviour of the objective function around the estimated parameter values.
%
% Syntax
% =======
%
%     [D,FigH,AxH,ObjH,LikH,EstH,BH] = neighbourhood(M,PS,Neigh,...)
%
% Input arguments
% ================
%
% * `M` [ model | bkwmodel ] - Model or bkwmodel object.
%
% * `PS` [ poster ] - Posterior simulator (poster) object returned by
% the [`model/estimate`](model/estimate) function.
%
% * `Neigh` [ numeric ] - The neighbourhood in which the objective function
% will be evaluated defined as multiples of the parameter estimates.
%
% Output arguments
% =================
%
% * `D` [ struct ] - Struct describing the local behaviour of the objective
% function and the data likelihood (minus log likelihood) within the
% specified range around the optimum for each parameter.
%
% The following output arguments are non-empty only if you choose `'plot='`
% true:
%
% * `FigH` [ numeric ] - Handles to the figures created.
%
% * `AxH` [ numeric ] - Handles to the axes objects created.
%
% * `ObjH` [ numeric ] - Handles to the objective function curves plotted.
%
% * `LikH` [ numeric ] - Handles to the data likelihood curves plotted.
%
% * `EstH` [ numeric ] - Handles to the actual estimate marks plotted.
%
% * `BH` [ numeric ] - Handles to the bounds plotted.
%
% Options
% ========
%
% * `'plot='` [ *`true`* | `false` ] - Call the
% [`grfun.plotneigh`](grfun/plotneigh) function from within `neighbourhood`
% to visualise the results.
%
% * `'neighbourhood='` [ struct | *empty* ] - Struct specifying the
% neighbourhood points for some of the parameters; these points will be
% used instead of those based on `Neigh`.
%
% Plotting options
% =================
%
% See help on [`grfun.plotneigh`](grfun/plotneigh) for options available
% when you choose `'plot='` true.
%
% Description
% ============
%
% In the output database, `D`, each parameter is a 1-by-3 cell array.
% The first cell is a vector of parameter values at which the local
% behaviour was investigated. The second cell is a matrix with two column
% vectors: the values of the overall minimised objective function (as set
% up in the [`estimate`](model/estimate) function), and the values of the
% data likelihood component. The third cell is a vector of four numbers:
% the parameter estimate, the value of the objective function at optimum,
% the lower bound and the upper bound.
%
% Example
% ========
%

% -IRIS Toolbox.
% -Copyright (c) 2007-2013 IRIS Solutions Team.

% Parse required input arguments.
pp = inputParser();
if ismatlab
pp.addRequired('M',@(x) isa(x,'estimateobj'));
pp.addRequired('Pos',@(x) isa(x,'poster'));
pp.addRequired('Pct',@isnumeric);
pp.parse(This,POS,Pct);
else
pp = pp.addRequired('M',@(x) isa(x,'estimateobj'));
pp = pp.addRequired('Pos',@(x) isa(x,'poster'));
pp = pp.addRequired('Pct',@isnumeric);
pp = pp.parse(This,POS,Pct);
end

% Parse options.
[opt,varargin] = passvalopt('model.neighbourhood',varargin{:});

%--------------------------------------------------------------------------

FigH = [];
AxH = [];
ObjH = [];
LikH = [];
EstH = [];
BH = [];

d = struct();
pList = POS.paramList;
pStar = POS.initParam;
np = numel(pList);
nPct = numel(Pct);
man = opt.neighbourhood;

if opt.progress
    msg = sprintf('IRIS %s.neighbourhood progress',class(This));
    progress = progressbar(msg);
end

for i = 1 : np
    x = cell(1,3);
    % `x{1}` is the vector of x-axis points at which the log posterior is
    % evaluated.
    if isstruct(man) && isfield(man,pList{i})
        n = numel(man.(pList{i}));
        pp = cell(1,n);
        pp(:) = {pStar};
        for j = 1 : n
            pp{j}(i) = man.(pList{i})(j);
            x{1}(end+1,1) = pp{j}(i);
        end
    else
        n = nPct;
        pp = cell(1,n);
        pp(:) = {pStar};
        for j = 1 : nPct
            pp{j}(i) = pStar(i)*Pct(j);
            x{1}(end+1,1) = pp{j}(i);
        end
    end
    % `x{2}` first column is minus the log posterior, second column is minus
    % the log likelihood.
    x{2} = zeros(n,2);
    % The function `eval` returns log posterior, not minus log posterior.
    [x{2}(:,1),x{2}(:,2)] = eval(POS,pp{:}); %#ok<EVLC>
    x{2} = -x{2};
    % `x{3}` is a vector of auxiliary information.
    x{3} = [POS.initParam(i),-POS.initLogPost, ...
        POS.lowerBounds(i),POS.upperBounds(i)];
    d.(pList{i}) = x;
    if opt.progress
        update(progress,i/np);
    end
end

if opt.plot
    [FigH,AxH,ObjH,LikH,EstH,BH] = grfun.plotneigh(d,varargin{:});
end

end