function [] = test_traj(test_traj,Ts,v)

% Number of datapoints
n = size(test_traj,1);
        
%% Density of datapoints
Min_density_distance = 10;
index = 0;
for i = 1:n-1
    dist = sqrt((test_traj(i,1)-test_traj(i+1,1))^2+(test_traj(i,2)-test_traj(i+1,2))^2);
    if dist > Min_density_distance
        index = [index i];
    end
end    
if length(index) ~= 1
    message_dens = ['Warning: Some ref points are more than ',num2str(Min_density_distance),'m apart from each other, index: '];
    disp(message_dens)
    disp(index(2:end))
end
  
%% Warns for sharp turns which are hard to reach for the bike    
%it warns when a turn of >90 will be made within ts/v
%Determine amount of datapoints which should be added
%Include dpsiref in this matlab script

% average distance between points
ref_dis = sqrt((test_traj(n,1)-test_traj(1,1))^2 + (test_traj(n,2)-test_traj(1,2))^2)/n;
ref_dis = 0.1;

turn_distance = 2/(ref_dis*10);
max_turn = pi/6;
index = 0;
Warningturn = rad2deg(max_turn);

if turn_distance > 1
    for i = 1:n-1
        dpsiref(i) = abs(test_traj(i,3)-test_traj(i+1,3));
    end
    
    for i = 1:1:length(dpsiref)-turn_distance
        tot_dpsiref = sum(dpsiref(i:i+turn_distance));
        if tot_dpsiref >= max_turn   
            index = [index i];
        end
    end
    
    if length(index) ~= 1
        message_turn = ['Warning: An unrealistic sharp turn has been detected (>',num2str(Warningturn),' degree), index:'];
        disp(message_turn)
        disp(index(2:end))
    end
end


%% Check if bike travels much longer distance than trajectory point distance
bike_dis=v*Ts;
tra_dis=0;
for i = 1:n-1
   tra_dis = sqrt((test_traj(i,1)-test_traj(i+1,1))^2+(test_traj(i,2)-test_traj(i+1,2))^2);
end

if bike_dis>tra_dis %if bike_dis is larger a lot than tra_dis, it's difficult to track reference trajectory, display warning
    disp('Warning: Sampling time of the simulation is larger than trajectory sampling');
end

end