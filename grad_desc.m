% d = 3;
% m=3;
% true_a = zeros(d,d);
% true_a(:,1)=[1,0,0];
% true_a(:,2)=[0,1,0];
% true_a(:,3)=[0,0,1];
% 
% n = 400*d;
% 
% X = zeros(d,n);
% 
% for i = 1:n 
%     if i <= n/3
%         theta = 0;
%         phi = 90;
%     elseif i <= 2*n/3
%         theta=90;
%         phi= 90;
%     else
%         theta=90;
%         phi=0;
%     end
%     r1 = rand*2-1;
%     r2 = rand*2-1;
%     X(:,i)=[cosd(theta+r1).*sind(phi+r2), sind(theta+r1).*sind(phi+r2), cosd(phi+r2)];
% end
% 
% 
% W=zeros(n,m);
% W(1:n/3, :)=repmat([1,0,0],n/3,1);
% W(1+n/3:2*n/3, :)=repmat([0,1,0],n/3,1);
% W(1+2*n/3:n,:)=repmat([0,0,1],n/3,1);
% 
% % W(n,:)=[1,0,0];
% A(:,2)=true_a(:,2);
% A(:,3)=true_a(:,3);
% distortion=45;
% A(:,1)=[cosd(0+distortion).*sind(90+distortion), sind(0+distortion).*sind(90+distortion), cosd(90+distortion)];


%initialize A
%initialize W
% A is dxm, X is dxn and W is nxm

grad_w = zeros(n,m);
grad_a = zeros(d,m);


U = zeros(n,m,d);
for i = 1:n
    for j = 1:m
        U(i,j,:) = A(:,j)-dot(A(:,j),X(:,i))*X(:,i);
    end
end

temp_var = repmat(W.*acos(X'*A)./sqrt(1-(X'*A).^2), [1 1 d]);
V = temp_var.*U;

temp4 = permute(X, [2, 3, 1]);
temp4 = repmat(temp4, [1 m 1]); %check
        
delta_hb = 0.01; %for huber loss function
lambda = 100; %for sparsity

[temp, max_index] = max(sum(abs(W),1));
% wb = waitbar(0,'Bilateral filtering ...');

for p = 1:n
    for q = 1:m 
        temp1 = sum(V(p,:,:),2);
        temp2 = 0;
        if q == max_index
            if W(p,q) <= delta_hb && W(p,q) >= -delta_hb
                temp2 = W(p,q);
            elseif W(p,q) < delta_hb
                temp2 = -delta_hb;
            else
                temp2 = delta_hb;
            end
        end
        grad_w(p,q) = 2 * acos(dot(X(:,p), A(:,q))) * ...
            dot((A(:,q)-dot(X(:,p), A(:,q))*X(:,p)), temp1(:)) / ...
            sqrt(1-dot(X(:,p), A(:,q))^2) + ...
            lambda * temp2;  
    end
    % waitbar(p/n,wb);
end
% delete(wb);
% wb = waitbar(0,'Bilateral filt/ering ...');


L = W.*acos(X'*A)./sqrt(1-(X'*A).^2);
L=L';
for t = 1:m
	temp1 = X'*A(:,t);
    temp1 = temp1';
    temp2 = 1-temp1.^2;
    f2 = W(:, t)'.*acos(temp1)./sqrt(temp2);    
	f21 = repmat(f2, m, 1);
    f6 = f21.*L;
    temp3 = repmat(U(:,t,:), [1 m 1]); %check
	for s = 1:d
        f1 = -W(:, t)'.*X(s,:)./temp2;
        f3 = -f2.*X(s,:);
        f4 = -(f3.*temp1)./temp2;
        f1 = repmat(f1, m, 1);
        f4 = repmat(f4, m, 1);
        f5 = (f1+f4).*L;
        f3 = repmat(f3, m, 1);
        f7 = f3.*L;
        Main = f5.*dot(U,temp3,3)' + f6.*U(:,:,s)' + f7.*dot(temp4,U,3)';
        grad_a(s,t) = 2*sum(sum(Main));
    end
    % waitbar(t/m,wb);
end

