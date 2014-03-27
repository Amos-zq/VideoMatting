function create_video( source_video, target_video)
mask_path = 'mask/mask_';
source = VideoReader(source_video);
target = VideoReader(target_video);

source_out = VideoWriter('source.avi');
source_out.FrameRate = 30;
open(source_out);
aviobj = VideoWriter('out.avi');
aviobj.FrameRate = 30;
open(aviobj);
for num = 2 : min(source.NumberOfFrames, target.NumberOfFrames)
    mask = imread([mask_path int2str(num) '.jpg']);
    mask = double(mask(:, :, 1)) / 255;
    target_frame = read(target, num+300);
    [m, n, ~] = size(target_frame);
    source_frame = read(source, num);
    source_frame = source_frame(1:670, 70:1000, :);
    
    edit_frame = uint8(zeros(m, n, 3));
    edit_mask = double(zeros(m, n));
    edit_frame(1:670, 1:931, :) = source_frame(:, :, :);
    edit_mask(1:670, 1:931) = mask(:,:);
    
    out_frame = double(edit_frame) .* repmat(edit_mask, 1, 1, 3) + double(target_frame) .* (1 - repmat(edit_mask, 1, 1, 3));
    writeVideo(aviobj, uint8(out_frame));
    writeVideo(source_out, uint8(target_frame));
end

close(aviobj);
close(source_out);
end

