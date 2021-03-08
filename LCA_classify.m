%% PLOT TEST DATA
%load monkey
x = extractfield(trial,'spikes');
Y=repmat([1:1:8]',100,1);
%%
clearvars -except x Y
bins = [20,40,60,80];
for epoch=1%1:100
    for bin=4%1:length(bins)
        acc = 1;
        for t=1:1:100
            for a=1:1:8
                clear fr;
                for u=1:1:98
                    var = x(u,:,t,a);
                    %var = var(~isnan(var));
                    l = 560;
                    var = var(1:l);
                    %l = length(var);
                    var(var==0) = NaN;
                    count = histcounts([1:1:l].*var,0:bins(bin):l);
                    fr(u,:) = count/bins(bin);
                end
                fr_avg(acc,:) = mean(fr,2);
                acc = acc+1;
            end
        end
        [split_X,split_labels] = split_data(fr_avg,Y,0.7);
        %MdlLinear = fitcdiscr(split_X.train,split_labels.train);
        %MdlLinear = fitctree(split_X.train,split_labels.train,'AlgorithmForCategorical','Exact');
        %MdlLinear = fitcnb(split_X.train,split_labels.train); % fails
        t = templateSVM('Standardize',true,'KernelFunction','gaussian');
        MdlLinear = fitcecoc(split_X.train,split_labels.train,'Learners',t);
        %MdlLinear = fitcknn(split_X.train,split_labels.train);
        %MdlLinear = fitglm(split_X.train,split_labels.train); % fails
        [meanclass2,post_probs,cost] = predict(MdlLinear,split_X.test');
        bools = meanclass2 == split_labels.test;
        percent = sum(bools)/size(split_labels.test',1)
        %lst_percent(epoch,bin) = percent;
    end
end
%%
m = mean(lst_percent,1);
stdev = std(lst_percent,1);


errorbar(m,stdev);










