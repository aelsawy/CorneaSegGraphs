function roi = other_layer_roi(imgsz, y)

% note that x will be shifted by 1 in the augimg

nElements = imgsz(1) * imgsz(2);

img = false(imgsz);

x = 1:numel(y);

y = round(y);

idx = sub2ind(imgsz, y, x);

img(idx) = 1;

img = imdilate(img, strel('disk', 50));

H = imgsz(1);
W = imgsz(2);


img(end-round(H/8):end, round(W/4:W-W/4)) = 1;

img(1:round(H/10), round([1:W/6, W-W/6:W])) = 1;


% figure, imshow(~img)
% hold on
% plot(x, y, '--')

roi = find(img==0);

% adding the first and the last elements in the image
roi = [nElements+1; nElements+2; roi];
