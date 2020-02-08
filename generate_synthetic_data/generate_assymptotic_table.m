%Impact of number of actions on accuracy - Reviewer 1 remark
clc, clear;

mc_iterations = 2;
n_guesses = 2;
[par,params] = setpar();
T = [100, 150];
n_acc = 200;
r = 0;
action_seq = [1, 2, 3];

simdata = cell(1, length(T));


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

parfor horizon=1:length(T)
    result_mle = zeros(n_guesses, length(params), mc_iterations);
    result_em = zeros(n_guesses, length(params), mc_iterations);
    fval_mle = zeros(n_guesses, 1 , mc_iterations);
    fval_em = zeros(n_guesses, 1, mc_iterations);

    [accounts, actions_field] = generate_portfolio(n_acc,horizon,par,r,action_seq);
    ai = 3/4;
    bi=  5/4;
    for it=1:mc_iterations
        [accounts, actions_field] = generate_portfolio(n_acc,horizon,par,r,action_seq);
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
            objfun = @(par) -loglike_portfolio(accounts,horizon,actions_field,par,0);
            [x,fval,exitflag,output] = fmincon(objfun, x0, A,b,Aeq,beq,lb,ub,nonlcon);
            [lls,thetas,timings] = EM(x0,accounts,actions_field,horizon);
            fval_mle(guess, 1, it)  = fval;
            fval_em(guess, 1, it) = lls(end);
            result_mle(guess, :, it) = x;
            result_em(guess, :, it) = thetas(end,:);
        end
        
    end
    simdata{horizon} = {fval_mle, fval_em, result_mle, result_em};

end

