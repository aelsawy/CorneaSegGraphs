function filtered = init_gradient(img, sz)


    img = double(img); 
    
    
    gauss_sz = sz;
    gauss_sgma = gauss_sz/6;

    img = imfilter(img, fspecial('gaussian',gauss_sz,gauss_sgma));
    
    filter_sz = sz;

    hVert = [ones(filter_sz,1); 0; -ones(filter_sz,1)];

    hHorz = hVert';

    fVert = imfilter(img, hVert);

    fVert = abs(fVert);


    fHorz = imfilter(img, hHorz);

    fHorz = abs(fHorz);

    x = 1:size(fHorz,2);
    
    alpha = 1 - gaussmf(x, [100 size(img,2)/2]);

    filtered = bsxfun(@times,fHorz,alpha)+ fVert;
  

    filtered = localnormalize(filtered, sz, (sz*2+1));
    
    filtered = (filtered-min(filtered(:)))/(max(filtered(:))-min(filtered(:)));
    
    filtered = imadjust(filtered);    