function [finalT,finalX,integralAbsoluteError] = aqm_sim(t0,tf,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows,aqmMethod,KP,KI,KD)   
    % define the initial conditions for the DE
    global outputT outputX
    % start with numberOfFlows flows
    offset=2;
    X0 = zeros(offset + numberOfFlows,1);
    X0(1) = 0.0;    % set average queue length = 0 at time t=0
    X0(2) = 0.0;    % set instantenous queue length = 0.0 at time t=0
    outputX = X0;
    outputT = t0;
    % set current flows to startup
    for i=1:numberOfFlows
       X0(i+offset) = 1.0;
    end
    % solve the DE using ode23 over some time interval
    options = odeset('OutputFcn',@queueOutput);
    %fprintf('ode23\n');
    [T,X] = ode23(@(t,x) queue(t,x,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows,aqmMethod,KP,KI,KD),[t0 tf],X0,options);
    % evaluate the outputs
    % time array
    finalT = T;
    % simulation results array
    finalX = X;
    % simulation will return an error, calculate it
    integralAbsoluteError = 0.0;
    % get the dimension of T
    [row1,~] = size(T);
    for i=1:row1
        integralAbsoluteError = integralAbsoluteError + abs(desiredQueueLength-X(i,1));
    end
end % function [finalT,finalX,integralAbsoluteError] = aqm_sim(t0,tf,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows,aqmMethod,KP,KI,KD)   
