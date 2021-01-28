function grad = dm_gradient(img, sz)

img = double(img);

img = medfilt2(img, [1, sz]);

h = [1 -1]';

grad = imfilter(img, h);

grad = localnormalize(grad, sz, 2*sz+1);
grad = (grad-min(grad(:)))/(max(grad(:))-min(grad(:)));
grad = imadjust(grad);

% figure, imshow(grad)