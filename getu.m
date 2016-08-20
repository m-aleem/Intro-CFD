function [unew]=getu(i, x, delta_x, u, courant, periodic_q, bc_xmin_type, bc_xmax_type, bc_xmin, bc_xmax, u1user, uenduser, time_type, tfinal);

       
imax=i(end);

unew=zeros(1,imax);
du=zeros(1,imax);

if periodic_q==1
    unew=zeros(1,imax+1);
    du=zeros(1, imax+1);
end

t=0;

%Initialize figure
figure
set(gca,'xlim',[x(1) x(end)])


if tfinal==0 %create a plot even if final time = 0 
    plot(x(1:imax),u(1:imax))
    ustring=sprintf('u(x) at t=%.3f',t);
        xlim([min(x) max(x)]);
    title(ustring);
end

while t < tfinal
    dx=x(2)-x(1);
    dt=courant*dx;
    
    if time_type==2
        if t>=imax*dt/4; break
        end
    end
    
    for i2=2:imax-1
        du(i2)=-courant/2*(u(i2+1)-u(i2-1))+courant^2/2*(u(i2+1)-2*u(i2)+u(i2-1));
        unew(i2)=u(i2)+du(i2);
    end
    
    t=t+dt;
    
    if periodic_q==1
        unew(1)=unew(imax-1);
        unew(imax)=unew(2);
    else
    unew(imax)=unew(imax-1);
    unew(1)=unew(2);
    end
    
    u=unew;
    
    % Output
    x(1:imax);
    u(1:imax);
    
    plot(x(1:imax),u(1:imax))
    ustring=sprintf('u(x) at t=%.3f',t);
    xlim([min(x) max(x)]);
    title(ustring);
    pause(0.05)
    
end