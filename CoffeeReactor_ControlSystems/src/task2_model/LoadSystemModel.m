function SystemModel=LoadSystemModel(exerciseNumber,exactModel)
if ~exist('exactModel')
    exactModel=1;
end

switch exerciseNumber
    case 1
        %% Cruise Control of a Car                
        % Measurement unit conversion
            m_s2km_h=1/1000*3600;
            
        % Sensor Paramters    
            Ts=1;%[s] sampling time
        
        % True System paramters    
            M=10^3; % [kg]
            b=10; %[Ns/m]
            %tau=M/b= 100; % [s]  
                    
        if exactModel==0
            %% Introduce Parameters Mismatch
            % discrepancy among the true system parameters and the model parameters 

            % Mass:     +10% error on the car mass
            M=1.1*M; % [kg]
            % Friction: -10% error on the viscous friction coeff.
            b=0.9*b; %[Ns/m] 
        end
        
        % Continuos Time State Space Model
            Ac=-b/M;
            Bc=1/M;
            Cc=m_s2km_h;
            Dc=0; 
        
   case 2
        %% Tank Level Control 
        % Measurement unit conversion
            l2m3=1/10^3;
            
        % Sensor Paramters    
            Ts=1;%[s] sampling time
        
        % True system parameters    
            A=pi*0.25^2; % [m^2]
            
        if exactModel==0
            %% Introduce Parameters Mismatch
            % discrepancy among the true system parameters and the model parameters 
            
            % Tanks Radius: 10% error on the tank radius  A=pi*(1.1*r)^2=1.1^2 A
              A=1.1^2*A; % [m^2]
        end
        
        % Continuos Time State Space Model
            Ac=0;
            Bc=1/A*l2m3;
            Cc=1;
            Dc=0;
        
    case 3
        %% Position Control of a Car 
        
        % Measurement unit conversion
            m_s2km_h=1/1000*3600;
            
        % Sensor Paramters    
            Ts=1;%[s] sampling time
        
        % True System paramters    
            M=10^3; % [kg]
            b=10; %[Ns/m]
            %tau=M/b= 100; % [s]  
                    
        if exactModel==0
            %% Introduce Parameters Mismatch
            % discrepancy among the true system parameters and the model parameters 

            % Mass:     +10% error on the car mass
            M=1.1*M; % [kg]
            % Friction: -10% error on the viscous friction coeff.
            b=0.9*b; %[Ns/m] 

        end

        % Continuos Time State Space Model
            Ac=[-b/M  0;
                  1   0];
            Bc=[1/M;
                 0];
            Cc=[0, 1];
            Dc=[0];
end

% Exact Discretization using Matlab Toolbox 
sys_c=ss(Ac,Bc,Cc,Dc);
sys_d=c2d(sys_c,Ts);

% System 
SystemModel.A=sys_d.A;
SystemModel.B=sys_d.B;
SystemModel.M=-sys_d.B;
SystemModel.C=sys_d.C;
SystemModel.D=sys_d.D;

