function [i x delta_x a b c d]=clustered(x1, xend, iend, xc, rho)

%OUTPUT
i=1:1:iend; %generate indexs

%unknowns
syms a b c d dxmin

ic=-b/(3*a); %define cluster index by knowing x'' = 0 at cluster index (ic)

%Find correct index corresponding to dx_max (will be at one of ends)
if (xend-x1)/2 >= xc
    idmax=iend;
elseif (xend-x1)/2 < xc
    idmax=1;
end

dxmax=dxmin*rho; %define dx_max in terms of dxmin
i1=1; %define first index as 1 

%x = fn(i) is a cubic of form a*i^3 + b*i^2 + c*i +d
x_i1=a+b+c+d; %x at the first index (=1), x = x1
x_iend=a*iend^3+b*iend^2+c*iend+d; % at the last index, x=xend
dx_ic=3*a*ic^2+2*b*ic+c; % at the cluster index, x'=dx_min
x_ic=a*ic^3+b*ic^2+c*ic+d; %at the cluster index, x=xc
dx_imax=3*a*idmax^2+2*b*idmax+c; %at the idmax index (1 or iend), x'=dx_max

[a b c d xmin]=solve(x_i1==x1,x_iend==xend,dx_ic==dxmin,x_ic==xc,dx_imax==dxmax,a,b,c,d,dxmin);
a=double(a(1));
b=double(b(1));
c=double(c(1));
d=double(d(1));

x=a*i.^3+b*i.^2+c*i+d; %define our cubic

for n=1:1:length(i)-1
    j=x(n+1)-x(n); %calculate delta at each index
    delta_x(n) = round(j * 1e8) / 1e8; %MATLAB rounding
end
delta_x(length(i))=NaN; %last grid point has no delta


end 