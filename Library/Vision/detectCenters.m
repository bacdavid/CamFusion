function [centers, misc] = detectCenters(frame, objectDict, nInstances, minDistance, cameraFile, surfThreshold)
%DEPRECATED!
%DETECTCENTER Detect objects in frames. Misc contains a bunch of stuff
%which could be used for visualization (not implemented).
% inputs:
%   frame               Frame from camera 1.
%   objectDict          Object dictionary.
%   nInstances          Array which the number of instances to expect per
%                       object defined in the dictionary.
%   minDistance         Minimum distance that two objects have to have in
%                       the same frame in pixels. 
%   cameraParameters    Camera parameters of the recording camera.
%   surfThreshold       Feature quality threshold.
%   nOctaves            Number of octaves to scan.
%   ambigRatio          Ambiguous match ration. The higher the more 'unique'
%                       the matches. 
% ouputs:
%   centers             Centers.
%   (misc)              Image ID per center and an object ID (both from the
%                       dictionary. Also contains undistorted grayscale
%                       frame.
    
    %% Detect centers in frame
    [features, points, frame] = detectFeatures(frame, cameraFile, surfThreshold);
    [matchIdx, matchIds, validIds] = matchDictionary(features, objectDict);
    
    centers = [];
    imageIds = [];
    objectIds = [];
    for i = 1 : numel(validIds)
       
        imageId = validIds(i);
        [validPoints, refPoints] = associatePoints(points, imageId, matchIdx, matchIds, objectDict);
        validMatches = false(size(validPoints, 1), 1);
        objectId = objectDict.ObjectId{imageId}(1);
        for j = 1 : nInstances(objectId)
        
            try
                [tform, validMatches] = estimateTransform(validPoints(~validMatches), refPoints(~validMatches));
                center = projectCenter(imageId, tform, objectDict);
                
                if ~isempty(centers)
                    if min(vecnorm(centers - center, 2, 2)) < minDistance; continue; end % Avoid that twice the same object is detected
                end
                
                centers = [centers; center]; imageIds = [imageIds; imageId]; objectIds = [objectIds; objectId];
                
                nInstances(objectId) = nInstances(objectId) - 1; 
            catch
                continue;
            end
            
        end
       
    end
    if nargout > 2
        misc.imageIds = imageIds;
        misc.objectIds = objectIds;
        misc.frame = frame;
    end
end