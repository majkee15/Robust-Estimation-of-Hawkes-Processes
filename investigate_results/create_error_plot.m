function [] = create_error_plot(simdata1,pf)
%%  generate a witty plot
C = linspecer(2) ;
[pfresults] = getbias(simdata1);
sampleres = select_pfolio(pfresults,pf);
bias = [sampleres(1,:);sampleres(3,:)];
stds = [sampleres(2,:);sampleres(4,:)];
figure;
hold on;
box on;
for i=1:8
    y=i;
    posmle = y-1+2/3;
    errmle = stds(1,i);
    %if(bias(1,i) < 10000)
    errorbar(bias(1,i),posmle,errmle,'horizontal','o','MarkerSize',6,...
        'MarkerEdgeColor',C(2,:),'MarkerFaceColor',C(2,:),'Color',C(2,:))
    %end
    posem = y-1+1/3;
    errem = stds(2,i);
    errorbar(bias(2,i),posem,errem,'horizontal','o','MarkerSize',6,...
        'MarkerEdgeColor',C(1,:),'MarkerFaceColor',C(1,:),'Color',C(1,:))
end
line([0,0],ylim,'Color','black','LineStyle','-.')
for i = 1:8
    y = i;
    line(xlim,[y,y],'Color','black','LineStyle','--');
end
%perc ticks
%{
a = [cellstr(num2str(get(gca,'xtick')'))];
pct = char(ones(size(a,1),1)*'%');
new_xticks =[char(a),pct];
set(gca,'xticklabel',new_xticks);
%}
yticks = {'\lambda_0', '\lambda_\infty','\kappa','\delta_{10}','\delta_{11}','\delta_{21}','\delta_{22}','\delta_{23}'};
set(gca,'ytick',[1:8],'yticklabel',yticks)

legend('MLE','EM')
hold off;

end

function [pfresults] = getbias(simdata1)
pfresults = [];


for pf = 1:size(simdata1,1)%
    relmle = reler(simdata1{pf}{5});
    relem = reler(simdata1{pf}{6});
    
    relmlemean = mean(relmle,1);
    relemmean = mean(relem,1);
    
    cvmle = std(relmle,1)./ relmlemean;
    cvem = std(relem,1)./ relemmean;
    
    pfresults = cat(1,pfresults,relmlemean,cvmle,relemmean,cvem);
end
end

function res = select_pfolio(pfresults,pf)
startfrom = (pf-1)*4+1;
continueto = startfrom + 3;
res = pfresults(startfrom:continueto,:);
end


