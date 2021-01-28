function get_features(img)


features = zeros(size(img));

% for i = 1:size(img,2)
%     
%    col = img(:, i);
%    
%    features(:,i) = col > mean(col);
%         
% end

[~, rows] = max(img, [], 1);

idx = sub2ind(size(img), rows, 1:size(img,2));

features(idx) = 1;

figure, imshow(img)

figure, imshow(features)