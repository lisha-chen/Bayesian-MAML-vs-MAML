function dataname = generate_data_trn_val(TNds)
    %% hyperparameters
    % T N d s
    % may add beta
    %%
    
        if isempty(TNds)
            T = 100; % task number
            N = 20; % data number per task
            d = 2; % dimension of features
    
            s = 0.5; % division of train validation
        else
            T = TNds.T;
            N = TNds.N;
            d = TNds.d;
            s = TNds.s;
        end
        
        N1 = s * N;
        % N2 = N - N1;
    
        % beta = random('Uniform', 0.1, 2);
        beta = 2; 
        
    
        %% generate data
    
        theta_gt_T = random('Uniform', 4, 6, [T, d]);
    
        beta_T = random('Uniform', 0.5, beta, [T, d]);
        % beta_T = ones([T, d]);
    
        V = RandOrthMat(d); % tol = 1e-6
    
        % var_T = random('Uniform', 0, 1, [T,1]);
        %var_T = zeros(T, 1);
        %var_T = 1e-1*ones(T, 1);
        var_T = ones(T, 1);
        
        %%
        % place holder
        Q_T = ones(T, d, d);
    
        X_al = zeros(T, N, d);
        eps_al = zeros(T, N);
        y_al = zeros(T, N);
    
        for i = 1:T
            % Q_T(i, :, :) = V * diag(beta_T(i, :)) * V';
            Q_T(i, :, :) = diag(beta_T(i, :));
    
            X_al(i, :, :) = mvnrnd(zeros(d, 1), squeeze(Q_T(i, :, :)), N);

            eps_al(i, :) = random('Normal', 0, sqrt(var_T(i, 1)), [1, N]); % T*N
            y_al(i, :) = reshape(squeeze(X_al(i, :, :)), [N,d]) * theta_gt_T(i, :)' + eps_al(i, :)'; % T*N
        end
    
        X_tr = X_al(:, 1:N1, :); y_tr = y_al(:, 1:N1); eps_tr = eps_al(:, 1:N1);
        X_va = X_al(:, N1 + 1:N, :); y_va = y_al(:, N1 + 1:N); eps_va = eps_al(:, N1 + 1:N);
    
        %% save data    
    
        dataname = get_dataname(TNds);
    
        datagen_para.Q_T = Q_T;
        datagen_para.var_T = var_T;
        datagen_para.theta_gt_T = theta_gt_T;
    
        data_Xye.X_all = X_al;
        data_Xye.y_all = y_al;
        data_Xye.eps_all = eps_al;
    
        data_Xye.X_val = X_va;
        data_Xye.y_val = y_va;
        data_Xye.eps_val = eps_va;
    
        data_Xye.X_trn = X_tr;
        data_Xye.y_trn = y_tr;
        data_Xye.eps_trn = eps_tr;
    
        save(['./data/', dataname, '.mat'], ...
            'TNds', ...
            'datagen_para', ...
            'data_Xye', ...
            '-v7.3');
    
    end
    