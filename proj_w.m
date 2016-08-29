function t = proj_w(x)
	m=size(x,2);
	t=zeros(size(x,1), size(x,2));
	for i = 1:m-1
		t(:,i)=(x(:,i)-x(:,m)+1)-((sum(x,2)-x(:,m)+(m-1)*(1-x(:,m)))/m);
	end
	t(:,m) = 1-sum(t,2);
end