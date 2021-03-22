%% REPORT PLOTS
close all; clc; clear variables;
set(groot, 'defaultTextInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

% RMSE of stages of LDA classifier

load('LDA_different_stages_performance');

figure;
boxplot([LDA1.RMSE;LDA2.RMSE;LDA3.RMSE]');
set(gca,'FontSize',15);
xlabel('LDA stages','FontSize',20);
ylabel('RMSE','FontSize',20);

figure;
boxplot([LDA1.percentage;LDA2.percentage;LDA3.percentage]');
set(gca,'FontSize',15);
xlabel('LDA stages','FontSize',20);
ylabel('Percentage','FontSize',20);

%% Decoder comparison
close all; clc; clear variables;
set(groot, 'defaultTextInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

% 3d

figure;
load('Decoder_comparison.mat');
gm_Ideal = gmdistribution([mean(Mean.RMSE),mean(Mean.t)],[std(Mean.RMSE),std(Mean.t)]);
plt_Mean = fsurf(@(x,y)reshape(pdf(gm_Ideal,[x(:),y(:)]),size(x)),[min(Mean.RMSE)-10 max(Mean.RMSE)+10 min(Mean.t)-10 max(Mean.t)+10]);
plt_Mean.FaceColor = 'b';
plt_Mean.ShowContours = 'on';
hold on;
gm_LDA_MS = gmdistribution([mean(Kalman.RMSE),mean(Kalman.t)],[std(Kalman.RMSE),std(Kalman.t)]);
plt_LDA_MS = fsurf(@(x,y)reshape(pdf(gm_LDA_MS,[x(:),y(:)]),size(x)),[min(Kalman.RMSE)-10 max(Kalman.RMSE)+10 min(Kalman.t)-10 max(Kalman.t)+10]);
plt_LDA_MS.FaceColor = 'g';
plt_LDA_MS.ShowContours = 'on';
gm_SVM = gmdistribution([mean(Kalman_trajectory.RMSE),mean(Kalman_trajectory.t)],[std(Kalman_trajectory.RMSE),std(Kalman_trajectory.t)]);
plt_SVM = fsurf(@(x,y)reshape(pdf(gm_SVM,[x(:),y(:)]),size(x)),[min(Kalman_trajectory.RMSE)-10 max(Kalman_trajectory.RMSE)+10 min(Kalman_trajectory.t)-10 max(Kalman_trajectory.t)+10]);
plt_SVM.FaceColor = '	#006400';
plt_SVM.ShowContours = 'on';
gm_ECOC = gmdistribution([mean(Kalman_OLS.RMSE),mean(Kalman_OLS.t)],[std(Kalman_OLS.RMSE),std(Kalman_OLS.t)]);
plt_ECOC = fsurf(@(x,y)reshape(pdf(gm_ECOC,[x(:),y(:)]),size(x)),[min(Kalman_OLS.RMSE)-10 max(Kalman_OLS.RMSE)+10 min(Kalman_OLS.t)-10 max(Kalman_OLS.t)+10]);
plt_ECOC.FaceColor = '#90ee90';
plt_ECOC.ShowContours = 'on';
xlabel('RMSE','Fontsize',20);
ylabel('Running time [s]','Fontsize',20);
gm_NN = gmdistribution([mean(Kalman_best.RMSE),mean(Kalman_best.t)],[std(Kalman_best.RMSE),std(Kalman_best.t)]);
plt_NN = fsurf(@(x,y)reshape(pdf(gm_NN,[x(:),y(:)]),size(x)),[min(Kalman_best.RMSE)-10 max(Kalman_best.RMSE)+10 min(Kalman_best.t)-10 max(Kalman_best.t)+10]);
plt_NN.FaceColor = 'y';
plt_NN.ShowContours = 'on';
legend('Mean trajectory','Kalman','Kalman - trajectory','Kalman - OLS','Kalman - best');

%Contour

figure;
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_Ideal,[x0 y0]),x,y);
fcontour(gmPDF,[min(Mean.RMSE)-10 max(Mean.RMSE)+10 min(Mean.t)-10 max(Mean.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
hold on;
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_LDA_MS,[x0 y0]),x,y);
fcontour(gmPDF,[min(Kalman.RMSE)-10 max(Kalman.RMSE)+10 min(Kalman.t)-10 max(Kalman.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_SVM,[x0 y0]),x,y);
fcontour(gmPDF,[min(Kalman_trajectory.RMSE)-10 max(Kalman_trajectory.RMSE)+10 min(Kalman_trajectory.t)-10 max(Kalman_trajectory.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_ECOC,[x0 y0]),x,y);
fcontour(gmPDF,[min(Kalman_OLS.RMSE)-10 max(Kalman_OLS.RMSE)+10 min(Kalman_OLS.t)-10 max(Kalman_OLS.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_NN,[x0 y0]),x,y);
fcontour(gmPDF,[min(Kalman_best.RMSE)-10 max(Kalman_best.RMSE)+10 min(Kalman_best.t)-10 max(Kalman_best.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
set(gca,'Fontsize',15);
xlabel('RMSE','Fontsize',20);
ylabel('Running time [s]','Fontsize',20);

%% Classifier comparison
close all; clc; clear variables;
set(groot, 'defaultTextInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

% 3d

figure;
load('Classifier_comparison_fast_100.mat');
gm_Ideal = gmdistribution([mean(Ideal.RMSE),mean(Ideal.t)],[std(Ideal.RMSE),std(Ideal.t)]);
plt_Ideal = fsurf(@(x,y)reshape(pdf(gm_Ideal,[x(:),y(:)]),size(x)),[min(Ideal.RMSE)-10 max(Ideal.RMSE)+10 min(Ideal.t)-10 max(Ideal.t)+10]);
plt_Ideal.FaceColor = 'b';
plt_Ideal.ShowContours = 'on';
hold on;
gm_LDA_MS = gmdistribution([mean(LDA_MS.RMSE),mean(LDA_MS.t)],[std(LDA_MS.RMSE),std(LDA_MS.t)]);
plt_LDA_MS = fsurf(@(x,y)reshape(pdf(gm_LDA_MS,[x(:),y(:)]),size(x)),[min(LDA_MS.RMSE)-10 max(LDA_MS.RMSE)+10 min(LDA_MS.t)-10 max(LDA_MS.t)+10]);
plt_LDA_MS.FaceColor = 'g';
plt_LDA_MS.ShowContours = 'on';
gm_LDA_Traditional = gmdistribution([mean(LDA_Traditional.RMSE),mean(LDA_Traditional.t)],[std(LDA_Traditional.RMSE),std(LDA_Traditional.t)]);
plt_LDA_Traditional = fsurf(@(x,y)reshape(pdf(gm_LDA_Traditional,[x(:),y(:)]),size(x)),[min(LDA_Traditional.RMSE)-10 max(LDA_Traditional.RMSE)+10 min(LDA_Traditional.t)-10 max(LDA_Traditional.t)+10]);
plt_LDA_Traditional.FaceColor = '#90ee90';
plt_LDA_Traditional.ShowContours = 'on';
gm_SVM = gmdistribution([mean(SVM.RMSE),mean(SVM.t)],[std(SVM.RMSE),std(SVM.t)]);
plt_SVM = fsurf(@(x,y)reshape(pdf(gm_SVM,[x(:),y(:)]),size(x)),[min(SVM.RMSE)-10 max(SVM.RMSE)+10 min(SVM.t)-10 max(SVM.t)+10]);
plt_SVM.FaceColor = 'y';
plt_SVM.ShowContours = 'on';
gm_ECOC = gmdistribution([mean(ECOC.RMSE),mean(ECOC.t)],[std(ECOC.RMSE),std(ECOC.t)]);
plt_ECOC = fsurf(@(x,y)reshape(pdf(gm_ECOC,[x(:),y(:)]),size(x)),[min(ECOC.RMSE)-10 max(ECOC.RMSE)+10 min(ECOC.t)-10 max(ECOC.t)+10]);
plt_ECOC.FaceColor = 'r';
plt_ECOC.ShowContours = 'on';
gm_NN = gmdistribution([mean(NN.RMSE),mean(NN.t)],[std(NN.RMSE),std(NN.t)]);
plt_NN = fsurf(@(x,y)reshape(pdf(gm_NN,[x(:),y(:)]),size(x)),[min(NN.RMSE)-10 max(NN.RMSE)+10 min(NN.t)-10 max(NN.t)+10]);
plt_NN.FaceColor = '#ffa500';
plt_NN.ShowContours = 'on';
xlabel('RMSE','Fontsize',20);
ylabel('Running time [s]','Fontsize',20);
xlim([0,20]);
ylim([0,45]);
legend('Ideal classifier','LDA\_MS','LDA\_Traditional','SVM','ECOC','NN');

%Contour

figure;
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_Ideal,[x0 y0]),x,y);
fcontour(gmPDF,[min(Ideal.RMSE)-10 max(Ideal.RMSE)+10 min(Ideal.t)-10 max(Ideal.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
hold on;
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_LDA_MS,[x0 y0]),x,y);
fcontour(gmPDF,[min(LDA_MS.RMSE)-10 max(LDA_MS.RMSE)+10 min(LDA_MS.t)-10 max(LDA_MS.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_LDA_Traditional,[x0 y0]),x,y);
fcontour(gmPDF,[min(LDA_Traditional.RMSE)-10 max(LDA_Traditional.RMSE)+10 min(LDA_Traditional.t)-10 max(LDA_Traditional.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_SVM,[x0 y0]),x,y);
fcontour(gmPDF,[min(SVM.RMSE)-10 max(SVM.RMSE)+10 min(SVM.t)-10 max(SVM.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_ECOC,[x0 y0]),x,y);
fcontour(gmPDF,[min(ECOC.RMSE)-10 max(ECOC.RMSE)+10 min(ECOC.t)-10 max(ECOC.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_NN,[x0 y0]),x,y);
fcontour(gmPDF,[min(NN.RMSE)-10 max(NN.RMSE)+10 min(NN.t)-10 max(NN.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
set(gca,'Fontsize',15);
xlabel('RMSE','Fontsize',20);
ylabel('Running time [s]','Fontsize',20);
