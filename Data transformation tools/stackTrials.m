%Written by Patrick Strassmann

function [eventMatrixStack, eventTimesStack] = stackTrials(eventValueMatrix, trialStartTimes, trialEndTimes, eventValueMatrixInd, trialTimeLimit)

eventMatrixStack = zeros(length(trialStartTimes),trialTimeLimit);
eventTimesStack = zeros(length(trialStartTimes), 10000);

if numel(trialStartTimes)>numel(trialEndTimes)
    trialStartTimes = trialStartTimes(1:numel(trialEndTimes));
    display('In stackTrials, tossed one or more trials because numel(trialStartTimes)>numel(trialEndTimes)');
end
for i=1:length(trialStartTimes)
    if i>length(trialStartTimes)
        continue
    end
    if(trialEndTimes(i)+1-trialStartTimes(i)>trialTimeLimit)
        if trialEndTimes(i)+1-trialStartTimes(i+1) == trialTimeLimit
            trialStartTimes(i)=[];
            eventMatrixStack(i,:)=[];
            eventTimesStack(i,:)=[];
        else
            if trialTimeLimit == 15001
                error('Unintended trial loss has occured')
            end
            continue
        end
    end
    oneTrialEventMatrix = eventValueMatrix(eventValueMatrixInd,trialStartTimes(i):trialEndTimes(i));
    oneTrialEventTimes = find(oneTrialEventMatrix==1)-1; %% -1 is here to correct for 10ms shift caused by find()

    if isempty(oneTrialEventTimes)==0
        oneTrialIPIs = diff(oneTrialEventTimes);
        oneTrialIPIsWithEndZero = diff(horzcat(oneTrialEventTimes, trialTimeLimit));
    end
    oneTrialEventMatrix_padded = horzcat(oneTrialEventMatrix,zeros(1,trialTimeLimit-numel(oneTrialEventMatrix)));
    eventMatrixStack(i,:) = oneTrialEventMatrix_padded;
    
    oneTrialEventTimes_padded = horzcat(oneTrialEventTimes,zeros(1,10000-numel(oneTrialEventTimes)));
    eventTimesStack(i,:) = oneTrialEventTimes_padded;
end

eventTimesStack = trimStack(eventTimesStack);

end
