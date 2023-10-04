fig = figure()
subplot(311)
plot(Results.estimatedRoll.Time, rad2deg(Results.estimatedRoll.Data))
hold on
plot(data1.Time, rad2deg(data1.Roll))
xlabel('Time (s)')
ylabel('Roll (degree)')
grid on
legend('Kalman Sim', 'data')

subplot(312)
plot(Results.estimatedSteer_angle.Time, rad2deg(Results.estimatedSteer_angle.Data))
hold on
plot(data1.Time, rad2deg(data1.SteeringAngle - data1.steering_offset))
xlabel('Time (s)')
ylabel('Steering Angle (degree)')
grid on
legend('Kalman Sim', 'data')

subplot(313)
plot(Results.estimatedRoll_rate.Time, rad2deg(Results.estimatedRoll_rate.Data))
hold on
plot(data1.Time, rad2deg(data1.RollRate))
xlabel('Time (s)')
ylabel('Roll Rate (degree/s)')
grid on
legend('Kalman Sim', 'data')
