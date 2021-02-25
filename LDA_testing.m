%% LDA
load labels_tuning_curve.mat
load features.mat

%% LDA MATLAB function
%train/test - needs different data for training and testing
%train
Mdl = fitcdiscr(peaks',labels);

%predict

%predict(Mdl,peaks(X))


%% LDA model from LDA.mat - using 8 dimensions

W = LDA(peaks',labels);
L = [ones(98,1) peaks'] * W';
col =sum(exp(L),2);
rep = [col,col,col,col,col,col,col,col];
P = exp(L) ./ rep;
[idx, colors]=max(P,[],2);

figure;
hold on;; % colors labels
scatter(L(:,1),L(:,2),[],colors,'filled')
axis equal
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
text(L(:,1),L(:,2),cellstr(num2str(labels')) )

%% LDA model from LDA.mat - using 3 dimensions from PCA

s = sum(peaks/1);
peaks_norm = peaks./s;
[coeff,score,latent,tsquared,explained,mu] = pca(peaks_norm','NumComponents',3);
W = LDA(score,labels);
L = [ones(98,1) score] * W';

col =sum(exp(L),2);
rep = [col,col,col,col,col,col,col,col];
P = exp(L) ./ rep;
[idx, colors]=max(P,[],2);

figure;
hold on;; % colors labels
scatter(L(:,1),L(:,2),[],colors,'filled')
axis equal
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
text(L(:,1),L(:,2),cellstr(num2str(labels')) )

