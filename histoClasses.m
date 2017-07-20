function histPlot = histoClasses(Feat, numClasses, indLens, Bins)
histPlot = figure;
colorMat = ['r','g','b','m','c','y']; 
hold on;   
for i = 2:(numClasses+1)
    histogram(Feat((indLens(i-1)+1):indLens(i)), Bins, 'FaceColor', colorMat(i-1));
end
hold off;