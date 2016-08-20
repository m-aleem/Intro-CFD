# Intro-CFD
Linear Advection Equation &amp; Burgers’ Equation Solver from Introductory CFD Course

One major project in this course was to develop a modular MATLAB language CFD program. The program allows users first to generate a 1-dimensional grid, then creates a function over the grid with user-specified boundary conditions, and, finally, solves either the linear advection equation or Burgers’ equation with certain user-specified parameters.

    The program's first mode produces a 1-dimensional grid. The grid can either be uniform, or clustered at a single location based upon user selection
    The second mode in the program generates a function . The user can select either a square wave, a Gaussian function, or a sine wave. The user also specifies the boundary conditions. These boundary conditions are either user-specified Dirichlet, program-specified Von Neumann, or periodic. Note that the user has the option to set one boundary as Von Neumann and the other as Dirichlet, if desired.
    For the next mode, the user selects to solve either the Linear Advection Equation or Burgers' Equation.
        The Linear Advection Equation Solver mode solves the time-dependent linear advection equation using the explicit Lax-Wendroff method; the user must input the value of the CFL number and final time.
        The alternate solver mode that the user may select is the Burgers’ Equation Solver. This mode solves the viscous Burgers’ equation; the user inputs the viscosity coefficient, the CFL number, and the final time.
