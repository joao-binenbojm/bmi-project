%% RANDOM SEED RMSE CALCULATOR

RMSE = zeros(1,50);
t = zeros(1,50);
percentage = zeros(1,50);
f = waitbar(0,'Processing...');
for itr = 1:50
    [RMSE(itr),t(itr),modelParameters] = testFunction_for_students_MTb('kalman',true);
    waitbar(itr/50,f,'Processing...');
end
close(f);
beep;

%% Plots

% Decoder comparison
% 3d

figure;
load('Decoder_comparison.mat');
gm_Mean = gmdistribution([mean(Mean.RMSE),mean(Mean.t)],[std(Mean.RMSE),std(Mean.t)]);
plt_Mean = fsurf(@(x,y)reshape(pdf(gm_Mean,[x(:),y(:)]),size(x)),[min(Mean.RMSE)-10 max(Mean.RMSE)+10 min(Mean.t)-10 max(Mean.t)+10]);
plt_Mean.FaceColor = 'b';
plt_Mean.ShowContours = 'on';
hold on;
gm_Kalman = gmdistribution([mean(Kalman.RMSE),mean(Kalman.t)],[std(Kalman.RMSE),std(Kalman.t)]);
plt_Kalman = fsurf(@(x,y)reshape(pdf(gm_Kalman,[x(:),y(:)]),size(x)),[min(Kalman.RMSE)-10 max(Kalman.RMSE)+10 min(Kalman.t)-10 max(Kalman.t)+10]);
plt_Kalman.FaceColor = 'g';
plt_Kalman.ShowContours = 'on';
gm_Kalman_trajectory = gmdistribution([mean(Kalman_trajectory.RMSE),mean(Kalman_trajectory.t)],[std(Kalman_trajectory.RMSE),std(Kalman_trajectory.t)]);
plt_Kalman_trajectory = fsurf(@(x,y)reshape(pdf(gm_Kalman_trajectory,[x(:),y(:)]),size(x)),[min(Kalman_trajectory.RMSE)-10 max(Kalman_trajectory.RMSE)+10 min(Kalman_trajectory.t)-10 max(Kalman_trajectory.t)+10]);
plt_Kalman_trajectory.FaceColor = '	#006400';
plt_Kalman_trajectory.ShowContours = 'on';
gm_Kalman_OLS = gmdistribution([mean(Kalman_OLS.RMSE),mean(Kalman_OLS.t)],[std(Kalman_OLS.RMSE),std(Kalman_OLS.t)]);
plt_Kalman_OLS = fsurf(@(x,y)reshape(pdf(gm_Kalman_OLS,[x(:),y(:)]),size(x)),[min(Kalman_OLS.RMSE)-10 max(Kalman_OLS.RMSE)+10 min(Kalman_OLS.t)-10 max(Kalman_OLS.t)+10]);
plt_Kalman_OLS.FaceColor = '#90ee90';
plt_Kalman_OLS.ShowContours = 'on';
xlabel('RMSE','Fontsize',20);
ylabel('Running time [s]','Fontsize',20);
legend('Mean trajectory','Kalman','Kalman - trajectory','Kalman - OLS');

%Contour

figure;
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_Mean,[x0 y0]),x,y);
fcontour(gmPDF,[min(Mean.RMSE)-10 max(Mean.RMSE)+10 min(Mean.t)-10 max(Mean.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
hold on;
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_Kalman,[x0 y0]),x,y);
fcontour(gmPDF,[min(Kalman.RMSE)-10 max(Kalman.RMSE)+10 min(Kalman.t)-10 max(Kalman.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_Kalman_trajectory,[x0 y0]),x,y);
fcontour(gmPDF,[min(Kalman_trajectory.RMSE)-10 max(Kalman_trajectory.RMSE)+10 min(Kalman_trajectory.t)-10 max(Kalman_trajectory.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm_Kalman_OLS,[x0 y0]),x,y);
fcontour(gmPDF,[min(Kalman_OLS.RMSE)-10 max(Kalman_OLS.RMSE)+10 min(Kalman_OLS.t)-10 max(Kalman_OLS.t)+10],'MeshDensity',100,'Fill','off','LineWidth',2);
set(gca,'Fontsize',15);
xlabel('RMSE','Fontsize',20);
ylabel('Running time [s]','Fontsize',20);
