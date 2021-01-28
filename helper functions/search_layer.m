function layer = search_layer(imgsz, roi, vrtx, nbr_vrtx, adjmat_white)

nElements = imgsz(1) * imgsz(2);

% include only region of interst in the adjacency matrix
includeV = ismember(vrtx, roi);
includeN = ismember(nbr_vrtx, roi);
keepInd = includeV & includeN;

% compile adjacency matrix
adjMatrix = sparse(vrtx(keepInd), nbr_vrtx(keepInd), adjmat_white(keepInd), nElements+2, nElements+2);


% we take the part of the adj matrix that belongs to the ROI

[ ~, path ] = graphshortestpath( adjMatrix, nElements+1, nElements+2, 'Method', 'Bellman-Ford');

[pathY, pathX] = ind2sub(imgsz, path);

% remove duplicates
[pathX, idx, ~] = unique(pathX);
pathY = pathY(idx);

% remove the first and last elements and shift x back by 1    
pathX = pathX(1:end-1);
pathY = pathY(1:end-1);

% pathY = medfilt1(pathY, 3);
% xlayer = pathX;
layer = pathY;



