function [flatImg, flatLayer] = img_flatten(img, layer, before, after)

img = double(img);

minLayer = round(min(layer));

for col = 1:size(img,2)
    
    % if is nan shift like the adjacent
    if isnan(layer(col))
    
        flatImg(:,col) = circshift(img(:,col), minLayer);
        
    else
        
        shift_amt = minLayer - ceil(layer(col));
        
        flatImg(:,col) = circshift(img(:,col), shift_amt);
        
    end
    
end

% before/after window are needed so that filtering does not affect the
% layer region

flatImg = flatImg(minLayer - before : minLayer + after, :);

flatLayer = (before + 1) * ones(size(layer));



