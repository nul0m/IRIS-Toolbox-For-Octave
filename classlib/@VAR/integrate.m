function This = integrate(This,varargin)
% integrate  Integrate VAR process and data associated with it.
%
% Syntax
% =======
%
%     V = integrate(V,...)
%
% Input arguments
% ================
%
% * `V` [ VAR ] - VAR object whose variables will be integrated by one
% order.
%
% Output arguments
% =================
%
% * `V` [ VAR ] - VAR object with the specified variables integrated by one
% order.
%
% Options
% ========
%
% * `'applyTo='` [ logical | numeric | *`Inf`* ] - Index of variables to
% integrate; Inf means all variables will be integrated.
%
% Description
% ============
%
% Example
% ========
%

% -IRIS Toolbox.
% -Copyright (c) 2007-2014 IRIS Solutions Team.

ny = size(This.A,1);
nAlt = size(This.A,3);

opt = passvalopt('VAR.integrate',varargin{:});

% Make options.applyto logical index.
if isnumeric(opt.applyto)
    if isequal(opt.applyto,Inf)
        ApplyTo = true(1,ny);
    else
        ApplyTo = false(1,ny);
        ApplyTo(opt.applyto) = true;
    end
elseif islogical(opt.applyto)
    ApplyTo = opt.applyto(:).';
    ApplyTo = ApplyTo(1:ny);
end

%--------------------------------------------------------------------------

% Integrate the VAR object.
if any(ApplyTo)
    D = cat(3,eye(ny),-eye(ny));
    D(~ApplyTo,~ApplyTo,2) = 0;
    A = This.A;
    This.A(:,end+1:end+ny,:) = NaN;
    for iAlt = 1 : nAlt
        a = poly.polyprod(poly.var2poly(A(:,:,iAlt)),D);
        This.A(:,:,iAlt) = poly.poly2var(a);
    end
    This = schur(This);
end

end