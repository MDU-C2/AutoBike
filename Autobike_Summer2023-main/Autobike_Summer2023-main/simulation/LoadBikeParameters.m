function Parameters = LoadBikeParameters(bike)

    if strcmp(bike,'red')

        % Red bike --> real parameters and positions on bike
        Parameters.inertia_front = 0.245;  %[kg.m^2] inertia of the front wheel
        Parameters.r_wheel = 0.35;        % radius of the wheel
        Parameters.h = 0.2085 + Parameters.r_wheel;   % height of center of mass [m]
        Parameters.lr = 0.4964;             % distance from rear wheel to frame's center of mass [m]
        Parameters.lf = 1.095-0.4964;       % distance from front wheel to frame's center of mass [m]
        Parameters.c = 0.06;               % length between front wheel contact point and the extention of the fork axis [m]
        Parameters.m = 45;                 % Bike mas [kg]
        Parameters.lambda = deg2rad(70);   % angle of the fork axis [deg]
        Parameters.IMU_height = 0.71;      % IMU height [m]
        Parameters.IMU_x = 0.0;           % x Position of the IMU measured from rear wheel (parallel to bike) [m]
        Parameters.IMU_roll = 0;           % Orientation offset in roll (degrees)
        Parameters.IMU_pitch = 0;            % Orientation offset in pitch (degrees)
        Parameters.IMU_yaw = 0;             % Orientation offset in yaw (degrees)
        Parameters.Xgps = 0.0;             % Actual GPS position offset X (measured from middlepoint position parralel to bike heading) [m]
        Parameters.Ygps = 0.0;             % Actual GPS position offset Y (measured from middlepoint position perpendicular to bike heading) [m]
        Parameters.Hgps = 0.0;             % GPS position height (measured from the groud to the GPS)   [m]
        Parameters.steer_motor_gear_rat = 111;
        Parameters.steer_pully_gear_rat = 1;
        Parameters.steer_enc_CPR = 500;
        Parameters.steer_motor_max_RPM = 4000;
        Parameters.max_steer_angle = 0.7; % [rad]
        Parameters.drive_motor_gear_rat = 190;
        Parameters.wheelbase = 1.12; % [m]
        Parameters.fork_angle = 1.3; % [rad]

        % Parameters in the model
        Parameters.inertia_front_mod = 0.245;  %[kg.m^2] inertia of the front wheel
        Parameters.r_wheel_mod = 0.350;        % radius of the wheel
        Parameters.h_mod = 0.2085 + Parameters.r_wheel_mod;   % height of center of mass [m]
        Parameters.lr_mod = 0.4964;             % distance from rear wheel to frame's center of mass [m]
        Parameters.lf_mod = 1.095-0.4964;       % distance from front wheel to frame's center of mass [m]
        Parameters.c_mod = 0.06;                % length between front wheel contact point and the extention of the fork axis [m]
        Parameters.m_mod = 45;                  % Bike mas [kg]
        Parameters.lambda_mod = deg2rad(70);    % angle of the fork axis [deg]
        Parameters.IMU_height_mod = 0.71;      % IMU height [m]
        Parameters.IMU_x_mod = 0.0;           % x Position of the IMU measured from rear wheel (parallel to bike) [m]
        Parameters.IMU_roll_mod = 0;           % Orientation offset in roll (degrees)
        Parameters.IMU_pitch_mod = 0;            % Orientation offset in pitch (degrees)
        Parameters.IMU_yaw_mod = 0;             % Orientation offset in yaw (degrees)
        Parameters.Xgps_mod = 0.0;              % GPS position X accoarding to the model [m] 
        Parameters.Ygps_mod = 0.0;              % GPS position Y accoarding to the model [m]
        Parameters.Hgps_mod = 0.0;              % GPS position height accoarding to the model   [m]
        
        %
        Parameters.uneven_mass = false;    % true = use uneven mass distribution in bike model ; false = do not use

    elseif strcmp(bike,'black')

        % Black bike --> Parameters on bike (actual measured)
        Parameters.inertia_front = 0.245;  %[kg.m^2] inertia of the front wheel
        Parameters.h = 0.534 ;             % height of center of mass [m]
        Parameters.lr = 0.4964;             % distance from rear wheel to frame's center of mass [m]
        Parameters.lf = 1.095-0.4964;       % distance from front wheel to frame's center of mass [m]
        Parameters.c = 0.06;               % length between front wheel contact point and the extention of the fork axis [m]
        Parameters.m = 31.3;               % Bike mass [kg]
        Parameters.lambda = deg2rad(66);   % angle of the fork axis [deg]  !!! TO BE MEASURED
        Parameters.IMU_height = 0.89;     % IMU height [m]
        Parameters.IMU_x = 0.0;           % x Position of the IMU measured from rear wheel (parallel to bike) [m]
        Parameters.IMU_roll = 0;           % Orientation offset in roll (degrees)
        Parameters.IMU_pitch = 0;            % Orientation offset in pitch (degrees)
        Parameters.IMU_yaw = 0;             % Orientation offset in yaw (degrees)
        Parameters.Xgps = 0.0;             % Actual GPS position offset X (measured from middlepoint position parralel to bike heading) [m]
        Parameters.Ygps = 0.0;             % Actual GPS position offset Y (measured from middlepoint position perpendicular to bike heading) [m]
        Parameters.Hgps = 0.0;             % GPS position height (measured from the groud to the GPS)   [m]
