function layer = layer_unflatten(faltLayer, refLayer, window)


minLayer = round( min(refLayer));

faltLayer = faltLayer + minLayer - window - 1;

for c = 1 : numel(faltLayer)
    
    % if is nan shift like the adjacent
    if isnan(faltLayer(c))
    
        layer(c) = faltLayer(c) + minLayer;
        
    else
        
        shift_amt = minLayer - ceil(refLayer(c));
        layer(c) = faltLayer(c) - shift_amt;    

    end
    
end