function output=myPID(ref,y,Ie_old,y_old,controller_paramters)

% ANNA

%% Input Description
% ref contains r(k)
% y contains y(k)
% I_old contains the integral of the error up to time k I_e(k-1)
%       i.e the sum of all errors up to time k-1. 
%       Needed to computate of the integral action
% y_old contains y(k-1)
%       Needed to computate of the derivative (and thus the derivative action)

% controller_paramter is a structure with at least 3 fields
% controller_paramters.Kp 
% controller_paramters.Ki 
% controller_paramters.Kd 
% controller_paramters.Ts

%% Output Description
% output is a vector:
% output(1) contains u(k)
% output(2) contains I_e(k) (to be memorized and used in the next cycle)
% output(3) contains y(k)   (to be memorized and used in the next cycle)
% output(4) containts P(t)
% output(5) containts I(t)
% output(6) containts D(t)


%% Input measurment units %(depends on the application)
% y,r and y_old are expected in [mg/dl]
% Ie is expected  [(mg/dl)*min]
% time_y,time_y_old are expected in [min]

% controller_paramters.Kp [dl/min]
% controller_paramters.Ki [dl/min^2]
% controller_paramters.Kd [dl]
% controller_paramters.Ts [min]

%% Output measurment units %(depends on the application)
%u and u_totUnsat are in [mg/min]
%P,I,D are in [mg/min]
%Ie is in are [(mg/dl)*min]


%% Proportional Action
    P=controller_paramters.Kp*(ref-y);         %[mg/min]

%% Integral Action
    I=controller_paramters.Ki*Ie_old;            %[mg/min]
    % Integral of the error
        Ie=Ie_old+(ref-y)*controller_paramters.Ts; %[(mg/dl)*min]
    
    % AntiWind-up
        Ie=min(Ie,controller_paramters.Ie_max);
        Ie=max(Ie,controller_paramters.Ie_min);

%     I=controller_paramters.Ki*Ie;            %[mg/min]
    
%% Derivative Action
     dy=(y-y_old)/controller_paramters.Ts;    %[mg/dl/min]
     D= -controller_paramters.Kd*dy;            %[mg/min]

   
%% Total Control Action
    u= P+I+D; %[mg/min]
   
%% Building the Output Vector    
    output=[u,Ie,y,P,I,D]';
