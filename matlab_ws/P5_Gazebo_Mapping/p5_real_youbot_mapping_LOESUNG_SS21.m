% p6_gazebo_mapping.m
%-----------------------------------------
% mappt mit dem realen youBot03 in der Arena
% Verbindung über ASUS_5G  
% pw: robotiklabor 
% OJ fuer EMR am 10.5.2021
%-----------------------------------------------------------------------
try
    rosnode list
catch exp   % Error from rosnode list
     rosinit
end

%%-----------------------------------------------------------------------
% gaezbo Topic /scan => /base_scan
subScan = rossubscriber('base_scan','sensor_msgs/LaserScan');
subOdom = rossubscriber ('odom', 'nav_msgs/Odometry');
scandata = receive(subScan,10); %first scan

%%----- Laserscan Daten vorbereiten ----
numbOfScans = size(scandata.Ranges,1); % Spaltenzahl des Zeilenvektors 
maxrange = double(scandata.RangeMax);  % must be double-Format
% make empty ray Object insize of scandata, must be double-Format
ranges = typecast(3*ones(numbOfScans, 1),'double');
% determine the angles corrersponding to ranges, must be double-Format
angles = double(scandata.AngleMin: (scandata.AngleMax-scandata.AngleMin)/(numbOfScans-1) :scandata.AngleMax );
%%----- map erstellen --------------
% 12m x 12m mit 60 Werten pro m => 2cm Raster
% Version bis Robotic System Toolbox 2.2 
% map = robotics.OccupancyGrid(12,12,60);

% map = binaryOccupancyMap(12,12,60); => funkt aber andere Map_Sorte
map = occupancyMap(12,12,60); %requires Navigation Toolbox.

%Startposition des youBot  % Offset-Map - Pose youBot
map.GridLocationInWorld = [-6,-6];

%%
while 1
   % pose holen und speichern
    posedata = receive(subOdom,10);
    
   % Winkel berechnet sich aus den Quarternionen 
    % pose als Quaternion speichern
    % Vektor mit 4 Spalten und einer Zeile => "..."
    myQuat = [ posedata.Pose.Pose.Orientation.X...
               posedata.Pose.Pose.Orientation.Y...
               posedata.Pose.Pose.Orientation.Z...
               posedata.Pose.Pose.Orientation.W];
    eulZYX = quat2eul(myQuat);
    theta = eulZYX(3);  
    
    %% xy-Daten des youBots sind ist nicht die exakte Position des Lasers
    % Hokuyo, Achse des Scanners ca 30 cm in X-Richtung
    % Laenge Base 58cm, Traegerblech - Mitte LAser ca. 4 cm
    versatz = 0.338; % 0.58/2 +0.05;
  
    poseX = posedata.Pose.Pose.Position.X + cos(theta)*versatz; 
    poseY = posedata.Pose.Pose.Position.Y + sin(theta)*versatz; 
    pose = [poseX, poseY, theta]; %X, Y, THETA
    
    %scan holen
    scandata = receive(subScan,10);
    ranges = double(scandata.Ranges);
        
    %In Map eintragen, (alles muss double sein)
    % Version bis Robotic System Toolbox 2.2 
    % insertRay(map, pose, ranges, angles, maxrange, [0.4 0.9]);
    insertRay(map, pose, ranges, angles, maxrange);
    
    show(map)    
end






