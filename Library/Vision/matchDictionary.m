function [matchIdx, matchIds, validIds] = matchDictionary(features, objectDict, ambigRatio)
%MATCHDICTIONARY Matches a set of features to the features in the object
%dictionary. Returns the match-indices (2 indices per match),the
%corresponding match-Ids (image Id in the dict), and the valid Ids arranged
%in order of occurance (most first). In other word you end up with point -
%point matches from a current frame to an Image in the dictionary.
% inputs:
%   features            Batch of features.
%   objectDict          Object dictionary.
%   ambigRation         Ambiguous match ration. The higher the more 'unique'
%                       the matches. 
% ouputs:
%   matchIdx            Index pairs for the matches.
%   matchIds            Single image ID per match.
%   validIds            Unique IDs in matchIds ordered by occurance.

    %% Match features to dictionary.
    dictFeatures = vertcat(objectDict.Features{:});
    matchIdx = matchFeatures(features, dictFeatures, 'Unique', false, 'MaxRatio', ambigRatio);
  
    dictIds = cat(1, objectDict.ImageId{:});
    matchIds = dictIds(matchIdx(:, 2));
    uniqueIds = unique(matchIds);
    count = hist(matchIds, [-1; uniqueIds]); % Trick to avoid faulty hist function
    count = count(2:end);
    validIds = uniqueIds(count > 4); % Adjust for more robust matches  
end