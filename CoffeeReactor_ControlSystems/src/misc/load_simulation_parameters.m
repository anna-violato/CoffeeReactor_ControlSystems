function simulationParameters=load_simulation_parameters
% Create the paramters structure needed for the simulation (including those of the reactor model)

%-------------------------------------------------------------------------%
%% Simulation Parameters
%-------------------------------------------------------------------------%
% Defines the other parameters needed for the simulation
    Ts=1/6; %[min] i.e. [10 s], sampling time
    simulationParameters.Ts=Ts;
    simulationParameters.Tint=simulationParameters.Ts/10; %[min] i.e. [1 s]
    simulationParameters.Tsim=150;    %[min]

% Defines the other parameters needed for the simulation
    simulationParameters.Fin1_max= 66; %[ml/min]
    simulationParameters.Fin1_min= 0 ; %[ml/min]
    
    simulationParameters.Fin2_max= 66; %[ml/min]
    simulationParameters.Fin2_min= 0 ; %[ml/min]


%TargetConcentration
    simulationParameters.y_target.signals.values=[25 25 35 35 15 15 40 40]';             %[mg/dl]
    simulationParameters.y_target.time= [0 30-Ts 30 60-Ts 60 90-Ts 90 150]';               %[min]
%-------------------------------------------------------------------------%   
%-------------------------------------------------------------------------%
%% Reactor Parameters
%-------------------------------------------------------------------------%
%       V: Reactor Volume [ml]
%       C_in1: coffee concentration in the inflow 1 [mg/dl]
%       Note: coffee concentration in the inflow 2 is C_in2=0[mg/dl], as pure water in contained in the second inflow

Reactor_parameters.V= 50;        %[ml]
Reactor_parameters.C_in1= 50;    %[mg/dl]

% Disturbance
    Reactor_parameters.Adist=3;%[ml/min]
    Reactor_parameters.Tdist=120;%[ml/min]
    
% Dimension of the reactor Model
    Reactor_parameters.n=1;
    Reactor_parameters.m=2;
    Reactor_parameters.md=0;
    Reactor_parameters.p=1;

%Intial Condition
    Reactor_parameters.x_0= 25;   % initial concentration of coffee in the reactor [mg/dl]

simulationParameters.Reactor_parameters=Reactor_parameters;
%-------------------------------------------------------------------------%
    
