function u=MPC_control_4_2(yr,x_a,u_k_1,condMat,PH,I)

% inputs: reference, current state, previous inputs,
%         struct containing call Matrices, PH value
% output: first terms of the control inputs sequence (delta_u1 and
%         delta_u2)

condMat.call_f = kron(ones(PH,1),u_k_1)./I;  %we substitute the matrix with the correct one

if any(u_k_1<0)
    disp("Warning: negative control inputs calculated!")
end

Ac=condMat.call_AC; Bc=condMat.call_BC;
Q=condMat.call_Q; R=condMat.call_R;
%Yr=kron(ones(PH,1),yr); old
Yr=yr;  %the input is already in its calligraphic form
Y_k_1=kron(ones(PH,1),x_a(2));

%All above matrices and vectores to be considered "calligraphic"
H_qp=Bc'*Q*Bc+R;

% f_qp=((Ac*x-Yr)'*Q*Bc)';
f_qp=Bc'*Q*(Ac*x_a(1)+Y_k_1-Yr);

A_qp=condMat.call_F;
b_qp=condMat.call_f;

options = optimset('Display','off','Algorithm','interior-point-convex','TolFun',1e-9);

[u_seq]=quadprog((H_qp+H_qp')/2,f_qp,A_qp,b_qp,[],[],[],[],[],options);
%u_seq is a vector that should contain both delta_u1 and delta_u2

delta_u = reshape(u_seq,2,PH);
delta_u1=delta_u(1,:)';
delta_u2=delta_u(2,:)';

u1 = delta_u1;
u2 = delta_u2;

u=[u1(1);u2(1)];


