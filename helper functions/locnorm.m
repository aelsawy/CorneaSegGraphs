function normalized = locnorm(img, sz)
%LOCALNORMALIZE A local normalization algorithm that uniformizes the local
%mean and variance of an image.
%  ln=localnormalize(IM,sigma1,sigma2) outputs local normalization effect of 
%  image IM using local mean and standard deviation estimated by Gaussian
%  kernel with sigma1 and sigma2 respectively.
%
%  Contributed by Guanglei Xiong (xgl99@mails.tsinghua.edu.cn)
%  at Tsinghua University, Beijing, China.

g = fspecial('gaussian', sz, sz/6);
num = img - imfilter(img, g);
den = sqrt(imfilter(num.^2, g));
normalized = num./den;

normalized = (normalized-min(normalized(:)))/(max(normalized(:))-min(normalized(:)));
normalized = imadjust(normalized);