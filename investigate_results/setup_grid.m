function [x,y,mles,ems] = setup_grid(p1,p2,range,objfun,objfunem)
% sets up grid for three D plot + paralelly evaluate MLEs and EMs on the
% grid
[inpar,params] = setpar();

range1 = range(1);
range2 = range(2);

lbp1 = params(p1) / range1;
ubp1 = params(p1) * range1;

lbp2 = params(p2) / range2;
ubp2 = params(p2) * range2;

step1 = (ubp1-lbp1) / 50;
step2 = (ubp2-lbp2) / 50;

par_grid1 = lbp1:step1:ubp1;
par_grid2 = lbp2:step2:ubp2;


[x,y] = meshgrid(par_grid1, par_grid2);

mles = zeros(size(x));
ems = zeros(size(x));

c = params;
n1 = length(par_grid1);
n2 = length(par_grid2);
%parfor here
%{
for i = 1:n2
    for j =1:n1
        c(p1) = x(i,j);
        c(p2) = y(i,j);
        z(i,j) = objfun(c);
    end
end
%}
objfuncforparfor = @(x,y) cforpar(x,y,params,p1,p2);
parfor i = 1:n2
    for j =1:n1
        mles(i,j) = objfun(objfuncforparfor(x(i,j),y(i,j)));
        ems(i,j) = objfunem(objfuncforparfor(x(i,j),y(i,j)));
    end
end
end

function c = cforpar (x,y,par,p1,p2)
c = par;
c(p1) = x;
c(p2) = y;
end

