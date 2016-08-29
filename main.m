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
distortion=45;
A(:,1)=[cosd(0+distortion).*sind(90+distortion), sind(0+distortion).*sind(90+distortion), cosd(90+distortion)];
%initialize A
%initialize W
% A is dxm, X is dxn and W is nxm

% grad_w = zeros(n,m);
% grad_a = zeros(d,m);
% V = zeros(n, m, d);
learning_rate_w = 0.01;
learning_rate_a = 0.01;

for it = 1:500
    fprintf('Step:%d\n',it);
    grad_desc;
    fprintf('objective function value: %d; gradient norm: %d %d \n',obj_func(X,A,W), norm(grad_w(:)), norm(grad_a(:)));

	if (norm(grad_w(:)) < 1e-6) && (norm(grad_a(:)) < 1e-6)
        %TODO: what to do here
        fprintf('Successfull break out\n');
        break
    end
    
    W_new = proj_w(W- grad_w*learning_rate_w);
    if obj_func(X, A, W) < obj_func(X, A, W_new)
        fprintf('W: learning_rate halved\n');
        learning_rate_w = 0.5*learning_rate_w;
        continue;
    else 
        learning_rate_w = learning_rate_w*1.1;
    end
    
    
    A_new = proj_a(A - grad_a*learning_rate_a);
    if obj_func(X, A, W) < obj_func(X, A_new, W)
        fprintf('A: learning_rate halved\n');
        learning_rate_a = 0.5*learning_rate_a;
        continue;
    else 
        learning_rate_a = learning_rate_a*1.1;    
    end;
    
     W = W_new;
    A = A_new;

end

toc