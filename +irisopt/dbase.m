function Def = dbase()
% dbase  [Not a public function] Default options for dbase functions.
%
% Backend IRIS function.
% No help provided.

% -IRIS Toolbox.
% -Copyright (c) 2007-2013 IRIS Solutions Team.

%--------------------------------------------------------------------------

Def = struct();

config = irisget();

dateformat = { ...
    'dateformat','config',config.validate.dateformat, ...
    'freqletters,freqletter','config',config.validate.freqletters, ...
    'months,month','config',config.validate.months, ...
    'standinmonth','config',config.validate.standinmonth, ...
    };

Def.dbbatch = {
    'append',[],@(x) isempty(x) || islogical(x), ...
    'classlist,classfilter',Inf,@(x) (isnumeric(x) && isinf(x)) || ischar(x) || iscellstr(x), ...
    'freqfilter',Inf,@isnumeric, ...
    'merge',[],@(x) isempty(x) || islogical(x), ...
    'namefilter','',@(x) isempty(x) || (isnumeric(x) && isinf(x)) || ischar(x), ...
    'namelist',Inf,@(x) (isnumeric(x) && isinf(x)) || ischar(x) || iscellstr(x), ...
    'fresh',false,@(x) islogical(x) || isstruct(x), ...
    'stringlist',{},@(x) iscellstr(x) || ischar(x), ...
    };

Def.dbload = { ...
    dateformat{:}, ...
    'case,changecase','',@(x) isempty(x) || any(strcmpi(x,{'lower','upper'})), ...
    'commentrow',{'comment','comments'},@(x) ischar(x) || iscellstr(x), ...
    'convert',[],@(x) (isnumericscalar(x) && any(x == [1,2,4,6,12,52])) ...
    || (iscell(x) && iscellstr(x(3:2:end)) && isnumericscalar(x{1}) && any(x{1} == [1,2,4,6,12,52]) && isnumeric(x{2})), ...
    'delimiter',',',@(x) ischar(x) && length(sprintf(x)) == 1, ...
    'firstdateonly',false,@islogicalscalar, ...
    'inputformat','auto',@(x) ischar(x) && (strcmpi(x,'auto') || strcmpi(x,'csv') || strncmpi(x,'xl',2)), ...
    'namerow,leadingrow',{'','variables'},@(x) ischar(x) || iscellstr(x) || isnumericscalar(x), ...
    'namefunc',[],@(x) isempty(x) || isfunc(x) || (iscell(x) && all(cellfun(@isfunc,x))), ...
    'freq',[],@(x) isempty(x) || (ischar(x) && strcmpi(x,'daily')) || (length(x) == 1 && isnan(x)) || (isnumeric(x) && length(x) == 1 && any(x == [0,1,2,4,6,12,52,365])), ... 
    'nan','NaN',@(x) ischar(x), ...
    'preprocess',[],@(x) isempty(x) || isfunc(x) || (iscell(x) && all(cellfun(@isfunc,x))), ...
    'skiprows,skiprow','',@(x) isempty(x) || ischar(x) || iscellstr(x) || isnumeric(x), ...
    'userdata',Inf,@(x) isequal(x,Inf) || (ischar(x) && isvarname(x)), ...
    'userdatafield','.',@(x) ischar(x) && length(x) == 1, ...
    'userdatafieldlist',{},@(x) isempty(x) || iscellstr(x) || isnumeric(x), ...
    }; %#ok<CCAT>

Def.dbfun = { ...
    'cascade',true,@islogicalscalar, ...
    'classlist,classfilter',Inf,@(x) (isnumeric(x) && isinf(x)) || ischar(x) || iscellstr(x), ...
    'fresh',false,@islogicalscalar, ...
    'merge',[],@(x) isempty(x) || islogicalscalar(x), ...
    'namelist',Inf,@(x) isequal(x,Inf) || iscellstr(x), ...
    'onerror','remove',@(x) ischar(x) && any(strcmpi(x,{'remove','keep','nan'})), ...
    'onwarning','nothing',@(x) ischar(x) && any(strcmpi(x,{'remove','keep','nan','nothing'})), ...
    };

Def.dbnames = { ...
    'classfilter',Inf,@(x) isequal(x,Inf) || ischar(x), ...
    'namefilter',Inf,@(x) isequal(x,Inf) || ischar(x), ...
    };

Def.dbplot = { ...
    'addclick',true,@islogicalscalar, ...
    'class',true,@islogicalscalar, ...
    'format','%.8e',@ischar, ...
    'highlight',[],@(x) isnumeric(x) ...
    || (iscell(x) && all(cellfun(@isnumeric,x))), ...
    'marks,mark',{},@iscellstr, ...
    'round',Inf,@(x) isnumericscalar(x) && x > 0 && x == round(x), ...
    'plotfunc',@plot,@isfunc, ...
    'saveas','',@ischar, ...
    'style',[],@(x) isempty(x) || isstruct(x) || (iscellstr(x) && length(x) == 1), ...
    'subplot','auto',@(x) strcmpi(x,'auto') || (isnumeric(x) && length(x) == 2), ...
    'title',{},@(x) isempty(x) || iscellstr(x) || ischar(x), ...
    'tight',false,@islogical, ...
    'transform',[],@(x) isempty(x) || isfunc(x), ...
    'vline',[],@isnumeric, ...
    'xlabel','',@(x) ischar(x) || iscellstr(x), ...
    'ylabel','',@(x) ischar(x) || iscellstr(x), ...
    ... 'zlabel','',@(x) ischar(x) || iscellstr(x), ...
    'zeroline',false,@islogicalscalar, ...
    };

Def.dbprintuserdata = { ...
    'output','prompt',@(x) ischar(x) && any(strcmpi(x,{'html','prompt'})), ...
    };

Def.dbrange = { ...
    'startdate','maxrange',@(x) ischar(x) && any(strcmpi(x,{'maxrange','minrange','balanced','unbalanced'})), ...
    'enddate','maxrange',@(x) ischar(x) && any(strcmpi(x,{'maxrange','minrange','balanced','unbalanced'})), ...
    };

Def.dbsave = { ...
    dateformat{:}, ...
    'class',true,@islogicalscalar, ...
    'comment',true,@islogicalscalar, ...
    'decimal',[],@(x) isempty(x) || (length(x) == 1 && isnumeric(x)), ...
    'format','%.8e',@(x) ischar(x) && ~isempty(x) && x(1) == '%' ...
    && isempty(strfind(x,'$')) && isempty(strfind(x,'-')), ...
    'nan','NaN',@ischar, ...
    'savesubdb',false,@islogicalscalar, ...
    'userdata','userdata',@(x) ischar(x) && isvarname(x), ...
    'delimiter', ',', @ischar, ...
    }; %#ok<CCAT>

Def.dbsplit = { ...
    'discard',true,@islogicalscalar, ...
    };

Def.xls2csv = { ...
    'sheet',1,@(x) (isnumericscalar(x) && x == round(x) && x > 0) || ischar(x), ...
    };

end