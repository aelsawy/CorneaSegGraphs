function [vrtx, nbr_vrtx, adjmat_white] = adjmat_directed(img, layer, Wt_exp, Wt_v, Wt_dir) % refdirections
  

% size of image
sz = size(img);
nel = numel(img);


img = double(img); % convert to double for negative values not clipping to 0

% normalize in range 0 -> 1
img = (img-min(img(:)))/(max(img(:))-min(img(:)));


%% generate adjacency matrix, see equation 1 in the refered article.

% minimum weight
minWeight = 1;

%           -1      0       +1 
%  -1   (-1, -1)  (0, -1)  (+1, -1) 
%   0   (-1,  0)  (0,  0)  (+1,  0)
%  +1   (-1, +1)  (0, +1)  (+1, +1)


xoffsets = [ 0  0  1  1  1];
yoffsets = [-1  1 -1  0  1];


N = numel(xoffsets);


vrtx = ( 1 : nel-sz(1) )'; % col vector

% convert adjMA to subscripts
% note here that rows are ys but here the code is interchanging them
% ind2sub => converts indices into rows + cols
% rows are ys and cols are xs actually so take care
% propagate this in all the code ...

[vrtx_y, vrtx_x] = ind2sub(sz, vrtx); % both are col vectors ... 1st output is rows and 2nd is cols

% prepare neighbors of each vertex in vrtx

% repeat N times as cols
% output size should be V X N
vrtx = repmat(vrtx,[1 N]); 
vrtx_y = repmat(vrtx_y, [1 N]);
vrtx_x = repmat(vrtx_x, [1 N]);

% get n-connected neighbors

nbr_vrtx_y = bsxfun(@plus, vrtx_y, yoffsets);
nbr_vrtx_x = bsxfun(@plus, vrtx_x, xoffsets);


vrtx = vrtx(:);
nbr_vrtx_y = nbr_vrtx_y(:);
nbr_vrtx_x = nbr_vrtx_x(:);

% make sure all locations are within the image.
keepIdx = nbr_vrtx_x > 0 & nbr_vrtx_x <= sz(2) & ...
    nbr_vrtx_y > 0 & nbr_vrtx_y <= sz(1);

vrtx = vrtx(keepIdx);
vrtx_x = vrtx_x(keepIdx);
vrtx_y = vrtx_y(keepIdx); 

nbr_vrtx_x = nbr_vrtx_x(keepIdx);
nbr_vrtx_y = nbr_vrtx_y(keepIdx); 

nbr_vrtx = sub2ind(sz, nbr_vrtx_y, nbr_vrtx_x);


% calculate weight
% here for each vertex in vrtx and in the corresponding vertex in nbr_vrtx

% adj mat for white layers

% adjmat_white = 1 - exp(-abs( filtered(vrtx) - filtered(nbr_vrtx) ) ) ... attraction weight inverted as we minimize
%                + 1 - filtered(vrtx) ... intensity inverted as we want high value but inverted
%                + 1 - filtered(nbr_vrtx) ;

dx = nbr_vrtx_x - vrtx_x;
dy = nbr_vrtx_y - vrtx_y;



% gradient           
qa = exp(-(img(vrtx).^2)*Wt_exp);
qb = exp(-(img(nbr_vrtx).^2)*Wt_exp);



% direction

reflayer_dir = layer(nbr_vrtx_x)' - layer(vrtx_x)';

layer_dir = nbr_vrtx_y - vrtx_y;

dir_term = Wt_dir * abs(reflayer_dir - layer_dir);


% spatial preference (penalty)

% Wt_h = 1;
% % Wt_v = 0.5;
% Wt_horizontal = ( Wt_h * abs(dx) + abs(dy)) ./ (abs(dx) + abs(dy));
% Wt_vertical = ( abs(dx) + Wt_v * abs(dy)) ./ (abs(dx) + abs(dy));
% 
% width = size(img,2);
% mask1 = vrtx_x > 0.4* width & vrtx_x < 0.6 * width;
% mask2 = vrtx_x < 0.2 * width | vrtx_x > 0.8 * width;
% 
% mask1 = double(mask1);
% mask2 = double(mask2);
% 
% edge_weights = ( mask1 .* Wt_horizontal ) ...
%              + ( mask2 .* Wt_vertical ) ...
%              + (1 - mask1 - mask2);
       
         
Wt_vertical = ( abs(dx) + Wt_v * abs(dy)) ./ (abs(dx) + abs(dy));
width = size(img,2);
mask = vrtx_x < 0.2 * width | vrtx_x > 0.8 * width;
mask = double(mask);

edge_weights = mask .* Wt_vertical + (1 - mask);         

% Wt = 2;
% edge_weights = Wt * abs(dx) + abs(dy);

adjmat_white = ( qa .* qb + dir_term ) .* edge_weights;  


          
% the start node
start_vrtx_id = nel + 1;
start_vrtx = start_vrtx_id * ones(sz(1), 1);
start_nbr_vrtx = (1 : sz(1) )';

% the end node
end_vrtx_id = nel + 2;
end_vrtx = end_vrtx_id * ones(sz(1), 1);
end_nbr_vrtx = ( nel - sz(1) + 1 : nel )';


vrtx = [start_vrtx; end_nbr_vrtx; vrtx];

nbr_vrtx = [start_nbr_vrtx; end_vrtx; nbr_vrtx];


weights = minWeight * ones(2*sz(1), 1);

adjmat_white = [weights; adjmat_white];