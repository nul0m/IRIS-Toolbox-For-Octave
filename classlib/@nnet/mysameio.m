function recurs = mysameio(This)

% mysameio  [Not a public function]
%
% Backend IRIS function.
% No help provided.

% -IRIS Toolbox.
% -Copyright (c) 2007-2014 IRIS Solutions Team.


inVars = unique(cellfun(@(x) x{1},regexp(This.Inputs,'\{[-\+]?\d*}','split'),'UniformOutput',false)) ;
outVars = unique(cellfun(@(x) x{1},regexp(This.Outputs,'\{[-\+]?\d*}','split'),'UniformOutput',false)) ;
recurs = true ;
if numel(inVars) == numel(outVars)
    for iVar = 1:numel(inVars)
        if all(~strcmp(inVars{iVar},outVars))
            recurs = false ;
        end
    end
else
    recurs = false ;
end

end