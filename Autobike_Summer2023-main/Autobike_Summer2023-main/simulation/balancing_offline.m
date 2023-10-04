clear all;
clc;
close all;

%% Params
% Name of the model
        model = 'balancing_offline_sim';
    % Sampling Time
        Ts = 0.01; 
    % Open the Simulink Model
        open([model '.slx']);
    % Choose the solver
        set_param(model,'AlgebraicLoopSolver','TrustRegion');

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

% Outer loop -- Roll Tracking
P_balancing_outer = 2;
I_balancing_outer = 0.0;
D_balancing_outer = 0.0;

% Inner loop -- Balancing
P_balancing_inner = 3.5;
I_balancing_inner = 0;
D_balancing_inner = 0;  

%% Load data
data_lab = readtable('Logging_data\Test_session_09_06\data_2.csv');
Table_traj = readtable('Traj_ref_test\trajectorymat_foot_line.csv');

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
v_GPS=data_lab.GPSVelocity_m_s_;

% Prepare measurement data for the offline kalman
gps_init = find(data_lab.flag > gps_delay, 1 );
measurementsGPS = [data_lab.Time X Y];
measurementsGPS(1:gps_init,:) = [];
X(1:gps_init) = [];
Y(1:gps_init) = [];
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

roll_est = data_lab.StateEstimateRoll_rad_;
roll_rate_est = data_lab.StateEstimateRollrate_rad_s_;

%% Simulation
sim_time = data_lab.Time(end);

tic
try results = sim(model);
    catch error_details %note: the model has runned for one time here
end
toc

%% Ploting
if selector == 0
        start_point = 1781;
        end_point = length(measurementsGPS)-1;
       elseif selector == 1
             start_point=find(data_lab.steeringFlag==1,1,'first');
             end_point = length(measurementsGPS)-1;
        elseif selector == 2
            start_point = 1;
            end_point = length(measurementsGPS)-1;
end

figure();
plot(data_lab.Time(start_point:end_point), data_lab.SteerrateInput_rad_s_(start_point:end_point))
hold on;
plot(results.steer_rate_sim.Time(:),results.steer_rate_sim.Data(:,1))
xlabel('Time [s]')
ylabel('[deg/s]')
legend('online estimation','simulation')
title('comparison between online and offline steer_rate')


avg = mean(results.steer_rate_sim.Data(:,1))

