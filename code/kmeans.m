function [centroid, label] = kmeans(data, centroid)
    label = zeros(size(data,1),1);
    %loop sampai centroidnya ga berubah
    temp_centroid = centroid+999; %inisialisasi awal
    while sum(sqrt(sum((centroid-temp_centroid).^2,2))) > 0.0001
%         hitung tiap data deketnya ke centroid yang mana
        for i = 1:size(data,1)
           for j = 1:size(centroid,1)
%                euclidean distance
               jarak(j) = sqrt(sum((centroid(j,:)-data(i,:)).^2));
           end
           [~, label(i)] = min(jarak);
        end
        temp_centroid = centroid;
%         update centroid
        centroid = objsse(data, label, centroid);
    end
end