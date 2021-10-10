filename = 'compare_formulations.mat';
load("compare_formulations.mat")

figure
set(gca, 'YScale', 'log')   
grid on
hold on
semilogy(lls{1}(2:end), marker='x')
semilogy((lls_naive{1}(2:end)), marker='x')
semilogy(ones(size(lls_naive{1})) * (fval), color='black')
hold off;

reler_adj = reler(thetas{1});
reler_naive = reler(thetas_naive{1  });

% yyaxis right
% plot(log(reler_adj), marker='x')
% yyaxis right
% plot(log(reler_naive), marker='x', color='green')
% 
% hold off
% figure
% hold on
% plot(log(reler(thetas_naive{1})), marker='x')
% plot(log(reler(thetas{1})), marker='x', color='green')

%% Func
function [reler] = reler(measured)
%compute relative error to params
[inpar,params] = setpar();
reler =  mynorm(measured - params)./mynorm(params);
end

function res = mynorm(X)
res = sqrt(sum(X.^2,2));
end


