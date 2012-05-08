function [ globalError, classErrors ] = classifierError( originalLabels, classifierLabels)

    class  = unique(originalLabels);
    qClass = length(class);

    globalError = 0;
    classErrors = zeros(qClass, 1);

    for k=1:qClass
        allK = length(originalLabels(originalLabels == class(k)));
        trueK = length(originalLabels(originalLabels == class(k) & originalLabels == classifierLabels ));
        falseK = allK - trueK;

        classErrors(k) = falseK / allK;
        globalError = globalError + falseK;
    end

    globalError = globalError/length(originalLabels);

end