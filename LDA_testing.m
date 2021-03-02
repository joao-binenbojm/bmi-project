%% LDA
load labels_tuning_curve.mat
load features.mat

%% LDA MATLAB function
%train/test - needs different data for training and testing
%train
%Mdl = fitcdiscr(peaks',labels);


%MdlLinear = fitcdiscr(X(1:560,:),Y(1:560,:));
%meanclass2 = predict(MdlLinear,X(561:end,:));
%bools = meanclass2 == Y(561:end,:);
[split_X,split_labels] = split_data(X,Y,0.7);
MdlLinear = fitcdiscr(split_X.train,split_labels.train);
%MdlLinear = fitctree(split_X.train,split_labels.train);
meanclass2 = predict(MdlLinear,split_X.test);
bools = meanclass2 == split_labels.test;
sum(bools)/size(split_labels.test,1)
gscatter(split_X.test,split_labels.test,meanclass2)

%% PLOT TEST DATA
load monkey
x = extractfield(trial,'spikes');
Y=repmat([1:1:8]',100,1);
%%
clearvars -except x Y
for l=160
    acc = 1;
    for t=1:1:100
        for a=1:1:8
            clear fr;
            for u=1:1:98
                var = x(u,:,t,a);
                %var = var(~isnan(var));
                var = var(1:l);
                %l = length(var);
                %l = 320;
                var(var==0) = NaN;
                count = histcounts([1:1:l].*var,0:80:l);
                fr(u,:) = count/80;
            end
            fr_avg(acc,:) = mean(fr,2);
            acc = acc+1;
        end
    end
    [split_X,split_labels] = split_data(fr_avg,Y,0.7);
    MdlLinear = fitcdiscr(split_X.train,split_labels.train);
    %MdlLinear = fitctree(split_X.train,split_labels.train);
    meanclass2 = predict(MdlLinear,split_X.test);
    bools = meanclass2 == split_labels.test;
    sum(bools)/size(split_labels.test,1)
end
%%
split_labels.test == 7;
split_X.test(ans,:);


%%
for i=320:20:500
    data2 = data(:,1:i,:,:);
    data3 = squeeze(sum(data2,2)/i);
    data4 = reshape(data3,800,98);

    [split_X,split_labels] = split_data(data4,Y,0.7);
    MdlLinear = fitcdiscr(split_X.train,split_labels.train);
    %MdlLinear = fitctree(split_X.train,split_labels.train);
    meanclass2 = predict(MdlLinear,split_X.test);
    bools = meanclass2 == split_labels.test;
    sum(bools)/size(split_labels.test,1)
end
gscatter(split_X.test,split_labels.test,meanclass2)


%%


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
%rep = [col,col,col,col,col,col,col,col];
rep = repmat(col,98);
P = exp(L) ./ rep;
[idx, colors]=max(P,[],2);

figure;
hold on;; % colors labels
scatter(L(:,1),L(:,2),[],colors,'filled')
axis equal
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
text(L(:,1),L(:,2),cellstr(num2str(labels')) )

