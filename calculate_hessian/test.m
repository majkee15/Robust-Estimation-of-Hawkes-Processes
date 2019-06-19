tic
[inpar,params] = setpar();
T = 100;
%Plot from sim results

pf = 1;
p1 = 3;
p2 = 5;
%retreive data from pf
pfolio = simdata1{pf}{1};
covariates = simdata1{pf}{2};
actions = simdata1{pf}{3};
x0 = simdata1{pf}{4};
x1 = simdata1{pf}{5};
thetas = simdata1{pf}{6};
lls = simdata1{pf};

objfun = @(par,N) [- loglike_portfolio(pfolio,covariates,T,actions,par,0),N+1];
objfunem = @(par,N) [- Q(par,thetas(1,:),pfolio,actions,T),N+1];

h = 10e-4;
POINT = thetas(1,:);%x0(5,:);
[H_mle, NFV] = num_hess(objfun, POINT, 0, h)
[H_em, NFV] = num_hess(objfunem, POINT, 0, h)

eig(H_mle)
eig(H_em)

cond(H_mle)-cond(H_em)
toc
%testvar = eig(H_em-H_mle)