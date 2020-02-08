function [] = plot_hessian_slice(p1,p2,p3,cartProd,cond_mle,cond_em)
[inpar,params] = setpar();

% cond_mle = log(cond_mle);
% cond_em = log(cond_em);

%all parameters value of the dimension p3
allvals = unique(cartProd(:,p3));
[minValue,closestIndex] = min(abs(allvals - params(p3)));
closest = allvals(closestIndex);
plotsl = cartProd(cartProd(:,p3)==closest,:);
cond_mle = (cond_mle(cartProd(:,p3)==closest));
cond_em = (cond_em(cartProd(:,p3)==closest));
x=plotsl(:,p1);
y=plotsl(:,p2);
figure;
scatter(x,y,100,(cond_mle-cond_em)>0,'filled');
colormap(jet);
colorbar;

x = unique(cartProd(:,p1));
y = unique(cartProd(:,p2));
figure
[x,y] = meshgrid(x,y);
dimension = sqrt(size(cond_mle,2));
cond_mle = reshape(cond_mle,dimension,dimension);
cond_em = reshape(cond_em,dimension,dimension);
[minValue,closestIndex] = min(abs(x(p1,:) - params(p1)));
semilogy(x(1,:),cond_mle(closestIndex,:))
hold on
semilogy(x(1,:),cond_em(closestIndex,:))
hold off
legend('MLE','EM')
figure;
[minValue,closestIndex] = min(abs(y(:,p2) - params(p2)));
semilogy(y(:,1),cond_mle(:,closestIndex))
hold on
semilogy(y(:,1),cond_em(:,closestIndex))
hold off
legend('MLE','EM')

figure;
surf(x,y,cond_mle-cond_em);
end

