function future_ref = futureRefCalc(t,struct_ref,PH,Ts)
% inputs : t, current time stimate
%          struct_ref, contains reference signal and corresponding time
%          values
%          PH, prediction horizon
%          Ts, sample time
% output: vector of future reference values (dim: PH x 1)

t_ref = struct_ref.time;
y_ref = struct_ref.signals.values;

future_ref = zeros(PH,1);        %vector containing future references 
t_val_fin = t + (PH*Ts);         %final time value (after PH instants)
t_temp = t+Ts:Ts:t_val_fin;      %time vector corresponding to future ref:
%                                 from k+1 to k+N (N=PH), with k being the current instant                              

% if t belongs to the last interval, y_ref is fixed to the last ref value
if t > t_ref(end-1)
    future_ref = future_ref + y_ref(end); 

%otherwise, each value is compared to the time instants
else
    for j=1:length(t_temp)
        ind_t = find(t_temp(j) < t_ref, 1, 'first');
        future_ref(j) = y_ref(ind_t-1);
    end
end


