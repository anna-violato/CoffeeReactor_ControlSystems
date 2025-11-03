clc
close all
clear all

addpath('Sources')

%% Load PhotoBioReactor Parameters and Simulation Parameters
% Set Bioreactor Parameters
simulationParameters=load_simulation_parameters;

% Set Controller Paramters
        controller_parameters.Ts=simulationParameters.Ts;
        
        controller_parameters.Kp=6; % measurement unit of the system input over those of the system output, [10^2*ml^2/min*mg]             
        controller_parameters.Ki=0.1; % [10^2*ml^2/min^2*mg] 
        % adding the integral action allows to acheive perfect step
        % reference tracking and disturbance rejection
        controller_parameters.Kd=0; % [10^2*ml^2/mg]     
        
        controller_parameters.Ie_max=10^6; 
        controller_parameters.Ie_min=0;     

%% run Simulink
sim('CoffeeReactor_task1')

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

    

