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
    
%%%%%%%%%%%%%GUI%%%%%%%%%%%%%%%%%%%%%%%%%
% % reduce/increase simulation time for desired timescale on x-axis of the plots
%     sim_time = 50;
% Take into account a valid speed. 
    v=2; 
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

% syms phi delta phi_d phi_d delta_d phi_2d

% phi =   States(1);%roll
% delta = States(2);%steering angle
% phi_d = States(3);%rollrate
v=2;
% linearized
% xdot1 = phi_d;
% xdot2 = delta_d ;
% xdot3 = (g/h)*phi + ((lr*Speed)/((lr+lf)*h))*delta_d + ((h*Speed^2-g*lr*c)/((lr+lf)*h^2))*sin(lambda)*delta;
% 
% xdot = [xdot1 xdot2 xdot3]';

% Bike model (linear and continuous)
A=[0,0,1;
   0,0,0
   (g/h), ((v^2/h)-(g*lr*c/(h^2*(lr+lf))))*sin(lambda), 0 ];

B=[0; 1; ((lr*v)/((lr+lf)*h))];
C=[0, 0, 1];
D=0;

% From ss to transfer function
s = tf('s');  
[num,den] = ss2tf(A,B,C,D);
G=tf(num,den)

% P and D parameters
K_p=1.3;
K_d=3.5;

% Intermediate steps
J = G / (1 + K_d*G);
H = K_p*J*(1/s);
L = (K_p*G) / (s + G*(K_p + K_d*s));

% N=k_p*G;
% D=(G*(k_p+k_d*s))+s;
% L=N/D
P = pole(L)
Z = zero(L)
% rlocus(L)