close all
[inpar,params] = setpar();
T = 100;
%Plot from sim results

pf = 1;
p1 = 4;
p2 = 5;
%retreive data from pf
pfolio = simdata1{pf}{1};
actions = simdata1{pf}{2};
x0 = simdata1{pf}{3};
x1 = simdata1{pf}{4};
thetas = simdata1{pf}{7};
allthetas = simdata1{pf}{9}{1};

plotlist = linspace(1,size(allthetas,1),5);

label = string(pf);
labelmle = strcat(label," MLE ");
labelem = strcat(label," EM ");
range = [20*params(p1),20*params(p2)];
globalrange = [10,10];
objfun = @(par) - loglike_portfolio(pfolio,T,actions,par,0);
ems = cell( ceil(size(allthetas,1)/3),1);
for index=1:length(plotlist)
    i = plotlist(index);
    objfunem = @(par) - Q(par,allthetas(i,:),pfolio,actions,T);
    [x,y,mles,ems{i}] = setup_grid(p1,p2,globalrange,objfun,objfunem);
end

plot2Dslice_progression(p1,p2,x,y,mles,ems)