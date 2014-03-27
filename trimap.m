function curr_trimap = trimap(fb_prop, threshold)
[m, n] = size(fb_prop);
curr_trimap = 0.5*ones(m, n);

for i = 1 : m
    for j = 1 : n
        if fb_prop(i, j) < threshold
            curr_trimap(i, j) = 0;
        elseif fb_prop(i, j) > 1 - threshold
            curr_trimap(i, j) = 1;
        end
    end
end
end