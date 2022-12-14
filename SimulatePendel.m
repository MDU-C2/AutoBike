function y=SimulatePendel(force, x, x_dot, theta, theta_dot)
% compute the next states given the force and the current states

GRAVITY=9.8;
MASSCART=1.0;
MASSPOLE=0.1;
TOTAL_MASS=MASSPOLE + MASSCART;
LENGTH=0.5;		  
POLEMASS_LENGTH=MASSPOLE * LENGTH;
STEP=0.02;
FOURTHIRDS=1.3333333333333;

    costheta = cos(theta);
    sintheta = sin(theta);

    temp = (force + POLEMASS_LENGTH * theta_dot  *theta_dot * sintheta)/ TOTAL_MASS;

    thetaacc = (GRAVITY * sintheta - costheta* temp)/(LENGTH * (FOURTHIRDS - MASSPOLE * costheta * costheta/ TOTAL_MASS));

    xacc  = temp - POLEMASS_LENGTH * thetaacc* costheta / TOTAL_MASS;

% Update the four state variables, using Euler's method.

    y(1)= x+STEP*x_dot; %x position of cart
    y(2)=x_dot+STEP*xacc; %x_dot speed of cart
    y(3)=theta+STEP*theta_dot; %theta angle of rod
    y(4)=theta_dot+STEP*thetaacc; %theta_dot angle velocity
    

