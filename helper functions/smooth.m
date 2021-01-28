function y = smooth(y, sz)

% note that conv used in this function will return a vector with the same
% length as the input but with invalid periphery with length half the
% length of the window on the left and half on the right so take care when
% you examine the vertical projections to ignore periphery of the signal
% also, conv can return the valid points but if you are searching for
% specific location then you have to add half the window to the location


% h = ones(1,siz)/siz;

x = 1:sz;

mu = ceil(sz/2);

sd = ceil(sz/4);

h = gaussmf(x,[sd mu]);

h = h / sum(h);

y = conv(y, h, 'same');

% sig=filter(h,1,sig);
