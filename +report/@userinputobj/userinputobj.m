classdef userinputobj < report.genericobj
    % userinputobj  [Not a public class] Base class for report elements built on user input.
    %
    % Backend IRIS class.
    % No help provided.
    
    % -IRIS Toolbox.
    % -Copyright (c) 2007-2014 IRIS Solutions Team.
    
    properties
        userinput = '';
    end
    
    methods
        
        function This = userinputobj(varargin)
            This = This@report.genericobj(varargin{:});
            This.childof = {'report'};
            This.default = [This.default,{ ...
                'centering',false,@is.logicalscalar,true, ...
                'verbatim',false,@is.logicalscalar,true, ...                                
                }];
        end
        
        function [This,varargin] = specargin(This,varargin)
        end
        
    end
    
    methods (Access=protected,Hidden)
        
        varargout = speclatexcode(varargin)
        
    end
    
end