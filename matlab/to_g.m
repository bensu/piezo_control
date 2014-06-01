function g = to_g(g_table,g_vals,n_val)
    

    g = interp1(g_table,g_vals,n_val,'linear','extrap');

end