classdef Classifier
    %CLASSIFIER Class of classifier classes
    
    properties
        NN
        LDA
        SVM
        NB
        ECOC
    end
    
    methods
        function obj = Classifier()
            %CLASSIFIER Construct an instance of this class
            
            obj.NN = nnClassifier();
            obj.LDA = ldaClassifier();
            obj.SVM = svmClassifier();
            obj.NB = nbClassifier();
            obj.ECOC = ecocClassifier();
        end
    end
end

