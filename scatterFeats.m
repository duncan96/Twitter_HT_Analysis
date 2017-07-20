function classPlot = scatterFeats(Feat1, Feat2, numClasses, indLens, Axes)
    classPlot = figure;
    colorMat = ['r','g','b','m','c','y'];
    shapeMat = ['o', '+', 'x', 'd', 's', '^'];
    hold on;
    for i = 2:(numClasses+1)
        scatter(Feat1((indLens(i-1)+1):indLens(i)), Feat2((indLens(i-1)+1):indLens(i)), shapeMat(i-1), colorMat(i-1));
        xlabel(Axes(1))
        ylabel(Axes(2))
    end
    hold off;