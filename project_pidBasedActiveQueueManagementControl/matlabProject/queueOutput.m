function status = queueOutput(t,x,flag)
    global outputT outputX
    persistent backLimit
    backLimit = 55;
    if nargin < 3 || isempty(flag)
        %save output of this iteration for future use
        outputT = [outputT t];
        outputX = [outputX x];
        [~,col] = size(outputT);
        if col > backLimit
            outputT = outputT(:,end-backLimit:end);
            outputX = outputX(:,end-backLimit:end);
        end
    else
        switch(flag)
        case 'init'
        %fprintf('start\n');
        outputT = t(1);
        outputX = x;
        case 'done'
        %fprintf('done\n');
        end
    end
    status = 0;
end %function status = queueOutput(t,x,flag)