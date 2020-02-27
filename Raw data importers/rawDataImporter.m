%%                           RAW DATA IMPORTER
% written by Patrick Strassmann, November 2014
% Imports behavioral data produced by Med-Associates operant boxes

%
% Various options you can change: first, change the 'username' that
% identifies you for the programs you use on the box. You can choose to
% 'autosave' files, meaning that relevant .mat files from the raw data are
% automatically named and saved. You can change what information and what
% order various parameters are included in the defaultFileName. If
% autoSaveNameAndLocation is turned on, you can either opt to be prompted for where to
% save all the files, or you can choose not to be prompted but instead have all files
% saved in the defaultSaveLocation (which you can also change, but defaults to
% to the current working directory). If autoSaveNameAndLocation is turned off, you can
% decide how files are named and saved manually. You can opt to manually
% name and choose the save location of each file, or you can choose to just
% name the files (with the defaultSaveLocation as the save location) or you can choose to
% just specify the location of each file (files will be saved with the defaultFileName).
% You can turn features 'on' and 'off' by using 1's and 0's below. Also,
% you can change the default name of the data matrix saved in each .mat
% file.
%
clear
%% -------      SETTINGS          ----------
%*********                        ************
%*********************************************
%-------     CHANGE USERNAME:     ---------
userName = 'Patrick';                                       % change to whatever you use to identify your MPC programs running on the box. For example, 'Patrick dualLever FI15-FI40...'
%----    TURN AUTOSAVE ON OR OFF  ----------

autoSaveNameAndLocation = 1;                                % even if 0, autoSave will occur if no manual saving option is turned on.
promptToChooseBatchSaveLocation = 1;                        %if 1, the user will be prompted to choose directory to save all files to. If zero, defaults to defaultSaveLocation below
defaultSaveLocation = [];                                   %default save location for when autoSaveNameAndLocation is turned on and prompt is turned off. Leave empty ([]) to save in current working directory

%---- IF AUTOSAVE OFF, CHOOSE MANUAL OPTIONS

manuallyChooseEachFileNameAndLocation = 0;                  % if 1, the file will be named and saved to the location as specified duruing the saving process.
manuallyChooseFileNameOnly = 0;                             % if 1, file will be saved to the defaultSaveLocation (above), even if another directory is navigated to during the saving process. However, the inputted name will be used.
manuallyChooseFileLocationOnly = 0;                         % if 1, the file will be given the defaultName no matter what the file is named as in the saving process. However, the file will be saved to the location navigated to.

%-----   CHANGE DEFAULT FILE NAME:                          You can do this near the bottom of the code. See marker in left margin for location.

%-----   CHANGE DEFAULT NAME OF DATA MATRIX SAVED IN .MAT FILES
defaultDataMatrixName = 'a';                                %name of the data matrix saved in each .mat file

%Selectively import certain sessions, based on program name. Enter the
%substring programNameSubstring that all imported session programNames must
%contain.
restrictDataFilesToImport = 0;
programNameSubstring = '';

currWorkingDir = pwd;
numFilesSaved = 0;
try cd('/Volumes/PSUSB/')
end
%-----------------------------------------
%**********************************************************
%**********************************************************

%% MAIN PROGRAM


[FileName,PathName,FilterIndex] = uigetfile('*.*','Select raw data file(s) to import','MultiSelect','on');
cd(currWorkingDir);
if FilterIndex == 0
    display('*****************   Canceled, no data files selected   *****************');
    return;
end
try cd('/home/patrick_s/Dropbox/Jin Lab/Imported Data/Single Lever Ai32 Opto 4')
end
currSaveLocation = defaultSaveLocation;
if promptToChooseBatchSaveLocation ==1  && autoSaveNameAndLocation == 1
    [currFileName, currPathName, currFilterIndex] = uiputfile('*.mat',['Where do you want to batch save all files? (File name doesnt matter)'], 'Filename doesnt matter');
    tic
    if currFilterIndex == 0
    display('*****************   Canceled, no save location selected   *****************');
        return;
    end
    currSaveLocation = currPathName;
end

if isa(FileName,'char')
    FileName = {FileName};
end

