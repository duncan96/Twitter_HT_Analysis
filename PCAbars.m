function plots = PCAbars(V)
    Vsquare = (V.^2) .* signMatrix(V);
    plots = figure;
    x = ceil(length(V)/2);
    for i = 1:length(V)
        if mod(length(V), 2) == 0
            subplot(x,x,i);
        else
            subplot(x,x,(i*2-1));
        end
        bar(V(:,i), 0.5);
        grid;
        ymin = min(Vsquare(:,i)) + (min(Vsquare(:,i))/10); 
        ymax = max(Vsquare(:,i)) + (max(Vsquare(:,i))/10); 
        axis([0, length(V) + 1, ymin, ymax]);
        xlabel('Feature index'); 
        ylabel('Importance of feature'); 
        [chart_title, ~] = sprintf('Loading Vector %d',i); 
        title(chart_title);
    end
    


