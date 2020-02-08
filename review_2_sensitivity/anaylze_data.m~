load('new_data_format_2_2.mat')

best_mle_error = zeros(n_sensitivities, mc_iterations);
worst_mle_error = zeros(n_sensitivities, mc_iterations);
best_em_error = zeros(n_sensitivities, mc_iterations);
worst_em_error = zeros(n_sensitivities, mc_iterations);

n_sensitivities = length(simdata);
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
best_mle_error = min(best_mle_error,[],2);
worst_mle_error = min(worst_mle_error,[],2);
best_em_error = min(best_em_error,[],2);
worst_em_error = min(worst_em_error,[],2);

figure;
hold on;
plot(sensitivity_sequence,best_mle_error)
plot(sensitivity_sequence, best_em_error)
plot(sensitivity_sequence, worst_em_error)
hold off;
legend('Best MLE', 'Best EM', 'Worst EM');
figure;
plot(sensitivity_sequence, worst_mle_error)

function err = calc_error(estimate, true)
    err = norm(estimate-true, 2) / norm(true);
%     err = norm((estimate - true) ./ true);
end