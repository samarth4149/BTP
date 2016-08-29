tic
d = 3;
m=3;
true_a = zeros(d,d);
true_a(:,1)=[1,0,0];
true_a(:,2)=[0,1,0];
true_a(:,3)=[0,0,1];

n = 400*d;

X = zeros(d,n);

for i = 1:n 
    if i <= n/3
        theta = 0;
        phi = 90;
    elseif i <= 2*n/3
        theta=90;
        phi= 90;
    else
        theta=90;
        phi=0;
    end
    r1 = rand*2-1;
    r2 = rand*2-1;
    X(:,i)=[cosd(theta+r1).*sind(phi+r2), sind(theta+r1).*sind(phi+r2), cosd(phi+r2)];
end


W=zeros(n,m);
W(1:n/3, :)=repmat([1,0,0],n/3,1);
W(1+n/3:2*n/3, :)=repmat([0,1,0],n/3,1);
W(1+2*n/3:n,:)=repmat([0,0,1],n/3,1);

% W(n,:)=[1,0,0];
A(:,2)=true_a(:,2);
A(:,3)=true_a(:,3);
distortion=20;
A(:,1)=[cosd(0+distortion).*sind(90+distortion), sind(0+distortion).*sind(90+distortion), cosd(90+distortion)];

%initialize A
%initialize W
% A is dxm, X is dxn and W is nxm

% grad_w = zeros(n,m);
% grad_a = zeros(d,m);
% V = zeros(n, m, d);
learning_rate_w = 0.01;
learning_rate_a = 1e-4;

grad_desc;
A_new = proj_a(A- grad_a*learning_rate_a);

