function [EP, EN] = order_layers(EP, EN)


if mean(EN) < mean(EP)
   
    temp = EN;
    EN = EP;
    EP = temp;
        
end

