
T = 100;
[par,params] = setpar();
n_acc = 100;
r = 2;
normalized = 1;
action_seq = [1 2 2  3 3 1 1 3 2];




[accounts, actions_field] = generate_portfolio(n_acc,T,par,r,action_seq);


x0 = rand(size(params));
objfun = @(par) -loglike_portfolio(accounts,T,actions_field,par,0);
[x,fval,exitflag,output] = fmincon(objfun,x0);

[lls,thetas,timings] = EM_comp(x0,accounts,actions_field,T);