for particularFileInd=1:length(FileName)
    
    particularFileName = [PathName FileName{particularFileInd}];
    fid = fopen(particularFileName,'r');
    display(' ')
    display(['Reading ' particularFileName])
    display(' ')
    separatedData = textscan(fid,'%s'); %separates datafile into a single column matrix, with each space-separated element of the data file as a new row
    fclose(fid);
    dataCharMatrix = strvcat(separatedData{1}); %verticle concatination of data
    nameMatchLocations = strmatch(userName,dataCharMatrix); %single column matrix of indices of all instances of userName
    if isempty(nameMatchLocations) %checking to see if userName is found in datafile
        display(['The specified username "' userName '" was not found in the data file, sorry! If "' userName '" is not your username, change the userName variable under the settings section of this file.'])
        input('Press ENTER to continue');
        continue
    end
    
    %Getting list of indices for header information, not username specific
    allSubjInds = strmatch('Subject:',dataCharMatrix,'exact');
    allDateInds = strmatch('Date:',dataCharMatrix,'exact');
    allGroupInds = strmatch('Group:',dataCharMatrix,'exact');
    allExperimentInds = strmatch('Experiment:',dataCharMatrix,'exact');
    allBoxInds = strmatch('Box:',dataCharMatrix,'exact');
    allTimeInds = strmatch('Time:',dataCharMatrix,'exact');
    allMSNInds = strmatch('MSN:',dataCharMatrix,'exact');
    allAInds = strmatch('A:',dataCharMatrix,'exact');
    allVInds = strmatch('V:',dataCharMatrix,'exact');
    allWInds = strmatch('W:',dataCharMatrix,'exact');
    all0ColonInds = strmatch('C:',dataCharMatrix,'exact'); %Looks for C:. Used to look for 0:. Data matrix must now be in matrix C (in MED-PC, DIM C= 50000...)
    %*********************************************************
    
    %Main loop that pulls data and header information for each run of each box,
    %based on instances of the specified userName. This loop ends with the
    %saving of a .MAT file for the particular run.

    for i=1:length(nameMatchLocations)
        
        %finds Start Date and transforms it into yyyymmdd format
        particularDateInd = max((allDateInds<nameMatchLocations(i)).*allDateInds); %finds index of "Date:" closest to the index of this instance of the userName location
        startDateRegFormat = dataCharMatrix(particularDateInd-2,:);
        startDate = strtrim(['20' startDateRegFormat(7:8) startDateRegFormat(1:2) startDateRegFormat(4:5)]);
        
        %finds Start time info and transforms it by removing colons.
        particularTimeInd = max((allTimeInds<nameMatchLocations(i)).*allTimeInds);
        startTimeRegFormat = dataCharMatrix(particularTimeInd-2,:);
        endTimeRegFormat = dataCharMatrix(particularTimeInd+1,:);
        
        colonInds_startTime = strmatch(':',startTimeRegFormat')';
        firstColon_startTime = colonInds_startTime(1);
        secondColon_startTime = colonInds_startTime(2);
        startTime = strtrim([startTimeRegFormat(1:firstColon_startTime-1) startTimeRegFormat(firstColon_startTime+1:secondColon_startTime-1) startTimeRegFormat(secondColon_startTime+1:length(startTimeRegFormat))]);
        
        colonInds_endTime = strmatch(':',endTimeRegFormat')';
        firstColon_endTime = colonInds_endTime(1);
        secondColon_endTime = colonInds_endTime(2);
        endTime = strtrim([endTimeRegFormat(1:firstColon_endTime-1) endTimeRegFormat(firstColon_endTime+1:secondColon_endTime-1) endTimeRegFormat(secondColon_endTime+1:length(endTimeRegFormat))]);
        
        
        
        %finds Group label. Will not work as of yet if group label contains spaces
        particularGroupInd = max((allGroupInds<nameMatchLocations(i)).*allGroupInds); %finds the index of "Group:" that is closest to the index of this instance of the userName location
        groupName = strtrim(dataCharMatrix(particularGroupInd+1,:)); %gets name using index, trims trailing whitespace
        
        %finds Box num.
        particularBoxInd = max((allBoxInds<nameMatchLocations(i)).*allBoxInds); %finds the index of "Box:" that is closest to the index of this instance of the userName location
        boxNumber = strtrim(dataCharMatrix(particularBoxInd+1,:)); %gets name using index, trims trailing whitespace
        
        %finds Subj Number. Will not work as of yet if subject contains spaces
        particularSubjInd = max((allSubjInds<nameMatchLocations(i)).*allSubjInds); %finds the index of "Subject:" that is closest to the index of this instance of the userName
        subjectNumber = strtrim(dataCharMatrix(particularSubjInd+1,:)); %gets name using index, trims trailing whitespace
        
        %Finds number of indices between "Group:" and "Experiment:", as this
        %will tell you the number of rows/words in the experiment name. It then
        %loops through these rows and concatenates them to experimentName.
        particularExperimentInd = max((allExperimentInds<nameMatchLocations(i)).*allExperimentInds); %finds the index of "Group:" that is closest to the index of this instance of the userName location
        experimentName = [];
        if particularGroupInd-particularExperimentInd>1
            for indIteration=1:particularGroupInd-particularExperimentInd-1
                experimentName = [experimentName ' ' strtrim(dataCharMatrix(particularExperimentInd+indIteration,:))];
            end
            experimentName = strtrim(experimentName);
        end
        
        %Finds the index of "A:", which comes right after the end of the
        %program name (labeled "MSN:" in data file). Each row between
        %"MSN:" and "A:" in dataFile, is concatenated to programName.
        relevantAInds = ((allAInds>nameMatchLocations(i)).*allAInds);
        relevantAInds(~relevantAInds)=NaN; %converts 0's to NaNs, so min can be computed
        IndOfA_AtEndOfprogramName = min(relevantAInds);
        programName = [userName]; %userName assumed to be start of programName
        for programLblIteration=1:IndOfA_AtEndOfprogramName-nameMatchLocations(i)-1
            programName = [programName strtrim(dataCharMatrix(nameMatchLocations(i)+programLblIteration,:))];
        end
        
        %Finds V_0_value of V array. In my (patrick) programs, V(0) is
        %equal to the  num of consec presses needed to mark a start of a
        %pressing bout.
        relevantVInds = (allVInds>nameMatchLocations(i)).*allVInds;
        relevantVInds(~relevantVInds)=NaN;
        closestVInd = min(relevantVInds);
        V_0_value = str2double(strtrim(dataCharMatrix(closestVInd+2,:))); %gets name using index, trims trailing whitespace

        %Finds W_0_Value of W array. In my (patrick) programs, W(0) is
        %equal to the minimum IPI necessary to register a press when
        %BoutFinding.
        relevantWInds = (allWInds>nameMatchLocations(i)).*allWInds;
        relevantWInds(~relevantWInds)=NaN;
        closestWInd = min(relevantWInds);
        W_0_value = str2double(strtrim(dataCharMatrix(closestWInd+2,:))); %gets name using index, trims trailing whitespace

        
        %*&*&*   Allows user to restrict which data files to import based on programName
        if restrictDataFilesToImport == 1 && isempty(strfind(programName,programNameSubstring)) == 1
            display(['Skipping ' programName]);
            continue
        end
        
        %Finds index of "0:" which is used to find start of dataMatrix 1 row after
        relevant0ColonInds = ((all0ColonInds>nameMatchLocations(i)).*all0ColonInds);
        relevant0ColonInds(~relevant0ColonInds)=NaN; %converts 0's to NaNs, so min can be computed
        dataStartInd = min(relevant0ColonInds)+2;
        
        %If row (word in data file) prior to start of data matrix is not "0:", throws error
        if strcmp(dataCharMatrix(dataStartInd-1,:),'0:');
            error('Error identifying start of data structure')
        end
        
        %Finds first row of dataFile and begins dataMatrix variable with it
        firstRowOfData = dataCharMatrix(dataStartInd:dataStartInd+4,:);
        firstRowOfDataConverted = str2num(firstRowOfData)';
        dataMatrix = firstRowOfDataConverted;
        rowLoopIteration = 0;
        
        %This loop adds each subsequent line of dataFile to the developing
        %dataMatrix variable. If the loop encounters a block of five rows that
        %are not all numbers (usually all 5 are numbers in data file), that
        %last block of 5 is examined to see where the numbers end. Zeros are
        %filled in for remaining spots in the block of 5.
        currentIndex = dataStartInd;
        while 1==1 %infinite loop until break
            %rowLoopIteration = rowLoopIteration + 1;
            
            currentIndex = currentIndex+6;
            if currentIndex>length(dataCharMatrix)
                break
            elseif isempty(str2num(dataCharMatrix(currentIndex,:)))==1
                break
            elseif currentIndex+4<=length(dataCharMatrix)
                singleRowOfData = dataCharMatrix(currentIndex:currentIndex+4,:);
                %above, each run through the loop will skip 6 rows in the huge, single column transformed data file to arrive at next line of 5 data points
                singleRowOfDataConverted = str2num(singleRowOfData)'; %converted from char array to numerical matrix, also from verticle column to horizontal row
                if ~isempty(singleRowOfDataConverted) %this length will be 0 if not all elements of this line of data are numerical
                    dataMatrix = vertcat(dataMatrix,singleRowOfDataConverted);
                else %if not all elements are numerical, finds index of the last real data point. Adds real data points, others become zeros.
                    indOfLastNum = 0;
                    for index=1:5
                        if ~isempty(str2num(singleRowOfData(index,:)))
                            continue
                        else indOfLastNum = index-1;
                            break
                        end
                    end
                    if indOfLastNum ~=0
                        lastRow = [0 0 0 0 0];
                        for q=1:indOfLastNum
                            lastRow(q) = str2num(singleRowOfData(q,:));
                        end
                        dataMatrix = vertcat(dataMatrix, lastRow); %concatenates last row of data to developing dataMatrix variable
                    end
                    break %break from while loop
                end
            elseif currentIndex>length(dataCharMatrix)
                break
            else
                restOfData = dataCharMatrix(currentIndex:end,:);
                indOfLastNum = 0;
                possIndOfLastNum = size(restOfData,1);
                if ~isempty(str2double(restOfData(possIndOfLastNum,:)))
                    indOfLastNum = possIndOfLastNum;
                else
                    error('check raw data importer');
                end
%                 for index=1:length(restOfData)
%                     if ~isempty(str2num(restOfData(index,:)))
%                         continue
%                     else
%                         indOfLastNum = index-1;
%                         break
%                     end
%                 end
                if indOfLastNum ~=0
                    lastRow = [0 0 0 0 0];
                    for q=1:indOfLastNum
                        lastRow(q) = str2num(restOfData(q,:));
                    end
                    dataMatrix = vertcat(dataMatrix, lastRow);
                    
                    %                     diff = length(dataCharMatrix) - currentIndex;
                    %                     lastRow = [0 0 0 0 0];
                    %                     for each=0:diff
                    %                         lastRow(each+1)=str2num(dataCharMatrix(currentIndex+each,:));
                    %                     end
                    %                     dataMatrix = vertcat(dataMatrix, lastRow);
                end
            end
            
        end
        
        %% CAN CHANGE DEFAULT FILENAME HERE
        %********************************************************************************************
        %******************    You can change the default filename here       ***********************
        %----------------------------------------------------------------------------------
        % OPTIONS: startDate, startTime, endTime programName, experimentName, subjectNumber, boxNumber
        defaultFileName = ['Date_' startDate '_' startTime  '_Box' boxNumber '_Program_' programName  '_Subj' subjectNumber];
        % **********************************************************************************
        
        
        %% REST OF PROGRAM
        fileNameToSave = defaultFileName;
        if manuallyChooseEachFileNameAndLocation == 1
            clearvars currFileName currPathName currFilterIndex
            [currFileName, currPathName, currFilterIndex] = uiputfile('*.mat',['Save Name and Location of ' fileNameToSave ' ?'], 'Insert File Name');
            if currFilterIndex == 0
                continue
            end
            fileNameToSave = currFileName;
            currSaveLocation = currPathName;
            
        elseif manuallyChooseFileLocationOnly == 1
            
            clearvars currFileName currPathName currFilterIndex
            [currFileName, currPathName, currFilterIndex] = uiputfile('*.mat',['Where do you want to save ' fileNameToSave ' ? (File name does not matter)'],'File will save with default file name');
            if currFilterIndex == 0
                continue
            end
            currSaveLocation = currPathName;
            
            
        elseif manuallyChooseFileNameOnly == 1
            clearvars currFileName currPathName currFilterIndex
            %display(['What you wanna call ' fileNameToSave ' ?'])
            [currFileName, currPathName, currFilterIndex] = uiputfile('*.mat',['What do you want to call ' fileNameToSave ' ? (File location does not matter)','Insert File Name']);
            if currFilterIndex == 0
                continue
            end
            fileNameToSave = currFileName;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Gets rid of any timestamps that occur at 0 seconds %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [rows columns] = size(dataMatrix);
        reshapedData = reshape(dataMatrix', 1, rows*columns);
        reshapedData = reshapedData(find(reshapedData>1,1,'first'):end); %get rid of weird simultaneous headentrys
        if rem(numel(reshapedData),5)~=0
            numZerosToAdd = 5 - rem(numel(reshapedData),5);
            reshapedData = [reshapedData zeros(1,numZerosToAdd)];
        end
        dataMatrix = reshape(reshapedData,5,numel(reshapedData)/5)';
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        fileNameToSave = [currSaveLocation fileNameToSave];
        assignin('base', defaultDataMatrixName, dataMatrix);
        save(fileNameToSave,defaultDataMatrixName, 'subjectNumber', 'boxNumber', 'programName', 'startDate', 'startTime', 'endTime', 'experimentName', 'V_0_value','W_0_value')
        display(['Saved ' fileNameToSave]);  numFilesSaved = numFilesSaved+1;
    end
    
    
end
% clearvars -except fileNameToSave fileName userName startDate groupName boxNumber subjectNumber experimentName programName dataMatrix
if numFilesSaved>1
display(['Imported ' num2str(numFilesSaved) ' files in ' num2str(toc) ' seconds'])
else
display(['Imported ' num2str(numFilesSaved) ' file in ' num2str(toc) ' seconds'])
end

