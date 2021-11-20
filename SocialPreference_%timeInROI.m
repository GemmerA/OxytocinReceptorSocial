clear;
% Select Maximum Projection
[file, path] = uigetfile({'*.avi';'*.*'},...
    'Select Maximum Projection');
video=VideoReader([path,file]);
mPro = readFrame(video);
if size(mPro,3) > 1
    mPro = mean(mPro,3);
end

%Load CSV File
[fileCSV, pathCSV] = uigetfile({'*.csv';'*.*'},...
    'Select CSV File');
csvData = importZT([pathCSV,fileCSV]);

%% Draw ROIs
%draw rois
h = matVis(mPro);

%wait for matvis to be closed
while isvalid(h.figHandles.gui)
    pause(1);
end
%get Number of fishes (assumes two rois per fish)
numFish = size(matVisRoiExport,2)/2;
numTimePoints = size(csvData,1);
%% Get Statistics
for fish = 1:numFish
    counter1 = 0;
    counter2 = 0;
    for t=1:numTimePoints
        x1 = round(csvData(t,3*(fish-1)+1));
        if x1<=0
            x1=1;
        end
        
        y1 = round(csvData(t,3*(fish-1)+2));
        if y1<=0 
            y1=1; 
        end
        
        counter1 = counter1 + matVisRoiExport(2*(fish-1)+1).mask(y1,x1);
        
        x2 = round(csvData(t, 3*(fish-1)+1));
         if x2<=0 
            x2=1; 
         end
        
        y2 = round(csvData(t, 3*(fish-1)+2));
        if y2<=0 
            y2=1; 
        end
        
        counter2 = counter2 + matVisRoiExport(2*(fish-1)+2).mask(y2,x2);
    end
    %generate output:
    per(fish, 1) = counter1/numTimePoints;
    per(fish, 2) = counter2/numTimePoints;
    per(fish, 3) = (counter1-counter2)/numTimePoints;
    per(fish, 4) = (counter2-counter1)/numTimePoints;
end
save([pathCSV,fileCSV(1:end-4),'_matlabBackup.mat'], 'matVisRoiExport','per')