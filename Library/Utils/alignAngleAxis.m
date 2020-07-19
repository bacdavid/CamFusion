function phi1 = alignAngleAxis(phi1, phi2)
%ALIGNANGLEAXIS Align angle axis of phi1 with phi2. Inputs can be m x 3
%matrices, where m corresponds to the batch.
% inputs:
%   phi1            	First angle axis.
%   phi2                Second angle axis.
% outputs:
%   phi1              	Aligned phi1.

%% Align angle axis
    theta1 = vecnorm(phi1, 2, 2);
    theta2 = vecnorm(phi2, 2, 2);
    n1 = phi1 ./ theta1; % If any is NaN the idx is empty anyway
    n2 = phi2 ./ theta2;
    idx = dot(-n1, n2, 2) > dot(n1, n2, 2);
    phi1(idx, :) = -n1(idx, :) .* (2 * pi - theta1(idx, :));
end

