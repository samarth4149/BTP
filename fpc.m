function A=fpc(X,k)
	A = zeros(size(X,1), k);
	t=randi([1 size(X,2)],1,1);
	A(:,1)=X(:,t);
	X(:,t)=[];

	for i=2:k
		clear('dist_arr');
	    dist_arr(1:size(X,2))=1e12; % 1e9==infinity
	    for j = 1:(i-1)
	        dist_arr = min(dist_arr, sum((X-repmat(A(:,j),1,size(X,2))).^2));
	    end
	    [minval,min_index]=max(dist_arr);
	    A(:,i)=X(:,min_index);
	    X(:,min_index)=[];
	end
end