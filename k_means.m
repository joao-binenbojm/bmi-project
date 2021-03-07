%% k-means algorithm

clear p;

addpath('funcs','data');

load('monkeydata_training');

data = section(trial);

for i = 1:1:98
    p(i) = tuning_curve(data,i,5,'count','');
end

peaks = extractfield(p,'values');
peaks = peaks(1:8,:);
s = sum(peaks,1);
peaks = peaks./s;

[idx,mu] = kmeans(score,8);

p = extractfield(p,'idx');
c = idx;
scatter3(score(:,1),score(:,2),score(:,3),[],c,'filled');
hold on;
scatter3(mu(:,1),mu(:,2),mu(:,3),200,'x');
set(gca,'FontSize',15);
xlabel(sprintf('$$f_r(\\theta_%d)$$',ang(1)),'FontSize',20);
ylabel(sprintf('$$f_r(\\theta_%d)$$',ang(2)),'FontSize',20);
zlabel(sprintf('$$f_r(\\theta_%d)$$',ang(3)),'FontSize',20);
text(score(:,1),score(:,2),score(:,3),cellstr(num2str(p(1,:)')));
col = colorbar;
col.Label.String = 'Units';
col.Label.FontSize = 15;
col.Label.Interpreter = 'latex';

