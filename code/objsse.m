function [centroid] = objsse(data, label, centroid)
% menghitung fungsi objective K-means, Sum of Squared Errors (SSE)
    for i=1:size(centroid,1)
        datapercentroid = data(label==i,:);
        centroid(i,:) = sum(datapercentroid)./size(datapercentroid,1);
    end
end