function [avg] = avg_arrivals(accounts)
%AVG_ARRIVALS Summary of this function goes here
%   Detailed explanation goes here
n = length(accounts);
runningsum = 0;
for acc=1:n
    runningsum = runningsum + length(accounts{acc});
end
avg = runningsum/n;
end

