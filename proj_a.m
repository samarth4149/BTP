function t = proj_a(x)
	temp = repmat(sqrt(sum(x.^2, 1)), size(x, 1), 1);
    t = x./temp;
end