%         Parameters.steer_motor_gear_rat = 111;
%         Parameters.steer_pully_gear_rat = 1;
%         Parameters.steer_enc_CPR = 500;
%         Parameters.steer_motor_max_RPM = 4000;
%         Parameters.max_steer_angle = 0.7; % [rad]
%         Parameters.drive_motor_gear_rat = 250;
%         Parameters.wheelbase = 1.12; % [m]
%         Parameters.fork_angle = 1.3; % [rad]

        % Parameters in model 
        Parameters.inertia_front_mod = 0.245;  %[kg.m^2] inertia of the front wheel
        Parameters.h_mod = 0.534 ;             % height of center of mass [m]
        Parameters.lr_mod = 0.4964;             % distance from rear wheel to frame's center of mass [m]
        Parameters.lf_mod = 1.095-0.4964;       % distance from front wheel to frame's center of mass [m]
        Parameters.c_mod = 0.06;               % length between front wheel contact point and the extention of the fork axis [m]
        Parameters.m_mod = 31.3;               % Bike mass [kg]
        Parameters.lambda_mod = deg2rad(66);   % angle of the fork axis [deg]  !!! TO BE MEASURED
        Parameters.IMU_height_mod = 0.89;     % IMU height [m]
        Parameters.IMU_x_mod = 0.0;            % x Position of the IMU measured from rear wheel (parallel to bike) [m]
        Parameters.IMU_roll_mod = 0;           % Orientation offset in roll (degrees)
        Parameters.IMU_pitch_mod = 0;            % Orientation offset in pitch (degrees)
        Parameters.IMU_yaw_mod = 0;             % Orientation offset in yaw (degrees)
        Parameters.Xgps_mod = 0.0;             % Actual GPS position offset X (measured from middlepoint position parralel to bike heading) [m]
        Parameters.Ygps_mod = 0.0;             % Actual GPS position offset Y (measured from middlepoint position perpendicular to bike heading) [m]
        Parameters.Hgps_mod = 0.0;             % GPS position height (measured from the groud to the GPS)   [m]
       
        %
        Parameters.uneven_mass = false;        % true = use uneven mass distribution in bike model ; false = do not use 
        
    elseif strcmp(bike,'green')

        % Black bike --> Parameters on bike (actual measured)
        Parameters.inertia_front = 0.245;  %[kg.m^2] inertia of the front wheel
        Parameters.r_wheel = 0.355;         % radius of the wheel
        Parameters.h = 0.534 ;             % height of center of mass [m]
        Parameters.lr = 0.4964;             % distance from rear wheel to frame's center of mass [m]
        Parameters.lf = 1.095-0.4964;       % distance from front wheel to frame's center of mass [m]
        Parameters.c = 0.06;               % length between front wheel contact point and the extention of the fork axis [m]
        Parameters.m = 31.3;               % Bike mass [kg]
        Parameters.lambda = deg2rad(66);   % angle of the fork axis [deg]  !!! TO BE MEASURED
        Parameters.IMU_height = 0.95;     % IMU height [m]
        Parameters.IMU_x = 0.0;           % x Position of the IMU measured from rear wheel (parallel to bike) [m]
        Parameters.IMU_roll = 0;           % Orientation offset in roll (degrees)
        Parameters.IMU_pitch = 0;            % Orientation offset in pitch (degrees)
        Parameters.IMU_yaw = 0;             % Orientation offset in yaw (degrees)
        Parameters.Xgps = 0.0;             % Actual GPS position offset X (measured from middlepoint position parralel to bike heading) [m]
        Parameters.Ygps = 0.0;             % Actual GPS position offset Y (measured from middlepoint position perpendicular to bike heading) [m]
        Parameters.Hgps = 0.0;             % GPS position height (measured from the groud to the GPS)   [m]
        Parameters.steer_motor_gear_rat = 111;
        Parameters.steer_pully_gear_rat = 1;
        Parameters.steer_enc_CPR = 500;
        Parameters.steer_motor_max_RPM = 4000;
        Parameters.max_steer_angle = 0.7; % [rad]
        Parameters.drive_motor_gear_rat = 23;
        Parameters.wheelbase = 1.12; % [m]
        Parameters.fork_angle = 1.3; % [rad]

        % Parameters in model 
        Parameters.inertia_front_mod = 0.245;  %[kg.m^2] inertia of the front wheel
        Parameters.h_mod = 0.534 ;             % height of center of mass [m]
        Parameters.lr_mod = 0.4964;             % distance from rear wheel to frame's center of mass [m]
        Parameters.lf_mod = 1.095-0.4964;       % distance from front wheel to frame's center of mass [m]
        Parameters.c_mod = 0.06;               % length between front wheel contact point and the extention of the fork axis [m]
        Parameters.m_mod = 31.3;               % Bike mass [kg]
        Parameters.lambda_mod = deg2rad(66);   % angle of the fork axis [deg]  !!! TO BE MEASURED
        Parameters.IMU_height_mod = 0.95;     % IMU height [m]
        Parameters.IMU_x_mod = 0.0;            % x Position of the IMU measured from rear wheel (parallel to bike) [m]
        Parameters.IMU_roll_mod = 0;           % Orientation offset in roll (degrees)
        Parameters.IMU_pitch_mod = 0;            % Orientation offset in pitch (degrees)
        Parameters.IMU_yaw_mod = 0;             % Orientation offset in yaw (degrees)
        Parameters.Xgps_mod = 0.0;             % Actual GPS position offset X (measured from middlepoint position parralel to bike heading) [m]
        Parameters.Ygps_mod = 0.0;             % Actual GPS position offset Y (measured from middlepoint position perpendicular to bike heading) [m]
        Parameters.Hgps_mod = 0.0;             % GPS position height (measured from the groud to the GPS)   [m]
       
        %
        Parameters.uneven_mass = false;    % true = use uneven mass distribution in bike model ; false = do not use

    elseif strcmp(bike, 'scooter')

        % E-scooter --> Parameters on scooter (actual measured)
        Parameters.inertia_front = 0.0369;
        Parameters.r_wheel = 0.1079;
        Parameters.h = 0.2352;
        Parameters.lr = 0.4401;
        Parameters.lf = 0.88 - Parameters.lr;
        Parameters.c = 0.03;
        Parameters.IMU_height = 0.23;
        Parameters.m = 18.2;
        Parameters.lambda = deg2rad(78.7);
        Parameters.uneven_mass = false;
        Parameters.Xgps = 0.0;            % GPS position X accoarding to the model [m] 
        Parameters.Ygps = 0.0;            % GPS position Y accoarding to the model [m]
        Parameters.Hgps = 0.0;              % GPS position height accoarding to the model [m]
        Parameters.Ximu = 0.0;             % IMU position offset X [m]
        Parameters.Yimu = 0.0;             % IMU position offset Y [m]
        Parameters.IMU_x = 0.0;            % x Position of the IMU measured from rear wheel (parallel to bike) [m]
        Parameters.IMU_roll = 0;           % Orientation offset in roll (degrees)
        Parameters.IMU_pitch = 0;            % Orientation offset in pitch (degrees)
        Parameters.IMU_yaw = 0;
        Parameters.steer_motor_gear_rat = 100;
        Parameters.steer_pully_gear_rat = 2;
        Parameters.steer_enc_CPR = 6;
        Parameters.steer_motor_max_RPM = 4000;
        Parameters.max_steer_angle = 1.5; % [rad]
        Parameters.drive_motor_gear_rat = 16;
        Parameters.wheelbase = 0.88; % [m]
        Parameters.fork_angle = 1.37; % [rad]

        % Model parameters
        Parameters.inertia_front_mod = 0.0369;
        Parameters.r_wheel_mod = 0.1079;
        Parameters.h_mod = 0.2352;
        Parameters.lr_mod = 0.4401;
        Parameters.lf_mod = 0.88 - Parameters.lr_mod;
        Parameters.c_mod = 0.03;
        Parameters.IMU_height_mod = 0.23;
        Parameters.m_mod = 18.2;
        Parameters.lambda_mod = deg2rad(78.7);
        Parameters.uneven_mass_mod = false;
        Parameters.IMU_x_mod = 0.0;            % x Position of the IMU measured from rear wheel (parallel to bike) [m]
        Parameters.IMU_roll_mod = 0;           % Orientation offset in roll (degrees)
        Parameters.IMU_pitch_mod = 0;            % Orientation offset in pitch (degrees)
        Parameters.IMU_yaw_mod = 0;    
        Parameters.Xgps_mod = 0.0;            % GPS position X accoarding to the model [m] 
        Parameters.Ygps_mod = 0.0;            % GPS position Y accoarding to the model [m]
        Parameters.Hgps_mod = 0.0;              % GPS position height accoarding to the model [m]
        Parameters.Ximu_mod = 0.0;             % IMU position offset X [m]
        Parameters.Yimu_mod = 0.0;             % IMU position offset Y [m]

    elseif strcmp(bike, 'plastic')

        % Plastic bike --> bike parameters
        Parameters.inertia_front = 0.0213;
        Parameters.r_wheel = 0.355;
        Parameters.h = 0.66;
        Parameters.lr = 0.46;
        Parameters.lf = 1.185 - Parameters.lr;
        Parameters.c = 0.4;
        Parameters.IMU_height = 0.94;
        Parameters.m = 23;
        Parameters.lambda = deg2rad(51);
        Parameters.uneven_mass = false;
        Parameters.Xgps = 0.0;            % GPS position X accoarding to the model [m] 
        Parameters.Ygps = 0.0;            % GPS position Y accoarding to the model [m]
        Parameters.Hgps = 0.0;              % GPS position height accoarding to the model [m]
        Parameters.Ximu = 0.0;             % IMU position offset X [m]
        Parameters.Yimu = 0.0;             % IMU position offset Y [m]
        Parameters.IMU_x = 0.0;            % x Position of the IMU measured from rear wheel (parallel to bike) [m]
        Parameters.IMU_roll = 0;           % Orientation offset in roll (degrees)
        Parameters.IMU_pitch = 0;            % Orientation offset in pitch (degrees)
        Parameters.IMU_yaw = 0;
        Parameters.steer_motor_gear_rat = 22;
        Parameters.steer_pully_gear_rat = 1;
        Parameters.steer_enc_CPR = 500;
        Parameters.steer_motor_max_RPM = 4000;
        Parameters.max_steer_angle = 0.7; % [rad]
        Parameters.drive_motor_gear_rat = 63;
        Parameters.wheelbase = 1.185; % [m]
        Parameters.fork_angle = 0.89; % [rad]
    end
end
