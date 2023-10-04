clear all;
clc;

% Params
Ts = 0.01;
v = 3; 
h = 0.534;
b = 1.15;
a = 0.6687;
lambda = deg2rad(66);
c = 0.06;
m = 31.3;
g = 9.81;
h_imu = 0.215;

lr = a; % distance from rear wheel center to center of mass
lf = b-a; % distance from front wheen center to center of mass

% States in global frame
States = [100 10 0.1 0.1 0.1 0.1 3]'; 

% States in local frame
States_l = zeros(7,1);

States_l(1) = States(1) * cos(States(3)) + States(2) * sin(States(3));
States_l(2) = -States(1) * sin(States(3)) + States(2) * cos(States(3));
States_l(3) = 0;        % direction of bike is aligned with X local frame
States_l(4) = States(4);
States_l(5) = States(5);
States_l(6) = States(6);
States_l(7) = States(7);

% Input value (= 0  if A wants to be tested, != if Ax+Bu wants to be
% tested)
dot_delta_e = 1;

%% Matlab script to obtain Kalman gain

% A matrix (linear bicycle model with constant velocity)
% Est_States := [X Y psi phi phi_dot delta v]
A = [0 0 0 0 0 0 1;
     0 0 v 0 0 v*(lr/(lf+lr))*sin(lambda) 0;
     0 0 0 0 0 (v/(lr+lf))*sin(lambda) 0;
     0 0 0 0 1 0 0;
     0 0 0 (g/h) 0 ((v^2*h-lr*g*c)/(h^2*(lr+lf)))*sin(lambda) 0;
     0 0 0 0 0 0 0;
     0 0 0 0 0 0 0];

% B matrix (linear bicycle model with constant velocity)
B = [0 0 0 0 ((lr*v)/(h*(lr+lf)))*sin(lambda) 1 0]';

% Including GPS
C = [1 0 0 0 0 0 0;
     0 1 0 0 0 0 0;
     0 0 0 g+((-h_imu*g)/h) 0 (-h_imu*(h*v^2-(g*a*c)))*sin(lambda)/(b*h^2) + (v^2)*sin(lambda)/b 0;
     0 0 0 0 1 0 0;
     0 0 0 0 0 (v)*sin(lambda)/b 0;
     0 0 0 0 0 1 0;
     0 0 0 0 0 0 1];

D = [0 0 (-h_imu*a*v*sin(lambda))/(b*h) 0 0 0 0]';

% Continuous update
res = A*States_l + B*dot_delta_e;

% Discrete update
A_d = (eye(size(A))+Ts*A);
B_d = Ts*B;
res_d = A_d*States_l + B_d*dot_delta_e;

% Measurement update
y = C*States_l + D*dot_delta_e;

%% Copy from Simulink!!

% the A matrix can be defined outside the loop
    A = [0 0 0 0 0 0 1;
         0 0 v 0 0 (v*lr/(lf+lr))*sin(lambda) 0;
         0 0 0 0 0 (v/(lr+lf))*sin(lambda) 0;
         0 0 0 0 1 0 0;
         0 0 0 (g/h) 0 ((v^2*h-lr*g*c)/(h^2*(lr+lf)))*sin(lambda) 0;
         0 0 0 0 0 0 0;
         0 0 0 0 0 0 0];
    
    % B matrix (linear bicycle model with constant velocity)
    B = [0 0 0 0 ((lr*v)/(h*(lr+lf)))*sin(lambda) 1 0]';
    
    % Discretization
    A_d = (eye(size(A))+Ts*A);
    B_d = Ts*B;

    % Time update
     res_d2= A_d*States_l + B_d*dot_delta_e;

 % C matrix for measurements predicted measurement (Cx)
            X_GPS       = States_l(1);  
            Y_GPS       = States_l(2);
            a_y         = States_l(6)*sin(lambda)*((-h_imu*(h*v^2-(g*a*c))/(b*h^2))+((v^2)/(b))) + States_l(4)*(g+((-h_imu*g)/(h))) + (-h_imu*a*v/(b*h))*dot_delta_e*sin(lambda);
            omega_x     = States_l(5);
            omega_z     = States_l(6)*sin(lambda)*(v/b);
            delta_enc   = States_l(6);
            v_sens      = States_l(7);

% Measurement
y2 = [X_GPS Y_GPS a_y omega_x omega_z delta_enc v_sens]';

%% Check results

% if res ~= res2 | res_d ~= res_d2 | y ~= y2
%     disp('The equation from simulink and matlabs matrices does not match.')
% else
%     disp('The equations from simulink are equivalent to matlabs matrices.')
% end
% if res ~= res2
%     disp('Continuous time equations are not the same')
% elseif res_d ~= res_d2
%     disp('Check the discretization')
% end
% if y ~= y2
%     disp('Measurement equations are not equivalent in simulink and matlab.')
% end
% 
% 
% % dlqe function
% % [Kalman_gain2, P2, Z,E] = dlqe(A_d,eye(7),C2,Q,R2);
% % Kalman_gain2 = A_d * Kalman_gain2;
