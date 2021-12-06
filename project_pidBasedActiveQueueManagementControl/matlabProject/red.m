function drop = red(a,desiredQueueLength,maxQueueLength)
    % initialize control points
    max=desiredQueueLength+20;
    min=desiredQueueLength;
    pmax=0.1;
    if (a >= 0.0) && (a < min)
        drop = 0.0;
    elseif (a >= min) && (a <= max)
        drop = ((a - min)/(max-min))*pmax;
    else
        drop = 1.0;
    end
end % function drop = red(a,desiredQueueLength,maxQueueLength)

