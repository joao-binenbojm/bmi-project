classdef Classifier
    %CLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        NN
        LDA
        SVM
        NB
    end
    
    methods
        function obj = Classifier()
            %CLASSIFIER Construct an instance of this class
            
            obj.NN = nnClassifier();
            obj.LDA = ldaClassifier();
            obj.SVM = svmClassifier();
            obj.NB = nbClassifier();
        end
    end
end

