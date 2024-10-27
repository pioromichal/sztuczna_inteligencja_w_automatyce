function [ys]=odp_jedn_fun(kk, Tp)

F1in=80; F1pp=73;
FDpp=14; h2pp=15.6384;

[~, h2_vals, ~] = odp_skok_mod_lin(F1in, FDpp, kk, Tp);

d=(length(h2_vals)-1)/kk;
h2_vals=h2_vals(d+1:d:length(h2_vals));

dF1in=F1in-F1pp;

ys=(h2_vals-h2pp)/dF1in;
end