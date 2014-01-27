function Def = dates()
% dates  [Not a public function] Default options for IRIS date functions.
%
% Backend IRIS function.
% No help provided.

% -IRIS Toolbox.
% -Copyright (c) 2007-2014 IRIS Solutions Team.

%--------------------------------------------------------------------------

Def = struct();

config = irisget();

dates = { ...
    'dateformat','config',config.validate.dateformat, ...
    'freqletters,freqletter','config',config.validate.freqletters, ...
    'months,month','config',config.validate.months, ...
    'standinmonth','config',config.validate.standinmonth, ...
    };

Def.convert = { ...
   'standinmonth','config',config.validate.standinmonth, ...
};

Def.dat2str = { ...
    dates{:}, ...
}; %#ok<CCAT1>

Def.datxtick = { ...
    dates{:}, ...
    'dateposition','c',@(x) ischar(x) && ~isempty(x) && any(x(1) == 'sec'), ...
    'datetick,dateticks',Inf,@(x) isnumeric(x) ...
    || any(strcmpi(x,{'yearstart','yearend','yearly'})) ...
    || isfunc(x), ...
}; %#ok<CCAT>

Def.str2dat = { ...
    dates{:}, ...
   'freq',[],@(x) isempty(x) ...
      || (isnumericscalar(x) && any(x == [0,1,2,4,6,12,52,365])) ...
      || isequal(x,'daily'), ...
}; %#ok<CCAT>

end