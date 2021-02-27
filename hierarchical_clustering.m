%% Hierarchical clustering

%% DATA
% 1 angle
data=extractfield(trial(:,1),'spikes');
data=squeeze(mean(data,3));
data=data(:,1:593);

% all angles
data=extractfield(trial,'spikes');
data=squeeze(mean(data,3));
data=data(:,1:593,:);
data=reshape(data,784,593);

% 1 unit, all angles
data=extractfield(trial,'spikes');
data=squeeze(mean(data,3));
data=squeeze(data(20,1:571,:));
data=data';

%%

load features.mat
load labels_tuning_curve.mat

s = sum(peaks/1);
peaks_norm = peaks./s;
[coeff,score,latent,tsquared,explained,mu] = pca(peaks_norm','NumComponents',3);

%X=score;
X=data;

Y = pdist(X,'correlation');
Y_square = squareform(Y);

Z = linkage(Y);
dendrogram(Z)

T = cluster(Z,'maxclust',3);
[coeff,score,latent,tsquared,explained,mu] = pca(data,'NumComponents',3);
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

