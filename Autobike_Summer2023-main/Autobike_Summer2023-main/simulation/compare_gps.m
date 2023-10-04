clear

%% Load data GPS
data_lab = readtable('Logging_data\Test_session_22_05\data_1.csv');Table_traj = readtable('trajectorymat_backstraight.csv');
data_lab1 = readtable('Logging_data\Test_session_22_05\data_14.csv');Table_traj1 = readtable('trajectorymat_backstraight.csv');
data_lab2 = readtable('Logging_data\Test_session_17_05\data_5.csv');%Table_traj1 = readtable('trajectorymat_backstraight.csv');
data_lab3 = readtable('Logging_data\Test_session_17_05\data_1.csv');%Table_traj1 = readtable('trajectorymat_backstraight.csv');
data_lab = readtable('Logging_data\Test_session_25_05\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parkinline.csv');

%% Parameter for plot
gps_delay = 5;
longitude0 = deg2rad(11);
latitude0 = deg2rad(57);
Earth_rad = 6371000.0;
X = Earth_rad * (data_lab.LongGPS_deg_ - longitude0) * cos(latitude0);
Y = Earth_rad * (data_lab.LatGPS_deg_ - latitude0);
gps_init = find(data_lab.flag > gps_delay, 1 );
measurementsGPS = [data_lab.Time X Y];
measurementsGPS(1:gps_init,:) = [];
X(1:gps_init) = [];
Y(1:gps_init) = [];
start_point = 1;
end_point = length(measurementsGPS)-1;

X1 = Earth_rad * (data_lab1.LongGPS_deg_ - longitude0) * cos(latitude0);
Y1 = Earth_rad * (data_lab1.LatGPS_deg_ - latitude0);
gps_init1 = find(data_lab1.flag > gps_delay, 1 );
measurementsGPS1 = [data_lab1.Time X1 Y1];
measurementsGPS1(1:gps_init1,:) = [];
X1(1:gps_init1) = [];
Y1(1:gps_init1) = [];
start_point1 = 1;
end_point1 = length(measurementsGPS1)-1;

X2 = Earth_rad * (data_lab2.LongGPS_deg_ - longitude0) * cos(latitude0);
Y2 = Earth_rad * (data_lab2.LatGPS_deg_ - latitude0);
gps_init2 = find(data_lab2.flag > gps_delay, 1 );
measurementsGPS2 = [data_lab2.Time X2 Y2];
measurementsGPS2(1:gps_init2,:) = [];
X2(1:gps_init2) = [];
Y2(1:gps_init2) = [];
start_point2 = 1;
end_point2 = length(measurementsGPS2)-1;

X3 = Earth_rad * (data_lab3.LongGPS_deg_ - longitude0) * cos(latitude0);
Y3 = Earth_rad * (data_lab3.LatGPS_deg_ - latitude0);
gps_init3 = find(data_lab3.flag > gps_delay, 1 );
measurementsGPS3 = [data_lab3.Time X3 Y3];
measurementsGPS3(1:gps_init3,:) = [];
X3(1:gps_init3) = [];
Y3(1:gps_init3) = [];
start_point3 = 1;
end_point3 = length(measurementsGPS3)-1;
%% Trajectory inizialization
GPS_offset_X = X(1) - Table_traj.Var1(1);
GPS_offset_Y = Y(1) - Table_traj.Var2(1);
Table_traj.Var1(:) = Table_traj.Var1(:) + GPS_offset_X;
Table_traj.Var2(:) = Table_traj.Var2(:) + GPS_offset_Y;


%% Plot
plot(measurementsGPS(start_point:end_point,2) - X(1),measurementsGPS(start_point:end_point,3) - Y(1))
hold on
plot(measurementsGPS1(start_point1:end_point1,2) - X1(1),measurementsGPS1(start_point1:end_point1,3) - Y1(1))
plot(measurementsGPS2(start_point2:end_point2,2) - X2(1),measurementsGPS2(start_point2:end_point2,3) - Y2(1))
% plot(measurementsGPS3(start_point3:end_point3,2) - X3(1),measurementsGPS3(start_point3:end_point3,3) - Y3(1))
plot(Table_traj.Var1(:) - X(1),Table_traj.Var2(:) - Y(1))



xlabel('X position (m)')
ylabel('Y position (m)')
axis equal
grid on
legend('Data 17-05 afternoon', 'Data1 22-05 afternoon', 'Data 17-05 afternoon', 'trajectory')
title('Comparison GPS measurement backstraight')


