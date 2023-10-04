clear all
close all
clc

%% Constants
% Göteborg's longitude and latitude
longitude0 = deg2rad(11);
latitude0 = deg2rad(57);

Earth_radius = 6371000.0;  

%% Section1: Define coordinates of points
% Coordinates of first point
lat1 = 57.782806; % Latitude of the first point in degrees
lon1 = 12.771923; % Longitude of the first point in degrees
% Coordinates of the second point
lat2 = 57.781885; % Latitude of the second point in degrees
lon2 = 12.772653; % Longitude of the second point in degrees

% Convert latitude and longitude to radians
lat1_rad = deg2rad(lat1);
lon1_rad = deg2rad(lon1);
lat2_rad = deg2rad(lat2);
lon2_rad = deg2rad(lon2);

% Point1 in format [x y]
Point1 = [Earth_radius * (lon1_rad - longitude0) * cos(latitude0) Earth_radius * (lat1_rad - latitude0)];
% Point2 in format [x y]
Point2 = [Earth_radius * (lon2_rad - longitude0) * cos(latitude0) Earth_radius * (lat2_rad - latitude0)];

%% Distance between the points
% Calculate the differences in latitude and longitude
dlat = lat2_rad - lat1_rad;
dlon = lon2_rad - lon1_rad;

% Calculate the distance using the haversine formula
a = sin(dlat/2)^2 + cos(lat1_rad) * cos(lat2_rad) * sin(dlon/2)^2;
c = 2 * atan2(sqrt(a), sqrt(1 - a));
distance = Earth_radius * c;
%% Section2: Create a line segment based on the points from google maps
dL=0.2; % distance between points (m), this can be changed at each segment, or kept the same
L1=distance;   %length of linear element (m)
% Define the coordinates of the starting and ending points
x_start = Point1(1,1);
y_start = Point1(1,2);
x_end = Point2(1,1);
y_end = Point2(1,2);

% Calculate the direction vector
dx = x_end - x_start;
dy = y_end - y_start;
distance = sqrt(dx^2 + dy^2); % Calculate the total distance between points

% Calculate the number of steps
num_steps = ceil(distance / dL); % Round up to ensure coverage

% Initialize arrays to store points
x_values = zeros(1, num_steps);
y_values = zeros(1, num_steps);

% Calculate points along the line
for i = 1:num_steps
    t = (i - 1) / (num_steps - 1); % Parametric parameter
    x_values(i) = x_start + t * dx;
    y_values(i) = y_start + t * dy;
end

% The points along the line are given by [x_values', y_values']

% Display the points
XY = [x_values', y_values'];

%% Section3: Linear segment at the end of the trajectory one with a specific angle relative the previous element

L2=5;   %length of second linear element (m)
rot=40;   % angle (in degrees)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rot=rot*2*pi/360; % convert to radians
x=(0:dL:L2)'; %
xy=[x zeros(size(x,1),1)];  % new segment
% end direction of the trajectory
Dx=XY(end,1)-XY(end-1,1);
Dy=XY(end,2)-XY(end-1,2);
if Dx==0, % the trajectory is in y-direction
    if Dy>0,rot=rot+pi/2;
    else rot=rot-pi/2;
    end
elseif Dx<0, % the trajectory is in nexative x-direction
    rot=rot+atan(Dy/Dx)+pi;
else
    rot=rot+atan(Dy/Dx); 
end
xy=xy*[cos(rot) sin(rot); -sin(rot) cos(rot)]; % rotate segment
XY=[XY;xy(2:end,:)+XY(end,:)]; % add new segment at the end, notice that first point of the new segment is removed to avoid two point at the same place

%% Section4: add a circular segment at the end of the trajectory so that the
% transition is smooth

R=20;   % radius of (m)
CS=-45 ;   % angle and direction of circular element (in degrees)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CS=CS*2*pi/360; % convert to radians

deg=CS*(0:(round(R/dL)))'/round(R/dL); % angle steps in the circle segment
xy=R*[cos(deg) sin(deg) ];  % new segment

% end direction of the trajectory
Dx=XY(end,1)-XY(end-1,1);
Dy=XY(end,2)-XY(end-1,2);
if Dx==0, % the trajectory is in y-direction
    if Dy>0,rot=pi/2;
    else rot=-pi/2;
    end
elseif Dx<0, % the trajectory is in nexative x-direction
    rot=atan(Dy/Dx)+pi;
