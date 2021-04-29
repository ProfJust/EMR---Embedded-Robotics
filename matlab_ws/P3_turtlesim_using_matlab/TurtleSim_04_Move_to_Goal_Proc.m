%------------------------------------------------------------------
% TurtleSim_04_Move_to_Goal.m
% Die Turtle mit Konsolen-Befehlen im Matlab CommandWindow steuern
% Bewegt sich zu einem Ziel in Weltkoordinaten
%------------------------------------------------------------------

ROS_init_MatlabNode

%--- Anmelden des Topics beim ROS-Master -----
myPublisher = rospublisher ('turtle1/cmd_vel', 'geometry_msgs/Twist');
%youBot myPublisher = rospublisher ('cmd_vel', 'geometry_msgs/Twist');
% Subscriber anmelden
mySub = rossubscriber ('/turtle1/pose');
%---  zun�chst leere Message in diesem Topic erzeugen --
myMsg = rosmessage(myPublisher);

%---- Globale Variablen ----
meter=0;
go = true;
var ='X';
dir ='Linear';

epsilon = 0.1;  % Umgebung der Soll_Position
STEPP_PAUSE = 0.0;

%---- Get Goal ----
goalX = str2double(input('Ziel X: ','s')); % Benutzereingabe
goalY = str2double(input('Ziel Y: ','s')); % Benutzereingabe
poseX = mySub.LatestMessage.X;
poseY = mySub.LatestMessage.Y;
poseTheta = mySub.LatestMessage.Theta;
%
distX = epsilon * 10; % while so mindestens einmal laufen

%--- Move ----
while (abs(distX) >epsilon)
Turtle_Drehung
Turtle_X_Fahrt
end

%---------------------
% 2 Stufe wenn Ziel nicht genau genug erreicht
%---- Get Goal ----
startX = mySub.LatestMessage.X;
startY = mySub.LatestMessage.Y;
startTheta = mySub.LatestMessage.Theta;

%--- Move ----
while (abs(distY) >epsilon)
    Turtle_Drehung
    Turtle_Y_Fahrt
end

% Debug Ausgabe
str = sprintf('Ziel erreicht!   goalX: %f goalY: %f poseX: %f poseY: %f', goalX, goalY, poseX, poseY);
disp(str)








