close all
clc
clear
%% Feed Forward
% data_lab = readtable('data.csv');
data_lab = readtable('data_motor_test.csv');
SteeringAngleEncoder_rad=data_lab.SteeringAngleEncoder_rad_;
SteerrateInput_rad_s=data_lab.SteerrateInput_rad_s_;
diff_SteeringAngleEncoder_rad=diff(SteeringAngleEncoder_rad);
Time = data_lab.Time_ms_*1e-3;
Time = Time - Time(1);
diffTime = diff(Time);
EncoderSpeed = diff_SteeringAngleEncoder_rad./diffTime;
figure()
plot(Time(1:(end-1)),(EncoderSpeed));
hold on
plot(Time,(SteerrateInput_rad_s));
legend('measured speed','steer rate input');
xlabel('Time [s]')
ylabel('velocity [rad/s]')
% %% feed_back
% data_lab1 = readtable('data3.csv');
% SteeringAngleEncoder_rad1=-data_lab1.SteeringAngleEncoder_rad_;
% SteerrateInput_rad_s1=data_lab1.SteerrateInput_rad_s_;
% diff_SteeringAngleEncoder_rad1=diff(SteeringAngleEncoder_rad1);
% Time1 = data_lab1.Time_ms_;
% Time1 = Time1 - Time1(1);
% diffTime1 = diff(Time1);
% EncoderSpeed1 = diff_SteeringAngleEncoder_rad1./diffTime1;
% figure(4)
% plot(Time1(1:(end-1)),rad2deg(EncoderSpeed1));
% hold on
% plot(Time1,SteerrateInput_rad_s1);
% legend('measured speed','steer rate input');
% xlabel('Time [s]')
% ylabel('velocity [rad/s]')