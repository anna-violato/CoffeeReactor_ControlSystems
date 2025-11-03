clc
close all
clear

addpath('Sources')

% Contains both tasks 2.1 and 2.2

%% Load PhotoBioReactor Parameters and Simulation Parameters
    simulationParameters=load_simulation_parameters;
%Set exercise-specific parameters.
simulationParameters.Tsim=25; %to coincide with the references in the presentation
Ts=simulationParameters.Ts; %for easier readability
simulationParameters.Reactor_parameters.Ts=Ts; %needed for the c2d function

%% -------------- Task 1 --------------


flowValue=7; %ml/min
Fin_1.signals.values=[0;0;flowValue;flowValue;0;0]; %Coffee input values
Fin_2.signals.values=[0;0;0;0;0;0]; %Water input values

Fin_1.time=[0; 10-Ts; 10; 20-Ts; 20; 25]; %Coffee input time instants
Fin_2.time=[0; 10-Ts; 10; 20-Ts; 20; 25]; %Water input time instants

%% Non Linear Model Case
flagLinear=0;
sim("CoffeeReactor_ex2.slx")
y_non_linear=reactorOutput.signals(2).values;

%% Linear Model (Continuous)
flagLinear=1;
sim("CoffeeReactor_ex2.slx")
y_linear_c=reactorOutput.signals(2).values;
y_linear_c_out=linear_continuous_out.signals.values;
t_lin_c=linear_continuous_out.time;

%% Linear Model (Discrete)
parameters=simulationParameters.Reactor_parameters;
A=0; B=[1/parameters.V*(parameters.C_in1-parameters.x_0), -parameters.x_0/parameters.V];
C=1; D=0;
sys_c = ss(A,B,C,D); %continuous model
sys_d = c2d(sys_c,parameters.Ts); %discrete model
sim("CoffeeReactor_ex2_linear_discrete.slx")
y_linear_d=reactorOutput.signals(2).values;


%% Plots
figure
    subplot(2,1,1)
        hold on
        plot(reactorOutput.time, y_non_linear,'LineWidth',3);
        plot(t_lin_c, y_linear_c_out,'LineWidth',3);
        plot(reactorOutput.time, y_linear_d,'LineWidth',3);
        plot([0 simulationParameters.Tsim],simulationParameters.Reactor_parameters.C_in1*[1 1],'k--');
        plot([0 simulationParameters.Tsim],0*[1 1],'k--');
        hold off 
        ylabel('C(t)- [mg/dl]')
        xlabel('time [min]')
        title("Model output")
    
        ylim([-20 80])
        legend({'Non Linear Model','Linear Model (Continuous)','Linear Model (Discrete)'}, "Location","northwest")

    subplot(2,1,2)
        plot([0 simulationParameters.Tsim],simulationParameters.Fin1_max*[1 1],'k--');
        hold on      
        plot([0 simulationParameters.Tsim],simulationParameters.Fin1_min*[1 1],'k--');

        h(2)=plot([0 10 10 20 20 25],Fin_2.signals.values,'Color',[ 0    0.447    0.741],'LineWidth',3); 
        h(1)=plot([0 10 10 20 20 25],Fin_1.signals.values,'Color',[0.5882    0.4118    0.0980],'LineWidth',3);
        hold off 
        ylabel('F_{in} (t) [ml/min]')
        xlabel('time [min]')
        title("Control Inputs")

        ylim([-10 70])
        legend(h,{'Concentrated Coffee','Water'})
        sgtitle("Model Behaviour after constant Coffee input at t=10 min: F_i_n_,_1=7 ml/min")


%% -------------- Task 2 --------------


Fin_1.signals.values=[0;0;0;0;0;0]; %Coffee input values
Fin_2.signals.values=[0;0;flowValue;flowValue;0;0]; %Water input values

Fin_1.time=[0; 10-Ts; 10; 20-Ts; 20; 25]; %Coffee input time instants
Fin_2.time=[0; 10-Ts; 10; 20-Ts; 20; 25]; %Water input time instants


%% Non Linear Model Case
flagLinear=0;
sim("CoffeeReactor_ex2.slx")
y_non_linear=reactorOutput.signals(2).values;

%% Linear Model (Continuous)
flagLinear=1;
sim("CoffeeReactor_ex2.slx")
y_linear_c=reactorOutput.signals(2).values;
y_linear_c_out=linear_continuous_out.signals.values;
t_lin_c=linear_continuous_out.time;

%% Linear Model (Discrete)
parameters=simulationParameters.Reactor_parameters;
A=0; B=[1/parameters.V*(parameters.C_in1-parameters.x_0), -parameters.x_0/parameters.V];
C=1; D=0;
sys_c = ss(A,B,C,D); %continuous model
sys_d = c2d(sys_c,parameters.Ts); %discrete model
sim("CoffeeReactor_ex2_linear_discrete.slx")
y_linear_d=reactorOutput.signals(2).values;


%% Plots
figure
    subplot(2,1,1)
        hold on
        plot(reactorOutput.time, y_non_linear,'LineWidth',3);
        plot(t_lin_c, y_linear_c_out,'LineWidth',3);
        plot(reactorOutput.time, y_linear_d,'LineWidth',3);
        plot([0 simulationParameters.Tsim],simulationParameters.Reactor_parameters.C_in1*[1 1],'k--');
        plot([0 simulationParameters.Tsim],0*[1 1],'k--');
        hold off 
        ylabel('C(t)- [mg/dl]')
        xlabel('time [min]')
        title("Model output")

        ylim([-20 80])
        legend({'Non Linear Model','Linear Model (Continuous)','Linear Model (Discrete)'}, "Location","northwest")

    subplot(2,1,2)
        plot([0 simulationParameters.Tsim],simulationParameters.Fin1_max*[1 1],'k--');
        hold on      
        plot([0 simulationParameters.Tsim],simulationParameters.Fin1_min*[1 1],'k--');

        h(2)=plot([0 10 10 20 20 25],Fin_2.signals.values,'Color',[ 0    0.447    0.741],'LineWidth',3); 
        h(1)=plot([0 10 10 20 20 25],Fin_1.signals.values,'Color',[0.5882    0.4118    0.0980],'LineWidth',3);
        hold off 
        ylabel('F_{in} (t) [ml/min]')
        xlabel('time [min]')
        title("Control Inputs")

        ylim([-10 70])
        legend(h,{'Concentrated Coffee','Water'})

        sgtitle("Model Behaviour after constant Water input at t=10 min: F_i_n_,_2=7 ml/min")
