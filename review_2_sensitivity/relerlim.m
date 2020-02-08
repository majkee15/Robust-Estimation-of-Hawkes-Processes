function [reler] = relerlim(measured)
%compute relative error to params
[inpar,params] = setparlimit();
reler =  (measured - params)./params;
end

