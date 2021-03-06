function xdot = queue(t,x,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows,aqmMethod,KP,KI,KD)
    % define variables
    global outputT outputX
    
    offset = 2;
    %tcp simulation parameters for the differential equations
    % linkCapacity -> initialized from GUI : link capacity in unit of packets per second
    alpha = 0.0001;     % weighting  factor in exponential average
    timeStep = 1.0/linkCapacity;   % time step size
    a = zeros(offset+numberOfFlows,1);
    for i=1:numberOfFlows
        a(i+offset) = 0.08;
    end

    % set up differential equation matrix
    % There are 2 + numberOfFlows number of differential equations.
    % First DE is for Average Queue Length
    % Second DE is for Instantaneous Queue Length
    % The others are for individual flow window sizes

    % offset designates the first 2 DE's
    % clean the difference matris
    xdot = zeros(numberOfFlows+offset,1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % average queue length, using estimation.
    % D.E. for average queue size estimate
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A = log((1.0-alpha))/timeStep;
    B = -1.0*A;
    % update average queue length
    xdot(1) = x(1)*A + x(2)*B;
    % adjustment
    if (x(1)+xdot(1) < 0.0)
        xdot(1) = -1.0*x(1);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DE for instantenous queue length
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    K=0;
    for i=1:numberOfFlows
        K = K + x(offset+i)./(a(offset+i) + x(2)./linkCapacity);
    end
    % update current queue length
    xdot(2) = -1.0*linkCapacity + K;
    % adjustment
    if (x(2)+xdot(2) < 0.0)
        xdot(2) = -1.0*x(2);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DE for individual flows' window sizes
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % take care of offset because the first 2 DE are x and q
    % here comes the differential equation
    for i=1:numberOfFlows
        if aqmMethod == 1 % NONE
        %xdot(i+offset) = 1.0/(a(i+offset)+x(1)./linkCapacity) - none(x(1),desiredQueueLength,maxQueueLength).*x(i+offset).*x(i+offset)./(2.0*(a(i+offset)+x(1)./linkCapacity));
        xdot(i+offset) = 1.0/(a(i+offset)+x(1)./linkCapacity) - none(x(1),desiredQueueLength,maxQueueLength).*x(i+offset).*outputX(i+offset,end)./(2.0*(a(i+offset)+outputX(1,end)./linkCapacity));
        elseif aqmMethod == 2 % RED
        %xdot(i+offset) = 1.0/(a(i+offset)+x(1)./linkCapacity) - red(x(1),desiredQueueLength,maxQueueLength).*x(i+offset).*x(i+offset)./(2.0*(a(i+offset)+x(1)./linkCapacity));
        xdot(i+offset) = 1.0/(a(i+offset)+x(1)./linkCapacity) - red(x(1),desiredQueueLength,maxQueueLength).*x(i+offset).*outputX(i+offset,end)./(2.0*(a(i+offset)+outputX(1,end)./linkCapacity));
        elseif aqmMethod == 3 % PID
        %xdot(i+offset) = 1.0/(a(i+offset)+x(1)./linkCapacity) - pid(KP,KI,KD,desiredQueueLength,maxQueueLength,outputT,outputX).*x(i+offset).*x(i+offset)./(2.0*(a(i+offset)+x(1)./linkCapacity));
        xdot(i+offset) = 1.0/(a(i+offset)+x(1)./linkCapacity) - pid(KP,KI,KD,desiredQueueLength,maxQueueLength,outputT,outputX).*x(i+offset).*outputX(i+offset,end)./(2.0*(a(i+offset)+outputX(1,end)./linkCapacity));
        else
        end
    end
    % adjustment
    for i=1:numberOfFlows
        if (x(i+offset) == 0.0)
            xdot(i+offset) = 0.0;
        elseif (x(i+offset)+xdot(i+offset) < 0.0)
            xdot(i+offset) = -1.0*x(i+offset);
        end
    end
end %function xdot = queue(t,x,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows,aqmMethod,KP,KI,KD)

