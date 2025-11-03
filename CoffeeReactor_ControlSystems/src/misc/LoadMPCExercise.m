function exerciseData=LoadMPCExercise(exerciseNumber,removeContraints,removeDistrubance,removeUnknownDistrubance)

if ~exist('removeContraints')
    removeContraints=0;
end
if ~exist('removeDistrubance')
    removeDistrubance=1;
end
if ~exist('removeUnknownDistrubance')
    removeUnknownDistrubance=1;
end


switch exerciseNumber
    case 1
        %% Cruise Control of a Car                
        % Measurement unit conversion
            m_s2km_h=1/1000*3600;
        
        % System paramters    
            M=10^3; % [kg]
            b=10; %[Ns/m]
            %tau=M/b= 100; % [s]  
            
        % Continuos Time State Space Model
            Ac=-b/M;
            Bc=1/M;
            Cc=m_s2km_h;
            Dc=0;
            
        % Sensor Paramters    
            exerciseData.Ts=1;%[s] sampling time
        
        % Simulation paramters
            exerciseData.SimTime=500; %[s]   
            
            exerciseData.Astep=50; %[km/h]
            exerciseData.Tstep=10; %[s]
            
            exerciseData.Tdist=150;%[s]
            exerciseData.D=M*9.8*sin(pi/180*5);%[N]
            
            exerciseData.TdistUnknown=2*exerciseData.Tdist;%[s]
            exerciseData.DUnknown=exerciseData.D;%
            
            exerciseData.u_max=4*10^3;%[N]
            exerciseData.u_min=-exerciseData.u_max;%[N]    
   case 2
        %% Tank Level Control 
        % Measurement unit conversion
            l2m3=1/10^3;
        
        % System paramters    
            A=pi*0.25^2; % [m^2]
            
        % Continuos Time State Space Model
            Ac=0;
            Bc=1/A*l2m3;
            Cc=1;
            Dc=0;  
            
       % Sensor Paramters    
            exerciseData.Ts=1;%[s] sampling time
            
       % Simulation paramters
            exerciseData.SimTime=1000; %[s]   
            
            exerciseData.Astep=1; %[m]
            exerciseData.Tstep=10; %[s]
            
            exerciseData.Tdist=150;%[s]
            exerciseData.D=5;%[l/s]
            
            exerciseData.TdistUnknown=1.5*exerciseData.Tdist;%[s]
            exerciseData.DUnknown=exerciseData.D;%
            
            exerciseData.u_max=10;%[l/s] 
            exerciseData.u_min=0;%[l/s]

    case 3
        %% Position Control of a Car                
        
        % System paramters    
            M=10^3; % [kg]
            b=10; %[Ns/m]
            %tau=M/b= 100; % [s]  
            
        % Continuos Time State Space Model
            Ac=[-b/M  0;
                  1   0];
            Bc=[1/M;
                 0];
            Cc=[0, 1];
            Dc=[0];
            
        % Sensor Paramters    
            exerciseData.Ts=1;%[s] sampling time
            
        % Simulation paramters
            exerciseData.SimTime=5000; %[s]   
            
            exerciseData.Astep=80; %[m]
            exerciseData.Tstep=10; %[s]
            
            exerciseData.Tdist=300;%[s]
            exerciseData.D=M*9.8*sin(pi/180*5);%[N]
            
            exerciseData.TdistUnknown=2*exerciseData.Tdist;%[s]
            exerciseData.DUnknown=exerciseData.D;%
            
            exerciseData.u_max=4*10^3;%[N]
            exerciseData.u_min=-exerciseData.u_max;%[N]

    case 4
        %% Position Control of a Car                      
        % System paramters    
            M=10^3; % [kg]
            b=100; %[Ns/m]
            %tau=M/b= 100; % [s]  

        % Continuos Time State Space Model
            Ac=[-b/M  0;
                  1   0];
            Bc=[1/M;
                 0];
            Cc=[0, 1];
            Dc=[0];
            
        % Sensor Paramters    
            exerciseData.Ts=1;%[s] sampling time    
            
        % Simulation paramters
            exerciseData.SimTime=1000; %[s]   
            
            exerciseData.Astep=80; %[m]
            exerciseData.Tstep=10; %[s]
            
            exerciseData.Tdist=300;%[s]
            exerciseData.D=M*9.8*sin(pi/180*5);%[N]
            
            exerciseData.TdistUnknown=2*exerciseData.Tdist;%[s]
            exerciseData.DUnknown=exerciseData.D;%
            
            exerciseData.u_max=4*10^3;%[N]
            exerciseData.u_min=-exerciseData.u_max;%[N]
            
   case 5
        %% Position Control of a Car                        
        % System paramters    
            M=10^3; % [kg]
            b=100; %[Ns/m]
            %tau=M/b= 100; % [s]  

        % Continuos Time State Space Model
            Ac=[-b/M  0;
                  1   0];
            Bc=[1/M;
                 0];
            Cc=[0, 1];
            Dc=[0];
            
        % Sensor Paramters    
            exerciseData.Ts=1;%[s] sampling time
            
        % Simulation paramters
            exerciseData.SimTime=1000; %[s]   
            
            exerciseData.Astep=80; %[m]
            exerciseData.Tstep=10; %[s]
            
            exerciseData.Tdist=300;%[s]
            exerciseData.D=M*9.8*sin(pi/180*5);%[N]
            
            exerciseData.TdistUnknown=2*exerciseData.Tdist;%[s]
            exerciseData.DUnknown=exerciseData.D;%
            
            exerciseData.u_max=4*10^3;%[N]
            exerciseData.u_min=-exerciseData.u_max;%[N]
end
%% Exact Discretization using Matlab Toolbox 
    sys_c=ss(Ac,Bc,Cc,Dc);
    sys_d=c2d(sys_c,exerciseData.Ts);

%% System 
    exerciseData.System.A=sys_d.A;
    exerciseData.System.B=sys_d.B;
    exerciseData.System.M=-sys_d.B;
    exerciseData.System.C=sys_d.C;
    exerciseData.System.D=sys_d.D;
    
    exerciseData.x_0=zeros(size(sys_d.A,1),1);

if removeContraints>0
    exerciseData.u_max=10^8;%practically infinity, i.e. no contraint
    exerciseData.u_min=-exerciseData.u_max;
end

if removeDistrubance>0
    exerciseData.D=0;
end

if removeUnknownDistrubance>0
    exerciseData.DUnknown=0;
end


