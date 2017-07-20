function mat = plotMatrixData(Matrix, numClasses, classLens, colPer, axVals)
colorMat = ['r','g','b','m','c','y'];
shapeMat = ['o', '+', 'x', 'd', 's', '^'];
mat = figure;
m = 0;
for i = 1:colPer
    for j = 1:colPer
        m = m + 1;
        if(i > j)
            subplot(colPer, colPer, m)
            hold on;      
            for k = 2:(numClasses+1)
                scatter(Matrix((classLens(k-1)+1):classLens(k),i), Matrix((classLens(k-1)+1):classLens(k),j), shapeMat(k-1), colorMat(k-1));
                xlabel(axVals(i));
                ylabel(axVals(j));
            end
            hold off;
        end 
    end
end
