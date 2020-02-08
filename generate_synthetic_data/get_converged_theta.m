function convergedtheta = get_converged_theta(thetas)
    convergedtheta = zeros(size(thetas,1),size(thetas{1},2));
    for row=1:size(thetas,1)
        convergedtheta(row,:) = thetas{row}(end,:);
    end
end