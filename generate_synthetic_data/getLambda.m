function lambda = getLambda(s,tau,repayments,actions,par) 
%=======================================================================
% Author: Michael Mark
% get immediate intensity of the process
% two versions for point and vector
% for vector evaluation - inefficient code atm - serves just for purpose of
% plotting lambda!!
%=======================================================================

v_i = actions(1,:);
actions_effect = zeros(size(actions(2,:)));
for i=1:length(actions(2,:))
    actions_effect(i) = par.delta2(actions(2,i));
end


if length(s) == 1
    tauhappened = tau(tau<s);
    actionshappened = v_i(v_i<s);
    effectshappened = actions_effect(v_i<s);
    repaymentshappened = repayments(tau<s);
    lambda = par.lambdainf + (par.lambda0 - par.lambdainf) * exp(-par.kappa*s) + ...
        par.delta10 * sum(exp(-par.kappa*(s-tauhappened))) + ...
        par.delta11 *  sum(repaymentshappened.* exp(-par.kappa*(s-tauhappened))) + ...
        (sum(effectshappened.*exp(-par.kappa*(s - actionshappened))));

%{
if length(s) == 1
        lambda = par.lambdainf + (par.lambda0 - par.lambdainf) * exp(-par.kappa*s) + par.delta10 * 
sum(exp(-par.kappa*(s-tau))) + ...
            par.delta11 *  sum(repayments.* exp(-par.kappa*(s-tau)));
%}
else
    n = length(s);
    lambda = zeros(1,n);
    for i=1:n
        tauhappened = tau(tau<s(i));
        actionshappened = v_i(v_i<s(i));
        effectshappened = actions_effect(v_i<s(i));
        repaymentshappened = repayments(tau<s(i));
        lambda(i) = par.lambdainf + (par.lambda0 - par.lambdainf) * exp(-par.kappa*s(i)) + ...
            par.delta10 * sum(exp(-par.kappa*(s(i)-tauhappened))) +...
            par.delta11 *  sum(repaymentshappened.* exp(-par.kappa*(s(i)-tauhappened))) + (sum(effectshappened.*exp(-par.kappa*(s(i) - actionshappened))));
    end
end
end
