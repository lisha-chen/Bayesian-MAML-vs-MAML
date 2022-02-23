# Bayesian-MAML-vs-MAML

This repository contains the code to reproduce the computational experiments of the paper: 
"Is Bayesian Model Agnostic Meta Learning Better than Model Agnostic Meta Learning, Provably?"


## Requirement
Matlab R2021a


##


## Instruction

### Data generation
Use the funtion:
dataname = generate_data_trn_val(TNds)

Example:
```
addpath('./functions/');
addpath('./shaded_plots/');

%% hyperparameters
T = 100;
N = 20;
d = 1;
s = .5;

%% generate / load data
TNds.T = T; TNds.N = N; TNds.d = d; TNds.s = s;
dataname = get_dataname(TNds);

filename = ['./data/', dataname, '.mat'];

if exist(filename, 'file')
    load(filename);
    disp(['load data from ', filename]);
else
    dataname = generate_data_trn_val(TNds);
    load(filename);
    disp(['generate and save data ', filename]);
end
```

### Experiments
#### Optimal population risk
run
```
linear_pop_risk.m
```
#### Statistical error vs N or T
run
```
linear_stats_N.m
linear_stats_T.m
plot_linear_stats_N_T.m
```



## License

This code is only for research purpose.
Please follow the GPL-3.0 License if you use the code.


## Citation

```
@inproceedings{chen2022_bamaml,
  title={Is Bayesian Model Agnostic Meta Learning Better than Model Agnostic Meta Learning, Provably?},
  author={Chen, Lisha and Chen, Tianyi},
  booktitle = {Proceedings of The 25th International Conference on Artificial Intelligence and Statistics},
  year={2022}
}
```


## Acknowledgement


