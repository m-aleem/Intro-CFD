function [u]=step(x, x1, stepxu1, xend, stepx, xwidth, periodic_q, bc_xmin_type, bc_xmax_type, bc_xmin, bc_xmax, u1user, uenduser);
u=zeros(1,length(x)); %make a u vector

u(x<stepx)=stepxu1; %start u at initial value
u(x>=stepx)=stepxu1+1; %create a step
u(x==stepx+xwidth)=stepxu1+1; %continue step out until width
u(x>stepx+xwidth)=stepxu1;  %return to pre-step value after width

if periodic_q==1 %periodic bcs
    u(1)=u(end); % if periodic, set last u(1) = u(end) for periodicity
    u(end+1)=u(2); % add ghost point u(end+1) = u(2) for periodicity (derivative)
end

if periodic_q==2 %non-periodic bcs
    
   if bc_xmin_type==1  %du/dx=0 bc at xmin
       u(1)=u(2); %make zero derivative
   elseif bc_xmin_type==2 %user input u(xmin)
       u(1)=u1user; %set to user input
   end
   
   if bc_xmax_type==1  %du/dx=0 bc at xax
       u(end)=u(end-1); %make zero derivative
   elseif  bc_xmax_type==2 %user input u(xmax)
       u(end)=uenduser; %set to user input
   end
end
