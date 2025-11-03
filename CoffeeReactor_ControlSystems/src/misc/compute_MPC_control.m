function u_MPC=compute_MPC_control(x_k_given_k,y0_current,u0_current,d_current,condensedMatrices,num_of_input,N)
y0=kron(ones(N,1),y0_current);
u0=kron(ones(N,1),u0_current);
d=kron(ones(N,1),d_current);

Q_qp= condensedMatrices.call_BC'*condensedMatrices.call_Q*condensedMatrices.call_BC+condensedMatrices.call_R;

c_qp=condensedMatrices.call_BC'*condensedMatrices.call_Q*(condensedMatrices.call_AC*x_k_given_k+condensedMatrices.call_MC*d-y0)-condensedMatrices.call_R*u0;

A_qp=condensedMatrices.call_F;
b_qp=condensedMatrices.call_f;


options = optimset('Display','off','Algorithm','interior-point-convex');
[u_sequence,~,exit_flag]=quadprog((Q_qp+Q_qp')/2,c_qp,A_qp,b_qp,[],[],[],[],[],options); % To Avoid warning

u_MPC_sequence=reshape(u_sequence,num_of_input,size(u_sequence,1)/num_of_input);
u_MPC=u_MPC_sequence(:,1);