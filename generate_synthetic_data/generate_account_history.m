
function [tau,repayments] = generate_account_history(T,par,repayment_dist, actions)
%=======================================================================
%Author: Michael Mark
%generate hawkes process based repayment history as per Chehrazi & Weber
%(2015)
%=======================================================================
s=0;
n=0;
tau =[];
repayments = [];
balance = [];
ind_process_finished = false;  %check if full repayment occurred

while s<T  && (ind_process_finished==false)
    
    %Lstar = getLambda(s,tau,repayments,actions,par);
    Lstar = 100; 
    w = -log(rand)/Lstar;
    s = s + w;
    D = rand;
    
    if D*Lstar <= getLambda(s,tau,repayments,actions,par)
        n = n+1;
        tau(n) = s;
        repayments(n) =  mixed_dist(repayment_dist);
        if repayments(n) == 1
            ind_process_finished = true;
        end
    end
    
    if( n ~= 0)
        if tau(n)<=T
            if repayments(n) == 1
                tau = tau(1:n);
                repayments = repayments(1:n);
                balance = balance(1:n+1);
            end
        elseif(n ==1) %generalization of the next case - if tau>T I return empty field
            tau = [];
            repayments =[];
        else
            tau = tau(1:n-1);
            repayments = repayments(1:n-1);
        end
    else
        tau = [];
        repayments =[];
    end
end

function [x] = mixed_dist(full_rep)
% distribution of relative repayments
if full_rep == 2
    x=0.3;

elseif full_rep == 1
    if rand(1)<0.2
        x = 1;
    else
        x = 0.2+ rand(1)*0.6;
    end
elseif full_rep ==0
    x = 0.2 + rand(1) *0.7;
else
    msg = 'mixed_dist accepts onlu logical argument indicating whether full repayment is allowed.';
    error(msg)
end



