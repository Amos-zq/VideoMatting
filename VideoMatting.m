run('vlfeat-0.9.18/toolbox/vl_setup.m');
clear all;
video_path = 'data/duck.mov';
mask_path = 'mask/mask_';
matting_path = 'matting/matting_';
frame_path = 'frame/frame_';

video = VideoReader(video_path);
num_frames = video.NumberOfFrames;

start_frame = imread('start_frame.jpg');
start_frame = start_frame(1:670, 70:1000, :);
start_mask = imread('start_mask.png');
start_mask = start_mask(1:670, 70:1000, :);

[m, n] = size(start_mask);
for i = 1 : m
    for j = 1 : n
        if start_mask(i, j) < 200
            start_mask(i, j) = 0;
        else
            start_mask(i, j) = 255;
        end
    end
end

[ tt, hist_f, hist_b ] = I_hist( start_frame, start_mask );
disp('Hist Finished!');
pre_mask = start_mask;

tic;
for num = 2 : num_frames
    curr_frame = read(video, num);
    curr_frame = curr_frame(1:670, 70:1000, :);
    imwrite(curr_frame, [frame_path int2str(num) '.jpg']);
    
    [Priors_F, Priors_B ] = Priors( pre_mask );
    fb_prop = I_prop( curr_frame, tt, hist_f, hist_b, Priors_F, Priors_B);
    curr_trimap = trimap(fb_prop, 0.01);
    curr_mask = knn_matting(curr_frame, curr_trimap);
    imwrite(curr_mask, [mask_path int2str(num) '.jpg']);
    
    curr_matting = double(curr_frame) .* repmat(curr_mask, 1, 1, 3);
    imwrite(uint8(curr_matting), [matting_path int2str(num) '.jpg']);
    
    pre_mask = curr_mask;
    
    disp(['The ' int2str(num) ' frame finished!']);
end
toc;







