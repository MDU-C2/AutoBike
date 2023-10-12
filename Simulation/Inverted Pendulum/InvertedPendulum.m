%% System setup
clear all;
MASS_REACTION_WHEEL = 3;
MASS_MOTOR = 1;
MASS_PENDULUM = 25;
L = 0.8;
GRAVITATIONAL_CONSTANT = 9.82;
RADIUS = 0.125;
A = [0 1 0;
    ((MASS_REACTION_WHEEL + MASS_MOTOR + MASS_PENDULUM / 2) * L * GRAVITATIONAL_CONSTANT) / ((MASS_PENDULUM * L^2 / 3) + MASS_MOTOR * L^2 + MASS_REACTION_WHEEL * RADIUS^2 + MASS_REACTION_WHEEL * L^2) 0 0;
    0 0 0]
B = [0;
    -1/((MASS_PENDULUM * L^2 / 3) + MASS_MOTOR * L^2 + MASS_REACTION_WHEEL * RADIUS^2 + MASS_REACTION_WHEEL * L^2);
    1 / (MASS_REACTION_WHEEL * RADIUS^2)]
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