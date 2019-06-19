function [] = plot_MLE_3D_convergence(p1,p2,params,range,objfun,x0,x1,plotsurface,label)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

range1 = range(1);
range2 = range(2);


par_grid1 = 0:range1*0.05:range1;
par_grid1 = par_grid1(par_grid1>0);
par_grid2 = 0:range2*0.05:range2;
par_grid2 = par_grid2(par_grid2>0);


[x,y] = meshgrid(par_grid1, par_grid2);
z = zeros(size(x));
zem = zeros(size(x));
c = params;
figure;
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
        z(i,j) = objfun(objfuncforparfor(x(i,j),y(i,j)));
        zem(i,j) = objfun2(objfuncforparfor(x(i,j),y(i,j)));
    end
end

%percentage adjustment
x = (x-params(p1))./params(p1);
y = (y-params(p2))./params(p2);
x0(:,p1) = (x0(:,p1) - params(p1))./params(p1);
x0(:,p2) = (x0(:,p2) - params(p2))./params(p2);
x1(:,p1) = (x1(:,p1) - params(p1))./params(p1);
x1(:,p2) = (x1(:,p2) - params(p2))./params(p2);
range1 = (range1 - params(p2))./params(p2);
range2 = (range2 - params(p2))./params(p2);
range = [range1,range2];
par1 = 0;
par2 = 0;

%% Controul Plot HERE
hold on
%contour(x,y,z,'ShowText','on');
contour(x,y,z,'LevelStep', 40);
scatter(par1,par2,42,'MarkerEdgeColor','k','MarkerFaceColor','r')

for i=1:size(x1,1)
    P1 = [x0(i,p1),x0(i,p2)];
    P2 = [x1(i,p1),x1(i,p2)];
    D = P2 - P1;
    if sum(P2<range)==2
        scatter(P1(1),P1(2),42,'x','MarkerEdgeColor','k','MarkerFaceColor','r');
        scatter(P2(1),P2(2),42,'d','MarkerEdgeColor','k','MarkerFaceColor','b');
        quiver( P1(1), P1(2), D(1), D(2), 1,'MaxHeadSize',0.01,'Color','black')
    else
        scatter(P1(1),P1(2),42,'square','MarkerEdgeColor','k','MarkerFaceColor','r');
    end
end
%convert to percentage
xticks_old = get(gca,'xtick');

yticks_old = get(gca,'ytick');

a1 = [cellstr(num2str(xticks_old'*100))];
pct1 = char(ones(size(a1,1),1)*'%');
new_xticks =[char(a1),pct1];
set(gca,'xticklabel',new_xticks);

a2 = [cellstr(num2str(yticks_old'*100))];
pct2 = char(ones(size(a2,1),1)*'%');
new_yticks =[char(a2),pct2];
set(gca,'yticklabel',new_yticks);

hold off
tit = strcat("Portfolio  ",label," ",string(p1)," and ",string(p2));
title(tit);


%% surf
if plotsurface == 1
    figure;
    hold on;
    %[dfdx,dfdy] = gradient(z);
    %quiver(x,y,dfdx,dfdy)
    surf(x,y,z,'edgecolor','none');
    %colorbar

    scatter3(par1,par2,objfun(params), 42,'MarkerEdgeColor','k','MarkerFaceColor','g')
    for i=1:size(x1,1)
        P1 = [x0(i,p1),x0(i,p2)];
        P2 = [x1(i,p1),x1(i,p2)];
        if ~(sum(P2<range)==2)
            [c,pos1]=min(abs(x(1,:)-P1(1)));
            [c,pos2]=min(abs(y(:,1)-P1(2)));
            %objfun(x0(i,:))
            scatter3(x(1,pos1),y(pos2,1),z(pos2,pos1),42,'d','MarkerEdgeColor','k','MarkerFaceColor','r');
        end
    end
    tit = strcat("Portfolio  ",label," ",string(p1)," and ",string(p2));
    title(tit);
    hold off
    %convert to percentage
    %{
    xticks_old = get(gca,'xtick');
    
    yticks_old = get(gca,'ytick');
    
    a1 = [cellstr(num2str(xticks_old'*100))];
    pct1 = char(ones(size(a1,1),1)*'%');
    new_xticks =[char(a1),pct1];
    set(gca,'xticklabel',new_xticks);
    
    a2 = [cellstr(num2str(yticks_old'*100))];
    pct2 = char(ones(size(a2,1),1)*'%');
    new_yticks =[char(a2),pct2];
    set(gca,'yticklabel',new_yticks);
    hold off;
    %}
end

end
function c = cforpar (x,y,par,p1,p2)
c = par;
c(p1) = x;
c(p2) = y;
end
