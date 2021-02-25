%% PCA test

%Feature space
%98 spike trains from time t = 0 to t = τ, then splitting each into bins 
%of size δt, computing the within-bin firing rates and concatenating the 
%results into a single vector

load monkeydata_training.mat

%select useful time range
data = section(trial);

for i=1:1:size(data,2)
    for j=1:1:98
        sel.angle=i;
        sel.unit=j;
        H(i,j)=PSTH(data,sel,80,'');
    end
end

%%
out = extractfield(H,'psth');
out = out(1:3,:,:);
out = out/80;

test = reshape(out,294,8);

%% New features (by Ruben)


