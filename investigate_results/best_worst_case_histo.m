%produce DJ Weber Plot
npf = size(simdata1,1);
T= 100;
[inpar,params] = setpar();
hisdataMLE = zeros(npf,2);
hisdataEM = zeros(npf,2);

for pf = 1 :npf
    x0 = simdata1{pf}{4};
    x = simdata1{pf}{5};
    theta = simdata1{pf}{6};
    %allocate values from the sim results
    mles = zeros(size(x,1),1);
    llses = zeros(size(x,1),1);
    pfolio = simdata1{pf}{1};
    covariates = simdata1{pf}{2};
    actions = simdata1{pf}{3};
    lls = simdata1{pf}{8};
    
    
    for i=1:size(x,1)
        mles(i) = simdata1{pf}{7}(i);
        llses(i) = lls{i}(end);
    end
    
    
    normtype = inf;
    [bMLEv,ibMLE] = min(mles);
    [bEMv,ibEM] = min(llses);%max(llses);
    
    [wMLEv,iwMLE] = max(mles);
    [wEMv,iwEM] = max(llses);%max(llses);
    
    
    bparMLE = reler(x(ibMLE,:))*100;
    wparMLE = reler(x(iwMLE,:))*100;
    bparEM = reler(theta(ibEM,:))*100;
    wparEM = reler(theta(iwEM,:))*100;

%     bparMLE = norm(x(ibMLE,:),normtype)/norm(params,normtype)*100;
%     wparMLE = norm(x(iwMLE,:),normtype)/norm(params,normtype)*100;
%     bparEM = norm(theta(ibEM,:),normtype)/norm(params,normtype)*100;
%     wparEM = norm(theta(iwEM,:),normtype)/norm(params,normtype)*100;    
%     
%     histdataMLE(pf,:) = [bparMLE,wparMLE];
%     histdataEM(pf,:) = [bparEM, wparEM];
    hisdataMLE(pf,:) = [norm(bparMLE,normtype),norm(wparMLE,normtype)];
    hisdataEM(pf,:) = [norm(bparEM,normtype),norm(wparEM,normtype)];
end
%plothist(estparMLE,estparEM,1)
plothist(hisdataMLE,hisdataEM)

function ret = plothist(MLE,EM)
    
    figure;
    hold on 
    histogram(EM(:,1),20);
    histogram(EM(:,2),20);
    hold off
    box on
    legend('Best case EM', 'Worst case EM')
    

    %histogram(MLE(:,1));
    wMLE = MLE(:,2);
    wmleleft = wMLE(wMLE<5*10e2 );
    wmlemid = wMLE(wMLE>5*10e2 );
    wmleright = wmlemid(end);
    wmlemid = wmlemid(1:37);
   
    
    figure
    hold on
    histogram(MLE(:,1),10);
    histogram(wmleleft,10);
    hold off
    box on
    legend('Best case MLE', 'Worst case MLE')
    figure
    histogram(wmlemid(1:37),10);
    
    o_dist = min(wmlemid);
    o_buffer = 100
    box on
    ylim([0,35])

    
end