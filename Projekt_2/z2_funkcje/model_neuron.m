function [y] = model_neuron(ukm5, ukm6, ykm1, ykm2, w10, w1, w20, w2)
    y=w20+w2*tanh(w10+w1*[ukm5; ukm6; ykm1; ykm2]);
end

