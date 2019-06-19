function [inpar,params] = setpar()
%set the parameters of the process
inpar.lambda0  =  0.05;
inpar.lambdainf = 0.03;
inpar.kappa =  0.4;
inpar.delta10 =  0.08;
inpar.delta11 = .06;
inpar.delta2 =  [0.03,0.06,0.09];
params = [inpar.lambda0, inpar.lambdainf, inpar.kappa,inpar.delta10,inpar.delta11,inpar.delta2];

% starting balance
inpar.B0 = 1000;

end

