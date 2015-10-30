function [] = underwater_GradientDescent()
%COMMENTS  WHo wrote this?
%
[X,Y] = coordsOfWSN();

sensors_loc = [X,Y]; % intializing the coordinates of the sensor nodes (fixed)
waypoints = [X,Y]; %initializing the coordinates of waypoints (moving)

route = [1, 5, 11, 14, 41, 38, 47, 34, 48, 32, 21, 17, 19, 33, 35,... % The initial route travelled the robot found using a TSP solver
    20, 37, 2, 16, 13, 10, 40, 23, 8, 9, 18, 27, 12, 49, 22, 15, 46, 4,...
    29, 7, 28, 43, 31, 26, 6, 30, 44, 45, 39, 50, 42, 3, 24, 25, 36, 1];

v =10; % velocity 10 km/h
gamma = 0.01; %weighting factor

iter =100; %max iteration
% initialization of variables
part_2 = zeros(length(waypoints),1);
DR = zeros(length(waypoints),1);
CostFunc = zeros(iter,2);
Dist_waypoints = zeros(length(waypoints),1);
dist_wpsensor=zeros(length(waypoints),1);

PlotSensorNodes(X,Y,route) %Plotting the Initial Setup
for x = 1:iter
    for r = 2:length(waypoints)
        P = CostFunction(x,waypoints,v,sensors_loc,Dist_waypoints,DR,part_2,dist_wpsensor);
        Q = Gradient(waypoints,r,gamma);
        
        waypoints(r,1)=waypoints(r,1)-Q(1,1);
        
        waypoints(r,2)=waypoints(r,2)-Q(2,1);
    end
    subplot(1,2,1)
    plot (waypoints(:,1),waypoints(:,2),'gO'); %plotting the waypoints
    drawnow;
     subplot(1,2,2)
    plot(P(:,2),P(:,1),'k-'); %plotting cost function vs iterations
    xlabel('iterations')
    ylabel('cost')
end
end


function[CostFunc] = CostFunction(x,waypoints,v,sensors_loc,Dist_waypoints,DR,part_2,dist_wpsensor)% Cost function has 2 parts
C = PART_1(waypoints,v,Dist_waypoints);
D = PART_2(sensors_loc,waypoints,DR,part_2,dist_wpsensor);
CostFunc(x,:) = [C+D,x];
%display([C,D])
%disp 'costfunc';
%disp(CostFunc);
end

function [PART1] = PART_1(waypoints,v,Dist_waypoints)%Travelling cost a part of cost function
%todo: RETITLE AS travel_cosT
for i =1:length(waypoints)
    if i ==50
        waypoints(i+1,1)=waypoints(1,1);
        waypoints(i+1,2)=waypoints(1,2);
    end
    Dist_waypoints(i,1) = sqrt((waypoints(i+1,1)-waypoints(i,1))^2+(waypoints(i+1,2)-waypoints(i,2))^2);
end
tot_dist = sum(Dist_waypoints);
PART1 = tot_dist/v;
%disp 'part-1';
%disp(PART1);
end

function [PART2] = PART_2(sensors_loc,waypoints,DR,part_2,dist_wpsensor) % Transmission Cost a part of cost function
data = 1000*ones(length(sensors_loc),1); %Considering each sensor node has 1mB of data stored
for o = 1:length(waypoints)
    for p = 1:length(sensors_loc)
        dist_wpsensor(p,1)=sqrt((sensors_loc(p,1)-waypoints(o,1))^2+(sensors_loc(p,2)-waypoints(o,2))^2);
    end
    [dist,sensor_no] = min(dist_wpsensor);
    DR(o,1) = 20 * exp(-dist/10);
    part_2(o,1) = (1/DR(o,1))*data(sensor_no,1);
end
PART2 = sum(part_2);
%disp 'part-2';
%disp(PART2);
end

function PlotSensorNodes(X,Y,route) % Plotting sensor loc and initial path
subplot(1,2,1)
plot(X,Y,'rO');
hold on;
route = route';
x_route = ones(size(route));
y_route = ones(size(route));

for p =1:51
    
    x_route(p,1)= X(route(p,1));
    y_route(p,1)= Y(route(p,1));
end
axis equal;

plot(x_route,y_route,'b-');
end

function [Grad] = Gradient(waypoints,r,gamma) % Calculating the gradient
if r == 50
    waypoints(r+1,1)=waypoints(1,1);
    waypoints(r+1,2)=waypoints(1,2);
end

Grad =gamma*[
    0.5*(((waypoints(r+1,1)-waypoints(r,1))^2)^-0.5)*2*(waypoints(r+1,1)-waypoints(r,1))*2; % gradient in x
    0.5*(((waypoints(r+1,2)-waypoints(r,2))^2)^-0.5)*2*(waypoints(r+1,2)-waypoints(r,2))*2
    ];
%disp 'grad';
%disp(Grad);
end

function [X,Y] = coordsOfWSN()
%coordinates of WSN
Z = [0.622576, 0.517316;
    0.992136, 0.839424;
    0.37956,0.43251;
    0.111894, 0.800901;
    0.696714, 0.415773;
    0.0998467,0.274909;
    0.00868668, 0.5038;
    0.541174, 0.664265;
    0.397267, 0.66277;
    0.760846, 0.970528;
    0.691389, 0.231795;
    0.224552, 0.76582;
    0.798352, 0.965361;
    0.880869, 0.24477;
    0.423369, 0.874798;
    0.957503, 0.843964;
    0.999681, 0.530546;
    0.294021, 0.642077;
    0.903532, 0.615913;
    0.954909, 0.750526;
    0.877366, 0.529767;
    0.369599, 0.82518;
    0.658159, 0.708112;
    0.394336, 0.447717;
    0.452598, 0.551509;
    0.171608, 0.289661;
    0.241169, 0.555352;
    0.0162981, 0.363427;
    0.0648796, 0.726844;
    0.0984561,0.265778;
    0.221071, 0.289024;
    0.875345, 0.433057;
    0.860009, 0.720698;
    0.943904, 0.323286;
    0.902932, 0.721992;
    0.572918, 0.506876;
    0.999087, 0.833258;
    0.984187, 0.167417;
    0.350074, 0.0487727;
    0.797108, 0.84134;
    0.960052, 0.215441;
    0.380463, 0.302407;
    0.232316, 0.378466;
    0.00413908, 0.144706;
    0.302643, 0.0288736;
    0.260761, 0.988548;
    0.981236, 0.313906;
    0.813854, 0.368035;
    0.30542, 0.772103;
    0.469089, 0.0127271];
%position of sensor nodes - x coordinates
x = Z(:,1);
% position of sensor nodes - y coordinates
y = Z(:,2);
% Length of the map
L = 135;
% coordinates on the map
X = L*x;
Y = L*y;
end

