function [inpar,params] = setparlimit(action_size)
%set the parameters of the process
inpar.lambda0  =  0.05;
inpar.lambdainf = 0.03;
inpar.kappa =  0.4;
inpar.delta10 =  0.08;
inpar.delta11 = .06;
inpar.delta2 =  action_size;
params = [inpar.lambda0, inpar.lambdainf, inpar.kappa,inpar.delta10,inpar.delta11,inpar.delta2];

% starting balance
inpar.B0 = 1000;

end

