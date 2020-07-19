function [centers1, centers2, misc] = detectCentersStereo(frame1, frame2, objectDict, nInstances, minDistance, cameraParameters1, cameraParameters2)
%DEPRECATED!
%DETECTCENTERSSTEREO Detect objects in stereo frames. Centers1 and
%centers2 are matched. Misc contains a bunch of stuff which could be used
%for visualization (not implemented).
% inputs:
%   frame1              Frame from camera 1.
%   frame2              Frame from camera 2.
%   rois1               Cell of ROIs for camera 1.
%   rois2               Cell of ROIs for camera 2.
%   objectDict          Object dictionary.
%   nInstances          Array which the number of instances to expect per
%                       object defined in the dictionary.
%   minDistance         Minimum distance that two objects have to have in
%                       the same frame in pixels. 
%   cameraParameters1   Camera parameters of the recording camera 1.
%   cameraParameters2   Camera parameters of the recording camera 2.
%   surfThreshold       Feature quality threshold.
%   nOctaves            Number of octaves to scan.
%   ambigRatio          Ambiguous match ration. The higher the more 'unique'
%                       the matches. 
% ouputs:
%   centers1            Centers 1.
%   centers2            Centers 2, matched to centers 1.
%   (misc)              Image ID per center and an object ID (both from the
%                       dictionary. Also contains undistorted grayscale
%                       frames.

    %% Detect centers in stereo images
    % features and matching
    [features1, points1, frame1] = detectFeatures(frame1, cameraParameters1);
    [features2, points2, frame2] = detectFeatures(frame2, cameraParameters2);
    [matchIdx1, matchIds1, validIds1] = matchDictionary(features1, objectDict);
    [matchIdx2, matchIds2, validIds2] = matchDictionary(features2, objectDict);
    validIds = intersect(validIds1, validIds2, 'stable');
    
    
    centers1 = []; centers2 = []; imageIds = []; objectIds = [];
    for i = 1 : numel(validIds)
        
        % Associate with dict points
        imageId = validIds(i);
        [validPoints1, refPoints1] = associatePoints(points1, imageId, matchIdx1, matchIds1, objectDict);
        [validPoints2, refPoints2] = associatePoints(points2, imageId, matchIdx2, matchIds2, objectDict);
        
        validMatches1 = false(size(validPoints1, 1), 1);
        validMatches2 = false(size(validPoints2, 1), 1);
        objectId = objectDict.ObjectId{imageId}(1);
        for j = 1 : nInstances(objectId)
        
            try % Transform finding can fail
                
                % Find transform and project forward
                [tform1, validMatches1] = estimateTransform(validPoints1(~validMatches1), refPoints1(~validMatches1));
                [tform2, validMatches2] = estimateTransform(validPoints2(~validMatches2), refPoints2(~validMatches2));
                center1 = projectCenter(imageId, tform1, objectDict);
                center2 = projectCenter(imageId, tform2, objectDict);
                
                % Form of "non-max-suppression"
                if ~isempty(centers1)
                    if min(vecnorm(centers1 - center1, 2, 2)) < minDistance; continue; end
                end
                
                if ~isempty(centers2)
                    if min(vecnorm(centers2 - center2, 2, 2)) < minDistance; continue; end
                end
                
                centers1 = [centers1; center1]; centers2 = [centers2; center2]; imageIds = [imageIds; imageId]; objectIds = [objectIds; objectId];
                
                nInstances(objectId) = nInstances(objectId) - 1; 
            catch
                continue;
            end
            
        end
       
    end
    
    [centers1, centers2] = matchStereoPairs(centers1, centers2);
    
    if nargout > 2
        misc.imageIds = imageIds;
        misc.objectIds = objectIds;
        misc.frame1 = frame1;
        misc.frame2 = frame2;
    end
end