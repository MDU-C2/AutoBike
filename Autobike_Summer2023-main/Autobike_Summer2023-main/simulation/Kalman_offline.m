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

    
%%%%%%%%%%%%%GUI%%%%%%%%%%%%%%%%%%%%%%%%%
% % reduce/increase simulation time for desired timescale on x-axis of the plots
%     sim_time = 50;
% Take into account a valid speed. 
    v=3; 
% set the initial global coordinate system for gps coordinates
    gps_delay = 5;
% Choose The Bike - Options: 'red' or 'black' 
    bike = 'red';
% Load the parameters of the specified bicycle
    bike_params = LoadBikeParameters(bike); 
% selector =1 to cut the data from the moment that steering is on until the end,
% selector=0 to cut the data from a specific point
% selector=2 all the data will be plotted
selector=1;

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
% % test for encoder measurement 31\05
% data_lab = readtable('Logging_data\Test_steering_measurement\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_steering_measurement\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');

% % Test 17/05
% data_lab = readtable('Logging_data\Test_session_17_05\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_17_05\data_2.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_17_05\data_3.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_17_05\data_4.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_17_05\data_5.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_17_05\data_6.csv');Table_traj = readtable('trajectorymat_parking_line.csv');

% % Test 22/05
% data_lab = readtable('Logging_data\Test_session_22_05\data_1.csv');Table_traj = readtable('trajectorymat_backstraight.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_2.csv');Table_traj = readtable('trajectorymat_backstraight.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_3.csv');Table_traj = readtable('trajectorymat_backstraight.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_4.csv');Table_traj = readtable('trajectorymat_backstraight.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_5.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_6.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_7.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_8.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_9.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_10.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_11.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_12.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_13.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_14.csv');Table_traj = readtable('trajectorymat_backstraight.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_15.csv');Table_traj = readtable('trajectorymat_backstraight.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_16.csv');Table_traj = readtable('trajectorymat_backstraight.csv');
% data_lab = readtable('Logging_data\Test_session_22_05\data_17.csv');Table_traj = readtable('trajectorymat_backstraight.csv');

% % Test 23/05
% data_lab = readtable('Logging_data\Test_session_23_05\data_1.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_23_05\data_2.csv');Table_traj = readtable('trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_23_05\data_3.csv');Table_traj = readtable('trajectorymat_parking_sharpturn');
% data_lab = readtable('Logging_data\Test_session_23_05\data_4.csv');Table_traj = readtable('trajectorymat_parking_sharpturn');
% data_lab = readtable('Logging_data\Test_session_23_05\data_5.csv');Table_traj = readtable('trajectorymat_parking_sharpturn');
% data_lab = readtable('Logging_data\Test_session_23_05\data_6.csv');Table_traj = readtable('trajectorymat_parking_sharpturn');
% data_lab = readtable('Logging_data\Test_session_23_05\data_7.csv');Table_traj = readtable('trajectorymat_parking_sharpturn');
% data_lab = readtable('Logging_data\Test_session_23_05\data_8.csv');Table_traj = readtable('trajectorymat_parking_sharpturn');

% % Test 25/05
% data_lab = readtable('Logging_data\Test_session_25_05\data_2.csv');Table_traj = readtable('trajectorymat_parking_turn_right.csv');
% data_lab = readtable('Logging_data\Test_session_25_05\data_3.csv');Table_traj = readtable('trajectorymat_parking_turn_right.csv');
% data_lab = readtable('Logging_data\Test_session_25_05\data_4.csv');Table_traj = readtable('trajectorymat_parking_turn_right.csv');
% data_lab = readtable('Logging_data\Test_session_25_05\data_5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right.csv');
% data_lab = readtable('Logging_data\Test_session_25_05\data_6.csv');Table_traj = readtable('trajectorymat_parking_turn_right.csv');
% data_lab = readtable('Logging_data\Test_session_25_05\data_7.csv');Table_traj = readtable('trajectorymat_parking_turn_right.csv');
% data_lab = readtable('Logging_data\Test_session_25_05\data_8.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_25_05\data_9.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_25_05\data_10.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_25_05\data_11.csv');Table_traj = readtable('trajectorymat_parking_turn_right.csv');

% % Test 26/05
%good to show data7
% data_lab = readtable('Logging_data\Test_session_26_05\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_26_05\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_26_05\data_3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_26_05\data_4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_26_05\data_9.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_26_05\data_8.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_26_05\data_7.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_26_05\data_5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');

% % Test 30/05
%data 7 valid test
% data_lab = readtable('Logging_data\Test_session_30_05\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_6.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_7.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_8.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_9.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_10.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_11.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parkinline.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_12.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parkinline.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_13.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parkinline.csv');
% data_lab = readtable('Logging_data\Test_session_30_05\data_14.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parkinline.csv');

