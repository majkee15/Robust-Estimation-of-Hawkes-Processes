load('10it_10_guesses.mat')
%load('new_data_format_2_2.mat')

n_sensitivities = length(simdata);

best_mle_error = zeros(n_sensitivities, mc_iterations);
worst_mle_error = zeros(n_sensitivities, mc_iterations);
best_em_error = zeros(n_sensitivities, mc_iterations);
worst_em_error = zeros(n_sensitivities, mc_iterations);

% each sensitivity cell contain 
% 2 matrices n_guesses x 1 x n_iter
% 2 matrices n_guesses x nparams x n_iter
for sensitivity=1:n_sensitivities
    fval_mle = simdata{sensitivity}{1};
    fval_em= simdata{sensitivity}{2};
    result_mle= simdata{sensitivity}{3};
    result_em= simdata{sensitivity}{4};
    
    for it=1:mc_iterations
        [best_mle_val,best_mle_i] = min(fval_mle(:,1,it));
        [worst_mle_val,worst_mle_i] = max(fval_mle(:,1,it));
        [best_em_val,best_em_i] = min(fval_em(:,1,it));
        [worst_em_val,worst_em_i] = max(fval_em(:,:,it));
        best_em_param = result_em(best_em_i,:, it);
        worst_em_param = result_em(worst_em_i,:, it);
        best_mle_param = result_mle(best_mle_i,:, it);
        worst_mle_param = result_mle(worst_mle_i,:, it);
        
        best_mle_error(sensitivity,it) = calc_error(best_mle_param, parameters_tested(sensitivity,:));
        worst_mle_error(sensitivity,it) = calc_error(worst_mle_param, parameters_tested(sensitivity,:));
        best_em_error(sensitivity,it) = calc_error(best_em_param, parameters_tested(sensitivity,:));
        worst_em_error(sensitivity,it) = calc_error(worst_em_param, parameters_tested(sensitivity,:));
    end
    
end

%here it should be mean
% best_mle_error = min(best_mle_error,[],2);
% worst_mle_error = min(worst_mle_error,[],2);
% best_em_error = min(best_em_error,[],2);
% worst_em_error = min(worst_em_error,[],2);

best_mle_error_mean = mean(best_mle_error,2);
worst_mle_error_mean = mean(worst_mle_error,2);
best_em_error_mean = mean(best_em_error,2);
worst_em_error_mean = mean(worst_em_error,2);

best_mle_error_std = std(best_mle_error,[],2)./best_mle_error_mean;
worst_mle_error_std = std(worst_mle_error,[],2)./worst_mle_error_mean;
best_em_error_std = std(best_em_error,[],2)./best_em_error_mean;
worst_em_error_std = std(worst_em_error,[],2)./worst_em_error_mean;

% figure;
% %errorbar(sensitivity_sequence, worst_mle_error_mean, worst_mle_error_std)
% plot(sensitivity_sequence, worst_mle_error_mean);

figure;
hold on;
%yyaxis left;
errorbar(sensitivity_sequence-0.01, best_mle_error_mean, best_mle_error_std, 'or')
errorbar(sensitivity_sequence, best_em_error_mean, best_em_error_std, 'bs')
errorbar(sensitivity_sequence+0.01, worst_em_error_mean, worst_em_error_std,'gd')
% yyaxis right;
% plot(sensitivity_sequence, worst_mle_error_mean);
hold off;
box on;
xlim([-0.02,0.32])
legend('Best MLE', 'Best EM', 'Worst EM');

function err = calc_error(estimate, true)
    err = norm(estimate-true, 2) / norm(true);
%     err = norm((estimate - true) ./ true);
end