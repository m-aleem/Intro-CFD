function [u]=guass(x, x1, xpeak, xend, xwidth, periodic_q, bc_xmin_type, bc_xmax_type, bc_xmin, bc_xmax, u1user, uenduser);

u=zeros(1,length(x)); %make u vector
u=1+exp(-10./xwidth.*((x-xpeak)*(xend+x1)/(xend-x1)).^2); %make u guass function

if periodic_q==1 % if periodic
    u(1)=u(end); % set last u(1) = u(end) for periodicity
    u(end+1)=u(2); % add ghost point u(end+1) = u(2) for periodicity (derivative)
end

if periodic_q==2 %non-periodic bcs
    
   if bc_xmin_type==1  %du/dx=0 bc at xmin
       u(1)=u(2); %make 0 derivative
   elseif bc_xmin_type==2 %user input u(xmin)
       u(1)=u1user; %set to user input
   end
   
   if bc_xmax_type==1  %du/dx=0 bc at xmax
       u(end)=u(end-1); %make 0 derivative
   elseif  bc_xmax_type==2 %user input u(xmax)
       u(end)=uenduser; %set to user input
   end
end