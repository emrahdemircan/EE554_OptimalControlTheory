function drop = none(a,desiredQueueLength,maxQueueLength)
    % initialize control points
    if a>maxQueueLength
        drop = 1.0;
    else
        drop = 0.0;
    end
end % function drop = none(a,desiredQueueLength,maxQueueLength)