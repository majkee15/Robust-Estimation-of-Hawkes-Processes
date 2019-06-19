%=======================================================================
%Author: Michael Mark
% Generate a porfolio of accounts for
%=======================================================================

s = 3;
rng(s)

%% simulation INPUT
inpar = setpar();
T = 100;
n_acc = 200;
action_seq = [1,2,3];

n_guess = 100;
n_portfolio = 100;
tic

simdata1 = run_robust(T,n_acc,n_portfolio,action_seq,n_guess);
toc
save('100portfoliosT100acc200COMPENSATED.mat');

function simdata = run_robust(T,n_acc,n_portfolio,action_seq,n_guess)
[inpar,params]= setpar();

np = length(params);
r0 = 0;
simdata = cell(n_portfolio,1);
parfor pf = 1:n_portfolio
    [pfolio,actions] = generate_portfolio(n_acc,T,inpar,r0,action_seq);
    %optimizer setting
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb=zeros(1,np);
    ub=[];
    nonlcon = [];
    ai = 1/20;
    bi= 20;
    randguess = ai + (bi-ai)*rand(n_guess,np);
    x0 = params .* randguess;
    x= zeros(size(x0));
    lls = cell(n_guess,1);
    llscomp = cell(n_guess,1);
    timings = cell(n_guess,1);
    timingscomp = cell(n_guess,1);
    thetas = cell(n_guess,1);
    thetascomp = cell(n_guess,1);
    fval = zeros(n_guess,1);
    % MLE/EM PART
    for i =1:n_guess
        fprintf('Portfolio: %i Guess: %i \n', pf, i)
        objfun = @(par) -loglike_portfolio(pfolio,T,actions,par,0);
        [x(i,:),fval(i),exitflag,output] = fmincon(objfun,x0(i,:),A,b,Aeq,beq,lb,ub,nonlcon);
        [lls{i},thetas{i},timings{i}] = EM(x0(i,:),pfolio,actions,T);
    end
    
    simdata{pf,1} = {pfolio,actions,x0,x,fval,lls,thetas,timings};
end
end