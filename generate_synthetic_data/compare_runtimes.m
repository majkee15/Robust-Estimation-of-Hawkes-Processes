
T = [500, 1000, 2000];
[par,params] = setpar();
n_acc = 500;
r = 0;
action_seq = [1 2 3];

x = cell(size(T));
lls = cell(size(T));
thetas = cell(size(T));
timings = cell(size(T));

parfor i=1:length(T)
    fprintf('Working on %d.', T(i));
    [accounts, actions_field] = generate_portfolio(n_acc,T(i),par,r,action_seq);
    x0 = rand(size(params));
    objfun = @(par) -loglike_portfolio(accounts,T(i),actions_field,par,0);
    [x{i},fval,exitflag,output] = fmincon(objfun,x0);
    [lls{i},thetas{i},timings{i}] = EM(x0,accounts,actions_field,T(i));
end