%=======================================================================
% Author: Michael Mark
% Demo - Showroom
% generate hawkes process representing an account repayment history 
% as per Chehrazi & Weber
% (2015)
%=======================================================================

clc, clear;
%rng('default');

%% INPUTS
%=======================================================================
% DEFINE params structure
[inpar,params] = setpar();

%observation horizon t
t=100;
%number of actions n_a
%actions is a matrix 2*n_a
% 1st row is the time of the action
% 2nd row is the action type denoted as int - mapping dirrectly onto delta2
% components
n_actions = 4;
action_effects = [1,1,2,3];
actions = [sort(t *  rand(1,n_actions,1));action_effects];

%set distribution of relative repayments
% 0 - r ~ U(0.2,0.9)
% 1 -  r~ U(0.2,0.8) with 0.2 prob of full repayment
% 2 - fixed relative repayment ammount r =0.3

rdist = 0;

%% MODEL
%generate a sample path
tic;
[hawkes1,repayments] = generate_account_history(t, inpar,rdist,actions); 
toc
length(hawkes1)

[tgrid]=plot_account_state(t,hawkes1,repayments,actions,inpar);

%% Model Test Q-Q plot + 2sided kolgomorov smirnov
%=======================================================================
n = length(hawkes1);
thetas = n-1;
for i=2:n
    
    thetas(i-1)=integrateIntensity(hawkes1(i-1),hawkes1(i),hawkes1,repayments,inpar,actions);
    
end
figure;
qqplot(thetas,makedist('Exponential',1))
%null hypothesis that both samoples come from the same dist 1-reject,
%0-cannot reject
[h,p,k] = kstest2(thetas,exprnd(1,1,100000),'Alpha',0.05)

%% FUNCTIONS
%=======================================================================
function [int] = integrateIntensity(ti_,ti,arrivals,repayments, params,actions)
%=======================================================================
%Author: Michael Mark
%returns integrated intensity from t_{i-1} to t_i
%only between two jump points
%=======================================================================

v_i = actions(1,:);
action_type = actions(2,:);
action_effect = zeros(1,size(actions,2));
for i=1:length(action_effect)
   action_effect(i) =params.delta2(action_type(i));
end

mu_part = (ti-ti_) * params.lambdainf + ((params.lambda0 - params.lambdainf) /(-params.kappa)) * (exp(-ti * params.kappa) - exp(-ti_ * params.kappa)); %drift
second_part = params.delta10/params.kappa * (1 - exp(-params.kappa * (ti-ti_))) * sum(exp(-params.kappa*(ti_-arrivals(arrivals<=ti_)))); %willingness to repay
third_part = params.delta11/params.kappa * (1 - exp(-params.kappa * (ti-ti_))) * sum(exp(-params.kappa*(ti_-arrivals(arrivals<=ti_))) .* ...
    repayments(1:length(arrivals(arrivals<=ti_)))); %ability to repay
fourth_part = 1/params.kappa * sum( action_effect(v_i<ti_).*(exp( -params.kappa*(ti_ - v_i(v_i<ti_)))))  ; %actions part

int = mu_part + second_part + third_part + fourth_part;
end

function [tgrid] = plot_account_state(t,arrivals,repayments,actions,par1)
%=======================================================================
%Author: Michael Mark
%Plot full realization of the repayment process
%=======================================================================

h=0.01;
tgrid = 0:h:t;



lambdas = getLambda(tgrid,arrivals,repayments,actions,par1);
figure('Name','Intensity');
hold on

plot(tgrid,lambdas);
neg = @(x) x(x<0);
for i = 1:size(actions,2)
    v_i = actions(1,i);
    [c,index] = max(neg(tgrid-v_i));
    plot([v_i,v_i+h],[lambdas(index),lambdas(index+1)],'-or');
end

hold off
xlabel('t') 
ylabel('\lambda') 


end