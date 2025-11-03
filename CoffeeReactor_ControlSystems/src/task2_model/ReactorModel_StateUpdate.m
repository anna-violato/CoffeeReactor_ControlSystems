function dot_x=ReactorModel_StateUpdate(x,u,d,parameters)
%% State Update of the continuos-time Reactor Model 
% x:    current state vector
%   x(1): coffee concentration    X %[mg/dl]
%   u(1): F_in_1, inflow of concentrated coffee [ml/min]
%   u(1): F_in_2, inflow of water [ml/min]
%   d: unmeasurable distubance
% parameters: model paramters
%       parameters.V: Reactor Volume [ml]
%       parameters.C_in1: coffee concentration in the inflow 1 [mg/dl]
%       Note: coffee concentration in the inflow 2 is C_in_2=0[mg/dl], as pure water in contained in the second inflow
    
%% State Update    
    % Biomass concentration update
        dot_x= (parameters.C_in1- x)./parameters.V*u(1) - x*(u(2)+d)./parameters.V;
