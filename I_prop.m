function fb_prop = I_prop( frame, tt, hist_f, hist_b, Priors_F, Priors_B)
[m, n, ~] = size(frame);
fb_prop = zeros(m, n);
sum_f = sum(hist_f(:));
sum_b = sum(hist_b(:));
parfor i = 1 : m
    for j = 1 : n
        lo = bin_locate(reshape(frame(i, j, :), 1, 3), tt);
        
        c_f = hist_f(lo(1, 1), lo(1, 2), lo(1, 3));
        c_b = hist_b(lo(1, 1), lo(1, 2), lo(1, 3));
        
        P_Cp_F = c_f / sum_f;
        P_Cp_B = c_b / sum_b;
        fb_prop(i, j) = (P_Cp_F * Priors_F(i, j)) ./ (P_Cp_F * Priors_F(i, j) + P_Cp_B * Priors_B(i, j));
    end
end

end

