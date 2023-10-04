function [] = Plot_bikesimulation_results(Tnumber, Ts, test_curve, Results)

% Trajectory
figure('Name',Tnumber);
subplot(3,2,[1,3,5]);
hold on;
plot3(test_curve(:,1),test_curve(:,2),1:length(test_curve(:,1)),'o');
plot3(Results.bike_states.Data(:,1),Results.bike_states.Data(:,2),Results.bike_states.Time(:,1));
plot3(Results.estimated_states.Data(:,1),Results.estimated_states.Data(:,2),Results.estimated_states.Time(:,1));
view(0,90)
legend('Ref','True', 'Estimated','Location','northwest');
xlabel('X-dir [m]');
ylabel('Y-dir [m]');
% ylim([traj_plot.ymin traj_plot.ymax])
% xlim([traj_plot.xmin traj_plot.xmax])
axis equal
% xlim([-50 50])
% ylim([0 150])
grid on;
title('Trajectory');


subplot(3,2,2)
plot(Results.error1.Time,Results.error1.Data)
xlabel('Time [s]')
ylabel('Distance [m]')
title('Lateral error')

subplot(3,2,4)
hold on
plot(Results.error2.Time,rad2deg(Results.error2.Data))
% plot(Results.dpsiref_steer.Time,rad2deg(Results.dpsiref_steer.Data))
xlabel('Time [s]')
ylabel('Angle [deg]')
grid on
title('Heading error')

subplot(3,2,6)
hold on
plot(Results.ids.Time,Results.ids.Data)
plot(Results.closest_point.Time,Results.closest_point.Data-1)
plot(Results.closestpoint_heading.Time,Results.closestpoint_heading.Data-2)
legend( 'Selected idx Total','Selected idx in local','Selected idx for heading','Location','northwest')
xlabel('Time [s]')
ylabel('Index [-]')
grid on
title('Closest point index selection')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name',Tnumber);

% X, Y, Psi
subplot(3,2,1)
hold on;
plot(Results.ref_states.Time(:,1),Results.ref_states.Data(:,1));
plot(Results.bike_states.Time(:,1),Results.bike_states.Data(:,1));
plot(Results.estimated_states.Time(:,1),Results.estimated_states.Data(:,1));
legend('Ref X','True X','Estimated X');
xlabel('Time [t]');
ylabel('Position X [m]');
% ylim([-50 50])
% xlim([-100 100])
grid on;
title('X-coordinate');

subplot(3,2,3);
hold on;
plot(Results.ref_states.Time(:,1),Results.ref_states.Data(:,2));                
plot(Results.bike_states.Time(:,1),Results.bike_states.Data(:,2));              
plot(Results.estimated_states.Time(:,1),Results.estimated_states.Data(:,2));    
legend('Ref Y','True Y','Estimated Y');
xlabel('Time [t]');
ylabel('Position Y [m]');
% ylim([-50 50])
% xlim([-100 100])
grid on;
title('Y-coordinate');

subplot(3,2,5)
hold on;
plot(Results.ref_states.Time(:,1),rad2deg(Results.ref_states.Data(:,3)));
plot(Results.bike_states.Time(:,1),rad2deg(Results.bike_states.Data(:,3)));
plot(Results.estimated_states.Time(:,1),rad2deg(Results.estimated_states.Data(:,3)));
legend('Ref psi','True psi','Estimated psi');
xlabel('Time [t]');
ylabel('Angle [Deg]');
% ylim([-50 50])
% xlim([-100 100])
grid on;
title('Heading');

% Roll and Roll_rate
subplot(3,2,2)
hold on;
plot(Results.roll_ref.Time(:,1),rad2deg(Results.roll_ref.Data(:,1)));
plot(Results.bike_states.Time(:,1),rad2deg(Results.bike_states.Data(:,4)));
plot(Results.estimated_states.Time(:,1),rad2deg(Results.estimated_states.Data(:,4)));
legend('Roll ref','True Roll','Estimated Roll');
xlabel('Time [t]');
ylabel('Angle [Deg]');
% ylim([-3 3])
% xlim([-100 100])
grid on;
title('Roll');

subplot(3,2,4)
hold on
plot(Results.bike_states.Time(:,1),rad2deg(Results.bike_states.Data(:,5)));
plot(Results.estimated_states.Time(:,1),rad2deg(Results.estimated_states.Data(:,5)));
legend('True Roll rate','Estimated Roll rate');
xlabel('Time [t]');
ylabel('Angle rate [Deg/s]');
%ylim([-3 3])
% xlim([0 0])
grid on;
title('Rollrate');

% Steer angle and rate
subplot(3,2,6)
hold on;
plot(Results.bike_states.Time(:,1),rad2deg(Results.bike_states.Data(:,6)));
plot(Results.estimated_states.Time(:,1),rad2deg(Results.estimated_states.Data(:,6)));
xlabel('Time [t]')
ylabel('Angle [Deg]')
yyaxis right
plot(Results.ref_states.Time(:,1),rad2deg(Results.ref_states.Data(:,5)))
ylabel('Rate [Deg/s]')
legend('True Steer angle','Estimated Steer angle', 'Steer rate')
% ylim([-3 3])
% xlim([0 0])
grid on
title('Steer angle')

figure()
subplot(211)
hold on;
plot(Results.delta_e1.Time(:,1),rad2deg(Results.delta_e1.Data(:,1)));
plot(Results.delta_e2.Time(:,1),rad2deg(Results.delta_e2.Data(:,1)));
plot(Results.delta_psi.Time(:,1),rad2deg(Results.delta_psi.Data(:,1)));
plot(Results.delta_ref.Time(:,1),rad2deg(Results.delta_ref.Data(:,1)));
xlabel('Time [t]')
ylabel('Angle [Deg]')
legend('delta e_1','delta e_2','delta psi','delta_{ref}','Location','southeast')
grid on
title('Steer contributions')

subplot(212)
hold on;
plot(Results.roll_ref.Time(:,1),rad2deg(Results.roll_ref.Data(:,1)));
plot(Results.delta_ref.Time(:,1),rad2deg(Results.delta_ref.Data(:,1)));
xlabel('Time [t]')
ylabel('Angle [Deg]')
legend('roll_{ref}','delta_{ref}','Location','southeast')
grid on
title('Delta_{ref} vs Roll_{ref}')
end