function roi = layer_roi(imgsz, y, win)

nElements = imgsz(1) * imgsz(2);

img = false(imgsz);

x = 1:numel(y);

y = round(y);

idx = sub2ind(imgsz, y, x);

img(idx) = 1;

img = imdilate(img, strel('disk', win));


% figure, imshow(img)
% hold on
% plot(x, y, '--')

roi = find(img==1);


% adding the first and the last elements in the image
roi = [nElements+1; nElements+2; roi];
