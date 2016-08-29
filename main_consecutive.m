tic
initialize;
learning_rate_w = 0.01;
learning_rate_a = 0.01;
W(n,:)=[0,0,1];

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