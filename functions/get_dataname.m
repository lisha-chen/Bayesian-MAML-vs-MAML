function dataname = get_dataname(TNds)

    if isempty(TNds)
        T = 1000; % task number
        N = 20; % data number per task
        d = 1; % dimension of features

        s = 0.5; % division of train validation
    else
        T = TNds.T;
        N = TNds.N;
        d = TNds.d;
        s = TNds.s;
    end

    dataname = ['data_linear_centroid_', ...
                'T-', num2str(T), '_N-', num2str(N), '_d-', num2str(d), '_s-', num2str(s)];
end
