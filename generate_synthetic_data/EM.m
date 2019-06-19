function [lls,thetas,timings] = EM(x0,pfolio,actions,T)
%=======================================================================
%Author: Michael Mark
% EM iterative algorithm for parameter estimation
%=======================================================================
theta_0 = x0;


c = 1;
k=1;
A = [];
b = [];
Aeq = [];
beq = [];
lb =zeros(size(x0));
ub = [];
nonlcon = [];
options = optimoptions('fmincon','Display','off');
lls = [];
lls(1) = -Q(theta_0(1,:),theta_0(1,:),pfolio,actions,T); 
while c> 10e-4
    objfun = @(x) -Q(x,theta_0(k,:),pfolio,actions,T);
    try
        tic;
        [opt,fval,exitflag,output] = fmincon(objfun,theta_0(k,:),A,b,Aeq,beq,lb,ub,nonlcon,options);
        timings(k) = toc;
    catch
        fprintf('iteration %i \n',k)
    end
        
    
    k=k+1;
    theta_0(k,:) = opt;
    %lls(k) = CL(opt,opt,pfolio,actions,T);
    %huliklada(k,1) = CL(opt,opt,pfolio,actions,T);
    %huliklada(k,2) = CL(opt,theta_0(k-1,:),pfolio,actions,T);
    lls(k) = fval;
    
    c = abs(lls(end) - lls(end-1));
    %c = lls(end) - lls(end-1);

end

thetas = theta_0;
end
