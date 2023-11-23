function [x,y] = outliers(x, y, num_sigma) 
% Function removing outliers from dataset
%   x = x component of dataset
%   y = y component. Outliers in y will remove (x,y) from dataset
%   num_sigma = number of stdev that are the border of our allowed region.
%       If a value is |y-average| > num_sigma*sigma it is removed.
    sigma = std(y);
    threshold = num_sigma * sigma;
    ave = mean(y);

    selector = (abs(ave-y)/threshold)<1;  % Diff must be less that 1 thresh.
    y = y(selector);    % Remove = average over two points if lineplot.
    x = x(selector);
end
