close all;
clear;
clc;

% load dataset
dataset = readtable('dataset1.csv');
% ambil matkul icm, side, tele --> 11, 15, 12
datanilai = dataset(:,5:end);
data = zeros(size(datanilai));

fprintf('Converting Index to Number 1-7 . . . .\n');
for i=1:size(datanilai,1)
    for j=1:size(datanilai,2)
        if strcmp(table2array(datanilai(i,j)),{'A'})
            data(i,j) = 7;
        elseif strcmp(table2array(datanilai(i,j)),{'AB'})
            data(i,j) = 6;
        elseif strcmp(table2array(datanilai(i,j)),{'B'})
            data(i,j) = 5;
        elseif strcmp(table2array(datanilai(i,j)),{'BC'})
            data(i,j) = 4;
        elseif strcmp(table2array(datanilai(i,j)),{'C'})
            data(i,j) = 3;
        elseif strcmp(table2array(datanilai(i,j)),{'D'})
            data(i,j) = 2;
        elseif strcmp(table2array(datanilai(i,j)),{'E'})
            data(i,j) = 1;
        else
            data(i,j) = 0;
        end 
    end
end

fprintf('Clustering K-Means  . .  .\n');

% run kmeans dengan 3 centroid (icm, side, tele)
centroid = [ones(1,11)*5 zeros(1,27); zeros(1,11) ones(1,15)*5 zeros(1,12); zeros(1,26) ones(1,12)*5];
[centroid, label] = kmeans(data, centroid);

%visualisasi hasil cluster
datapca = princompal(data,2);
figure;
gscatter(datapca(:,1), datapca(:,2), label);
% hold on;
% centpca = princompal(centroid,2);
% gscatter(centpca(:,1), centpca(:,2), [1 2]);

fprintf('Split and Labeling Cluster . .  .\n');
% label
icm_cluster = data(find(label==1),:);
side_cluster = data(find(label==2),:);
tele_cluster = data(find(label==3),:);

fprintf('Done Cluster\n');

% cek icm
for i=1:size(icm_cluster,1)
    icm_cluster(i,find((icm_cluster(i,:))<3)) = 0;
    icm_cluster(i,find((icm_cluster(i,:))>=3)) = 1;
end

% cek side
for i=1:size(side_cluster,1)
    side_cluster(i,find((side_cluster(i,:))<3)) = 0;
    side_cluster(i,find((side_cluster(i,:))>=3)) = 1;
end

% cek tele
for i=1:size(tele_cluster,1)
    tele_cluster(i,find((tele_cluster(i,:))<3)) = 0;
    tele_cluster(i,find((tele_cluster(i,:))>=3)) = 1;
end

%setting apriori
minSup = 0.25;
minConf = 0.5;
nRules = 500;
sortFlag = 1;
labels = dataset.Properties.VariableNames(5:end);

%apriori buat icm
[Rules FreqItemsets] = findRules(icm_cluster, minSup, minConf, nRules, sortFlag, labels, 'ICM_Rules');

%apriori buat side
[Rules FreqItemsets] = findRules(side_cluster, minSup, minConf, nRules, sortFlag, labels, 'Side_Rules');

%apriori buat tele
[Rules FreqItemsets] = findRules(tele_cluster, minSup, minConf, nRules, sortFlag, labels, 'Tele_Rules');

fprintf('Done Apriori\n');