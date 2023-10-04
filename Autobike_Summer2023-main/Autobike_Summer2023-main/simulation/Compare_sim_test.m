clear all;
close all;
clc;

%% Load data

sim_data = readtable("bikedata_simulation.csv");
data_lab = readtable('Logging_data\Test_session_14_06\data_8.csv');
Table_traj = readtable('Traj_ref_test\trajectorymat_parking_line.csv');

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

% Starting point of simulation in the test
start_time = 23.66;

%% Prepare data for ploting

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

% Make the time from the simulation and test match
sim_data.Time(:,1) = sim_data.Time(:,1) + start_time;

%% Plot 

if selector == 0
        start_point = 2400;
        end_point = length(measurementsGPS)-1;
       elseif selector == 1
             start_point=find(data_lab.steeringFlag==1,1,'first');
             end_point = length(measurementsGPS)-1;
        elseif selector == 2
            start_point = 1;
            end_point = length(measurementsGPS)-1;
end

% Trajectory
fig = figure();
plot3(sim_data.X_estimated(:,1), sim_data.Y_estimated(:,1),sim_data.Time(:,1))
hold on
plot3(data_lab.StateEstimateX_m_(start_point:end_point) - X(1) ,data_lab.StateEstimateY_m_(start_point:end_point) - Y(1),data_lab.Time(start_point:end_point))
plot3(measurementsGPS(start_point:end_point,2) - X(1),measurementsGPS(start_point:end_point,3) - Y(1),data_lab.Time(start_point:end_point),'*')
plot3(Table_traj.Var1(:) - X(1),Table_traj.Var2(:) - Y(1),1:length(Table_traj.Var1(:)))
view(0,90)
xlabel('X position (m)')
ylabel('Y position (m)')
axis equal
legend('Estimated sim','Estimated test','Measurements','Trajectory ref');
title('Trajectory')

% States
fig = figure();
subplot(421)
plot(sim_data.Time(:,1),sim_data.X_estimated(:,1))
hold on
plot(data_lab.Time(start_point:end_point), data_lab.StateEstimateX_m_(start_point:end_point)-measurementsGPS(1,2))
plot(measurementsGPS(start_point:end_point,1),measurementsGPS(start_point:end_point,2)-measurementsGPS(1,2))
xlabel('Time (s)')
ylabel('X position (m)')
grid on
legend('Simulation', 'Online estimation','GPS measurements')

subplot(423)
plot(sim_data.Time(:,1),sim_data.Y_estimated(:,1))
hold on
plot(data_lab.Time(start_point:end_point), data_lab.StateEstimateY_m_(start_point:end_point)-measurementsGPS(1,3))
plot(measurementsGPS(start_point:end_point,1),measurementsGPS(start_point:end_point,3)-measurementsGPS(1,3))
xlabel('Time (s)')
ylabel('Y position (m)')
grid on
legend('Simulation', 'Online estimation','GPS measurements')

subplot(425)
plot(sim_data.Time(:,1), rad2deg(wrapToPi(sim_data.Psi_estimated(:,1))))
hold on
plot(data_lab.Time(start_point:end_point), rad2deg(wrapToPi(data_lab.StateEstimatePsi_rad_(start_point:end_point))))
xlabel('Time (s)')
ylabel('heading (deg)')
grid on
legend('Simulation', 'Online estimation')

subplot(422)
plot(sim_data.Time(:,1), rad2deg(sim_data.Roll_estimated(:,1)))
hold on
plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.StateEstimateRoll_rad_(start_point:end_point)))
plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.Input(start_point:end_point)))
plot(sim_data.Time(:,1),rad2deg(sim_data.ref_roll(:,1)))
xlabel('Time (s)')
ylabel('Roll (deg)')
grid on
legend('Simulation', 'Online estimation','rollref est','rollref sim')

subplot(424)
plot(sim_data.Time(:,1), rad2deg(sim_data.Rollrate_estimated(:,1)))
hold on
plot(data_lab.Time(start_point:end_point), rad2deg(data_lab.StateEstimateRollrate_rad_s_(start_point:end_point)))
plot(data_lab.Time(start_point:end_point), rad2deg(data_lab.GyroscopeX_rad_s_(start_point:end_point)))
xlabel('Time (s)')
ylabel('Roll Rate (deg/s)')
grid on
legend('simulation', 'Online estimation', 'Measurement')

