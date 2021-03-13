classdef Classifier
    %CLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        NN
        LDA
        SVM
    end
    
    methods
        function obj = Classifier()
            %CLASSIFIER Construct an instance of this class
            
            obj.NN = nnClassifier();
            obj.LDA = ldaClassifier();
            obj.SVM = svmClassifier();
        end
    end
end
