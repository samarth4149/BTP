d = 3;
m=3;
true_a = zeros(d,d);
true_a(:,1)=[1,0,0];
true_a(:,2)=[0,1,0];
true_a(:,3)=[0,0,1];

n = 400*d;

X = zeros(d,n);

for i = 1:n 
    % r = 30+ rand*30;
    r=90*rand;
    if i <= n/3
        X(:,i)=[cosd(r),0,sind(r)];
    elseif i <= 2*n/3
        X(:,i)=[0,cosd(r),sind(r)];
    else
        X(:,i)=[cosd(r),sind(r),0];
    end
end

% W(1:n/3, :)=repmat([1,0,0],n/3,1);
% W(1+n/3:2*n/3, :)=repmat([0,1,0],n/3,1);
% W(1+2*n/3:n,:)=repmat([0,0,1],n/3,1);

A(:,1)=true_a(:,1);
A(:,2)=true_a(:,2);
A(:,3)=true_a(:,3);

k_means_init=true;

if k_means_init
	W=zeros(n,m);
	[idx, C]=kmeans(X',m,'start',fpc(X,m)); % Replicate to avoid being stuck at a local minima
	for i = 1:size(idx,1)
		W(i,idx(i))=1;
	end
	C=C';
	A=proj_a(C);
end

% distortion=45;
% A(:,1)=[cosd(0+distortion).*sind(90+distortion), sind(0+distortion).*sind(90+distortion), cosd(90+distortion)];
% W(n,:)=[1,0,0]; % true value : [0,0,1]

% A is dxm, X is dxn and W is nxm