function [fig, x, cum] = scree(S, plotTitle)
    a = sum(sum(S^2));
    x = sum(S^2)/a;
    cum = zeros(1,length(x));
    for i = 1:length(x)
        cum(i) = sum(x(1:i));
    end
    fig = figure;
    hold on;
    plot(x);
    plot(cum);
    xlabel('Feature');
    ylabel('Importance');
    title(plotTitle);
    hold off;