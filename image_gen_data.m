tic;
im = double(imread('lena-256x256.jpg')); % uint8 image
count = 1;
w=9;
d=w*w;
m=25;
v_threshold=0.004;
% X=zeros(w*w,(257-w)*(257-w));
% v=zeros((257-w)*(257-w),1);
% X=zeros(w*w,10000);
% v=zeros((257-w)*(257-w),1);
% clear('X');
% clear('v');
for i=1:257-w
	for j=1:257-w
		t=im(i:i+w-1, j:j+w-1);
		t=t(:);
		t=t./sqrt(sum(t.^2));
		if var(double(t))>=v_threshold
			X(:,count)=t;
			v(count)=var(double(t));
			count=count+1;
		end
	end
end

fprintf('Done reading image!\n');
n=size(X,2);
k_means_init=true;

if k_means_init
	W=zeros(n,m);
	[idx, C]=kmeans(X',m,'start',fpc(X,m)'); % Replicate to avoid being stuck at a local minima
	for i = 1:size(idx,1)
		W(i,idx(i))=1;
	end
	C=C';
	A=proj_a(C);
end
save('cached-X.mat', 'X');
save('cached-A.mat', 'A');
save('cached-W.mat', 'W');
% dis = A(:,1);
% dis=reshape(dis,9,9);

toc;