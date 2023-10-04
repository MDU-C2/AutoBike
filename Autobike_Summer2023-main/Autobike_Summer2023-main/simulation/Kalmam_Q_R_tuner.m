% this code is created to tune the Q and R matrix based on the measurement,
%when you are satisfied of your estimation save the matrixes in a
%Q_and_R_backup_nameofbike.m

%% clear the possible remnant on previous running

set(0,'defaulttextinterpreter','none');
dbclear all;
clear;
close all;
clc;

%% Simulation Settings and Bike Parameters
% General Parameters

    % Gravitational Acceleration
        g = 9.81;
    % Name of the model
        model = 'Kalman_offline_sim';
    % Sampling Time
        Ts = 0.01; 
    % Open the Simulink Model
        open([model '.slx']);
    % Choose the solver
        set_param(model,'AlgebraicLoopSolver','TrustRegion');

% Take into account a valid speed. 
    v=3; 
% set the initial global coordinate system for gps coordinates
    gps_delay = 5;
% Choose The Bike - Options: 'red' or 'black' 
    bike = 'red';
% Load the parameters of the specified bicycle
    bike_params = LoadBikeParameters(bike); 


%% Unpacked bike_params

h = bike_params.h_mod;
lr = bike_params.lr_mod;
lf = bike_params.lf_mod; 
lambda = bike_params.lambda_mod;
c = bike_params.c_mod;
m = bike_params.m_mod;
h_imu = bike_params.IMU_height_mod;
gpsflag = [0 0];

% Correction IMU
IMU_x = bike_params.IMU_x_mod;
IMU_roll = bike_params.IMU_roll_mod;
IMU_pitch = bike_params.IMU_pitch_mod;            
IMU_yaw = bike_params.IMU_yaw_mod;

% Convert orientation offsets to radians
roll = IMU_roll * pi / 180;
pitch = IMU_pitch * pi / 180;
yaw = IMU_yaw * pi / 180;

% Calculate transformation matrix
Rx = [1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)];   % Rotation matrix for roll
Ry = [cos(pitch) 0 sin(pitch); 0 1 0; -sin(pitch) 0 cos(pitch)]; % Rotation matrix for pitch
Rz = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1];        % Rotation matrix for yaw

T = Rz*Ry*Rx; 

