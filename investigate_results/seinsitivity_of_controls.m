%Impact of number of actions on accuracy - Reviewer 1 remark
clc, clear;

mc_iterations = 1;

T = 100;
[par,params] = setpar();
n_acc = 200;
r = 0;
action_seq = [1,2,3];

result_mle = zeros(mc_iterations, length(params));
result_em = zeros(mc_iterations, length(params));


for it=1:mc_iterations
    [accounts, actions_field] = generate_portfolio(n_acc,T,par,r,action_seq);
    x0 = rand(size(params));
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb =zeros(size(x0));
    ub = [];
    nonlcon = [];
    objfun = @(par) -loglike_portfolio(accounts,T,actions_field,par,0);
    [x,fval,exitflag,output] = fmincon(objfun, x0, A,b,Aeq,beq,lb,ub,nonlcon);
    [lls,thetas,timings] = EM(x0,accounts,actions_field,T);
    
    result_mle(it,:) = x;
    result_em(it,:) = thetas(end,:);
    
end


