function ret = obj_func(X, A, W)
	for i=1:size(W,1)
	    for j=1:size(W,2)
	        V(i,j,:) = (W(i,j) * acos(dot(X(:,i),A(:,j))) / sqrt(1-dot(X(:,i),A(:,j))^2)) ...
			            * (A(:,j)-dot(A(:,j), X(:,i))*X(:,i));
	    end
	end
    temp1 = squeeze(sum(V(:,:,:),2));
    temp1 = squeeze( sqrt(sum(temp1.^2,2)) );
    ret = sum(temp1);
end