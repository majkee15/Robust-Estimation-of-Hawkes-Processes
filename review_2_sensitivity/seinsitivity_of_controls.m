%Impact of number of actions on accuracy - Reviewer 1 remark
clc, clear;

mc_iterations = 2;
n_guesses = 20;
[par,params] = setparlimit(0);
T = 100;
n_acc = 200;
r = 0;
sensitivity_sequence = [0, 0.05, 0.1, 0.15, 0.2, 0.25,0.3];
action_seq = [1, 1, 1];

simdata = cell(1, length(sensitivity_sequence));

parameters_tested = zeros(length(sensitivity_sequence),length(params));

% tot_mle = zeros(length(sensitivity_sequence), 1, mc_iterations);
% tot_em = zeros(length(sensitivity_sequence), 1, mc_iterations);
% best_mle = zeros(length(sensitivity_sequence), 1, mc_iterations);
% best_em = zeros(length(sensitivity_sequence), 1, mc_iterations);
% worst_mle = zeros(length(sensitivity_sequence), 1, mc_iterations);
% worst_em = zeros(length(sensitivity_sequence), 1,mc_iterations);
% 
% best_em_param = zeros(1, length(params), mc_iterations);
% worst_em_param = zeros(1, length(params), mc_iterations);
% best_mle_param = zeros(1, length(params), mc_iterations);
% worst_mle_param = zeros(1, length(params), mc_iterations);

for sensitivity=1:length(sensitivity_sequence)
    result_mle = zeros(n_guesses, length(params), mc_iterations);
    result_em = zeros(n_guesses, length(params), mc_iterations);
    fval_mle = zeros(n_guesses, 1 , mc_iterations);
    fval_em = zeros(n_guesses, 1, mc_iterations);

    [par,params] = setparlimit(sensitivity_sequence(sensitivity));
    parameters_tested(sensitivity,:) = params;
    [accounts, actions_field] = generate_portfolio(n_acc,T,par,r,action_seq);
    ai = 1/10;
    bi= 10;
    parfor it=1:mc_iterations
        [accounts, actions_field] = generate_portfolio(n_acc,T,par,r,action_seq);
        randguess = (ai + (bi-ai)*rand(n_guesses,length(params))) .* params;
        for guess=1:n_guesses
            x0 = randguess(guess,:);
            A = [];
            b = [];
            Aeq = [];   
            beq = [];
            lb =zeros(size(x0));
            ub = [];
            nonlcon = [];
            objfun = @(par) -loglike_portfolio(accounts,T,actions_field,par,0);
            [x,fval,exitflag,output] = fmincon(objfun, x0, A,b,Aeq,beq,lb,ub,nonlcon);
            [lls,thetas,timings] = EM(x0,accounts,actions_field,T);
            fval_mle(guess, 1, it)  = fval;
            fval_em(guess, 1, it) = lls(end);
            result_mle(guess, :, it) = x;
            result_em(guess, :, it) = thetas(end,:);
        end
        
    end
%     mean_mle = mean(result_mle,3);
%     mean_em = mean(result_em,3);
%     [best_mle_val,best_mle_i] = min(fval_mle(:,1,it));
%     [worst_mle_val,worst_mle_i] = max(fval_mle(:,1,it));
%     
%     [best_em_val,best_em_i] = min(fval_em(:,1,it));
%     [worst_em_val,worst_em_i] = max(fval_em(:,1,it));
%     
%     best_em_param = result_em(best_em_i,:, it);
%     worst_em_param = result_em(worst_em_i,:, it);
%     best_mle_param = result_mle(best_mle_i,:, it);
%     worst_mle_param = result_mle(worst_mle_i,:, it);
    
    
    if sensitivity_sequence(sensitivity) == 0
        result_mle(:,end,:) = 0;
        result_em(:,end,:) = 0;
        
    end
    simdata{sensitivity} = {fval_mle, fval_em, result_mle, result_em};
%     best_mle(sensitivity) = norm(best_mle_param - params)/norm(params);
%     worst_mle(sensitivity) = norm(worst_mle_param - params)/norm(params);
%     best_em(sensitivity) = norm(best_em_param - params)/norm(params);
%     worst_em(sensitivity) = norm(worst_em_param - params)/norm(params);
%     
%     tot_mle(sensitivity) = norm(mean_mle-params)/norm(params);
%     tot_em(sensitivity) = norm(mean_em-params)/norm(params);
end

