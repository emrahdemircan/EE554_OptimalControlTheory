function p = pid(KP, KI, KD, desiredQueueLength, maxQueueLength, outputT, outputX)
    % evaluate the errors
    err = 0.0;
    intErr = 0.0;
    diffErr = 0.0;
    [~, col] = size(outputT);
    if(col > 1)
        % update instantaneous error
        err = abs(desiredQueueLength-outputX(1,end)); % set instantenous error at time now
        % update integral error
        backLimit = col;
        % integral error is limited to last 50 elements!
        if col > 50
            backLimit = 50;
        end
        for dummyT = (col-backLimit+2):col;
            intErr = intErr + (outputX(1,dummyT)+outputX(1,dummyT-1))*(outputT(dummyT)-outputT(dummyT-1))/2; 
        end
        % update differential error
        diffErr = (outputX(1,col)-outputX(1,col-1))/(outputT(col)-outputT(col-1));
    end
    % here comes the output
    u = KP*err + KI*intErr + KD*diffErr;
    if u >= 1
        p = 1;
    elseif u < 0
        p = 0;
    else
        p = u;
    end;
end % function p = pid(KP, KI, KD, desiredQueueLength, maxQueueLength, outputT, outputX)