clc;
clear all;

%% Transform deg to X/Y for trajectory creator

longitude0 = deg2rad(11);
latitude0 = deg2rad(57);
Earth_rad = 6371000.0;  

% Insert values
long =  deg2rad( 11.980413); % in sweden is the small value
lat = deg2rad(57.688862); % long value


X = Earth_rad * (long - longitude0) * cos(latitude0);
Y = Earth_rad * (lat - latitude0);

% To have them together
sol = [X Y];

%% Transform from X/Y to deg to check values
% 
% X = 59415.16046;
% Y = 76517.89921;

Longitude = rad2deg((X/(Earth_rad*cos(latitude0))) + longitude0);
Latitude = rad2deg((Y/Earth_rad) + latitude0);
sol2 = [Latitude Longitude];