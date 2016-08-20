function [unew]=getuburgers(i, x, delta_x, u, visc, courant, periodic_q, bc_xmin_type, bc_xmax_type, bc_xmin, bc_xmax, u1user, uenduser,time_type, tfinal);

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
    xlim([min(x) max(x)]);
    ustring=sprintf('Burgers Equation u(x) at t=%.3f',t);
    title(ustring);
    
end

while t < tfinal
    dx=min(delta_x);
    dt=courant*dx;
    
%     qbar=u;
%     flux=.5.*(u).^2;
%     for i2=2:imax-1
%         dxdown=x(i2)-x(i2-1);
%         dxup=x(i2+1)-x(i2);
%         s=visc*((u(i2+1)-u(i2))/(dxup*dxdown)-(u(i2)-u(i2-1))/(dxdown^2));
%         qbar(i2)=u(i2)-(dt/dxdown)*(flux(i2)-flux(i2-1))+dt*s;
%     end
%     fluxbar=.5.*(qbar).^2;
%     for i2=2:imax-1
%         dxdown=x(i2)-x(i2-1);
%         dxup=x(i2+1)-x(i2);
%         sbar=visc*((qbar(i2+1)-qbar(i2))/(dxup*dxdown)-(qbar(i2)-qbar(i2-1))/(dxdown^2));
%         du(i2)=-.5*u(i2)+.5*qbar(i2)-.5*(dt/dxup)*(fluxbar(i2+1)-fluxbar(i2))+.5*dt*sbar;
%         unew(i2)=u(i2)+du(i2);
%     end
     
for i2=2:imax-1
    dxdown(i2)=x(i2)-x(i2-1);
    dxup(i2)=x(i2+1)-x(i2);
    fup(i2)=.5*u(i2+1)^2+.5*u(i2)^2;
    fdown(i2)=.5*u(i2)^2+.5*u(i2-1)^2;
    dfdx(i2)=fup(i2)/(2*dxup(i2))-fdown(i2)/(2*dxdown(i2));
    s(i2)=visc*((u(i2+1)-u(i2))/(dxup(i2)*dxdown(i2))-(u(i2)-u(i2-1))/(dxdown(i2)^2));
    du(i2)=dt*(-dfdx(i2))+dt*s(i2);
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
    ustring=sprintf('Burgers Equation u(x) at t=%.3f',t);
    xlim([min(x) max(x)]);
    title(ustring);
    pause(0.05)
end