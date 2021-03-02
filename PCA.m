%% PCA
%data is fr_avg from Ruben found in matlab.mat downloads

s = sum(fr_avg/1);
peaks_norm = fr_avg./s;
[coeff,score,latent,tsquared,explained,mu] = pca(peaks_norm,'NumComponents',3);

gscatter(score(:,2),score(:,3),Y);
xlabel('PCA 2');
ylabel('PCA 3');

%%


load features.mat
load labels_tuning_curve.mat

s = sum(peaks/1);
peaks_norm = peaks./s;
[coeff,score,latent,tsquared,explained,mu] = pca(peaks_norm','NumComponents',3);
figure;
hold on;
c=labels; % colors labels
scatter3(score(:,1),score(:,2),score(:,3),[],c,'filled')
axis equal
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
zlabel('3rd Principal Component')
l = 1:98; % units labels
text( score(:,1),score(:,2), score(:,3),cellstr(num2str(l')) )

figure;
pareto(explained)

figure;
plot(explained)

explained(1)+explained(2) %total explained variance
