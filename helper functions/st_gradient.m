function grad = st_gradient(img, sz)

img = double(img);

img = medfilt2(img, [1 (2*sz+1)]);

% h = ones(1, (2*sz)) / (2*sz);
% img = imfilter(img, h);



h = [-1 0 1]';

grad = imfilter(img, h);


grad = localnormalize(grad, sz, 2 * sz + 1);
grad = (grad-min(grad(:)))/(max(grad(:))-min(grad(:)));
grad = imadjust(grad);

% figure, imshow(grad)