else
    rot=atan(Dy/Dx); 
end

xy(:,1)=  xy(:,1)-R; % move start point of circle segment to the origin
rot=rot+pi/2; % adjust so that rotation is from positive x-direction
xy=xy*[cos(rot) sin(rot); -sin(rot) cos(rot)]; % rotate segment
XY=[XY;xy(2:end,:)+XY(end,:)]; % add new segment at the end, notice that first point of the new segment is removed to avoid two point at the same place


%% Section5: From this step, it is only used in case the direction is not good or if the first step was skipped
% uncomment the commented part below if needed and collect two new points on google
% maps Asta zero or by walking with the bike while running the program in LabView,
% % The data can be taken out from log files on myRIO

% % Coordinates of the first point
% newlat1 = 57.780535; % Latitude of the first point in degrees
% newlon1 = 12.771172; % Longitude of the first point in degrees
% 
% % Coordinates of the second point
% newlat2 = 57.781027; % Latitude of the second point in degrees
% newlon2 = 12.772985; % Longitude of the second point in degrees
% 
% % Convert latitude and longitude to radians
% newlat1_rad = deg2rad(newlat1);
% newlon1_rad = deg2rad(newlon1);
% newlat2_rad = deg2rad(newlat2);
% newlon2_rad = deg2rad(newlon2);
% 
% % Point1 in format [x y]
% newPoint1 = [Earth_radius * (newlon1_rad - longitude0) * cos(latitude0) Earth_radius * (newlat1_rad - latitude0)];
% 
% % Point1 in format [x y]
% newPoint2 = [Earth_radius * (newlon2_rad - longitude0) * cos(latitude0) Earth_radius * (newlat2_rad - latitude0)];
% 
% %% Find the rotational angle
% %These will be our four known points, two on each line
% x1_line1 = Point1(1,1); y1_line1 = Point1(1,2);
% x2_line1 = Point2(1,1); y2_line1 = Point2(1,2);
% 
% x1_line2 = newPoint1(1,1); y1_line2 = newPoint1(1,2);
% x2_line2 = newPoint2(1,1); y2_line2 = newPoint2(1,2);
% 
% % Calculate the direction vectors for each line
% direction_vector_line1 = [x2_line1 - x1_line1, y2_line1 - y1_line1];
% direction_vector_line2 = [x2_line2 - x1_line2, y2_line2 - y1_line2];
% 
% % Calculate the dot product of the direction vectors
% dot_product = dot(direction_vector_line1, direction_vector_line2);
% 
% % Calculate the magnitudes of the direction vectors
% magnitude_line1 = norm(direction_vector_line1);
% magnitude_line2 = norm(direction_vector_line2);
% 
% % Calculate the cosine of the angle between the lines
% cos_angle = dot_product / (magnitude_line1 * magnitude_line2);
% 
% % Calculate the angle in radians
% angle_radians = acos(cos_angle);
% 
% % Convert the angle to degrees
% angle_degrees = rad2deg(angle_radians);
% 
% % Display the angle between the lines
% fprintf('Angle between the lines: %.2f degrees\n', angle_degrees);
% %Plot the rotated trajectory...
% 
% rotationAngle=angle_degrees*pi/180;
% 
% %Create a rotation matrix based on the rotation angle
% rotationMatrix = [cos(rotationAngle), -sin(rotationAngle);
%                   sin(rotationAngle), cos(rotationAngle)];
% 
% %Rotate the entire trajectory using the rotation matrix
% XY = XY * rotationMatrix;
% 
% % Plot the rotated trajectory
% figure;
% plot(XY(:, 1), XY(:, 2), 'o');
% title('Rotated Trajectory');
% xlabel('X');
% ylabel('Y');

%% Section6: Plot the trajectory
figure;
plot(XY(:, 1), XY(:, 2), 'o');
title('Rotated Trajectory');
xlabel('X');
ylabel('Y');

%% Section7: Create a csv file for the trajectory
% Define the file name and path
csv_file_name = 'trajectoryfile.csv';
csv_file_path = 'D:\Sommarjobb';  % Update this with your desired path

% Combine the file path and name
full_csv_file_path = fullfile(csv_file_path, csv_file_name);

% Save the XY matrix to the CSV file
csvwrite(full_csv_file_path, XY);

disp(['Trajectory data saved to: ', full_csv_file_path]);


