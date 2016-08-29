tic
% initialize_sphere_edge;
% image_gen_data;
X = load('cached-X.mat');X=X.X;
A = load('cached-A.mat');A=A.A;
W = load('cached-W.mat');W=W.W;
n=size(X,2);
m=size(A,2);
d=size(X,1);
% W(n,:)=[0,0,1];
% A=rand(d,m);
% A=proj_a(A);
% W=rand(n,m);

learning_rate_w = 0.01;
learning_rate_a = 0.001;
cutoff_w = 1e-5;
cutoff_a=1e-5;
save_freq=1;
it_count = 0;
plot_array = [];

for it = 1:50
    fprintf('Step:%d\n',it);
    f1=true;c=0;
  	
    while 1 
        grad_desc;
        A_new = proj_a(A - grad_a*learning_rate_a);
        if norm(A - A_new, 'fro')/norm(A, 'fro') < cutoff_a
            fprintf('Break A\n')
            break
        end
        if obj_func(X, A, W) < obj_func(X, A_new, W)
            fprintf('A: learning_rate halved\n');
            learning_rate_a = 0.5*learning_rate_a;
            continue;
        else 
            learning_rate_a = learning_rate_a*1.1;
            it_count = it_count+1;
            plot_array = [plot_array, obj_func(X, A_new, W)];
        end;
        f1 = false;
        A= A_new;
        c=c+1;
        if mod(c, save_freq)==0
        	save('cached-iter-A.mat',A);
        	save('objective_func.mat',plot_array);
        end
        fprintf('A: objective function value: %d; gradient norm: %d %d \n',obj_func(X, A, W), norm(grad_w(:)), norm(grad_a(:)));
    end
    c=0;
    while 1
	    grad_desc;
	    W_new = proj_w(W- grad_w*learning_rate_w);
	    if norm(W-W_new, 'fro')/norm(W, 'fro') < cutoff_w
	        fprintf('Break W\n')
	        break
	    end
	    if obj_func(X, A, W) < obj_func(X, A, W_new)
	        fprintf('W: learning_rate halved\n');
	        learning_rate_w = 0.5*learning_rate_w;
	        continue;
	    else 
	        learning_rate_w = learning_rate_w*1.1;
	        it_count = it_count+1;
	        plot_array = [plot_array, obj_func(X, A_new, W)];
	    end
        W = W_new;
        c=c+1;
        if mod(c, save_freq)==0
        	save('cached-iter-W.mat',W);
        	save('objective_func.mat',plot_array);
        end
        f1=false;
        fprintf('W: objective function value: %d; gradient norm: %d %d \n',obj_func(X,A,W), norm(grad_w(:)), norm(grad_a(:)));
        it_count = it_count+1;
    end
    if f1 == true
    	break
    end
end

% plot(plot_array);

toc