clc, clear, close 
addpath("Sources")

%% Load PhotoBioReactor Parameters and Simulation Parameters
    simulationParameters=load_simulation_parameters;
%Set exercise-specific parameters.
Ts=simulationParameters.Ts; %for easier readability


%% Linear Model (Discrete)
parameters=simulationParameters.Reactor_parameters;
A=0; B=[1/parameters.V*(parameters.C_in1-parameters.x_0), -parameters.x_0/parameters.V];
C=1; D=0;
M=0;
sys_c = ss(A,B,C,D); %continuous model
sys_d = c2d(sys_c,Ts); %discrete model
systemModel.A=sys_d.A;
systemModel.B=sys_d.B;
systemModel.C=sys_d.C;
systemModel.D=sys_d.D;
systemModel.M = 0;


%% MPC Parameters
r= 1;
R= r*eye(parameters.m); %2 inputs, so 2x2 matrix
Q= 1; %1 output, so single value
F= [-1 0;
    0 -1];
f= [ simulationParameters.Fin1_min
     simulationParameters.Fin2_min
    ];

PH=50;
I=5; %integral gain for discrete integrator

%PH=50, I=15, Q=1, r=1 for ex 1


%% Building Condensed Matrices
condensedMat = BuildCondendsedMPCmatrices(systemModel,R,Q,F,f,PH);


%% Exercise 4.1 - No constraints
sim("CoffeeReactor_ex_4_2.slx")


%% Plot
figure;
    subplot(2,1,1)
        h(1)=stairs(reactorOutput.time,reactorOutput.signals(1).values,'k');
        hold on
        h(2)=stairs(reactorOutput.time, reactorOutput.signals(2).values,'LineWidth',2);
        %stairs([0 simulationParameters.Tsim],simulationParameters.Reactor_parameters.C_in1*[1 1],'k--');
        plot(simulationParameters.y_target.time, simulationParameters.y_target.signals.values*1.05,'b--');
        plot(simulationParameters.y_target.time, simulationParameters.y_target.signals.values*0.95,'b--');
        hold off 
        ylabel('C(t)- [mg/dl]')
        xlabel('time [min]')
    
        ylim([0 60])
        legend(h,{'ref','output'})
        title('Coffee output concentration')

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
        title('Control Inputs')

%disturbance rejection focus
figure
    h(1)=stairs(reactorOutput.time,reactorOutput.signals(1).values,'k');
    hold on
    h(2)=stairs(reactorOutput.time, reactorOutput.signals(2).values,'LineWidth',2);
    %stairs([0 simulationParameters.Tsim],simulationParameters.Reactor_parameters.C_in1*[1 1],'k--');
    plot(simulationParameters.y_target.time, simulationParameters.y_target.signals.values*1.05,'b--');
    plot(simulationParameters.y_target.time, simulationParameters.y_target.signals.values*0.95,'b--');
    hold off 
    ylabel('C(t)- [mg/dl]')
    xlabel('time [min]')
    xlim([118 123])
    ylim([30 50])
    legend(h,{'ref','output'})
    title('Focus on disturbance rejection - Task 4.2')