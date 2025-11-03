clc
close all
% bdclose all
clear all

addpath('Sources')


%% Load Data 

simulationParameters=load_simulation_parameters;

% Prediction horizon 
PH=100; %[steps]

%% Controller constraints
% References input
u_0=[0;0];
Q = 5;
R = [1 0; 0 1];
F=[-1 0;1 0;0 -1;0 1];
f=[-simulationParameters.Fin1_min;simulationParameters.Fin1_max;
    -simulationParameters.Fin1_min;simulationParameters.Fin1_max];
       
%% Linear Model (Discrete)
parameters=simulationParameters.Reactor_parameters;
A=[0]; B=[1/parameters.V*(parameters.C_in1-parameters.x_0), -parameters.x_0/parameters.V];
C=1; D=0;
sys_c = ss(A,B,C,D); %continuous model
sys_d = c2d(sys_c,simulationParameters.Ts); %discrete model

SystemModel.A=sys_d.A;
SystemModel.B=sys_d.B;
SystemModel.M=-sys_d.B;
SystemModel.C=sys_d.C;
SystemModel.D=sys_d.D;
condensedMatrices=BuildCondensedMPCmatrices(SystemModel,R,Q,F,f,PH);

% System Dimension
n=size(SystemModel.A,1);
p=size(SystemModel.C,1);
m_input=size(SystemModel.B,2);
m_dist=size(SystemModel.M,2); 
    

%% Simulating
sim('CoffeeReactor_ex3_2.slx')


%% Plot
figure
    subplot(2,1,1)
        h(1)=stairs(reactorOutput.time,reactorOutput.signals(1).values,'k');
        hold on
        h(2)=stairs(reactorOutput.time, reactorOutput.signals(2).values,'LineWidth',2);
        stairs([0 simulationParameters.Tsim],simulationParameters.Reactor_parameters.C_in1*[1 1],'k--');
        stairs([0 simulationParameters.Tsim],0*[1 1],'k--');
        hold off 
        ylabel('C(t)- [mg/dl]')
        xlabel('time [min]')
    
        ylim([0 60])
        legend(h,{'ref','output'})

    subplot(2,1,2)
        stairs([0 simulationParameters.Tsim],simulationParameters.Fin1_max*[1 1],'k--');
        hold on      
        plot([0 simulationParameters.Tsim],simulationParameters.Fin1_min*[1 1],'k--');

        h(2)=plot(reactorInput.time,reactorInput.signals.values(:,2),'Color',[ 0    0.447    0.741],'LineWidth',2); 
        h(1)=plot(reactorInput.time,reactorInput.signals.values(:,1),'Color',[0.5882    0.4118    0.0980],'LineWidth',2);
        hold off 
        ylabel('F_{in} (t) [ml/min]')
        xlabel('time [min]')

        ylim([-10 70])
        legend(h,{'Concentrated Coffee','Water'})
