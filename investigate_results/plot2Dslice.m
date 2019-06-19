function [] = plot2Dslice(p1,p2,xs,ys,mles,ems)

[inpar,params] = setpar();

x = xs(1,:);
y = ys(:,1);

[minValx,closestIndexx] = min(abs(x-params(p1)));
[minValy,closestIndexy] = min(abs(y-params(p2)));

figure;
hold on;
plot(y,mles(closestIndexx,:));
plot(y,ems(closestIndexx,:));
plot([y(closestIndexy),y(closestIndexy)],ylim,'--');
hold off;
legend('MLE','EM');

figure;
hold on;
plot(x,mles(:,closestIndexy));
plot(x,ems(:,closestIndexy));
plot([x(closestIndexx),x(closestIndexx)],ylim,'--');
hold off;
legend('MLE','EM');

end

