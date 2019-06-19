function LL = Q(params,prevparams,accounts,actions,timeframe)

par.lambda0 = params(1);
par.lambdainf = params(2);
par.kappa = params(3);
par.delta10 = params(4);
par.delta11 = params(5);
par.delta2 = params(6:end);


prevpar.lambda0 = prevparams(1);
prevpar.lambdainf = prevparams(2);
prevpar.kappa = prevparams(3);
prevpar.delta10 = prevparams(4);
prevpar.delta11 = prevparams(5);
prevpar.delta2 = prevparams(6:end);


n_acc = length(accounts);
loglike = zeros(1,n_acc);

for account=1:n_acc
    if isempty(accounts{1,account})
        arrivals = [];
        repayments = [];
    else
        arrivals = accounts{1,account}(1,:);
        repayments = accounts{1,account}(2,:);
    end
    
    action_effect = zeros(size(actions{account}(2,:)));
    action_effect_est = zeros(size(actions{account}(2,:)));
    
    for i=1:length(action_effect)
        action_effect(i) = par.delta2(actions{account}(2,i));
    end
    
    for i=1:length(action_effect_est)
        action_effect_est(i) = prevpar.delta2(actions{account}(2,i));
    end
    
    action_times = actions{1,account}(1,:);
    n = length(arrivals);
    uijpart2 = 0;
    cumsum = 0;
    l0part1 =  -(par.lambdainf*timeframe+(par.lambda0 - par.lambdainf)/(-par.kappa) * (exp(-par.kappa*timeframe) - 1));
    apart1 = -sum((action_effect)./(par.kappa) .* (1-exp(-par.kappa*(timeframe-action_times))));
    uijpart1= -sum(((par.delta10 + par.delta11.*repayments)/(par.kappa) .* (1-exp(-par.kappa*(timeframe-arrivals)))));
    for i=1:n
        t_i = arrivals(i);
        mask = action_times<t_i;
        v_l = action_times(mask);
        v_leff = action_effect(mask);
        v_leffest = action_effect_est(mask);
        
        dl = t_i - v_l; 
        
        norm = (prevpar.lambdainf + (prevpar.lambda0 - prevpar.lambdainf) * exp(-prevpar.kappa*t_i)+...
            sum(v_leffest.*exp(-prevpar.kappa*dl)));
        
        lambda_base = norm;
        if i>1
            t_j = arrivals(1:i-1);
            repaymentshappened = repayments(1:i-1);
            dt = t_i - t_j;
            g = (prevpar.delta10 + prevpar.delta11 *  (repaymentshappened)) .* (exp(-prevpar.kappa*(dt)));
            norm = norm + sum(g);
        end
%         Expectation
        P_uii = lambda_base ./ norm;
        l0part2 = P_uii * log((par.lambdainf +(par.lambda0 - par.lambdainf)*exp(-par.kappa*t_i) + ...
            sum(exp(-par.kappa*dl).*v_leff))./P_uii);
        if i>1
%             Expectation
            P_uij = g ./ norm;
            uijpart2 = (-par.kappa*(dt) + log((par.delta10 + par.delta11*repaymentshappened)./P_uij)) * P_uij';
            if ~(abs(P_uii+sum(P_uij)-1) < eps*100)
                error('Probs dont sum to one');
            end
        end
        cumsum = cumsum + l0part2 + uijpart2;
    end
    loglike(account) = l0part1 + apart1 + uijpart1 + cumsum;
end
LL = sum(loglike);
end