%% Load measurements
% BikeData from labview
% data_lab = readtable('data.csv');
data_lab = readtable('Logging_data\Test_session_02_06\data9.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
%% Load trajectory
% Table_traj = readtable('trajectorymat.csv');

%% Select right measurements and input AND initialize

% Delete the data before reseting the trajectory and obtain X/Y position
reset_traj = find(data_lab.ResetTraj==1,1,'last');
data_lab(1:reset_traj,:) = [];
longitude0 = deg2rad(11);
latitude0 = deg2rad(57);
Earth_rad = 6371000.0;

X = Earth_rad * (data_lab.LongGPS_deg_ - longitude0) * cos(latitude0);
Y = Earth_rad * (data_lab.LatGPS_deg_ - latitude0);

% Obtain the relative time of the data
data_lab.Time = (data_lab.Time_ms_- data_lab.Time_ms_(1))*0.001;

% Obtain the measurements
ay = -data_lab.AccelerometerY_rad_s_2_;
omega_x = data_lab.GyroscopeX_rad_s_;
omega_z = data_lab.GyroscopeZ_rad_s_;
delta_enc = data_lab.SteeringAngleEncoder_rad_;
v_enc = data_lab.SpeedVESC_rad_s_*bike_params.r_wheel;

% Prepare measurement data for the offline kalman
gps_init = find(data_lab.flag > gps_delay, 1 );
measurementsGPS = [data_lab.Time X Y];
measurementsGPS(1:gps_init,:) = [];
measurements = [data_lab.Time ay omega_x omega_z delta_enc v_enc];
measurements(1,:) = [];
steer_rate = [data_lab.Time data_lab.SteerrateInput_rad_s_];
steer_rate(1,:) = [];
gpsflag = [data_lab.Time data_lab.flag];

% Translate the trajectory to the point where is reseted
GPS_offset_X = X(1) - Table_traj.Var1(1);
GPS_offset_Y = Y(1) - Table_traj.Var2(1);
Table_traj.Var1(:) = Table_traj.Var1(:) + GPS_offset_X;
Table_traj.Var2(:) = Table_traj.Var2(:) + GPS_offset_Y;

% Initial Roll
        initial_state.roll = deg2rad(0);
        initial_state.roll_rate = deg2rad(0);
% Initial Steering
        initial_state.steering = deg2rad(0);
% Initial Pose (X,Y,theta)
        initial_state.x = Table_traj.Var1(1);
        initial_state.y = Table_traj.Var2(1);
        initial_state.heading = Table_traj.Var3(1);
        initial_pose = [initial_state.x; initial_state.y; initial_state.heading];
        initial_state_estimate = initial_state;


%% Kalman Filter
% A matrix (linear bicycle model with constant velocity)
% Est_States := [X Y psi phi phi_dot delta v]
A = [0 0 0 0 0 0 1;
     0 0 v 0 0 v*(lr/(lf+lr))*sin(lambda) 0;
     0 0 0 0 0 (v/(lr+lf))*sin(lambda) 0;
     0 0 0 0 1 0 0;
     0 0 0 (g/h) 0 ((v^2/h)-(g*lr*c/(h^2*(lr+lf))))*sin(lambda) 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0];

% B matrix (linear bicycle model with constant velocity)
B = [0 0 0 0 ((v*lr)/(h*(lr+lf))) 1 0]';

% Including GPS
C1 = [1 0 0 0 0 0 0;
     0 1 0 0 0 0 0;
     0 0 0 -g+((-h_imu*g)/h) 0 (-h_imu*(h*v^2-(g*lr*c)))*sin(lambda)/((lr+lf)*h^2) + (v^2)*sin(lambda)/(lr+lf) 0;
     0 0 0 0 1 0 0;
     0 0 0 0 0 (v)*sin(lambda)/(lr+lf) 0;
     0 0 0 0 0 1 0;
     0 0 0 0 0 0 1];

D1 = [0 0 (-h_imu*lr*v)/((lr+lf)*h) 0 0 0 0]';

% Excluding GPS
C2 = [(-g+((-h_imu*g)/h)) 0 (-h_imu*(h*v^2-(g*lr*c)))*sin(lambda)/((lr+lf)*h^2)+(v^2)*sin(lambda)/(lr+lf) 0;
      0 1 0 0;
      0 0 (v)*sin(lambda)/(lr+lf) 0;
      0 0 1 0;
      0 0 0 1];

D2 = [(-h_imu*lr*v)/((lr+lf)*h) 0 0 0 0]';

% Discretize the model
A_d = (eye(size(A))+Ts*A);
B_d = Ts*B;

%% Q and R without tuning
Q = eye(7);
R = eye(7);
% Compute Kalman Gain
    % including GPS
    [P1,Kalman_gain1,eig_K] = idare(A_d',C1',Q,R,[],[]);
    eig1_K = abs(eig_K);
    Kalman_gain1 = Kalman_gain1';
    Ts_GPS = 0.1; % sampling rate of the GPS
    counter = (Ts_GPS / Ts) - 1 ; % Upper limit of the counter for activating the flag 

% Polish the kalman gain (values <10-5 are set to zero)
for i = 1:size(Kalman_gain1,1)
    for j = 1:size(Kalman_gain1,2)
        if abs(Kalman_gain1(i,j)) < 10^-5
            Kalman_gain1(i,j) = 0;
        end
    end
end 

% Kalman_gain excluding GPS
Kalman_gain2 = Kalman_gain1(4:7,3:7);

%% Offline Simulation
sim_time = data_lab.Time(end);
tic
try Results = sim(model);
    catch error_details %note: the model has runned for one time here
end
toc

%% evaluate the variances
% Adding the flag to gps
measurementsGPS_X_flag = [data_lab.Time data_lab.LatGPS_deg_ data_lab.flag];
measurementsGPS_Y_flag = [data_lab.Time data_lab.LongGPS_deg_ data_lab.flag];

[X_variance_diff, X_variance_real, X_variance_estimated, X_Mean_diff, X_Mean_real, X_Mean_estimated, realX_value, estimatedX_value] = variance_calculator(measurementsGPS_X_flag,[Results.sim_Kalman.Time Results.sim_Kalman.Data(:,1)]);
[Y_variance_diff, Y_variance_real, Y_variance_estimated, Y_Mean_diff, Y_Mean_real, Y_Mean_estimated, realY_value, estimatedY_value] = variance_calculator(measurementsGPS_Y_flag,[Results.sim_Kalman.Time Results.sim_Kalman.Data(:,2)]);
GPS_variance=(X_variance_real+Y_variance_real)/2;

[heading_variance_diff, heading_variance_real, heading_variance_estimated, heading_Mean_diff, heading_Mean_real, heading_Mean_estimated,  real_heading_value, estimated_heading_value] = variance_calculator([measurements(:,1) measurements(:,2)],[Results.sim_Kalman.Time Results.sim_Kalman.Data(:,3)]);

[roll_variance_diff, roll_variance_real, roll_variance_estimated, roll_Mean_diff, roll_Mean_real, roll_Mean_estimated,real_roll_value, estimated_roll_value] = variance_calculator([measurements(:,1) measurements(:,3)],[Results.sim_Kalman.Time Results.sim_Kalman.Data(:,4)]);


[RollRate_variance_diff, RollRate_variance_real, RollRate_variance_estimated, RollRate_Mean_diff, RollRate_Mean_real, RollRate_Mean_estimated,real_RollRate_value, estimated_RollRate_value] = variance_calculator([measurements(:,1) measurements(:,4)],[Results.sim_Kalman.Time Results.sim_Kalman.Data(:,5)]);

[SteeringAngle_variance_diff, SteeringAngle_variance_real, SteeringAngle_variance_estimated, SteeringAngle_Mean_diff, SteeringAngle_Mean_real, SteeringAngle_Mean_estimated,real_SteeringAngle_value, estimated_SteeringAngle_value] = variance_calculator([measurements(:,1) measurements(:,5)],[Results.sim_Kalman.Time Results.sim_Kalman.Data(:,6)]);

%% Histogram plot of the data
% figure(8)
% % subplot(211)
% % histogram2(estimatedX_value,estimatedY_value)
% % ylabel('values')
% % xlabel('[m]')
% % grid on
% % % legend('X GPS estimated', 'X GPS measurement','Y GPS estimated','Y GPS measurement');
% % title('histogram GPS estimates values plot');
% % estimated_pos_var=var([estimatedX_value,estimatedY_value])
% 
% subplot(212)
% histogram2(realX_value,realY_value)
% ylabel('values')
% xlabel('[m]')
% grid on
% % legend('X GPS estimated', 'X GPS measurement','Y GPS estimated','Y GPS measurement');
% title('histogram GPS real value plot');

figure(7)
subplot(321)
% histogram(estimatedX_value)
hold on
histogram(realX_value)
% histogram(estimatedY_value)
hold on
histogram(realY_value)
ylabel('values')
grid on
legend('X GPS estimated', 'X GPS measurement','Y GPS estimated','Y GPS measurement');
title('histogram GPS plot');


subplot(322)
histogram(real_heading_value)
hold on
histogram(estimated_heading_value)
ylabel('values')
grid on
legend('heading estimated', 'heading measurement');
title('histogram plot heading');

subplot(323)
histogram(real_roll_value)
hold on
histogram(estimated_roll_value)
ylabel('values')
grid on
legend('roll estimated', 'roll measurement');
title('histogram roll plot');

subplot(324)
histogram(real_RollRate_value)
hold on
histogram(estimated_RollRate_value)
ylabel('values')
grid on
legend('RollRate estimated', 'RollRate measurement');
title('histogram RollRate plot')

subplot(325)
histogram(real_SteeringAngle_value)
hold on
histogram(estimated_SteeringAngle_value)
ylabel('values')
grid on
legend('SteeringAngle estimated', 'SteeringAngle measurement');
title('histogram SteeringAngle plot')

%% Computing R and Q
% Q_vector=[Q_GPS,Q_Psi,Q_roll,Q_rollrate,Q_delta,Q_v,Q_scale];
% R_vector=[R_GPS,R_heading,R_roll,R_RollRate,R_SteeringAngle,R_v,R_scale];
% Q =Qscale* [Q_GPS 0 0 0 0 0 0;
%               0 Q_GPS 0 0 0 0 0;
%               0 0 Q_Psi 0 0 0 0;
%               0 0 0 Q_roll 0 0 0;
%               0 0 0 0 Q_rollrate 0 0;
%               0 0 0 0 0 Q_delta 0;
%               0 0 0 0 0 0 Q_v];
% R =Rscale* [R_GPS 0 0 0 0 0 0;
%               0 R_GPS 0 0 0 0 0;
%               0 0 R_ay 0 0 0 0;
%               0 0 0 R_wx 0 0 0;
%               0 0 0 0 R_wz 0 0;
%               0 0 0 0 0 R_delta 0;
%               0 0 0 0 0 0 R_v];
% GPS_variance=1;

Q_vector=[0.1,0.1,10e-10,5,10,0.5,1];
R_vector=[0.01*GPS_variance,1*heading_variance_real,10e-10*roll_variance_real,1*RollRate_variance_real,SteeringAngle_variance_real,0.1,1];
[Q,R] = Q_R_modifier(Q_vector,R_vector);
% Compute Kalman Gain
    % including GPS
    [P1,Kalman_gain1,eig] = idare(A_d',C1',Q,R,[],[]);
    eig1 = abs(eig);
    Kalman_gain1 = Kalman_gain1';
    Ts_GPS = 1; % sampling rate of the GPS
    counter = (Ts_GPS / Ts) - 1 ; % Upper limit of the counter for activating the flag 

% Polish the kalman gain (values <10-5 are set to zero)
for i = 1:size(Kalman_gain1,1)
    for j = 1:size(Kalman_gain1,2)
        if abs(Kalman_gain1(i,j)) < 10^-5
            Kalman_gain1(i,j) = 0;
        end
    end
end 

% Kalman_gain excluding GPS
Kalman_gain2 = Kalman_gain1(4:7,3:7);

tic
try Results2 = sim(model);
    catch error_details %note: the model has runned for one time here
end
toc
%% Plot results
%labview data
fig = figure();
plot3(Results2.sim_Kalman.Data(:,1) - X(1), Results2.sim_Kalman.Data(:,2) - Y(1),Results2.sim_Kalman.Time)
hold on
plot3(data_lab.StateEstimateX_m_(:) - X(1) ,data_lab.StateEstimateY_m_(:) - Y(1),data_lab.Time)
plot3(measurementsGPS(:,2) - X(1),measurementsGPS(:,3) - Y(1),data_lab.Time(1:end-1))
plot3(Table_traj.Var1(:) - X(1),Table_traj.Var2(:) - Y(1),1:length(Table_traj.Var1(:)))
view(0,90)
% % plot(Results2.sim_Kalman.Data(start_point:end_point,1) - X(1), Results2.sim_Kalman.Data(start_point:end_point,2) - Y(1))
% % hold on
% % plot3(data_lab.StateEstimateX_m_(start_point:end_point) - X(1) ,data_lab.StateEstimateY_m_(start_point:end_point) - Y(1))
% % plot3(measurementsGPS(start_point:end_point,2) - X(1),measurementsGPS(start_point:end_point,3) - Y(1))
% % plot3(Table_traj.Var1(:) - X(1),Table_traj.Var2(:) - Y(1))

xlabel('X position (m)')
ylabel('Y position (m)')
axis equal
grid on
legend('offline Kalman estimation', 'online estimation', 'GPS measurements','trajectory')
title('Comparison with Kalman estimator on bike')

fig = figure();
subplot(421)
plot(Results2.sim_Kalman.Time,Results2.sim_Kalman.Data(:,1)-measurementsGPS(1,2))
hold on
plot(Results.sim_Kalman.Time,Results.sim_Kalman.Data(:,1)-measurementsGPS(1,2))
plot(measurementsGPS(:,1),measurementsGPS(:,2)-measurementsGPS(1,2))
xlabel('Time (s)')
ylabel('X position (m)')
grid on
legend('offline Kalman estimation Tuned R', 'offline Kalman estimation without tune','GPS measurements')
title('Comparison with Kalman estimator on bike')

subplot(423)
plot(Results2.sim_Kalman.Time, Results2.sim_Kalman.Data(:,2)-measurementsGPS(1,3))
hold on
plot(Results2.sim_Kalman.Time, Results2.sim_Kalman.Data(:,2)-measurementsGPS(1,3))
plot(measurementsGPS(:,1),measurementsGPS(:,3)-measurementsGPS(1,3))
xlabel('Time (s)')
ylabel('Y position (m)')
grid on
legend('offline Kalman estimation Tuned R', 'offline Kalman estimation without tune','GPS measurements')

subplot(425)
plot(Results2.sim_Kalman.Time, rad2deg(Results2.sim_Kalman.Data(:,3)))
hold on
plot(Results.sim_Kalman.Time, rad2deg(Results.sim_Kalman.Data(:,3)))
plot(data_lab.Time, rad2deg(wrapToPi(data_lab.StateEstimatePsi_rad_)))
xlabel('Time (s)')
ylabel('heading (deg)')
grid on
legend('offline Kalman estimation Tuned R','offline Kalman estimation without tune', 'Online estimation')

subplot(422)
plot(Results2.sim_Kalman.Time, rad2deg(Results2.sim_Kalman.Data(:,4)))
hold on
plot(Results2.integration_rollrate.Time, rad2deg(Results2.integration_rollrate.Data))
plot(Results.sim_Kalman.Time, rad2deg(Results.sim_Kalman.Data(:,4)))
xlabel('Time (s)')
ylabel('Roll (deg)')
grid on
legend('offline Kalman estimation Tuned R','Integration Rollrate','offline Kalman estimation without tune')
title('Comparison with Kalman estimator on bike')

subplot(424)
plot(Results2.sim_Kalman.Time, rad2deg(Results2.sim_Kalman.Data(:,5)))
hold on
plot(Results.sim_Kalman.Time, rad2deg(Results.sim_Kalman.Data(:,5)))
plot(data_lab.Time, rad2deg(data_lab.GyroscopeX_rad_s_))
xlabel('Time (s)')
ylabel('Roll Rate (deg/s)')
grid on
legend('offline Kalman estimation Tuned R', 'offline Kalman estimation without tune', 'Measurement')

subplot(426)
plot(Results2.sim_Kalman.Time,rad2deg(Results2.sim_Kalman.Data(:,6)))
hold on
plot(Results.sim_Kalman.Time,rad2deg(Results.sim_Kalman.Data(:,6)))
plot(data_lab.Time,rad2deg(data_lab.SteeringAngleEncoder_rad_))
xlabel('Time (s)')
ylabel('Steering Angle (deg)')
grid on
legend('offline Kalman estimation Tuned R', 'offline Kalman estimation without tune', 'Measurement')

subplot(428)
plot(Results2.sim_Kalman.Time, Results2.sim_Kalman.Data(:,7))
hold on
plot(Results.sim_Kalman.Time, Results.sim_Kalman.Data(:,7))
plot(data_lab.Time, v_enc)
xlabel('Time (s)')
ylabel('velocity (m/s)')
grid on
legend('offline Kalman estimation Tuned R', 'offline Kalman estimation without tune','Measurement')

figure
subplot(221)
plot(Results2.y_hat.Time,Results2.y_hat.Data(:,1))
hold on
plot(Results.y_hat.Time,Results.y_hat.Data(:,1))
plot(measurements(:,1),measurements(:,2))
xlabel('Time (s)')
ylabel(' (m/s^2)')
title('a_y')
grid on
legend('offline Kalman estimation Tuned R','offline Kalman estimation without tune','meas')

subplot(222)
plot(Results2.y_hat.Time,rad2deg(Results2.y_hat.Data(:,2)))
hold on
plot(Results.y_hat.Time,rad2deg(Results.y_hat.Data(:,2)))
plot(measurements(:,1),rad2deg(measurements(:,3)))
xlabel('Time (s)')
ylabel(' (deg/s)')
title('w_x')
grid on
legend('offline Kalman estimation Tuned R','offline Kalman estimation without tune','meas')

subplot(223)
plot(Results2.y_hat.Time,rad2deg(Results2.y_hat.Data(:,3)))
hold on
plot(Results.y_hat.Time,rad2deg(Results.y_hat.Data(:,3)))
plot(measurements(:,1),rad2deg(measurements(:,4)))
xlabel('Time (s)')
ylabel(' (deg/s)')
title('w_z')
grid on
legend('offline Kalman estimation Tuned R','offline Kalman estimation without tune','meas')

%% Q and R matrix for red bike (just in case)
% Q and R matrix
% Parameters of Q
% Q_GPS = 0.2^2;
% Q_Psi = 1^2;
% Q_roll = deg2rad(0.01)^2;
% Q_rollrate = deg2rad(0.05)^2;
% Q_delta = deg2rad(0.05)^2;
% Q_v = 0.1^2;
% Qscale = 1;
% Q =Qscale* [Q_GPS 0 0 0 0 0 0;
%               0 Q_GPS 0 0 0 0 0;
%               0 0 Q_Psi 0 0 0 0;
%               0 0 0 Q_roll 0 0 0;
%               0 0 0 0 Q_rollrate 0 0;
%               0 0 0 0 0 Q_delta 0;
%               0 0 0 0 0 0 Q_v];
% 
% % Parameters of R
% R_GPS = 0.2^2;
% R_ay =deg2rad(0.1)^2;
% R_wx = deg2rad(0.1)^2;
% R_wz = deg2rad(0.1)^2;
% R_delta = 0.001^2;
% R_v = 10^2;
% Rscale = 1;
% R =Rscale* [R_GPS 0 0 0 0 0 0;
%               0 R_GPS 0 0 0 0 0;
%               0 0 R_ay 0 0 0 0;
%               0 0 0 R_wx 0 0 0;
%               0 0 0 0 R_wz 0 0;
%               0 0 0 0 0 R_delta 0;
%               0 0 0 0 0 0 R_v];