% % Test 30/05
% data_lab = readtable('Logging_data\Test_session_31_05\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% data_lab = readtable('Logging_data\Test_session_31_05\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% data_lab = readtable('Logging_data\Test_session_31_05\data_3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');

% % Test 02/06
% TEST GPS WITHOUT DRIVE MOTOR
% data_lab = readtable('Logging_data\Test_session_02_06\data1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% TEST GPS WITH DRIVE MOTOR
% data_lab = readtable('Logging_data\Test_session_02_06\data2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% data_lab = readtable('Logging_data\Test_session_02_06\data3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% TEST TRAJECOTRY CONTROL WITH TURN RIGHT, AT 2 M/S
% data_lab = readtable('Logging_data\Test_session_02_06\data4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% SAME AS PREVIOUS ONE
% data_lab = readtable('Logging_data\Test_session_02_06\data5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% TEST TRAJECOTRY CONTROL WITH TURN LEFT, AT 2 M/S
% data_lab = readtable('Logging_data\Test_session_02_06\data6.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_left_10.csv');
% data_lab = readtable('Logging_data\Test_session_02_06\data7.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_left_10.csv');
% UNTIL THIS TEST WE ARE USING 3 M/S VELOCITY BUT THE MATRIXMAT TUNED FOR 3 M/S

% TRAJECTORY CONTROL WITH TURN LEFT, AT 3 M/S
% data_lab = readtable('Logging_data\Test_session_02_06\data8.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_left_10.csv');
% TRAJECTORY CONTROL WITH TURN RIGHT, AT 3 M/S
%data_lab = readtable('Logging_data\Test_session_02_06\data9.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');
% data_lab = readtable('Logging_data\Test_session_02_06\data10.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_right_10.csv');

% % Test 06/06
% data_lab = readtable('Logging_data\Test_session_06_06\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_06_06\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_06_06\data_3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_06_06\data_4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');

% % Test 07/06
% data_lab = readtable('Logging_data\Test_session_07_06\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_07_06\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_07_06\data_3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% next one is for record trajectory
% data_lab = readtable('Logging_data\Test_session_07_06\data_4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');

%% Test 09-06 Football pitch
% data_lab = readtable('Logging_data\Test_session_09_06\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_line.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_line.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_line.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_line.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_line.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_6.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_line.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_7.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_line.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_8.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_left.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_9.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_right.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_10.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_lat_left.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_11.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_circle_5.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_12.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_circle_5.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_13.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_circle_5.csv');
%% GOOD ONE
% data_lab = readtable('Logging_data\Test_session_09_06\data_14.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_circle_5.csv');
% data_lab = readtable('Logging_data\Test_session_09_06\data_15.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_foot_lat_right.csv');

%% Test 14-06 parking lot
% data_lab = readtable('Logging_data\Test_session_14_06\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_14_06\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_14_06\data_3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_14_06\data_4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_14_06\data_5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_14_06\data_6.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_14_06\data_7.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_14_06\data_8.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
%% Test 15-06 parking lot
% data_lab = readtable('Logging_data\Test_session_15_06\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_15_06\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_15_06\data_3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_15_06\data_4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_15_06\data_5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_15_06\data_6.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_15_06\data_7.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_15_06\data_8.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_15_06\data_9.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');

%% Test 16-06 parking lot
% data_lab = readtable('Logging_data\Test_session_16_06\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_16_06\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_16_06\data_3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_16_06\data_4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_16_06\data_5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_16_06\data_6.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_16_06\data_7.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');

%% Test 16-06 parking lot
% data_lab = readtable('Logging_data\Test_session_22_06\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_06\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_06\data_3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_06\data_4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\Test_session_22_06\data_5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');

%% green bike test
% Test steering motor configuration green bike
% data_lab = readtable('Logging_data\greenbike\Test_steeringconfig_green\data1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\greenbike\Test_steeringconfig_green\data2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\greenbike\Test_steeringconfig_green\data3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');

%% Test 22-06 Green bike Parking lot
% data_lab = readtable('Logging_data\greenbike\Test_session_22_06_green\data_balancing_good.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\greenbike\Test_session_22_06_green\data_gps_test.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\greenbike\Test_session_22_06_green\data1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\greenbike\Test_session_22_06_green\data2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\greenbike\Test_session_22_06_green\data3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\greenbike\Test_session_22_06_green\data4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');
% data_lab = readtable('Logging_data\greenbike\Test_session_22_06_green\data5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');

%% Test 27-06 AstaZero test track
% Red bike
% data_lab = readtable('Logging_data\Test_session_27_06\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_line.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_line.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_line.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_line.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_line.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_6.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_line.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_7.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_turn_right.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_8.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_turn_left.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_9.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_lat_right.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_10.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_lat_right.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_11.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_lat_left.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_12.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_13.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_14.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_infinite_30.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_15.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_infinite_30.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_16.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_infinite_35.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_17.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% data_lab = readtable('Logging_data\Test_session_27_06\data_18.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_infinite_30.csv');

% Green bike
% data_lab = readtable('Logging_data\greenbike\Test_session_27_06_green\data_1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_line.csv');
% data_lab = readtable('Logging_data\greenbike\Test_session_27_06_green\data_2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_line.csv');
% data_lab = readtable('Logging_data\greenbike\Test_session_27_06_green\data_3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');


%% PI speed controller tests - 7/21
%data_lab = readtable('Logging_data\PI_speed_controller_tests\data4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');

%% PI speed controller tests - 7/24
%data_lab = readtable('Logging_data\PI_speed_controller_tests\data8.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');

%% PI speed controller tests - 7/26
%data_lab = readtable('Logging_data\PI_speed_controller_tests\data10.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
%data_lab = readtable('Logging_data\PI_speed_controller_tests\data11.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
%data_lab = readtable('Logging_data\PI_speed_controller_tests\data12.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
%data_lab = readtable('Logging_data\PI_speed_controller_tests\data15.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
%data_lab = readtable('Logging_data\PI_speed_controller_tests\data16.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
%data_lab = readtable('Logging_data\PI_speed_controller_tests\data17.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');

%% PI speed controller tests - 8/02
% data_lab = readtable('Logging_data\PI_speed_controller_tests\dataGF3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% subplot(311)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold off
% axis manual;
% clickableLegend("Real Speed Motor","Reference Speed")
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(312)
% plot(Time,data_lab.Kp)
% axis manual;
% clickableLegend("Kp")
% xlabel("Time (s)")
% subplot(313)
% plot(Time,data_lab.Kd)
% hold on
% plot(Time,data_lab.PICurrent_A_)
% hold off
% axis manual;
% clickableLegend("Ki","PICurrent (A)")
% xlabel("Time (s)")
% 
% s11=data_lab.SpeedVESC_rad_s_(4200:4900);
% s22=data_lab.SpeedVESC_rad_s_(6500:7200);
% s33=data_lab.SpeedVESC_rad_s_(11600:12300);
% s44=data_lab.SpeedVESC_rad_s_(17400:18100);
% data_lab.SpeedVESC_rad_s_ = data_lab.SpeedVESC_rad_s_ - mean(data_lab.SpeedVESC_rad_s_);
% s1=data_lab.SpeedVESC_rad_s_(4200:4900);
% T1=0.01:0.01:length(s1)*0.01;
% [Pxx1,f1]=pwelch(s1,[],[],[]);
% Frequency1=f1*100/(2*pi);
% s2=data_lab.SpeedVESC_rad_s_(6500:7200);
% T2=0.01:0.01:length(s2)*0.01;
% [Pxx2,f2]=pwelch(s2,[],[],[]);
% Frequency2=f2*100/(2*pi);
% s3=data_lab.SpeedVESC_rad_s_(11600:12300);
% T3=0.01:0.01:length(s3)*0.01;
% [Pxx3,f3]=pwelch(s3,[],[],[]);
% Frequency3=f3*100/(2*pi);
% s4=data_lab.SpeedVESC_rad_s_(17400:18100);
% T4=0.01:0.01:length(s4)*0.01;
% [Pxx4,f4]=pwelch(s4,[],[],[]);
% Frequency4=f4*100/(2*pi);
% 
% figure()
% subplot(311)
% plot(T1,s11)
% hold on
% plot(T2,s22)
% hold on
% plot(T3,s33)
% hold on
% plot(T4,s44)
% hold off
% title("Real Speed Signal with Ki=0 and Kp variable")
% axis manual;
% clickableLegend("Kp=2","Kp=20","Kp=50","Kp=0.2")
% xlabel("Temps (s)")
% ylabel("Magnitude")
% subplot(312)
% plot(Frequency1,Pxx1)
% hold on
% plot(Frequency2,Pxx2)
% hold on
% plot(Frequency3,Pxx3)
% hold on
% plot(Frequency4,Pxx4)
% hold off
% title("Power Spectrum of the Real Speed with Ki=0 and Kp variable")
% axis manual;
% clickableLegend("Kp=2","Kp=20","Kp=50","Kp=0.2")
% xlabel("Frequency (Hz)")
% ylabel("Power")
% subplot(313)
% plot(Frequency1,10*log10(Pxx1))
% hold on
% plot(Frequency2,10*log10(Pxx2))
% hold on
% plot(Frequency3,10*log10(Pxx3))
% hold on
% plot(Frequency4,10*log10(Pxx4))
% hold off
% axis manual;
% clickableLegend("Kp=2","Kp=20","Kp=50","Kp=0.2")
% xlabel("Frequency (Hz)")
% ylabel("Power (dB)")
% 
% %% PI speed controller tests - 8/02
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRF2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRF.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% subplot(311)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold off
% axis manual;
% clickableLegend("Real Speed Motor","Reference Speed")
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(312)
% plot(Time,data_lab.Kp)
% axis manual;
% clickableLegend("Kp")
% xlabel("Time (s)")
% subplot(313)
% plot(Time,data_lab.Kd)
% hold on
% plot(Time,data_lab.PICurrent_A_)
% hold off
% axis manual;
% clickableLegend("Ki","PICurrent (A)")
% xlabel("Time (s)")
% 
% % s11=data_lab.SpeedVESC_rad_s_(2200:3000);
% % s22=data_lab.SpeedVESC_rad_s_(3400:4200);
% % s33=data_lab.SpeedVESC_rad_s_(6000:6800);
% % s44=data_lab.SpeedVESC_rad_s_(9400:10200);
% % data_lab.SpeedVESC_rad_s_ = data_lab.SpeedVESC_rad_s_ - mean(data_lab.SpeedVESC_rad_s_);
% % s1=data_lab.SpeedVESC_rad_s_(2200:3000);
% % T1=0.01:0.01:length(s1)*0.01;
% % [Pxx1,f1]=pwelch(s1,[],[],[]);
% % Frequency1=f1*100/(2*pi);
% % s2=data_lab.SpeedVESC_rad_s_(3400:4200);
% % T2=0.01:0.01:length(s2)*0.01;
% % [Pxx2,f2]=pwelch(s2,[],[],[]);
% % Frequency2=f2*100/(2*pi);
% % s3=data_lab.SpeedVESC_rad_s_(6000:6800);
% % T3=0.01:0.01:length(s3)*0.01;
% % [Pxx3,f3]=pwelch(s3,[],[],[]);
% % Frequency3=f3*100/(2*pi);
% % s4=data_lab.SpeedVESC_rad_s_(9400:10200);
% % T4=0.01:0.01:length(s4)*0.01;
% % [Pxx4,f4]=pwelch(s4,[],[],[]);
% % Frequency4=f4*100/(2*pi);
% % 
% % figure()
% % subplot(311)
% % plot(T1,s11)
% % hold on
% % plot(T2,s22)
% % hold on
% % plot(T3,s33)
% % hold on
% % plot(T4,s44)
% % hold off
% % title("Real Speed Signal with Ki=0 and Kp variable")
% % axis manual;
% % clickableLegend("Kp=2","Kp=20","Kp=50","Kp=0.2")
% % xlabel("Temps (s)")
% % ylabel("Magnitude")
% % subplot(312)
% % plot(Frequency1,Pxx1)
% % hold on
% % plot(Frequency2,Pxx2)
% % hold on
% % plot(Frequency3,Pxx3)
% % hold on
% % plot(Frequency4,Pxx4)
% % hold off
% % title("Power Spectrum of the Real Speed with Ki=0 and Kp variable")
% % axis manual;
% % clickableLegend("Kp=2","Kp=20","Kp=50","Kp=0.2")
% % xlabel("Frequency (Hz)")
% % ylabel("Power")
% % subplot(313)
% % plot(Frequency1,10*log10(Pxx1))
% % hold on
% % plot(Frequency2,10*log10(Pxx2))
% % hold on
% % plot(Frequency3,10*log10(Pxx3))
% % hold on
% % plot(Frequency4,10*log10(Pxx4))
% % hold off
% % axis manual;
% % clickableLegend("Kp=2","Kp=20","Kp=50","Kp=0.2")
% % xlabel("Frequency (Hz)")
% % ylabel("Power (dB)")
% 
% 
% %% Current Control Test - 8/04
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRC.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRC2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% % subplot(311)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold off
% axis manual;
% clickableLegend("Real Speed Motor","Reference Speed")
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(312)
% plot(Time,data_lab.Kp)
% axis manual;
% clickableLegend("Kp")
% xlabel("Time (s)")
% subplot(313)
% plot(Time,data_lab.Kd)
% hold on
% plot(Time,data_lab.PICurrent_A_)
% hold off
% axis manual;
% clickableLegend("Ki","PICurrent (A)")
% xlabel("Time (s)")

% s11=data_lab.SpeedVESC_rad_s_(4200:4900);
% s22=data_lab.SpeedVESC_rad_s_(6500:7200);
% s33=data_lab.SpeedVESC_rad_s_(11600:12300);
% s44=data_lab.SpeedVESC_rad_s_(17400:18100);
% data_lab.SpeedVESC_rad_s_ = data_lab.SpeedVESC_rad_s_ - mean(data_lab.SpeedVESC_rad_s_);
% s1=data_lab.SpeedVESC_rad_s_(4200:4900);
% T1=0.01:0.01:length(s1)*0.01;
% [Pxx1,f1]=pwelch(s1,[],[],[]);
% Frequency1=f1*100/(2*pi);
% s2=data_lab.SpeedVESC_rad_s_(6500:7200);
% T2=0.01:0.01:length(s2)*0.01;
% [Pxx2,f2]=pwelch(s2,[],[],[]);
% Frequency2=f2*100/(2*pi);
% s3=data_lab.SpeedVESC_rad_s_(11600:12300);
% T3=0.01:0.01:length(s3)*0.01;
% [Pxx3,f3]=pwelch(s3,[],[],[]);
% Frequency3=f3*100/(2*pi);
% s4=data_lab.SpeedVESC_rad_s_(17400:18100);
% T4=0.01:0.01:length(s4)*0.01;
% [Pxx4,f4]=pwelch(s4,[],[],[]);
% Frequency4=f4*100/(2*pi);
% 
% figure()
% subplot(311)
% plot(T1,s11)
% hold on
% plot(T2,s22)
% hold on
% plot(T3,s33)
% hold on
% plot(T4,s44)
% hold off
% title("Real Speed Signal with Ki=0 and Kp variable")
% axis manual;
% clickableLegend("Kp=2","Kp=20","Kp=50","Kp=0.2")
% xlabel("Temps (s)")
% ylabel("Magnitude")
% subplot(312)
% plot(Frequency1,Pxx1)
% hold on
% plot(Frequency2,Pxx2)
% hold on
% plot(Frequency3,Pxx3)
% hold on
% plot(Frequency4,Pxx4)
% hold off
% title("Power Spectrum of the Real Speed with Ki=0 and Kp variable")
% axis manual;
% clickableLegend("Kp=2","Kp=20","Kp=50","Kp=0.2")
% xlabel("Frequency (Hz)")
% ylabel("Power")
% subplot(313)
% plot(Frequency1,10*log10(Pxx1))
% hold on
% plot(Frequency2,10*log10(Pxx2))
% hold on
% plot(Frequency3,10*log10(Pxx3))
% hold on
% plot(Frequency4,10*log10(Pxx4))
% hold off
% axis manual;
% clickableLegend("Kp=2","Kp=20","Kp=50","Kp=0.2")
% xlabel("Frequency (Hz)")
% ylabel("Power (dB)")

%% PI speed controller tests - 8/04
% data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPI.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% subplot(311)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold off
% axis manual;
% clickableLegend("Real Speed Motor","Reference Speed")
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(312)
% plot(Time,data_lab.Kp)
% axis manual;
% clickableLegend("Kp")
% xlabel("Time (s)")
% subplot(313)
% plot(Time,data_lab.Kd)
% hold on
% plot(Time,data_lab.PICurrent_A_)
% hold off
% axis manual;
% clickableLegend("Ki","PICurrent (A)")
% xlabel("Time (s)")
% 
%% PI speed controller tests - 8/07
%data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPI2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
%data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPI3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPI4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
%data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPI5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
%data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPI6.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% subplot(311)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold off
% axis manual;
% clickableLegend("Real Speed Motor","Reference Speed")
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(312)
% plot(Time,data_lab.Kd)
% axis manual;
% clickableLegend("Ki")
% xlabel("Time (s)")
% subplot(313)
% plot(Time,data_lab.Kp)
% hold on
% plot(Time,data_lab.PICurrent_A_)
% hold off
% axis manual;
% clickableLegend("Kp","PICurrent (A)")
% xlabel("Time (s)")
% 
%% PI speed controller tests - 8/08
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPIB.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPIB2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataCU.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% data_lab = readtable('Logging_data\PI_speed_controller_tests\dataTT.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% subplot(311)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold off
% axis manual;
% clickableLegend("Real Speed Motor","Reference Speed")
% xlim([300 580])
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(312)
% plot(Time,data_lab.Kd)
% axis manual;
% clickableLegend("Ki")
% xlim([300 580])
% xlabel("Time (s)")
% subplot(313)
% plot(Time,data_lab.Kp)
% hold on
% plot(Time,data_lab.PICurrent_A_)
% hold off
% axis manual;
% clickableLegend("Kp","PICurrent (A)")
% xlim([300 580])
% xlabel("Time (s)")

%% PI speed controller tests - 8/09
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPIB2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPF.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPF2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPF3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPF4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPF5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPF6.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRPF7.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% subplot(311)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold off
% axis manual;
% clickableLegend("Real Speed Motor","Reference Speed")
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(312)
% plot(Time,data_lab.Kd)
% axis manual;
% clickableLegend("Ki")
% xlabel("Time (s)")
% subplot(313)
% plot(Time,data_lab.Kp)
% hold on
% plot(Time,data_lab.PICurrent_A_)
% hold off
% axis manual;
% clickableLegend("Kp","PICurrent (A)")
% xlabel("Time (s)")

% %% PI Red Bike Kp Tuning with Ki=0 - 8/10
% data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRBI.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% subplot(311)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold off
% axis manual;
% %xlim([130 176])
% clickableLegend("Real Speed Motor","Reference Speed")
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(312)
% plot(Time,data_lab.Kp)
% axis manual;
% %xlim([130 176])
% %ylim([0 3])
% clickableLegend("Kp")
% xlabel("Time (s)")
% subplot(313)
% plot(Time,data_lab.Ki)
% hold on
% plot(Time,data_lab.PICurrent_A_)
% hold off
% axis manual;
% %xlim([130 176])
% clickableLegend("Ki","PICurrent (A)")
% xlabel("Time (s)")
% 
% %% PI Red Bike Ki Tuning with Kp=2 - 8/10
% data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRBI2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% subplot(311)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold off
% axis manual;
% %xlim([252 430])
% clickableLegend("Real Speed Motor","Reference Speed")
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(312)
% plot(Time,data_lab.Ki)
% axis manual;
% %xlim([252 430])
% %ylim([0 2])
% clickableLegend("Ki")
% xlabel("Time (s)")
% subplot(313)
% plot(Time,data_lab.Kp)
% hold on
% plot(Time,data_lab.PICurrent_A_)
% hold off
% axis manual;
% %xlim([252 430])
% clickableLegend("Kp","PICurrent (A)")
% xlabel("Time (s)")
% 
% %% PI Red Bike great Tuning Kp=2 and Ki=0.5 - 8/10
% data_lab = readtable('Logging_data\PI_speed_controller_tests\dataRBI3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% subplot(311)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold off
% axis manual;
% clickableLegend("Real Speed Motor","Reference Speed")
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(312)
% plot(Time,data_lab.Ki)
% hold on
% plot(Time,data_lab.Kp)
% hold off
% axis manual;
% clickableLegend("Ki","Kp")
% xlabel("Time (s)")
% subplot(313)
% plot(Time,data_lab.PICurrent_A_)
% axis manual;
% clickableLegend("PICurrent (A)")
% xlabel("Time (s)")
% 
% %% Bumpless Transfer Tests - 8/11
% data_lab = readtable('Logging_data\PI_speed_controller_tests\dataBPT.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataBPT2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% subplot(311)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold off
% axis manual;
% clickableLegend("Real Speed Motor","Reference Speed")
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(312)
% plot(Time,data_lab.Ki)
% hold on
% plot(Time,data_lab.Kp)
% hold off
% axis manual;
% clickableLegend("Ki","Kp")
% xlabel("Time (s)")
% subplot(313)
% plot(Time,data_lab.PICurrent_A_)
% axis manual;
% clickableLegend("PICurrent (A)")
% xlabel("Time (s)")
% 
% %% Memory Remove Test - 8/11
% data_lab = readtable('Logging_data\PI_speed_controller_tests\dataME.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\PI_speed_controller_tests\dataME2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% subplot(311)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold off
% axis manual;
% clickableLegend("Real Speed Motor","Reference Speed")
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(312)
% plot(Time,data_lab.Ki)
% hold on
% plot(Time,data_lab.Kp)
% hold off
% axis manual;
% clickableLegend("Ki","Kp")
% xlabel("Time (s)")
% subplot(313)
% plot(Time,data_lab.PICurrent_A_)
% axis manual;
% clickableLegend("PICurrent (A)")
% xlabel("Time (s)")
% 
% %% PI Test Outside - 8/11
% %data_lab = readtable('Logging_data\Test_PI_11_08\data1.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\Test_PI_11_08\data2.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\Test_PI_11_08\data3.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\Test_PI_11_08\data4.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% %data_lab = readtable('Logging_data\Test_PI_11_08\data5.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% data_lab = readtable('Logging_data\Test_PI_11_08\data6.csv');Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% 
% N=length(data_lab.SpeedVESC_rad_s_);
% Time=0.01:0.01:N*0.01;
% figure();
% subplot(211)
% plot(Time,data_lab.SpeedVESC_rad_s_)
% hold on
% plot(Time,data_lab.SpeedReference_rad_s_)
% hold on
% plot(Time,data_lab.GPSVelocity_m_s_/0.35)
% hold off
% axis manual;
% clickableLegend("Real Speed Motor","Reference Speed","Real Speed GPS")
% ylabel("Speed (rad/s)")
% xlabel("Time (s)")
% title("PI Speed Control")
% subplot(212)
% plot(Time,data_lab.PICurrent_A_)
% axis manual;
% clickableLegend("PICurrent (A)")
% xlabel("Time (s)")

%% AstaZero All Test RB - 8/29

% Current Limit
% adress='Logging_data\Test_AstaZero_25_08\data\data13.csv'
% adress2='Logging_data\Test_AstaZero_25_08\Good\PI_RB_Fall.csv'

% Vesc Speed non equal to zero
adress='Logging_data\Test_AstaZero_25_08\data\data15.csv'
adress2='Logging_data\Test_AstaZero_25_08\data\data22.csv'

% Steering motor not responding
% adress='Logging_data\Test_AstaZero_25_08\data\data13.csv'
% adress2='Logging_data\Test_AstaZero_25_08\Good\PIGB2.csv'

% Speed controller working
% adress='Logging_data\Test_AstaZero_25_08\data\data39.csv'
% adress2='Logging_data\Test_AstaZero_25_08\Good\PIGB2.csv'

% adress='Logging_data\Test_AstaZero_25_08\data\data31.csv'

data_lab = readtable(adress);Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
data_lab2 = readtable(adress2);Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');

N=length(data_lab.SpeedVESC_rad_s_);
Time=0.01:0.01:N*0.01;
figure();
subplot(421)
plot(Time,data_lab.SpeedReference_rad_s_)
hold on
plot(Time,data_lab.SpeedVESC_rad_s_)
hold on
plot(Time,data_lab.GPSVelocity_m_s_/0.35)
hold on
plot(Time,data_lab.StateEstimateVelocity_m_s_/0.35)
hold off
axis manual;
clickableLegend("Reference Speed","Vesc Speed","GPS Speed","Kalman Speed")
ylabel("Speed (rad/s)")
xlabel("Time (s)")
title("AstaZero Red Bike")
subplot(423)
plot(Time,data_lab.PICurrent_A_)
axis manual;
clickableLegend("PI Current (A)")
xlabel("Time (s)")
subplot(425)
plot(Time,data_lab.Ki)
hold on
plot(Time,data_lab.Kp)
hold off
axis manual;
clickableLegend("Ki","Kp")
xlabel("Time (s)")
subplot(427)
plot(Time,data_lab.SteerrateInput_rad_s_)
hold on 
plot(Time,data_lab.steeringFlag)
hold off
axis manual;
clickableLegend("Steering Rate Input (rad/s)","Steering Flag")
xlabel("Time (s)")

N=length(data_lab2.SpeedVESC_rad_s_);
Time=0.01:0.01:N*0.01;
subplot(422)
plot(Time,data_lab2.SpeedReference_rad_s_)
hold on
plot(Time,data_lab2.SpeedVESC_rad_s_)
hold on
plot(Time,data_lab2.GPSVelocity_m_s_/0.35)
hold on
plot(Time,data_lab2.StateEstimateVelocity_m_s_/0.35)
hold off
axis manual;
clickableLegend("Reference Speed","Vesc Speed","GPS Speed","Kalman Speed")
ylabel("Speed (rad/s)")
xlabel("Time (s)")
title("AstaZero Red Bike")
subplot(424)
plot(Time,data_lab2.PICurrent_A_)
axis manual;
clickableLegend("PI Current (A)")
xlabel("Time (s)")
subplot(426)
plot(Time,data_lab2.Ki)
hold on
plot(Time,data_lab2.Kp)
hold off
axis manual;
clickableLegend("Ki","Kp")
xlabel("Time (s)")
subplot(428)
plot(Time,data_lab2.SteerrateInput_rad_s_)
hold on 
plot(Time,data_lab2.steeringFlag)
hold off
axis manual;
clickableLegend("Steering Rate Input (rad/s)","Steering Flag")
xlabel("Time (s)")

%% Test GPS - 8/30

adress='Logging_data\Test_AstaZero_25_08\Vesc Speed\dataGBT2.csv'
adress2='Logging_data\Test_AstaZero_25_08\Vesc Speed\dataRBT5.csv'

data_lab = readtable(adress);Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
data_lab2 = readtable(adress2);Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');

N=length(data_lab.SpeedVESC_rad_s_);
Time=0.01:0.01:N*0.01;
figure();
subplot(321)
plot(Time,data_lab.SpeedReference_rad_s_)
hold on
plot(Time,data_lab.SpeedVESC_rad_s_)
hold on
plot(Time,data_lab.StateEstimateVelocity_m_s_/0.35)
hold off
axis manual;
clickableLegend("Reference Speed","Vesc Speed","Kalman Speed")
ylabel("Speed (rad/s)")
xlabel("Time (s)")
title("Lab")
subplot(323)
plot(Time,data_lab.PICurrent_A_)
axis manual;
clickableLegend("PI Current (A)")
xlabel("Time (s)")
subplot(325)
plot(Time,data_lab.Ki)
hold on
plot(Time,data_lab.Kp)
hold off
axis manual;
clickableLegend("Ki","Kp")
xlabel("Time (s)")

N=length(data_lab2.SpeedVESC_rad_s_);
Time=0.01:0.01:N*0.01;
subplot(322)
plot(Time,data_lab2.SpeedReference_rad_s_)
hold on
plot(Time,data_lab2.SpeedVESC_rad_s_)
hold on
plot(Time,data_lab2.StateEstimateVelocity_m_s_/0.35)
hold off
axis manual;
clickableLegend("Reference Speed","Vesc Speed","Kalman Speed")
ylabel("Speed (rad/s)")
xlabel("Time (s)")
title("Lab")
subplot(324)
plot(Time,data_lab2.PICurrent_A_)
axis manual;
clickableLegend("PI Current (A)")
xlabel("Time (s)")
subplot(326)
plot(Time,data_lab2.Ki)
hold on
plot(Time,data_lab2.Kp)
hold off
axis manual;
clickableLegend("Ki","Kp")
xlabel("Time (s)")

%% Test Vesc- 8/31
adress='Logging_data\Test_AstaZero_25_08\Vesc Speed\dataGB1.csv'
data_lab = readtable(adress);Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');

N=length(data_lab.SpeedVESC_rad_s_);
Time=0.01:0.01:N*0.01;
figure();
subplot(311)
plot(Time,data_lab.SpeedReference_rad_s_)
hold on
plot(Time,data_lab.SpeedVESC_rad_s_)
hold on
plot(Time,data_lab.StateEstimateVelocity_m_s_/0.35)
hold off
axis manual;
clickableLegend("Reference Speed","Vesc Speed","Kalman Speed")
ylabel("Speed (rad/s)")
xlabel("Time (s)")
title("AstaZero Red Bike")
subplot(312)
plot(Time,data_lab.PICurrent_A_)
axis manual;
clickableLegend("PI Current (A)")
xlabel("Time (s)")
subplot(313)
plot(Time,data_lab.Ki)
hold on
plot(Time,data_lab.Kp)
hold off
axis manual;
clickableLegend("Ki","Kp")
xlabel("Time (s)")

%%

% % Load trajectory
% data_lab = readtable('data.csv');
% Table_traj = readtable('Traj_ref_test\trajectorymat_asta0_circle_3_l.csv');
% Table_traj = readtable('Traj_ref_test\trajectorymat_parking_turn_left_10.csv');
% Table_traj = readtable('trajectorymat_backstraight.csv');
% Table_traj(1,:) = [];
% 
% %% Select right measurements and input AND initialize
% % Converting GPS data to X and Y position
% % Setting X and Y to zero at first long/lat datapoint
% 
% % [data_lab_,data_lab_idx,data_lab_ic1] = unique(data_lab.StateEstimateX_m_,'stable');
% % data_lab = data_lab(data_lab_idx,:);
% 
% % Delete the data before reseting the trajectory and obtain X/Y position
% reset_traj = find(data_lab.ResetTraj==1,1,'last');
% data_lab(1:reset_traj,:) = [];
% longitude0 = deg2rad(11);
% latitude0 = deg2rad(57);
% Earth_rad = 6371000.0;
% 
% X = Earth_rad * (data_lab.LongGPS_deg_ - longitude0) * cos(latitude0);
% Y = Earth_rad * (data_lab.LatGPS_deg_ - latitude0);
% 
% % Obtain the relative time of the data
% data_lab.Time = (data_lab.Time_ms_- data_lab.Time_ms_(1))*0.001;
% 
% % Obtain the measurements
% ay = -data_lab.AccelerometerY_rad_s_2_;
% omega_x = data_lab.GyroscopeX_rad_s_;
% omega_z = data_lab.GyroscopeZ_rad_s_;
% delta_enc = data_lab.SteeringAngleEncoder_rad_;
% v_enc = data_lab.SpeedVESC_rad_s_*bike_params.r_wheel;
% v_GPS=data_lab.GPSVelocity_m_s_;
% 
% % Prepare measurement data for the offline kalman
% gps_init = find(data_lab.flag > gps_delay, 1 );
% measurementsGPS = [data_lab.Time X Y];
% measurementsGPS(1:gps_init,:) = [];
% X(1:gps_init) = [];
% Y(1:gps_init) = [];
% measurements = [data_lab.Time ay omega_x omega_z delta_enc v_enc];
% measurements(1,:) = [];
% steer_rate = [data_lab.Time data_lab.SteerrateInput_rad_s_];
% steer_rate(1,:) = [];
% gpsflag = [data_lab.Time data_lab.flag];
% 
% % Translate the trajectory to the point where is reseted
% GPS_offset_X = X(1) - Table_traj.Var1(1);
% GPS_offset_Y = Y(1) - Table_traj.Var2(1);
% Table_traj.Var1(:) = Table_traj.Var1(:) + GPS_offset_X;
% Table_traj.Var2(:) = Table_traj.Var2(:) + GPS_offset_Y;
% 
% % Initial Roll
%         initial_state.roll = deg2rad(0);
%         initial_state.roll_rate = deg2rad(0);
% % Initial Steering
%         initial_state.steering = deg2rad(0);
% % Initial Pose (X,Y,theta)
%         initial_state.x = Table_traj.Var1(1);
%         initial_state.y = Table_traj.Var2(1);
%         initial_state.heading = Table_traj.Var3(1);
%         initial_pose = [initial_state.x; initial_state.y; initial_state.heading];
%         initial_state_estimate = initial_state;
% 
% %% mirror sample times
% %this part is used to check logging sample time
% %logging
% sampletime_diff_log = diff(data_lab.Time);
% 
% %state estimator
% sampletime_it_filter = diff(data_lab.StateEstimatorIterations);
% sampletime_diff_filter = sampletime_diff_log./sampletime_it_filter;
% 
% %trajectory
% sampletime_it_traj = diff(data_lab.TrajectoryIterations);
% sampletime_diff_traj = sampletime_diff_log./sampletime_it_traj;
% 
% %GPS
% % sampletime_logGPS = NaN(length(data_lab.Time)-1,1);
% Flag_new=unique(data_lab.flag,'row','stable');
% 
% for i = 1:size(Flag_new)
%      time_index(i)=find((data_lab.flag(:)==Flag_new(i)),1,'first');
%      sampletime_logGPS(i)=data_lab.Time(time_index(i))';
% end
% 
% sampletime_it_GPS_short = diff(Flag_new);
% sampletime_diff_logGPS=diff(sampletime_logGPS);
% sampletime_diff_GPS = sampletime_diff_logGPS'./sampletime_it_GPS_short;
% 
% sampletime_diff_GPS_N=NaN(length(data_lab.Time)-1,1);
% for i = 1:(size(Flag_new)-1)
%      time_index(i)=find((data_lab.flag(:)==Flag_new(i)),1,'first');
%     sampletime_diff_GPS_N(time_index(i))=sampletime_diff_GPS(i);
% end
% 
% %% Kalman Filter
% % A matrix (linear bicycle model with constant velocity)
% % Est_States := [X Y psi phi phi_dot delta v]
% A = [0 0 0 0 0 0 1;
%      0 0 v 0 0 v*(lr/(lf+lr))*sin(lambda) 0;
%      0 0 0 0 0 (v/(lr+lf))*sin(lambda) 0;
%      0 0 0 0 1 0 0;
%      0 0 0 (g/h) 0 ((v^2/h)-(g*lr*c/(h^2*(lr+lf))))*sin(lambda) 0;
%      0 0 0 0 0 0 0;
%      0 0 0 0 0 0 0];
% 
% % B matrix (linear bicycle model with constant velocity)
% B = [0 0 0 0 ((v*lr)/(h*(lr+lf))) 1 0]';
% 
% % Including GPS
% C1 = [1 0 0 0 0 0 0;
%      0 1 0 0 0 0 0;
%      0 0 0 -g+((-h_imu*g)/h) 0 (-h_imu*(h*v^2-(g*lr*c)))*sin(lambda)/((lr+lf)*h^2) + (v^2)*sin(lambda)/(lr+lf) 0;
%      0 0 0 0 1 0 0;
%      0 0 0 0 0 (v)*sin(lambda)/(lr+lf) 0;
%      0 0 0 0 0 1 0;
%      0 0 0 0 0 0 1];
% 
% D1 = [0 0 (-h_imu*lr*v)/((lr+lf)*h) 0 0 0 0]';
% 
% % Excluding GPS
% C2 = [(-g+((-h_imu*g)/h)) 0 (-h_imu*(h*v^2-(g*lr*c)))*sin(lambda)/((lr+lf)*h^2)+(v^2)*sin(lambda)/(lr+lf) 0;
%       0 1 0 0;
%       0 0 (v)*sin(lambda)/(lr+lf) 0;
%       0 0 1 0;
%       0 0 0 1];
% 
% D2 = [(-h_imu*lr*v)/((lr+lf)*h) 0 0 0 0]';
% 
% % Discretize the model
% A_d = (eye(size(A))+Ts*A);
% B_d = Ts*B;
% 
% %% Comparing different Q R
% 
% % Load Q and R matrices
% load('Q_and_R_backup_red_bike.mat');
% 
% % Compute Kalman Gain
%     % including GPS
%     [P1,Kalman_gain1,eig_K] = idare(A_d',C1',Q,R,[],[]);
%     eig1_K = abs(eig_K);
%     Kalman_gain1 = Kalman_gain1';
%     Ts_GPS = 0.1; % sampling rate of the GPS
%     counter = (Ts_GPS / Ts) - 1 ; % Upper limit of the counter for activating the flag 
% 
% % Polish the kalman gain (values <10-5 are set to zero)
% for i = 1:size(Kalman_gain1,1)
%     for j = 1:size(Kalman_gain1,2)
%         if abs(Kalman_gain1(i,j)) < 10^-5
%             Kalman_gain1(i,j) = 0;
%         end
%     end
% end 
% 
% % Kalman_gain excluding GPS
% Kalman_gain2 = Kalman_gain1(4:7,3:7);
% 
% %save matrices
% matrixmat = [A_d; B_d'; C1; D1';Kalman_gain1];
% 
% filename_matrix = 'matrixmat.csv'; % Specify the filename
% csvwrite(filename_matrix, matrixmat); % Write the matrix to the CSV file
% 
% %% Offline Simulation
% sim_time = data_lab.Time(end);
% 
% tic
% try Results2 = sim(model);
%     catch error_details %note: the model has runned for one time here
% end
% toc
% 
% %% Plot results
% 
% if selector == 0
%         start_point = 2500;
%         end_point = length(measurementsGPS)-1;
%        elseif selector == 1
%              start_point=find(data_lab.steeringFlag==1,1,'first');
%              end_point = length(measurementsGPS)-1;
%         elseif selector == 2
%             start_point = 1;
%             end_point = length(measurementsGPS)-1;
% end
% 
% %labview data
% fig = figure();
% plot3(Results2.sim_Kalman.Data(start_point:end_point,1) - X(1), Results2.sim_Kalman.Data(start_point:end_point,2) - Y(1),Results2.sim_Kalman.Time(start_point:end_point))
% hold on
% plot3(data_lab.StateEstimateX_m_(start_point:end_point) - X(1) ,data_lab.StateEstimateY_m_(start_point:end_point) - Y(1),data_lab.Time(start_point:end_point))
% plot3(measurementsGPS(start_point:end_point,2) - X(1),measurementsGPS(start_point:end_point,3) - Y(1),data_lab.Time(start_point:end_point))
% plot3(Table_traj.Var1(:) - X(1),Table_traj.Var2(:) - Y(1),1:length(Table_traj.Var1(:)))
% view(0,90)
% % % plot(Results2.sim_Kalman.Data(start_point:end_point,1) - X(1), Results2.sim_Kalman.Data(start_point:end_point,2) - Y(1))
% % % hold on
% % % plot3(data_lab.StateEstimateX_m_(start_point:end_point) - X(1) ,data_lab.StateEstimateY_m_(start_point:end_point) - Y(1))
% % % plot3(measurementsGPS(start_point:end_point,2) - X(1),measurementsGPS(start_point:end_point,3) - Y(1))
% % % plot3(Table_traj.Var1(:) - X(1),Table_traj.Var2(:) - Y(1))
% xlabel('X position (m)')
% ylabel('Y position (m)')
% axis equal
% grid on
% legend('offline Kalman estimation', 'online estimation', 'GPS measurements','trajectory')
% title('Comparison with Kalman estimator on bike')
% 
% fig = figure();
% subplot(421)
% plot(Results2.sim_Kalman.Time(start_point:end_point),Results2.sim_Kalman.Data(start_point:end_point,1)-measurementsGPS(1,2))
% hold on
% plot(data_lab.Time(start_point:end_point), data_lab.StateEstimateX_m_(start_point:end_point)-measurementsGPS(1,2))
% plot(measurementsGPS(start_point:end_point,1),measurementsGPS(start_point:end_point,2)-measurementsGPS(1,2))
% xlabel('Time (s)')
% ylabel('X position (m)')
% grid on
% legend('offline Kalman estimation Tuned R', 'Online estimation','GPS measurements')
% title('Comparison with Kalman estimator on bike')
% 
% subplot(423)
% plot(Results2.sim_Kalman.Time(start_point:end_point), Results2.sim_Kalman.Data(start_point:end_point,2)-measurementsGPS(1,3))
% hold on
% plot(data_lab.Time(start_point:end_point), data_lab.StateEstimateY_m_(start_point:end_point)-measurementsGPS(1,3))
% plot(measurementsGPS(start_point:end_point,1),measurementsGPS(start_point:end_point,3)-measurementsGPS(1,3))
% xlabel('Time (s)')
% ylabel('Y position (m)')
% grid on
% legend('offline Kalman estimation Tuned R', 'Online estimation','GPS measurements')
% 
% subplot(425)
% plot(Results2.sim_Kalman.Time(start_point:end_point), rad2deg(Results2.sim_Kalman.Data(start_point:end_point,3)))
% hold on
% plot(data_lab.Time(start_point:end_point), rad2deg(wrapToPi(data_lab.StateEstimatePsi_rad_(start_point:end_point))))
% xlabel('Time (s)')
% ylabel('heading (deg)')
% grid on
% legend('offline Kalman estimation Tuned R', 'Online estimation')
% 
% subplot(422)
% plot(Results2.sim_Kalman.Time(start_point:end_point), rad2deg(Results2.sim_Kalman.Data(start_point:end_point,4)))
% hold on
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.StateEstimateRoll_rad_(start_point:end_point)))
% % balancing_ref = zeros(length(measurementsGPS)-1,1);
% % plot(data_lab.Time(start_point:end_point),balancing_ref(start_point:end_point))
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.Input(start_point:end_point)))
% % plot(Results2.integration_rollrate.Time(start_point:end_point), rad2deg(Results2.integration_rollrate.Data(start_point:end_point)))
% % s=size(data_lab.Time(start_point:end_point));
% % Zero=zeros(s(1),s(2));
% % plot(data_lab.Time(start_point:end_point),Zero)
% xlabel('Time (s)')
% ylabel('Roll (deg)')
% grid on
% legend('offline Kalman estimation Tuned R', 'Online estimation','rollref','Integration Rollrate')
% title('Comparison with Kalman estimator on bike')
% 
% subplot(424)
% plot(Results2.sim_Kalman.Time(start_point:end_point), rad2deg(Results2.sim_Kalman.Data(start_point:end_point,5)))
% hold on
% plot(data_lab.Time(start_point:end_point), rad2deg(data_lab.StateEstimateRollrate_rad_s_(start_point:end_point)))
% plot(data_lab.Time(start_point:end_point), rad2deg(data_lab.GyroscopeX_rad_s_(start_point:end_point)))
% xlabel('Time (s)')
% ylabel('Roll Rate (deg/s)')
% grid on
% legend('offline Kalman estimation Tuned R', 'Online estimation', 'Measurement')
% 
% subplot(426)
% plot(Results2.sim_Kalman.Time(start_point:end_point),rad2deg(Results2.sim_Kalman.Data(start_point:end_point,6)))
% hold on
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.StateEstimateDelta_rad_(start_point:end_point)))
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.SteeringAngleEncoder_rad_(start_point:end_point)))
% xlabel('Time (s)')
% ylabel('Steering Angle (deg)')
% grid on
% legend('offline Kalman estimation Tuned R', 'Online estimation', 'Measurement')
% 
% subplot(428)
% plot(Results2.sim_Kalman.Time(start_point:end_point), Results2.sim_Kalman.Data(start_point:end_point,7))
% hold on
% plot(data_lab.Time(start_point:end_point), data_lab.StateEstimateVelocity_m_s_(start_point:end_point))
% plot(data_lab.Time(start_point:end_point), v_enc(start_point:end_point))
% plot(data_lab.Time(start_point:end_point), v_GPS(start_point:end_point))
% xlabel('Time (s)')
% ylabel('velocity (m/s)')
% ylim([-1 5])
% grid on
% legend('offline Kalman estimation Tuned R', 'Online estimation','Vesc Measurement','GPS Measurement')
% 
% % figure
% % data_lab_1.Time = (data_lab_1.Time_ms_- data_lab_1.Time_ms_(1))*0.001;
% % plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.SteeringAngleEncoder_rad_(start_point:end_point)))
% % hold on
% % start_point=find(data_lab_1.steeringFlag==1,1,'first');
% % end_point = length(measurementsGPS)-1;
% % plot(data_lab_1.Time(start_point:end_point),rad2deg(data_lab_1.SteeringAngleEncoder_rad_(start_point:end_point)))
% % xlabel('Time (s)')
% % ylabel('Steering Angle (deg)')
% % grid on
% % legend('test 1', 'test 2')
% 
% figure
% subplot(221)
% plot(Results2.y_hat.Time(start_point:end_point),Results2.y_hat.Data(start_point:end_point,1))
% hold on
% plot(measurements(start_point:end_point,1),measurements(start_point:end_point,2))
% xlabel('Time (s)')
% ylabel(' (m/s^2)')
% title('a_y')
% grid on
% legend('prediction','meas')
% 
% subplot(222)
% plot(Results2.y_hat.Time(start_point:end_point),rad2deg(Results2.y_hat.Data(start_point:end_point,2)))
% hold on
% plot(measurements(start_point:end_point,1),rad2deg(measurements(start_point:end_point,3)))
% xlabel('Time (s)')
% ylabel(' (deg/s)')
% title('w_x')
% grid on
% legend('prediction','meas')
% 
% subplot(223)
% plot(Results2.y_hat.Time(start_point:end_point),rad2deg(Results2.y_hat.Data(start_point:end_point,3)))
% hold on
% plot(measurements(start_point:end_point,1),rad2deg(measurements(start_point:end_point,4)))
% xlabel('Time (s)')
% ylabel(' (deg/s)')
% title('w_z')
% grid on
% legend('prediction','meas')
% 
% subplot(224)
% plot(Results2.y_hat.Time(start_point:end_point),Results2.y_hat.Data(start_point:end_point,4))
% hold on
% plot(measurements(start_point:end_point,1),measurements(start_point:end_point,6))
% plot(data_lab.Time(start_point:end_point), v_GPS(start_point:end_point))
% xlabel('Time (s)')
% ylabel(' (m/s)')
% title('velocity')
% ylim([-1 5])
% grid on
% legend('prediction','meas Vesc', 'meas GPS')
% 
% % figure(100)
% % plot(measurements(start_point:end_point,1),rad2deg(data_lab.GyroscopeY_rad_s_(start_point:end_point)))
% % xlabel('Time (s)')
% % ylabel(' (deg/s)')
% % title('w_y')
% % grid on
% 
% % sum of contributions in traj_controller
% sum_cont = rad2deg(data_lab.DpsirefContribution)+rad2deg(data_lab.HeadingContribution)+rad2deg(data_lab.LateralContribution);
% 
% figure()
% subplot(321)
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.Rollref(start_point:end_point)))
% hold on
% plot(data_lab.Time(start_point:end_point),sum_cont(start_point:end_point))
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.StateEstimateDelta_rad_(start_point:end_point)))
% grid on
% xlabel('Time (s)')
% ylabel('Angle(deg)')
% title('roll vs delta references')
% legend('Rollreference','deltaref','steering angle')
% 
% 
% subplot(322)
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.LateralContribution(start_point:end_point)))
% hold on
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.HeadingContribution(start_point:end_point)))
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.DpsirefContribution(start_point:end_point)))
% plot(data_lab.Time(start_point:end_point),sum_cont(start_point:end_point))
% xlabel('Time (s)')
% ylabel('Angle(deg)')
% title('delta contributions')
% grid on
% legend('lateral','heading','dpsi','deltaref')
% 
% subplot(323)
% plot(data_lab.Time(start_point:end_point),data_lab.Error1(start_point:end_point))
% xlabel('Time (s)')
% ylabel('error1 (m)')
% grid on
% title('Lateral error')
% 
% subplot(324)
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.Error2(start_point:end_point)))
% xlabel('Time (s)')
% ylabel('error2 [Deg]')
% grid on
% title('Heading error')
% 
% subplot(325)
% plot(data_lab.Time(start_point:end_point),data_lab.Closestpoint(start_point:end_point))
% xlabel('Time (s)')
% ylabel('Closest point [-]')
% grid on
% title('closest point')
% 
% figure()
% subplot(211)
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.SteerrateInput_rad_s_(start_point:end_point)))
% hold on
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.Input(start_point:end_point)))
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.Rollref(start_point:end_point)))
% xlabel('Time (s)')
% ylabel('Angle [Deg]')
% grid on
% legend('Steerrate from balancing controller','Input balancing controller (generated rollref)','output traj controller')
% title('Balance controller')
% 
% subplot(212) 
% plot(data_lab.Time(start_point:end_point),sum_cont(start_point:end_point))
% hold on
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.StateEstimateDelta_rad_(start_point:end_point)))
% plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.SteeringAngleEncoder_rad_(start_point:end_point)))
% title('Comparison of steering angles')
% xlabel('Time (s)')
% ylabel('Angle [Deg]')
% grid on
% legend('Delta ref','Estimated Delta','Measured Delta')
% 
% figure()
% scatter(1:length(data_lab.Time)-1,sampletime_diff_log)
% hold on
% scatter(1:length(data_lab.Time)-1,sampletime_diff_filter)
% scatter(1:length(data_lab.Time)-1,sampletime_diff_traj,'*')
% scatter(1:length(data_lab.Time)-1,sampletime_diff_GPS_N,'*')
% legend('Logging Ts','State estimator Ts','Trajectory Ts','GPS data Ts')
% title('average iteration times')
% xlabel('Time (s)')
% ylabel('Ts [s]')

