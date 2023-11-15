%% System setup
clear all;

% AXI 5330/24 3D Extreme KV197 V2
% RPM_PER_VOLT = 197;
% MOTOR_VELOCITY_CONSTANT = RPM_PER_VOLT;
% MOTOR_TORQUE_CONSTANT = 60 / (2 * pi * MOTOR_VELOCITY_CONSTANT); % Conversion from RPM to radians. Otherwise K_torque = 1 / K_velocity.
% NO_LOAD_CURRENT = 1.4;  
% MOTOR_INTERNAL_RESISTANCE = 34 * 10^6;
% MOTOR_SHAFT_RADIUS = 4 * 10^-3;
% MASS_MOTOR = 0.690;
% MAX_POWER = 2500;

% AXI 5360/24D V2 Gold Line
RPM_PER_VOLT = 95;
MOTOR_VELOCITY_CONSTANT = RPM_PER_VOLT;
MOTOR_TORQUE_CONSTANT = 60 / (2 * pi * MOTOR_VELOCITY_CONSTANT); % Conversion from RPM to radians. Otherwise K_torque = 1 / K_velocity.
NO_LOAD_CURRENT = 1.8;
MOTOR_INTERNAL_RESISTANCE = 63 * 10^6;
MOTOR_SHAFT_RADIUS = 4 * 10^-3;
MASS_MOTOR = 1.270;
MAX_POWER = 3120;

MASS_REACTION_WHEEL = 0.950 + 1.200 * 4;
RADIUS_REACTION_WHEEL = 0.180;
MASS_PENDULUM = 35;
L = 0.65;

GRAVITATIONAL_CONSTANT = 9.82;

A = [0 1 0;
    ((MASS_REACTION_WHEEL + MASS_MOTOR + MASS_PENDULUM / 2) * L * GRAVITATIONAL_CONSTANT) / ((MASS_PENDULUM * L^2 / 3) + MASS_MOTOR * L^2 + MASS_REACTION_WHEEL * RADIUS_REACTION_WHEEL^2 + MASS_REACTION_WHEEL * L^2) 0 0;
    0 0 0]
B = [0;
    -1/((MASS_PENDULUM * L^2 / 3) + MASS_MOTOR * L^2 + MASS_REACTION_WHEEL * RADIUS_REACTION_WHEEL^2 + MASS_REACTION_WHEEL * L^2);
    1 / (MASS_REACTION_WHEEL * RADIUS_REACTION_WHEEL^2)]
C = eye(3)
D = zeros(3,1)

%% Run Simulink simulation based on Ekedahl and Lundberg
open_system("InvertedPendulum_Simulink_based_on_Ekedahl_Lundberg")

%% Run Simulink simulation based on 
open_system("InvertedPendulum_Simulink.slx")

%% Matlab system
StateSpaceSystem = ss(A,B,C,D);
%plot(step(StateSpaceSystem))
plot(impulse(StateSpaceSystem))