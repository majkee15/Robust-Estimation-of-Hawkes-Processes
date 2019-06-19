
[inpar,params] = setpar();
T = 100;
pf=5;
h = 10e-4;

%retreive data from pf
pfolio = simdata1{pf}{1};
covariates = simdata1{pf}{2};
actions = simdata1{pf}{3};
x0 = simdata1{pf}{4};
x1 = simdata1{pf}{5};
thetas = simdata1{pf}{6};
lls = simdata1{pf};

sets = cell(1,length(params));
parfor ip=1:length(params)
    lb = params(ip)/10;
    ub = params(ip)*10;
    sets{1,ip} = linspace(lb,ub,10);
end
cartProd = allcomb(sets{:});


objfun = @(par,N) [- loglike_portfolio(pfolio,covariates,T,actions,par,0),N+1];
objfunem = @(par,N) [- Q(par,thetas(1,:),pfolio,actions,T),N+1];

k=randi([1 1e8],1,5000);
mnew = cartProd(k,:);

parfor row=1:size(mnew,1)
    p = mnew(row,:);
    [H_mle, NFV] = num_hess(objfun, p, 0, h)
    [H_em, NFV] = num_hess(objfunem, p, 0, h)
    cond_mle(row) = cond(H_mle);
    cond_em(row) = cond(H_em);
end

res = cond_mle-cond_em;

%scatter(mnew(:,3),mnew(:,5),100,res','filled');
scatter3(mnew(:,3),mnew(:,5),mnew(:,4),100,res>0,'filled')
colormap(jet);
colorbar;
caxis([-1.0e+06,3.0e+07])
%{
objfun = @(par,N) [- loglike_portfolio(pfolio,covariates,T,actions,par,0),N+1];
objfunem = @(par,N) [- Q(par,thetas(1,:),pfolio,actions,T),N+1];

h = 10e-4;
POINT = thetas(1,:);%x0(5,:);
[H_mle, NFV] = num_hess(objfun, POINT, 0, h)
[H_em, NFV] = num_hess(objfunem, POINT, 0, h)
%}