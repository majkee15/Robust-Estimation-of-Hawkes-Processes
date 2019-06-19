%test 3-d plot res
p1 = 2;
p2 = 3;
p3 = 5;

[inpar,params] = setpar();

%all parameters value of the dimension p3
allvals = unique(cartProd(:,p3));

[minValue,closestIndex] = min(abs(allvals - params(p3)));
closest = allvals(closestIndex);
plotsl = cartProd(cartProd(:,p3)==closest,:);
res = res(cartProd(:,p3)==closest);
cond_mle = cond_mle(cartProd(:,p3)==closest);
cond_em = cond_em(cartProd(:,p3)==closest);

surf(reshape(res,30,30))

%log_mle = reshape(log(cond_mle),30,30)
%log_em = reshape(log(cond_em),30,30)
