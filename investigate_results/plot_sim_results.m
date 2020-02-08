%=======================================================================
%Author: Michael Mark
%Plotting script for a given portfolio 2-D contour plots
%(2015)
%=======================================================================
[inpar,params] = setpar();
T = 100;

pf = 5;
% contour plot parameters
p1 = 3;
p2 = 5;

%retreive data from pf
% pfolio = simdata1{pf}{1};
% covariates = simdata1{pf}{2};
% actions = simdata1{pf}{3};
% x0 = simdata1{pf}{4};
% x1 = simdata1{pf}{5};
% thetas = simdata1{pf}{6};
% lls = simdata1{pf};
pfolio = simdata{pf}{1};
actions = simdata{pf}{2};
x0 = simdata{pf}{3};
x1 = simdata{pf}{4};
thetas = get_converged_theta(simdata{pf}{7});

objfun = @(par) - loglike_portfolio(pfolio,T,actions,par,0);
objfunem = @(par) - Q(par,thetas(end,:),pfolio,actions,T);


label = string(pf);
labelmle = strcat(label," MLE ");
labelem = strcat(label," EM ");
range = [20*params(p1),20*params(p2)];

globalrange = [10,10];


[x,y,mles,ems] = setup_grid(p1,p2,globalrange,objfun,objfunem);

plot_loglike_3D(p1,p2,x,y,mles,objfun,[],[],0,labelmle)

plot2Dslice(p1,p2,x,y,mles,ems)
plot_loglike_3D(p1,p2,x,y,ems,objfunem,[],[],0,labelem)


function convergedtheta = get_converged_theta(thetas)
    convergedtheta = zeros(size(thetas,1),size(thetas{1},2));
    for row=1:size(thetas,1)
        convergedtheta(row,:) = thetas{row}(end,:);
    end
end