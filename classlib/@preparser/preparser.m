classdef preparser < userdataobj
% preparser  [Not a public class] IRIS preparser.
%
% Backend IRIS class.
% No help provided.

% -IRIS Toolbox.
% -Copyright (c) 2007-2014 IRIS Solutions Team.

    properties
        FName = '';
        Code = '';
        Labels = fragileobj();
        Assign = struct();
        Export = {};
        Subs = struct();
    end
        
    methods
        
        function This = preparser(varargin)
            % preparser  [Not a public function] IRIS preparser.
            %
            % Backend IRIS function.
            % No help provided.
            
            % -IRIS Toolbox.
            % -Copyright (c) 2007-2014 IRIS Solutions Team.
            
            % p = preparser(inputFile,Opt)
            % p = preparser(inputFile,...)
            
            if nargin == 0
                return
            end

            if isa(varargin{1},'preparser')
                This = varargin{1};
                return
            end
            inpFiles = varargin{1};
            varargin(1) = [];
            if ischar(inpFiles)
                inpFiles = {inpFiles};
            end
            This.FName = [This.FName,sprintf(' & %s',inpFiles{:})];
            This.FName(1:3) = '';
            % Parse options.
            if ~isempty(varargin) && isstruct(varargin{1})
                opt = varargin{1};
                varargin(1) = [];
            else
                [opt,varargin] = ...
                    passvalopt('preparser.preparser',varargin{:});
            end
            % Add remaining input arguments to the assign struct.
            if ~isempty(varargin) && iscellstr(varargin(1:2:end))
                for i = 1 : 2 : length(varargin)
                    opt.assign.(varargin{i}) = varargin{i+1};
                end
            end
            This.Assign = opt.assign;
            % Read the code files and resolve preparser commands.
            [This.Code,This.Labels,This.Export,This.Subs,This.Comment] = ...
                preparser.readcode(inpFiles, ...
                opt.assign,This.Labels,{},'',opt);
            % Create a clone of the preparsed code.
            if ~isempty(opt.clone)
                This.Code = preparser.myclone(This.Code,opt.clone);
            end
            % Save the pre-parsed file if requested by the user.
            if ~isempty(opt.saveas)
                saveas(This,opt.saveas);
            end
        end
        
        function disp(This)
            mosw.fprintf( ...
                '\tpreparser object <a href="matlab:edit %s">%s</a>\n', ...
                This.FName,This.FName);
            disp@userdataobj(This);
            disp(' ');
        end
        
        varargout = saveas(varargin)
        
    end
    
    methods (Hidden)
        % TODO: Create reportingobj and make the parser its method.
        varargout = reporting(varargin)
    end
    
    methods (Static,Hidden)
        varargout = mychkclonestring(varargin)
        varargout = myclone(varargin)
        varargout = alt2str(varargin)
        varargout = eval(varargin)
        varargout = export(varargin)
        varargout = grabcommentblk(varargin)
        varargout = labeledexpr(varargin)
        varargout = lincomb2vec(varargin)
        varargout = controls(varargin)
        varargout = pseudofunc(varargin)
        varargout = pseudosubs(varargin)
        varargout = readcode(varargin)
        varargout = removecomments(varargin)
        varargout = substitute(varargin)
    end
    
end
