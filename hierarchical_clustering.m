%% Hierarchical clustering

load features.mat
load labels_tuning_curve.mat

s = sum(peaks/1);
peaks_norm = peaks./s;
[coeff,score,latent,tsquared,explained,mu] = pca(peaks_norm','NumComponents',3);

%X=score;
X=peaks';

Y = pdist(X);
Y_square = squareform(Y);

Z = linkage(Y);
dendrogram(Z,98)

T = cluster(Z,'maxclust',8);

figure;
hold on;
scatter3(score(:,1),score(:,2),score(:,3),[],T,'filled')
axis equal
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
zlabel('3rd Principal Component')
l = 1:98; % units labels
text( score(:,1),score(:,2), score(:,3),cellstr(num2str(l')) )

%% correlation distance
Y = pdist(X,'correlation');
Z = linkage(Y,'average');
c = cophenet(Z,Y)