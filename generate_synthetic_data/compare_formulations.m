
T = [500];
[par,params] = setpar();
n_acc = 100;
r = 0;
action_seq = [1 2 3];

x = cell(size(T));
lls = cell(size(T));
thetas = cell(size(T));
timings = cell(size(T));

lls_naive = cell(size(T));
thetas_naive = cell(size(T));
timings_naive = cell(size(T));

for i=1:length(T)
    fprintf('Working on %d.', T(i));
    [accounts, actions_field] = generate_portfolio(n_acc,T(i),par,r,action_seq);
    x0 = rand(size(params));
    objfun = @(par) -loglike_portfolio(accounts,T(i),actions_field,par,0);
    [x{i},fval,exitflag,output] = fmincon(objfun,x0);
    [lls_naive{i}, thetas_naive{i}, timings_naive{i}] = EM_naive(x0, accounts, actions_field,T(i));
    [lls{i}, thetas{i}, timings{i}] = EM(x0, accounts, actions_field,T(i));
end

hold on
plot(log(lls{1}(2:end)), 'x')
plot(log(lls_naive{1}(2:end)), 'x', color='red')
hold off

% filename = 'compare_formulations.mat';
% save(filename)