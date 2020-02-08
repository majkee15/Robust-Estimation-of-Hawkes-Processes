%plot_hessian_2_d(p1,p2,cartProd,cond_em,cond_mle)
%11/4/2019

p1 = 2;
p2 = 3;
p3 = 5;
[inpar,params] = setpar();

cond_mle = log(cond_mle);
cond_em = log(cond_em);

%all parameters value of the dimension p3
allvals = unique(cartProd(:,p3));

[minValue,closestIndex] = min(abs(allvals - params(p3)));
closest = allvals(closestIndex);
plotsl = cartProd(cartProd(:,p3)==closest,:);
res = res(cartProd(:,p3)==closest);
cond_mle = (cond_mle(cartProd(:,p3)==closest));
cond_em = (cond_em(cartProd(:,p3)==closest));
x=plotsl(:,p1);
y=plotsl(:,p2);
figure;
res = cond_mle-cond_em
scatter(x,y,100,res>0,'filled');
colormap(jet);
colorbar;


x = unique(cartProd(:,p1));
y = unique(cartProd(:,p2));

[x,y] = meshgrid(x,y);
cond_mle = reshape(cond_mle,50,50);
cond_em = reshape(cond_em,50,50);
[minValue,closestIndex] = min(abs(x(p1,:) - params(p3)));
surf(x,y,cond_mle)