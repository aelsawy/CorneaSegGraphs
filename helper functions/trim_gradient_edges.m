function img = trim_gradient_edges(img, toremove)

    img(1:toremove,:) = 0;
    img(end-toremove+1:end,:) = 0;