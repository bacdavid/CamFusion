function results = printMarkers(app)
%PRINTMARKERS Main function to print markers.
% inputs:
%   app                 Application instance, can be replaced with a struct as
%                       longs as it contains the setup params.
% outputs:
%   results             Returns a "1" once done. The frames themselfes are directly
%                       written to a folder.
    %% Setup
    outputFolder = app.userConfig.outputFolder;
    nMarkers = app.userConfig.nMarkers;
    markerSize = app.userConfig.markerSize;

    %% Print 
    % A4 standard
    markerSize = markerSize * 100;
    l = (21 - markerSize) / 2;
    b = (29.7 - markerSize) / 2;
    dict = {'Predefined', 'ArucoOriginal'};
    for i = 1 : nMarkers
        img = cv.drawMarkerAruco(dict, i, 200); % 200 px sidelength
        f = figure('visible', 'off');
        imshow(img, 'Border', 'tight', 'InitialMagnification', 'fit');
        f.PaperType = 'a4';
        f.PaperUnits = 'centimeters';
        f.PaperPosition = [l b markerSize markerSize];
        outName = sprintf('%s/%09d.pdf', outputFolder, i);
        print(f, outName, '-dpdf', '-r0');
        close(f);
    end
    
    %% Results
    results = 1;
    
end