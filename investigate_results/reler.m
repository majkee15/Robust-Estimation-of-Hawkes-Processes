function [reler] = reler(measured)
%compute relative error to params
[inpar,params] = setpar();
reler =  (measured - params)./params;
end

