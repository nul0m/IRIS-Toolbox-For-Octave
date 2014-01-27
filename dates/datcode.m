function Dat = datcode(Freq,Year,Per)
% datcode  [Not a public function] IRIS serial date number.
%
% Backend IRIS function.
% No help provided.

% -IRIS Toolbox.
% -Copyright (c) 2007-2014 IRIS Solutions Team.

try
    Per; %#ok<VUNUS>
catch
    Per = ones(size(Year));
end

%--------------------------------------------------------------------------

if length(Freq) == 1
    Freq = Freq*ones(size(Year));
end

ixZero = Freq == 0;
ixWeekly = Freq == 52;
ixRegular = ~ixZero & ~ixWeekly;

% Create date for the last period in the year.
if isequal(Per,'end')
    Per = nan(size(Year));
    if any(ixRegular)
        Per(ixRegular) = Freq(ixRegular);
    end
    if any(ixWeekly(:))
        n = weeksinyear(Year);
        Per(ixWeekly) = n;
    end
end

% Use the formula for regular dates first to get the right size of `Dat`.
Dat = Year.*Freq + Per - 1 + Freq/100;

% Indeterminate frequency
%-------------------------
if any(Freq(:) == 0)
    if length(Freq) == 1
        Dat(:) = Per(:);
    else
        inx = Freq == 0;
        Dat(inx) = Per(inx);
    end
end

% Weekly frequency
%------------------
if any(Freq(:) == 52)
    if length(Freq) == 1
        Dat(:) = ww(Year,Per);
    else
        inx = Freq == 52;
        Dat(inx) = ww(Year(inx),Per(inx));
    end
end

end
