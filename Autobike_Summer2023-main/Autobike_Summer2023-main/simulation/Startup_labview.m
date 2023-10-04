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
% Sampling Time
    Ts = 0.01; 
% Constant Speed [m/s]
    v = 3;    
% Choose The Bike - Options: 'red' or 'black'
    bike = 'red';
% Load the parameters of the specified bicycle
    bike_params = LoadBikeParameters(bike);
% Trajectory Record : 
    % 0 : just visualize the trajectory or apply offset, vizualize an
    % existing trajectory
    % 1 : using measurement data GPS as trajectory
    % 2 : create a new trajectory with trajectory_creator
    % 3 : use an aleardy prepared reference trajectoty, typically  by
    % option 1 or 2.
TrajectoryRecord = 0;

% Trajectory offset
offset_X = 0;
offset_Y = 0;
offset_Psi = deg2rad(0); % isn't psi ref given by X and y ref? does it make sense to have an offset? Has the this been tested in simulation?

% Calculate starting point in case of creating your own trajectory
long_start = deg2rad(57);
lat_start = deg2rad(11);

%% Trajectory creator

% Recorded trajectory
if TrajectoryRecord == 1
data_lab = readtable('data.csv');
longitude0 = deg2rad(11);
latitude0 = deg2rad(57);
Earth_rad = 6371000.0;
X = Earth_rad * (data_lab.LongGPS_deg_ - longitude0) * cos(latitude0);
Y = Earth_rad * (data_lab.LatGPS_deg_ - latitude0);

% XY = unique([X Y],'rows');
XY = unique([X Y],'rows','stable');
n = length(XY);

psiref = atan2(XY(2:n,2)-XY(1:n-1,2),XY(2:n,1)-XY(1:n-1,1));
traj_or_rec = [XY [psiref(1);psiref]];
traj_or_rec(1:3,:) = []; 

filename_trajectory = 'trajectorymat.csv';
dlmwrite( filename_trajectory, traj_or_rec, 'delimiter', ',', 'precision', 10);


elseif TrajectoryRecord == 2
longitude0 = deg2rad(11);
latitude0 = deg2rad(57);
Earth_rad = 6371000.0;
X = Earth_rad * (long_start - longitude0) * cos(latitude0);
Y = Earth_rad * (lat_start - latitude0);
TrajectoryCreator()
disp('X start = ') 
disp(X)
disp('Y start = ')
disp(Y)
disp('Create your trajectory and press a key to continue !')
pause
end
% now XY psi is stored in trajectorymat.csv

% Correct the trajectory if necessary
trajectory = readtable('trajectorymat.csv');
traj_or = table2array(trajectory);
traj_or = traj_or';

n = length(traj_or(1,:));

psiref = atan2(traj_or(2,2:n)-traj_or(2,1:n-1),traj_or(1,2:n)-traj_or(1,1:n-1));
traj_or = [traj_or(1,:); traj_or(2,:); psiref(1) psiref]';

traj(:,1) = traj_or(:,1) + offset_X;
traj(:,2) = traj_or(:,2) + offset_Y;
traj(:,3) = traj_or(:,3) + offset_Psi;

GPSXY = traj(:,1:2)-traj(2,1:2);
RotGPS = [cos(offset_Psi) sin(offset_Psi); -sin(offset_Psi) cos(offset_Psi)];
traj(:,1:2) = (GPSXY*RotGPS)+traj(2,1:2);

%% Trajectory test, tests for "untypical" features you probably don't want to have in the trajectory.

test_traj(traj,Ts,v);

%% Visualize the trajectory
figure()
plot(traj_or(2:end,1)-traj_or(2,1),traj_or(2:end,2)-traj(2,2))
hold on
plot(traj(2:end,1)-traj(2,1),traj(2:end,2)-traj(2,2))
xlabel('X position (m)')
ylabel('Y position (m)')
axis equal
grid on
legend('Original trajectory', 'adjusted trajectory')
title('Trajectory')

% index = find(traj(3:end,3)==0);
% index = index + 2;
% traj(index(1),:) = [];
% traj(index(2)-1,:) = [];

