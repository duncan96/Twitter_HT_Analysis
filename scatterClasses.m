function fig = scatterClasses(UR, Orig, numClasses, ind_Len, feats, names)
    color = ['r','g','b','y','o','p'];
    fig = figure;
    
    subplot(2,1,1);
    hold on
    for i = 2:(numClasses+1)
        scatter3(UR((ind_Len(i-1)+1):ind_Len(i), feats(1)), UR((ind_Len(i-1)+1):ind_Len(i),feats(2)), UR((ind_Len(i-1)+1):ind_Len(i),feats(3)), color(i-1));
    end
    xlabel(strcat('PC ', num2str(feats(1))));
    ylabel(strcat('PC ', num2str(feats(2))));
    zlabel(strcat('PC ', num2str(feats(3))));
    title('Normalized PCA Scatter');
    hold off

    subplot(2,1,2)
    hold on
    for i = 2:(numClasses+1)
        scatter3(Orig((ind_Len(i-1)+1):ind_Len(i),feats(1)), Orig((ind_Len(i-1)+1):ind_Len(i),feats(2)), Orig((ind_Len(i-1)+1):ind_Len(i),feats(3)), color(i-1));
    end
    xlabel(names(feats(1)));
    ylabel(names(feats(2)));
    zlabel(names(feats(3)));
    title('Original Scatter');
    hold off
        
        
        