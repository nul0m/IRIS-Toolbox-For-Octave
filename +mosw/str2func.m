function varargout = str2func(varargin)
% str2func  [Not a public function] Workaround for Octave's str2func.
%
% Backend IRIS function.
% No help provided.

% -IRIS Toolbox.
% -Copyright (c) 2007-2014 IRIS Solutions Team.

%--------------------------------------------------------------------------

if false % ##### MOSW
    varargout{1} = str2func(varargin{1});
else
    % Make sure the function string starts with an `@`.
    if varargin{1}(1) ~= '@' %#ok<UNRCH>
        varargin{1} = ['@',varargin{1}];
    end
    % Replace `++` and `--` with `+`.
    varargin{1} = mosw.ppmm(varargin{1});
    % Create the function handle.
    varargout{1} = evalin('caller',varargin{1});
end

end
