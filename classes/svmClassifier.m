classdef svmClassifier < handle
    %SVMCLASSIFIER LDA Classifier
    %   Support vector machine classifier
    
    properties
        model
    end
    
    methods
        function obj = svmClassifier()
            %LDACLASSIFIER Construct an instance of this class
            
        end
        
        function [out,obj] = fit(obj,trainingData)
            %FIT(trainingData) Trains model based on training data
            
            outputArg = obj.Property1 + inputArg;
        end
        
        function [out,obj] = predict(obj,testData)
            %PREDICT(testData) uses trained model to generate labels on
            %test data
            
            outputArg = obj.Property1 + inputArg;
        end
    end
end