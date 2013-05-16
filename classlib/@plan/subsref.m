function This = subsref(This,S)
% subsref  Subscripted reference for plan objects.
%
% Syntax
% =======
%
%     P = P(StartDate:EndDate)
%     P = P{Shift}
%
% Input arguments
% ================
%
% * `P` [ plan ] - Simulation plan.
%
% Output aguments
% ================
%
% * `P` [ plan ] - Simulation plan reduced, expanded, or shifted to the new
% range,
%
% * `StartDate` [ numeric ] - New start date for the simulation plan.
%
% * `EndDate` [ numeric ] - New end date for the simulation plan.
%
% * `Shift` [ numeric ] - Lag or lead by which the simulation plan range
% will be shifted.
%
% Description
% ============
%
% Example
% ========
%

% -IRIS Toolbox.
% -Copyright (c) 2007-2013 IRIS Solutions Team.

%--------------------------------------------------------------------------

if isequal(S(1).type,'{}') ...
        && length(S(1).subs) == 1 && length(S(1).subs{1}) == 1
    shift = S(1).subs{1}(1);
    This.startDate = This.startDate + shift;
    This.endDate = This.endDate + shift;
    S(1) = [];
    if ~isempty(S)
        This = builtin('subsref',This,S);
    end
elseif isequal(S(1).type,'()') ...
        && length(S(1).subs) == 1
    newRange = S(1).subs{1};
    if ~datcmp(This.startDate,newRange(1)) ...
            || ~datcmp(This.endDate,newRange(end))
        This = mychngrange(This,newRange);
    end
elseif isequal(S(1).type,'.')
    This = builtin('subsref',This,S(1));
    S(1) = [];
    if ~isempty(S)
        This = builtin('subsref',This,S);
    end
else
    utils.error('plan', ...
        'Invalid subscripted reference to a plan object.');
end

end