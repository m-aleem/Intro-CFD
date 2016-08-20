clear all
close all
clc

%%
%------------------------------------------------------------------------
%GRID GENERATOR
%------------------------------------------------------------------------

fprintf('\n>> Grid Generator \n')

%% Grid Type

%Choose a type of grid
prompt_type = 'Enter 1 for a uniform grid or 2 for a clustered grid: ';
type=input(prompt_type);

%Ensure a proper selection to make a grid was made
if type == 1
    select = true;
elseif type == 2
    select = true;
else
    select = false;
    disp('Incorrect selection')
end

%% Input

if select == true
    %---------------------------------------------------------------------
    % Standard Grid Inputs
    %---------------------------------------------------------------------
    
    prompt_start = 'What is the grid range starting point (x_min)? ';
    x1 = input(prompt_start); %define start of range
    
    prompt_end = 'What is the grid range ending point(x_max)? ';
    xend = input(prompt_end); %define end of range
    
    prompt_points = 'What is the number of grid points? ';
    iend = input(prompt_points); %define grid points
    
    %---------------------------------------------------------------------
    % Clustered Grid Inputs
    %---------------------------------------------------------------------
    
    if type==2 %inputs required for clustered grid only
        prompt_cluster = 'Where is the grid clustered (x_cluster)? ';
        xc = input(prompt_cluster); %define cluster locaation
        
        prompt_clusterdeg = 'What is the degree of clustering (ratio of dx_max/dx_min)? ';
        rho = input(prompt_clusterdeg); %define cluster locaation
    end
    
    
    %% Grid Calculations
    
    if type==1 %uniform grid
        [i,x,delta_x]=uniform(x1, xend, iend); %define uniform grid
    end
    
    if type==2 %clustered grid
        [i,x,delta_x,a,b,c,d]=clustered(x1, xend, iend, xc, rho); %define clustered grid
        
        %calculate error in delta_x (for reference)
        dxerror=abs(max(delta_x)/min(delta_x)-rho)/rho*100;
    end
    
    %%
    %------------------------------------------------------------------------
    % Dependent Function
    %------------------------------------------------------------------------
    
    fprintf('\n>> Initial Function Generator \n')
    
    %% Input
    %---------------------------------------------------------------------
    % Boundary Conditions
    %---------------------------------------------------------------------
    
    prompt_function = 'Enter 1 for a step, 2 for Gaussian, or 3 for sine: ';
    functiontype = input(prompt_function); %step or guass
    
    if functiontype==1 || functiontype==2
        prompt_width= 'What is the width (xwidth)? ';
        xwidth = input(prompt_width); %step width or xwidth for Guass
        
        prompt_xpeak= 'Where is the peak value (xpeak)? ';
        xpeak = input(prompt_xpeak); %xpeak for Guass or center of step
        
    elseif functiontype==3
        prompt_sinetype= 'Enter 1 for u(x)=sin(x) and 2 for u(x)=-sin(x): ';
        sinetype = input(prompt_sinetype); %periodic or not
    end
    %initialize bc type/value placeholders (all required inputs for
    %step/guass functions later on)
    bc_xmin_type=0;
    bc_xmax_type=0;
    bc_xmin=0;
    bc_xmax=0;
    u1user=0;
    uenduser=0;
    
    
    prompt_periodic = 'Enter 1 for periodic boundary conditions or 2 for other: ';
    periodic_q = input(prompt_periodic); %periodic or not
    
    if periodic_q==2 %non-periodic bc inputs
        
        prompt_bc_xmin1 = 'Enter 1 for du/dx=0 boundary conditions at xmin or 2 to define u(x_min): ';
        bc_xmin_type = input(prompt_bc_xmin1); %du/dx condition or u(xmin)
        if bc_xmin_type==1
            bc_xmin=1;
        elseif bc_xmin_type==2
            bc_xmax=2;
            prompt_bc_xmin_2 = 'What is u(x_min)? ';
            u1user=input(prompt_bc_xmin_2); %define u(xmin)
        end
        
        prompt_bc_xmax1 = 'Enter 1 for du/dx=0 boundary conditions at xmax or 2 to define u(x_max): ';
        bc_xmax_type = input(prompt_bc_xmax1); %du/dx condition or u(xmin/xmax)
        if bc_xmax_type==1
            bc_xmax=1;
        elseif bc_xmax_type==2
            bc_xmax=2;
            prompt_bc_xax_2 = 'What is u(x_max)? ';
            uenduser=input(prompt_bc_xax_2); %define x(max)
        end
        
    end
    
    %% U(x) Calculations
    
    if functiontype==1 %Step Function
        stepxu1=0; %the step function will start at a value of 0
        stepx=xpeak-xwidth/2; %step is centered around xpeak
        
        [u]=step(x, x1, stepxu1, xend, stepx, xwidth, periodic_q, bc_xmin_type, bc_xmax_type, bc_xmin, bc_xmax, u1user, uenduser);
    end
    
    if functiontype==2 %Guass Function
        [u]=guass(x, x1, xpeak, xend, xwidth, periodic_q, bc_xmin_type, bc_xmax_type, bc_xmin, bc_xmax, u1user, uenduser);
    end
    
    if functiontype==3 %Sine function
        [u]=sine(x, periodic_q, bc_xmin_type, bc_xmax_type, bc_xmin, bc_xmax, u1user, uenduser, sinetype);
    end
    
    %% Output
    i; %index
    x; %x
    delta_x; %delta_x
    u; %u(x)
    
    %%  Solve Linear Advection or Burger's Eq
    
    %if type==1 %Only goes to solve if uniform grid
    fprintf('\n>>Equations Solver \n')
    
    prompt_soltype = 'Enter 1 for Linear Advection Solver or 2 for Burgers Solver: ';
    soltype = input(prompt_soltype); %
    
    if soltype==1 %Linear Advection
        fprintf('\n>>Linear Advection Solver \n')
        prompt_CFL = 'What is the CFL number? ';
        courant = input(prompt_CFL); %
        
        prompt_timetype= 'Enter 1 to enter a final time or 2 to end at  imax*dt/4: ';
        dt=courant*min(delta_x);
        %dt=courant*delta_x(1) %for uniform grid only option
        tfinal=i(end)*dt/4+50;
        time_type = input(prompt_timetype); %
        
        if time_type ==1
            prompt_tfinal = 'What is the final time? ';
            tfinal = input(prompt_tfinal); %
        end
        getu(i, x, delta_x, u, courant, periodic_q, bc_xmin_type, bc_xmax_type, bc_xmin, bc_xmax, u1user, uenduser, time_type, tfinal);
        
    elseif soltype==2 %Burgers Eq
        fprintf('\n>>Burgers Equation Solver \n')
        
        prompt_visc = 'What is the viscosity coefficient? ';
        visc = input(prompt_visc); %
        
        prompt_CFL = 'What is the CFL number? ';
        courant = input(prompt_CFL); %
        
        prompt_tfinal = 'What is the final time? ';
        tfinal = input(prompt_tfinal); %
        time_type=1;
        getuburgers(i, x, delta_x, u, visc, courant, periodic_q, bc_xmin_type, bc_xmax_type, bc_xmin, bc_xmax, u1user, uenduser, time_type, tfinal);
        
    end
    %end %uniform grid only solver
end