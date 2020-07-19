function [translation, rotation] = getStereoPose(stereoParameters)
%DEPRECATED!
%GETSTEREOPOSE Relative translation and rotation, expressed in the in the
% in the coordinate frame of the first camera: C1_r_C1C2, R_C1C2.
% inputs:
%   stereoParameters    Stereo parameters.
% outputs:
%   translation         Translation from camera 1 to 2 as C1_r_C1C2.
%   rotation            Rotation from camera 1 to 2 as R_C1C2
    
    %% Relative pose between stereo cameras
    translation = -stereoParameters.RotationOfCamera2' * stereoParameters.TranslationOfCamera2';
    rotation = cv.Rodrigues(stereoParameters.RotationOfCamera2);
end

