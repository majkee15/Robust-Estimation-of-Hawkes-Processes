[inpar,params] = setpar();
T = 100;
pf=5;
h = 10e-4;
%Plot from sim results
ps = [3 ,5];
%retreive data from pf
pfolio = simdata{pf}{1};
actions = simdata{pf}{2};
x0 = simdata{pf}{3};
x1 = simdata{pf}{4};
thetas = get_converged_theta(simdata{pf}{7});

sets = cell(1,length(params));
parfor ip=1:length(params) 
    if any(ps == ip)
        lb = params(ip)/10;
        ub = params(ip)*10;
        sets{1,ip} = linspace(lb,ub,10);
    else
        sets{1,ip} = params(ip);
    end
end
cartProd = allcomb(sets{:});

% Obj Fun definition consistent with Hessian def
objfun = @(par,N) [- loglike_portfolio(pfolio,T,actions,par,0),N+1];
objfunem = @(par,N) [- Q(par,thetas(end,:),pfolio,actions,T),N+1];

%k = randperm(1000);
%k=randi([1 size(cartProd,1)],1,5000);
%mnew = cartProd(k,:);
mnew = cartProd;

parfor row=1:size(mnew,1)
    p = mnew(row,:);
    [H_mle, NFV] = num_hess(objfun, p, 0, h);
    [H_em, NFV] = num_hess(objfunem, p, 0, h);
    cond_mle(row) = cond(H_mle);
    cond_em(row) = cond(H_em);
end

res = cond_mle-cond_em;

scatter(mnew(:,3),mnew(:,5),100,res','filled');
% scatter3(mnew(:,ps(1)),mnew(:,ps(2)),mnew(:,ps(3)),100,res>0,'filled')
colormap(jet);
colorbar;
xlabel('\lambda_\infty')
ylabel('\kappa')
zlabel('\delta_{10}')
%caxis([-1.0e+06,3.0e+07])
%{
objfun = @(par,N) [- loglike_portfolio(pfolio,covariates,T,actions,par,0),N+1];
objfunem = @(par,N) [- Q(par,thetas(1,:),pfolio,actions,T),N+1];

h = 10e-4;
POINT = thetas(1,:);%x0(5,:);
[H_mle, NFV] = num_hess(objfun, POINT, 0, h)
[H_em, NFV] = num_hess(objfunem, POINT, 0, h)
%}