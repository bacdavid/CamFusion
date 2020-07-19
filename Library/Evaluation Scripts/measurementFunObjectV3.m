function h= measurementFunObjectV3(ypCamera, ypObject)
%MEASUREMENTFUNOBJECT Measurement function for a point object being measuremed
%from a single camera in 3D coordinates. The ids correspond to the entires 
%in the state vector.
% inputs:
%   ypCamera: 6 x 1 array 
%   ypObject: 6 x 1 array or m x (6 x 1) cell
%   idCamera: int
%   idObject: int or m x 1 array
%   idNoise: int or m x 1 array
%   kalmanFile: struct
% outputs:
%   h: 3 x 1 array or m x (3 x 1) cell
%   H: 3 x 6 array or m x (3 x n) cell
%   M: 3 x 3 array or m x (3 x j) cell
 
    if iscell(ypObject)
        
        h = cell(numel(ypObject), 1);
        for i = 1 : numel(ypObject)
            h{i} = ...
                measurementFunObjectV3(ypCamera, ypObject{i});
        end

    else
        
        % measurement
        I_r_IC = ypCamera(1:3);
        I_r_IO = ypObject(1:3);
        [R_CI, ~] = cv.Rodrigues(-ypCamera(4:6));
        h = R_CI * (I_r_IO - I_r_IC);

    end
            
end

