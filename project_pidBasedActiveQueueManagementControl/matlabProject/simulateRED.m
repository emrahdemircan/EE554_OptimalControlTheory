function [finalT,finalX,integralAbsoluteError] = simulateRED(t0,tf,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows)
    % do the AQM simulation
    [finalT,finalX,integralAbsoluteError] = aqm_sim(t0,tf,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows,2,0,0,0);
end %function [finalT,finalX,integralAbsoluteError] = simulateRED(t0,tf,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows)