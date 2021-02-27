%% MMT Bayesian filter
%% Ruben Ruiz-Mateos Serrano, Start date: 27/02/2021

set(groot, 'defaultTextInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
clear variables; clc; close all;

load('monkeydata_training');

data = extractfield(trial,'handPos');

data = data(1:2,1:672,1,1);

vel(1,:) = [0,diff(data(1,:),1)];
vel(2,:) = [0,diff(data(2,:),1)];

acc(1,:) = [0,0,diff(data(1,:),2)];
acc(2,:) = [0,0,diff(data(2,:),2)];

for p = 1:1:length(vel)
    mag_pos(p) = norm(data(:,p));
    mag_vel(p) = norm(vel(:,p));
end

figure;
subplot(3,1,1);
plot(1:1:length(data),data,'LineWidth',2)
title('Position','FontSize',20)
subplot(3,1,2);
plot(1:1:length(data),vel,'LineWidth',2)
title('Velocity','FontSize',20)
subplot(3,1,3);
plot(1:1:length(data),acc,'LineWidth',2)
title('Acceleration','FontSize',20)

X = cat(1,data,vel,acc,mag_pos,mag_vel);

x = X(:,50);
dt = 20;

% Initialising variables

m = randi(8);
delta = 10;

for u = 1:1:98
    lag{u} = 
end

for i = 1:1:8
    Pi{i} = rand(8,1);
    V{i} = rand(8);
    b{i} = rand(8,1);
    Q{i} = rand(8);
    A{i} = rand(8); 
end

for p = 1:1:8
    x1_m{1}(p) = makedist('Normal','mu',Pi{m}(p),'sigma',V{m}(p,p));
end

for t = 1:1:length(data)
    for p = 1:1:8
        x1_m{t+1}(p) = makedist('Normal','mu',A{m}(p,p)*random(x1_m{t}(p),1)+b{m}(p),'sigma',Q{m}(p,p));
    end
    
end




