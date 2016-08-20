function [i x delta_x]=uniform(x1, xend, iend, xc, rho)

x = linspace(x1, xend, iend); %generate grid location
i = 1:1:length(x); %generate indexs 



for n=1:1:length(i)-1
    j=x(n+1)-x(n); %calculate delta at each index
    delta_x(n) = round(j * 1e8) / 1e8; %MATLAB rounding
end

delta_x(length(i))=NaN; %last grid point has no delta

end
