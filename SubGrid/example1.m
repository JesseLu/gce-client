function empty_subgrid_example(filename, kappa)

mg_shape = [100 100 100];
e = ones(mg_shape);
mg_epsilon = {e, e, e};

sg_shape = kappa * [20 20 20];
sg_pos = [50 50 40];
e = ones(sg_shape);
sg_epsilon = {e, e, e};

SubGrid_make(filename, mg_epsilon, kappa, sg_pos, sg_epsilon, ...
    10, 300, {[0.4 0.8 25 25 40]});
