clc,clear;
load('10it_10_guesses.mat')
%load('new_data_format_2_2.mat')

n_sensitivities = length(simdata);

mle_error = zeros(n_sensitivities, mc_iterations);
em_error = zeros(n_sensitivities, mc_iterations);

% each sensitivity cell contain 
% 2 matrices n_guesses x 1 x n_iter
% 2 matrices n_guesses x nparams x n_iter
for sensitivity=1:n_sensitivities
    fval_mle = simdata{sensitivity}{1};
    fval_em= simdata{sensitivity}{2};
    mle_est= simdata{sensitivity}{3};
    em_est= simdata{sensitivity}{4};
    
    for it=1:mc_iterations
        em_param = em_est(:,:, it);
        mle_param = mle_est(:,:, it);
        mle_error(sensitivity,it) = calc_error(mean(mle_param), parameters_tested(sensitivity,:));
        em_error(sensitivity,it) = calc_error(mean(em_param), parameters_tested(sensitivity,:));
    end
    
end

mean_mle_error = mean(mle_error,2);
mean_em_error = mean(em_error,2);
% 
% mean_mle_error_std = std(mle_error, [], 2)./mean_mle_error;
% mean_em_error_std = std(em_error, [], 2)./mean_em_error;

mean_mle_error_std = std(mle_error, [], 2);
mean_em_error_std = std(em_error, [], 2);


figure;
hold on;
yyaxis left;
%errorbar(sensitivity_sequence, mean_mle_error, mean_mle_error_std)
errorbar(sensitivity_sequence, mean_em_error, mean_em_error_std)
yyaxis right;
plot(sensitivity_sequence, mean_mle_error)
set(gca, 'YScale', 'log')
hold off;
box on;
legend('Mean EM error', 'Mean MLE error')
xlim([-0.01,0.31])
function err = calc_error(estimate, true)
    err = norm(estimate-true, 2) / norm(true);
%     err = norm((estimate - true) ./ true);
end