function [ tt, hist_f, hist_b ] = I_hist( frame, mask )
[m, n, ~] = size(frame);
hist_dist = 10;
hist_num = 26;
tt = 0 : hist_dist : 255;
tt = [tt, 256];

hist_f = zeros(hist_num, hist_num, hist_num);
hist_b = zeros(hist_num, hist_num, hist_num);

for i = 1 : m
    for j = 1 : n
        lo = bin_locate(reshape(frame(i, j, :), 1, 3), tt);
        if mask(i, j) == 255
            hist_f(lo(1, 1), lo(1, 2), lo(1, 3)) = hist_f(lo(1, 1), lo(1, 2), lo(1, 3)) + 1;
        elseif mask(i, j) == 0
            hist_b(lo(1, 1), lo(1, 2), lo(1, 3)) = hist_b(lo(1, 1), lo(1, 2), lo(1, 3)) + 1;
        end
    end
end
end

