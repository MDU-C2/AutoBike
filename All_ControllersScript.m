% Patched for AB3, without Bob
clc
clear
close all
Simulink.sdi.clear %Clear simulink data inspector

%Point-mass model parameters
% AB3 data from PM15... (without Bob)
a=0.505; 
v=14/3.6;
h=0.562;
b=1.115; 
g=9.82;
m = 25;
lambda = deg2rad(90-24); % angle of the fork axis [deg]
bike_params = [g h b a lambda m]; % Store bike parameters in a vector

%Different sample rates
Ts=0.01;
TsD = 0.1;
Tsm=Ts/6;



%% P, PD, Fuzzy
%steering system step response matching
%k=110 ; % AB3 33.9;
%steer_sys = tf(k^2,[1,2*0.7*k,k^2],'InputDelay',0.015); % AB3: 0.7 (was 0.6)
%sys_dicretePID=c2d(steer_sys,Tsm,'matched');

steer_sys = tf(33.9^2, [1, 2*0.6*33.9, 33.9^2], 'InputDelay', 0.0150);  %Unsure which is the right one. 
sys_dicretePID = c2d(steer_sys, Tsm, 'matched'); % GF: Convert model from continuous to discrete time


%Transfer function for point mass model from steering pos to lean angle
sys = tf((a*v/(h*b))*[1,v/a],[1,0,-g/h]);


%Gain for noise, if set to 0 we got no noise at all.
Noise=1;

%Initialise the state space with Init_Angle degree lean angle
Init_Angle=0;
Init_condLQR=[0; deg2rad(Init_Angle); 0; 0];
FinalValue=1; %disturbance amplitude


%Run simulation
[A,B,C,D]=tf2ss(sys.Numerator{1}, sys.Denominator{1});

%%
w = warning ('off','all');
distanceStep = (v)*TsD; %run simulation Main first
distance = 20;
xc = 0:0.1:distance;
yc = zeros(1,length(xc));
radius = 20;
xc = [xc radius*cos(pi/2:-pi/64:pi/4)+distance];
yc = [yc radius*sin(pi/2:-pi/64:pi/4)-radius];
ye = yc(end);
xe = xc(end);
yb = ye:-0.1*sin(pi/4):ye-2*distance*sin(pi/4);
xb = xe:0.1*cos(pi/4):xe+2*distance*cos(pi/4);
xc = [xc xb];
yc = [yc yb];
TestPath = [xc' yc'];
total_length = arclength(TestPath(:,1),TestPath(:,2),'linear');
SimulinkPath = interparc(0:(distanceStep/total_length):1,TestPath(:,1),TestPath(:,2),'linear');
yd = diff(SimulinkPath(:,2));
xd = diff(SimulinkPath(:,1));
vd = [0; atan2(yd,xd)];
PathData = length(SimulinkPath)-1;
