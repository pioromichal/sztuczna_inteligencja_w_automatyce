function y_out = model_rbf(model, ukm5, ukm6, ykm1, ykm2)
    input = [ukm5; ukm6; ykm1; ykm2];
    y_out = model(input);
end
