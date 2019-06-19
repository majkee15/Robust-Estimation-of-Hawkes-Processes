function [] = plot2Dslice_progression(p1,p2,xs,ys,mles,ems)
ems = ems(~cellfun('isempty',ems));
n= length(ems);

[inpar,params] = setpar();

x = xs(1,:);
y = ys(:,1);

[minValx,closestIndexx] = min(abs(x-params(p1)));
[minValy,closestIndexy] = min(abs(y-params(p2)));

figure;
hold on;
plot(y,mles(closestIndexx,:));
for i=1:n
    txt = ['X = ',num2str(i)];
    plot(y,ems{i}(closestIndexx,:),'DisplayName',txt);
end
plot([y(closestIndexy),y(closestIndexy)],ylim,'--');
hold off;
%legend('MLE','EM');
legend show

figure;
hold on;
plot(x,mles(:,closestIndexy));
for i=1:n
    plot(x,ems{i}(:,closestIndexy));
end
plot([x(closestIndexx),x(closestIndexx)],ylim,'--');
hold off;
legend('MLE','EM');

end