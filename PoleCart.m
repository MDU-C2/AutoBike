close all;
clc;
clear;

startState = [0 0 0 0];

x1 = -2.4:1.2:2.4; %x pos. The position of the cart
x2 = -2:1:2; %x dist dot. The speed of the cart
x3 = -pi/15:pi/60:pi/15; %theta. The angle of the pendelum.
x4 = -pi/4:pi/8:pi/4; %theta dot. The angle velocity of the pendelum

Q1 = 0;
Q2 = 0;
Q3 = 0;
Q4 = 0;

force = 10;
actions = [-force, -force/2, force/2, force]; % Either force backward or forward
allowedPoleAngle = pi/30;
deathPoleAngle = pi/5;
allowedCartPos = 0.4;
deathCartPos = 2.4;

i = 0;
currentState = startState;

%% Set up the pendulum plot
panel = figure;
panel.Color = [1 1 1];

hold on
% Axis for the pendulum animation
f = plot(0,0,'b','LineWidth',6); % Pendulum stick
axPend = f.Parent;
axPend.XTick = []; % No axis stuff to see
axPend.YTick = [];
axPend.Visible = 'off';
axPend.Clipping = 'off';
axis equal
axis([-1.2679 1.2679 -1 1]); %bottom line
line([-2.4 2.4],[0 0],'color', 'red')
g  = plot(0.001,0,'.k','MarkerSize',30); % Pendulum axis point
hold off

%% Generate small net data
TrSet = {};
Input = [];

for i = 1:200
    currentState = startState;
    TrSet{1, i} = [currentState];
    TrSet{2, i} = [0];
    
    while(abs(currentState(1)) <= deathCartPos && abs(currentState(3))<=deathPoleAngle)
        action = actions(round(3*rand+1)*1);
        nextState = SimulatePendel(action, currentState(1), currentState(2), currentState(3), currentState(4));
        TrSet{1, i} = [TrSet{1, i} ; nextState];
        TrSet{2, i} = [TrSet{2, i}; action];
        currentState = nextState;
    end
    Target = 0.10 + 0.80*(abs(TrSet{1,i}(:,3)) > allowedPoleAngle);
    Input = [Input; [TrSet{1,i}(1:end-1,:) TrSet{2,i}(2:end,:)] Target(2:end)];
end
QNeur;

%% Generate data

bestActionNr = 0;
range = 500;
for k = 1:20
    for i = 1:20
        currentState = startState;
        TrSet{1, i} = [currentState];
        TrSet{2, i} = [0];
        
        actionNr = 0;
        
        while(abs(currentState(1)) <= deathCartPos && abs(currentState(3))<=deathPoleAngle && actionNr < range)
            
            if(mod(actionNr, 3) == 0)
                action = round(20*rand) - 10;
            else
                Q1 = net([currentState actions(1)]');
                Q2 = net([currentState actions(2)]');
                Q3 = net([currentState actions(3)]');
                Q4 = net([currentState actions(4)]');
                
                if(min([Q1 Q2 Q3 Q4]) == Q1)
                    action = actions(1);
                elseif(min([Q1 Q2 Q3 Q4]) == Q2)
                    action = actions(2);
                elseif(min([Q1 Q2 Q3 Q4]) == Q3)
                    action = actions(3);
                else
                    action = actions(4);
                end
            end
            nextState = SimulatePendel(action, currentState(1), currentState(2), currentState(3), currentState(4));
            TrSet{1, i} = [TrSet{1, i} ; nextState];
            TrSet{2, i} = [TrSet{2, i}; action];
            currentState = nextState;
            
            actionNr = actionNr + 1;
            
            clc;
            disp('Episode: ');
            disp(i);
            disp('Survival Actions: ');
            disp(actionNr);
            disp('Best Survival Actions: ')
            disp(bestActionNr)
        end
        
        if actionNr > bestActionNr
            bestNet = net;
            bestActionNr = actionNr;
        end
        
        if bestActionNr == range
            range = range + 100;
        end
        
        Target = 0.10 + 0.80*(abs(TrSet{1,i}(:,3)) > allowedPoleAngle); % Cost
        Input = [Input; [TrSet{1,i}(1:end-1,:) TrSet{2,i}(2:end,:)] Target(2:end)];
        
    end
    QNeur;
end
net = bestNet;
%% Simulate
currentState = startState;
i = 0;
while(abs(currentState(1)) <= deathCartPos && abs(currentState(3))<=deathPoleAngle)
    i = i + 1;
    
    set(f,'XData',[currentState(1) currentState(1)+ sin(currentState(3))]); %x pos of stick
    set(g,'XData',currentState(1)); %x pos of dot
    set(f,'YData',[0 cos(currentState(3))]); %y pos of stick
    
    if(mod(i, 3) == 0)
        action = 10*rand - 5
    else
        Q1 = net([currentState actions(1)]');
        Q2 = net([currentState actions(2)]');
        Q3 = net([currentState actions(3)]');
        Q4 = net([currentState actions(4)]');

        if(min([Q1 Q2 Q3 Q4]) == Q1)
            action = actions(1);
        elseif(min([Q1 Q2 Q3 Q4]) == Q2)
            action = actions(2);
        elseif(min([Q1 Q2 Q3 Q4]) == Q3)
            action = actions(3);
        else
            action = actions(4);
        end
    end
    nextState = SimulatePendel(action, currentState(1), currentState(2), currentState(3), currentState(4));
    
    actionTaken(i) = action;
    
    currentState = nextState;
    
    %Update
    clc;
    disp('Cart distance is: ');
    disp(currentState(1));
    disp('Cart speed is: ');
    disp(currentState(2));
    disp('Angle is: ');
    disp(180/pi*currentState(3));
    disp('Angle velocity is: ');
    disp(currentState(4));
    disp('Survival time');
    disp(i*0.02);
    
    pause(0.02)
    
    grap(i,1) = i*0.02;
    grap(i,2) = currentState(1);
    grap(i,3) = currentState(3)*180/pi;
end

%% Plot
figure;
plot(grap(:,2),grap(:,1));
ylabel("time (s)");
xlabel("Cart position from center (m)");
xlim([-2.4,2.4]);
title("Cart position");
figure;
plot(grap(:,3),grap(:,1));
ylabel("time (s)");
xlabel("Rod angle (Degrees)");
xlim([-12,12]);
title("Rod angle");
toPlot = 0;