subplot(426)
plot(sim_data.Time(:,1), rad2deg(sim_data.Delta_estimated(:,1)))
hold on
plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.StateEstimateDelta_rad_(start_point:end_point)))
plot(data_lab.Time(start_point:end_point),rad2deg(data_lab.SteeringAngleEncoder_rad_(start_point:end_point)))
xlabel('Time (s)')
ylabel('Steering Angle (deg)')
grid on
legend('simulation', 'Online estimation', 'Measurement')

subplot(428)
plot(sim_data.Time(:,1), sim_data.Velocity_estimated(:,1))
hold on
plot(data_lab.Time(start_point:end_point), data_lab.StateEstimateVelocity_m_s_(start_point:end_point))
plot(data_lab.Time(start_point:end_point), v_enc(start_point:end_point))
plot(data_lab.Time(start_point:end_point), v_GPS(start_point:end_point))
xlabel('Time (s)')
ylabel('velocity (m/s)')
ylim([-1 5])
grid on
legend('simulation', 'Online estimation','Vesc Measurement','GPS Measurement')

% Delta contributions
test = rad2deg(-0.008944 .* sign(data_lab.Error1(:,1)) .* min(abs(data_lab.Error1(:,1)),5.66548));
figure()
subplot(311)
hold on;
plot(sim_data.Time(:,1),rad2deg(sim_data.delta_e1(:,1)));
plot(data_lab.Time(start_point:end_point,1),rad2deg(data_lab.LateralContribution(start_point:end_point,1)));
% plot(data_lab.Time(start_point:end_point,1),test(start_point:end_point,1));
xlabel('Time [t]')
ylabel('Angle [Deg]')
legend('simulation','Onlime estimation','test','Location','southeast')
grid on
title('lateral error contribution')

subplot(312)
plot(sim_data.Time(:,1),rad2deg(sim_data.delta_e2(:,1)));
hold on
plot(data_lab.Time(start_point:end_point,1),rad2deg(data_lab.HeadingContribution(start_point:end_point,1)));
xlabel('Time [t]')
ylabel('Angle [Deg]')
legend('simulation','Onlime estimation','Location','southeast')
grid on
title('Heading error contribution')

subplot(313)
plot(sim_data.Time(:,1),rad2deg(sim_data.delta_psi(:,1)));
hold on
plot(data_lab.Time(start_point:end_point,1),rad2deg(data_lab.DpsirefContribution(start_point:end_point,1)));
xlabel('Time [t]')
ylabel('Angle [Deg]')
legend('simulation','Onlime estimation','Location','southeast')
grid on
title('Dpsiref contribution')

% Compare delta_ref and roll_ref
sum_cont = rad2deg(data_lab.DpsirefContribution)+rad2deg(data_lab.HeadingContribution)+rad2deg(data_lab.LateralContribution);
figure();
subplot(211)
hold on;
plot(sim_data.Time(:,1),rad2deg(sim_data.delta_ref(:,1)));
plot(data_lab.Time(start_point:end_point,1),sum_cont(start_point:end_point,1));
xlabel('Time [t]')
ylabel('Angle [Deg]')
legend('simulation','online estimation','Location','southeast')
grid on
title('Delta_{ref}')

subplot(212)
hold on;
plot(sim_data.Time(:,1),rad2deg(sim_data.ref_roll(:,1)));
plot(data_lab.Time(start_point:end_point,1),rad2deg(data_lab.Rollref(start_point:end_point,1)));
xlabel('Time [t]')
ylabel('Angle [Deg]')
legend('simulation','online estimation','Location','southeast')
grid on
title('Roll_{ref}')

% Lateral and heading error
figure();
subplot(211)
hold on;
plot(sim_data.Time(:,1),sim_data.error1(:,1));
plot(data_lab.Time(start_point:end_point,1),data_lab.Error1(start_point:end_point,1));
xlabel('Time [t]')
ylabel('Distance [m]')
legend('simulation','online estimation','Location','southeast')
grid on
title('Lateral error')

subplot(212)
hold on;
plot(sim_data.Time(:,1),rad2deg(sim_data.error2(:,1)));
plot(data_lab.Time(start_point:end_point,1),rad2deg(data_lab.Error2(start_point:end_point,1)));
xlabel('Time [t]')
ylabel('Angle [Deg]')
legend('simulation','online estimation','Location','southeast')
grid on
title('Heading error')




