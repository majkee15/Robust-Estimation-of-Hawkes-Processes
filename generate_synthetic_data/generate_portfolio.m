function [accounts, actions_field] = generate_portfolio(n_acc,T,par,r,action_seq)
%=======================================================================
%Author: Michael Mark
% Generate a porfolio of accounts
% returns portfolio as cell structure
%=======================================================================

accounts = cell(1,n_acc);
n_actions = length(action_seq);
actions_field = cell(1,n_acc);

    
parfor k=1:n_acc
    
    action_times = sort(T * rand(1,n_actions,1)); %generate action times
    actions = round([action_times;action_seq],2);
    [arrivals, repayments] =  generate_account_history(T, par, r,actions);
    accounts{1,k} = [arrivals; repayments];
    actions_field{1,k} = actions;
  
end
end
