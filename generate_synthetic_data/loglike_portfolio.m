function [Loglike] = loglike_portfolio(accounts, timeframe, actions, params,regularized)
%=======================================================================
%Author: Michael Mark
%LOGLIKE_PORTFOLIO loglikelihood estimation on a portfolio level
%parameters in form [lambdainf,k0,k1,k2,d10,d11,d12,d20,d21,d22]
%=======================================================================

par.lambda0 = params(1);
par.lambdainf = params(2); 
par.kappa = params(3); 
par.delta10 = params(4);
par.delta11 = params(5);
par.delta2 = params(6:end);

n_acc = length(accounts);
loglike = zeros(1,n_acc);


for account=1:n_acc
    
    actions_effects = zeros(size(actions{account}(2,:)));
    for i=1:length(actions_effects)
        actions_effects(i) = par.delta2(actions{account}(2,i));
    end
    
    if isempty(accounts{1,account})
        arrivals = [];
        repayments = [];
    else
        arrivals = accounts{1,account}(1,:);
        repayments = accounts{1,account}(2,:);
    end
    actions_times = actions{1,account}(1,:);
    n = length(arrivals);

    
    runningsum=0;
    R_i = zeros(1,n);
    for i=1:n
        
        if i ~= 1
            R_i(i) = exp(-par.kappa*(arrivals(i)-arrivals(i-1))) * (par.delta10+par.delta11*repayments(i-1) + R_i(i-1));
        end
        
        runningsum = runningsum  + log (par.lambdainf +(par.lambda0 - par.lambdainf)*exp(-par.kappa*arrivals(i)) + R_i(i) ...
            + sum( actions_effects(actions_times<arrivals(i)).*exp(-par.kappa*(arrivals(i)-actions_times(actions_times<arrivals(i))))));
    end
    
    loglike(account) = - (par.lambdainf*timeframe+(par.lambda0 - par.lambdainf)/(-par.kappa) * (exp(-par.kappa*timeframe) -1)   ) ...
        - sum( (par.delta10 + par.delta11*repayments)/par.kappa .* (1-exp(-par.kappa*(timeframe-arrivals))))...
        - sum(actions_effects .*1/par.kappa.*(1-exp(-par.kappa*(timeframe - actions_times)))) + runningsum;
end

if regularized == 0
    Loglike = sum(loglike);
else
    Loglike = sum(loglike)-sum(abs(params).^2);%-(- (n-nv) + (n^2-nv)/(2*n+nv));% - 10000*delta_a^2;%sum(params.^2);
end
end




