function direction_pol = layer_direction(layer, filt_sz)

if ~isempty(layer)
        
            
            hfsz = ceil(filt_sz/2);
                        
            layer = smooth(layer, filt_sz);

            layer([1:hfsz, end-hfsz+1:end]) = nan; % remove due to filtering artifact
                        
            b = [-ones(1,hfsz), 0, ones(1,hfsz)];
            
            a = 1;
            
            dlayer = filter(b, a, diff(layer));
           
            
            idx = find(abs(dlayer) > 3.5);

            idx1 = idx(idx < 150);
            idx2 = idx(idx >= 150 & idx <= 350);
            idx3 = idx(idx > 350);


            if ~isempty(idx1)

                layer(1:idx1(end)) = nan;

            end

            if ~isempty(idx2)

                layer(idx2(1):idx2(end)) = nan;

            end

            if ~isempty(idx3)

                layer(idx3(1):end) = nan;

            end
   
            
            if any(isnan(layer))
                
                x = 1:numel(layer);            

                pol = polyfit( x(~isnan(layer)), layer(~isnan(layer)), 2);

                direction_pol = polyval(pol, x);
                
            else
                
                direction_pol = [];
                                       
            end
            
%             figure, plot(direction_pol)

end