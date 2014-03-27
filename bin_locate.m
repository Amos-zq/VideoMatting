function locate = bin_locate(color, tt)
num = size(tt, 2);
locate = zeros(1, 3);
for ll = 1 : 3
    for i = 1 : num - 1
        if color(1, ll) >= tt(1, i) && color(1, ll) < tt(1, i + 1)
            locate(1, ll) = i;
            break;
        end
    end
end
end