clc;

close all;

addpath(genpath('helper functions'))

img = imread('elsawy_od.png');

img = img(:,:,1);

layers = segment_img(img);

img = img(1:2:end, 1:2:end);


hfig = figure; 

himg = imshow(img);

ax = get(himg, 'parent');

set(ax, 'Units', 'normalized', 'Position', [0 0 1 1])

axis(ax, 'normal')

hold(ax, 'on')

    
for i = 1:size(layers,1)

    plot(ax, layers(i, :), '-', 'linewidth', 1)

end

fdata = getframe(hfig);
    
fimg = frame2im(fdata);
    
imwrite(fimg, 'segmentation.png')
