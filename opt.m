%% RANDOM SEED RMSE CALCULATOR

RMSE = zeros(1,50);
t = zeros(1,50);
percentage = zeros(1,50);
f = waitbar(0,'Processing...');
for itr = 1:50
    
    [RMSE(itr),t(itr),modelParameters] = testFunction_for_students_MTb('linear_regressor',true);
    percentage(itr) = modelParameters.percentage/modelParameters.count;
    waitbar(itr/50,f,'Processing...');
end
close(f);
beep;

%% Plots

% 3d

figure;
load('Classifier_comparison.mat');
gm_LDA = gmdistribution([mean(LDA.RMSE),mean(LDA.t)],[std(LDA.RMSE),std(LDA.t)]);
plt_LDA = fsurf(@(x,y)reshape(pdf(gm_LDA,[x(:),y(:)]),size(x)),[min(LDA.RMSE)-10 max(LDA.RMSE)+10 min(LDA.t)-10 max(LDA.t)+10]);
plt_LDA.FaceColor = 'b';
plt_LDA.ShowContours = 'on';
hold on;
gm_SVM = gmdistribution([mean(SVM.RMSE),mean(SVM.t)],[std(SVM.RMSE),std(SVM.t)]);
plt_SVM = fsurf(@(x,y)reshape(pdf(gm_SVM,[x(:),y(:)]),size(x)),[min(SVM.RMSE)-10 max(SVM.RMSE)+10 min(SVM.t)-10 max(SVM.t)+10]);
plt_SVM.FaceColor = 'g';
plt_SVM.ShowContours = 'on';
gm_ECOC = gmdistribution([mean(ECOC.RMSE),mean(ECOC.t)],[std(ECOC.RMSE),std(ECOC.t)]);
plt_ECOC = fsurf(@(x,y)reshape(pdf(gm_ECOC,[x(:),y(:)]),size(x)),[min(ECOC.RMSE)-10 max(ECOC.RMSE)+10 min(ECOC.t)-10 max(ECOC.t)+10]);
plt_ECOC.FaceColor = 'r';
plt_ECOC.ShowContours = 'on';
gm_NN = gmdistribution([mean(NN.RMSE),mean(NN.t)],[std(NN.RMSE),std(NN.t)]);
plt_NN = fsurf(@(x,y)reshape(pdf(gm_NN,[x(:),y(:)]),size(x)),[min(NN.RMSE)-10 max(NN.RMSE)+10 min(NN.t)-10 max(NN.t)+10]);
plt_NN.FaceColor = 'y';
plt_NN.ShowContours = 'on';
gm_Ideal = gmdistribution([mean(Ideal.RMSE),mean(Ideal.t)],[std(Ideal.RMSE),std(Ideal.t)]);
plt_Ideal = fsurf(@(x,y)reshape(pdf(gm_Ideal,[x(:),y(:)]),size(x)),[min(Ideal.RMSE)-10 max(Ideal.RMSE)+10 min(Ideal.t)-10 max(Ideal.t)+10]);
plt_Ideal.FaceColor = 'w';
plt_Ideal.ShowContours = 'on';
gm_LDA_PCA = gmdistribution([mean(LDA_PCA.RMSE),mean(LDA_PCA.t)],[std(LDA_PCA.RMSE),std(LDA_PCA.t)]);
plt_LDA_PCA = fsurf(@(x,y)reshape(pdf(gm_LDA_PCA,[x(:),y(:)]),size(x)),[min(LDA_PCA.RMSE)-10 max(LDA_PCA.RMSE)+10 min(LDA_PCA.t)-10 max(LDA_PCA.t)+10]);
plt_LDA_PCA.FaceColor = 'b';
plt_LDA_PCA.ShowContours = 'on';
set(gca,'Fontsize',15);
xlabel('RMSE','Fontsize',20);
ylabel('Running time [s]','Fontsize',20);
zlabel('Probability density function','Fontsize',20);
legend('LDA','SVM','ECOC','NN','Ideal','LDA\_PCA');

%2d

figure;
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_LDA,[x0 y0]),x,y);
fcontour(gmPDF,[min(LDA.RMSE)-10 max(LDA.RMSE)+10 min(LDA.t)-10 max(LDA.t)+10],'Fill','off','LineWidth',2);
hold on;
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_SVM,[x0 y0]),x,y);
fcontour(gmPDF,[min(SVM.RMSE)-10 max(SVM.RMSE)+10 min(SVM.t)-10 max(SVM.t)+10],'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_ECOC,[x0 y0]),x,y);
fcontour(gmPDF,[min(ECOC.RMSE)-10 max(ECOC.RMSE)+10 min(ECOC.t)-10 max(ECOC.t)+10],'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_NN,[x0 y0]),x,y);
fcontour(gmPDF,[min(NN.RMSE)-10 max(NN.RMSE)+10 min(NN.t)-10 max(NN.t)+10],'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_Ideal,[x0 y0]),x,y);
fcontour(gmPDF,[min(Ideal.RMSE)-10 max(Ideal.RMSE)+10 min(Ideal.t)-10 max(Ideal.t)+10],'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_LDA_PCA,[x0 y0]),x,y);
fcontour(gmPDF,[min(LDA_PCA.RMSE)-10 max(LDA_PCA.RMSE)+10 min(LDA_PCA.t)-10 max(LDA_PCA.t)+10],'Fill','off','LineWidth',2);
set(gca,'Fontsize',15,'yscal','log');
xlabel('RMSE','Fontsize',20);
ylabel('Running time [s]','Fontsize',20);
% legend('LDA','SVM','ECOC','NN','Ideal');
