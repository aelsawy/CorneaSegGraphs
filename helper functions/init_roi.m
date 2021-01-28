function roi = init_roi(imgsz)

% note that x will be shifted by 1 in the augimg


img = true(imgsz);

H = imgsz(1);
W = imgsz(2);

% [x, y] = meshgrid(1:W, 1:H);
% 
% x = x(:);
% y = y(:);
% 
% lowercircle = ( (x-W/2).^2 + (y-H).^2 ) < (W/4).^2;
% 
% idx = sub2ind(imgsz, y(lowercircle), x(lowercircle));
% 
% img(idx) = false;

img(end-round(H/8):end, round(W/4:W-W/4)) = false;

img(1:round(H/10), round([1:W/7, W-W/7:W])) = false;



% img(:,1) = true;
% img(:,end) = true;


% figure, imshow(img)
% hold on
% plot(x, y, '--')

roi = find(img);


% figure, imshow(img)

% adding the first and the last elements in the image
roi = [numel(img)+1; numel(img)+2; roi];
