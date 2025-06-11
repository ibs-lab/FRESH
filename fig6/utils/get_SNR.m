% Base directory for the FRESH data
baseDir = 'C:\Users\mayucel\Documents\PROJECTS\PROJECTS\2021_FRESH\FRESH DATA\FRESH-Motor\FRESH-Motor';

% Get the list of subject directories
subjects = dir(fullfile(baseDir, 'sub-*'));

% Initialize results storage
results = [];

for iSub = 1:length(subjects)
    subDir = fullfile(baseDir, subjects(iSub).name);
    
    % Recursively find all nirs subfolders
    nirsFolders = dir(fullfile(subDir, '**', 'nirs'));
    for iNirs = 1:length(nirsFolders)
        nirsFolder = fullfile(nirsFolders(iNirs).folder, nirsFolders(iNirs).name);
        
        % Get all SNIRF files in the nirs folder
        snirfFiles = dir(fullfile(nirsFolder, '*.snirf'));
        for iFile = 1:length(snirfFiles)
            snirfPath = fullfile(snirfFiles(iFile).folder, snirfFiles(iFile).name);
            
            % Load the SNIRF file
            obj = SnirfLoad(snirfPath);
            
            % Extract data and calculate SNR
            d = obj.data.dataTimeSeries;
            dmean = mean(d, 1);
            dstd = std(d, [], 1);
            SNR = dmean ./ dstd;
            
            % Store results
            results = [results; struct(...
                'Subject', subjects(iSub).name, ...
                'SNIRF_File', snirfFiles(iFile).name, ...
                'Mean_SNR', mean(SNR), ...
                'Std_SNR', std(SNR))];
        end
    end
end

% Display the results
disp(struct2table(results));

