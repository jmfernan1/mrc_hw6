clear all; clc; close all
%% Init
% Setup ROS with defaults
%rosinit()

% Get a list of available actions to see what servers are available
rosaction list

%% Initial Pose of turtlebot
x=0;y=0;yaw=[0 0 0];
set_initialpose(x,y,yaw);


%% Populate the goal to be sent to the server
% A good way to determine the syntax is to use tab-complete in the command
% window
%POSE X&Y
x=[1.9;4.4;4.9;0.8];
y=[-2.2;-3.0;0.4;-0.0];
%YAW
W=[0.7;0.7;-0.3;0.9];
X=[0;0;0;0];
Y=[0;0;0;0];
Z=[0.7;0.7;0.95;-0.07];
count=numel(x);
i=1;

while i <= count;
%% Connect to move_base action server
% This initiates the client and prints out some diagnostic information
[client,goalMsg] = rosactionclient('/move_base');
waitForServer(client);

% Is the client connected to the server?
client.IsServerConnected

%% Setup call back functions for the action client
client.ActivationFcn=@(~)disp('Goal active');
client.FeedbackFcn=@(~,msg)fprintf('Feedback: X=%.2f, Y=%.2f, yaw=%.2f, pitch=%.2f, roll=%.2f  \n',msg.BasePosition.Pose.Position.X,...
    msg.BasePosition.Pose.Position.Y,quat2eul([msg.BasePosition.Pose.Orientation.W,...
    msg.BasePosition.Pose.Orientation.X,msg.BasePosition.Pose.Orientation.Y, ...
    msg.BasePosition.Pose.Orientation.Z]));

client.FeedbackFcn=@(~,msg)fprintf('Feedback: X=%.2f\n',msg.BasePosition.Pose.Position.X);
client.ResultFcn=@(~,res)fprintf('Result received: State: <%s>, StatusText: <%s>\n',res.State,res.StatusText);


goalMsg.TargetPose.Header.FrameId = 'map';
goalMsg.TargetPose.Pose.Position.X = x(i);
goalMsg.TargetPose.Pose.Position.Y = y(i);
%yawtgt = pi/2;   % Setting the target heading
%q = eul2quat([yawtgt, 0,0]);
goalMsg.TargetPose.Pose.Orientation.W = W(i);   
goalMsg.TargetPose.Pose.Orientation.X = X(i);   
goalMsg.TargetPose.Pose.Orientation.Y = Y(i);   
goalMsg.TargetPose.Pose.Orientation.Z = Z(i);   


%% Start the action and wait for it to finish - successfully or not
sendGoalAndWait(client,goalMsg);
%fprintf('Action completed: State: <%s>, StatusText: <%s>\n',resultmsg.State,resultmsg.StatusText);


%% If necessary, cancel the action 
cancelAllGoals(client)
delete(client)
clear goalMsg
i = i + 1;
end

%% Shutdown
% rosshutdown()
