function layers = segment_img(img)

    
% resize images

img = img(1:2:end, 1:2:end);
    


%% EP / EN

sz = 5;

filtered = init_gradient(img, sz);

filtered = trim_gradient_edges(filtered, round(sz/2));
   
imgsz = size(filtered);


%% 1st stage

ep_roi = init_roi(imgsz);    

ep_roi_img = zeros(size(img));

ep_roi_img(ep_roi(3:end)) = 1;

ep_roi_img = ep_roi_img.*filtered;


Wt_exp = 2;

Wt_v = 0.5;

[vrtx, nbr_vrtx, adjmat_white] = adjmat(filtered, Wt_exp, Wt_v);

EP = search_layer(imgsz, ep_roi, vrtx, nbr_vrtx, adjmat_white);



en_roi = other_layer_roi(imgsz, EP);

en_roi_img = zeros(size(img));

en_roi_img(en_roi(3:end)) = 1;

en_roi_img = en_roi_img.*filtered;


EN = search_layer(imgsz, en_roi, vrtx, nbr_vrtx, adjmat_white);


%% 2nd stage

ep_dir = layer_direction(EP, 15);


if ~isempty(ep_dir)
    
	Wt_exp = 2;
    Wt_v = 0.5;
    Wt_dir = 1;
        
    [vrtx, nbr_vrtx, adjmat_white] = adjmat_directed(filtered, ep_dir, Wt_exp, Wt_v, Wt_dir);

    EP = search_layer(imgsz, ep_roi, vrtx, nbr_vrtx, adjmat_white);

end


en_dir = layer_direction(EN, 15);

if ~isempty(en_dir)
    
	Wt_exp = 2;
    Wt_v = 0.5;
    Wt_dir = 1;
    
    [vrtx, nbr_vrtx, adjmat_white] = adjmat_directed(filtered, en_dir, Wt_exp, Wt_v, Wt_dir);

    EN = search_layer(imgsz, en_roi, vrtx, nbr_vrtx, adjmat_white);

end

[EP, EN] = order_layers(EP, EN);
    

% shift correction
EP = EP + 2;
EN = EN - 2;


%% BW

ep_before = min(20, min(EP) - 1); % in case that the EP apex is touching the top

ep_after = 50;

[epFlatImg, epFlatLayer] = img_flatten(img, EP, ep_before, ep_after);


bw_grad = bw_gradient(epFlatImg, 7);


bw_imgsz = size(bw_grad);

bw_depth = 20;

bw_win = 10;

bw_roi = layer_roi(bw_imgsz, epFlatLayer + bw_depth, bw_win);

Wt_exp = 2;
Wt_horz = 0.5;
Wt_dir = 2;

[vrtx, nbr_vrtx, adjmat_white] = adjmat_directed_flat(bw_grad, epFlatLayer, Wt_exp, Wt_horz, Wt_dir);


BW = search_layer(bw_imgsz, bw_roi, vrtx, nbr_vrtx, adjmat_white);


%% unflatten layers

BW = layer_unflatten(BW, EP, ep_before);


EP = smooth_layer(EP, 15);
BW = smooth_layer(BW, 15);
EN = smooth_layer(EN, 15);

layers = [EP; BW; EN];
