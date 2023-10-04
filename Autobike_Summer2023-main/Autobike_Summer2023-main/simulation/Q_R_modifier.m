function [Q,R] = Q_R_modifier(Q_vector,R_vector)
% Function that return the Q (process noise covariance) and R (measurement covariance matrix)
% input must be vectors with this aspect:
% Q_vector=[Q_GPS,Q_Psi,Q_roll,Q_rollrate,Q_delta,Q_v,Q_scale];
% R_vector=[R_GPS,R_heading,R_roll,R_RollRate,R_SteeringAngle,R_v,R_scale];
% Q =Qscale* [Q_GPS 0 0 0 0 0 0;
%               0 Q_GPS 0 0 0 0 0;
%               0 0 Q_Psi 0 0 0 0;
%               0 0 0 Q_roll 0 0 0;
%               0 0 0 0 Q_rollrate 0 0;
%               0 0 0 0 0 Q_delta 0;
%               0 0 0 0 0 0 Q_v];
% R =Rscale* [R_GPS 0 0 0 0 0 0;
%               0 R_GPS 0 0 0 0 0;
%               0 0 R_ay 0 0 0 0;
%               0 0 0 R_wx 0 0 0;
%               0 0 0 0 R_wz 0 0;
%               0 0 0 0 0 R_delta 0;
%               0 0 0 0 0 0 R_v];

Q =Q_vector(7).* [Q_vector(1) 0 0 0 0 0 0;
              0 Q_vector(1) 0 0 0 0 0;
              0 0 Q_vector(2) 0 0 0 0;
              0 0 0 Q_vector(3) 0 0 0;
              0 0 0 0 Q_vector(4) 0 0;
              0 0 0 0 0 Q_vector(5) 0;
              0 0 0 0 0 0 Q_vector(6)];

R =R_vector(7).* [R_vector(1) 0 0 0 0 0 0;
              0 R_vector(1) 0 0 0 0 0;
              0 0 R_vector(2) 0 0 0 0;
              0 0 0 R_vector(3) 0 0 0;
              0 0 0 0 R_vector(4) 0 0;
              0 0 0 0 0 R_vector(5) 0;
              0 0 0 0 0 0 R_vector(6)];

end