%% Save the trajectory
filename_trajectory = 'trajectorymat.csv'; % Specify the filename
dlmwrite( filename_trajectory, traj, 'delimiter', ',', 'precision', 10);

%% Initial states
% Initial states
initial_X = traj(2,1);
initial_Y = traj(2,2);
initial_Psi = traj(2,3);
initial_roll = deg2rad(0);
initial_roll_rate = deg2rad(0);
initial_delta = deg2rad(0);
initial_v = 0;

initial_states = [initial_X,initial_Y,initial_Psi, initial_roll, initial_roll_rate, initial_delta, initial_v];

%% Unpacked bike_params
h = bike_params.h;
lr = bike_params.lr;
lf = bike_params.lf; 
lambda = bike_params.lambda;
c = bike_params.c;
m = bike_params.m;
h_imu = bike_params.IMU_height; 
r_wheel = bike_params.r_wheel; 

%% Balancing Controller

% Outer loop -- Roll Tracking
P_balancing_outer = 3.75;
I_balancing_outer = 0.0;
D_balancing_outer = 0.0;

% Inner loop -- Balancing
P_balancing_inner = 3.5;
I_balancing_inner = 0;
D_balancing_inner = 0;  

%% The LQR controller for lateral controller
% model of lateral error  
A_con=[0 v;0 0];
B_con=[lr*v/(lr+lf);v/(lr+lf)];

%  kk=0.000000010;
%  kk=2.581e-7;
%  kk=9e-7;
 kk=6e-7;
%  Q=kk*[100 0;0 1000];
 Q=kk*[1000 0;0 100];
 R=0.2;
%  R=0.5;
 [K,S,e] = lqr(A_con,B_con,Q,R);
 k1=K(1);
 k2=K(2);


e2_max=deg2rad(30);% Here is the e2_max we used to calculate e1_max
e1_max=abs(-k2*e2_max/k1); % k1,k2 has been known, so we can calculate e1_max

%% Transfer function for heading in wrap traj
%feed forward trasfer function for d_psiref to steering reference (steering contribution for heading changes)
num = 1;
den = [lr/(lr+lf), v/(lr+lf)];
[A_t, B_t, C_t, D_t] = tf2ss(num,den);

% Discretize the ss
Ad_t = (eye(size(A_t))+Ts*A_t);
Bd_t = B_t*Ts;

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

% Select the Q and R tuning depending on the bike(run the% Kalman_Q_R_tuner)
load('Q_and_R_backup_red_bike.mat');

% Compute Kalman Gain
    % including GPS
    [P1,Kalman_gain1,eig] = idare(A_d',C1',Q,R,[],[]);
    eig1 = abs(eig);
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

%% Load params to labview

% Matrix (3,7) of parameters
params = zeros(3,7);
params(1,1) = bike_params.steer_motor_gear_rat;
params(1,2) = bike_params.steer_pully_gear_rat;
params(1,3) = bike_params.steer_enc_CPR;
params(1,4) = bike_params.steer_motor_max_RPM;
params(1,5) = bike_params.max_steer_angle;
params(1,6) = bike_params.drive_motor_gear_rat;
params(1,7) = bike_params.wheelbase;
params(2,1) = bike_params.fork_angle;
params(2,2) = bike_params.r_wheel;
params(2,3) = bike_params.lr;
params(2,4) = bike_params.lf;
params(2,5) = bike_params.lambda;
params(2,6) = k1;
params(2,7) = k2;
params(3,1) = e1_max;
params(3,2) = Ad_t;
params(3,3) = Bd_t;
params(3,4) = C_t;
params(3,5) = D_t;
params(3,6) = P_balancing_outer;
params(3,7) = P_balancing_inner;


%% Save matrix in XML/CSV
matrixmat = [A_d; B_d'; C1; D1';Kalman_gain1;initial_states;params];

prompt = {'Enter the bike type','Enter the matrix name.'};
dlgtitle = 'Parameters matrix';
dims = [1 40];
definput = {'red_bike','matrixmat'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
type=string(answer{1,1});
name=string(answer{2,1});
filename_matrix = strcat('Parameters_matrixmat\',type,'\',name,'.csv');
dlmwrite(filename_matrix, matrixmat, 'delimiter', ',', 'precision', 10);
