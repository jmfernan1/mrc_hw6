clear all; clc; close all
% Create a bag file object with the file name
bag = rosbag('~/mrc_hw5_data/hw6_3.bag');
   
% Display a list of the topics and message types in the bag file
bag.AvailableTopics;
   
% Since the messages on topic /odom are of type Odometry,
% let's see some of the attributes of the Odometry

% This helps determine the syntax for extracting data
msg_odom = rosmessage('nav_msgs/Odometry');
showdetails(msg_odom);
   
% Get just the topic we are interested in
bagselect = select(bag,'Topic','/odom');
   
% Create a time series object based on the fields of the turtlesim/Pose
% message we are interested in
ts = timeseries(bagselect,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Twist.Twist.Linear.X','Twist.Twist.Angular.Z',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');

x1=ts.data(:,1);
y1=ts.data(:,2);

% Select by topic
amcl_select = select(bag,'Topic','/amcl_pose');
 
% Create time series object
ts_amcl = timeseries(amcl_select,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');

x2=ts_amcl.data(:,1);
y2=ts_amcl.data(:,2);

% Select by topic
goal_select = select(bag,'Topic','/move_base/goal');
 
% Create time series object
ts_goal = timeseries(goal_select,'Goal.TargetPose.Pose.Position.X','Goal.TargetPose.Pose.Position.Y',...
    'Goal.TargetPose.Pose.Orientation.W','Goal.TargetPose.Pose.Orientation.X',...
    'Goal.TargetPose.Pose.Orientation.Y','Goal.TargetPose.Pose.Orientation.Z');

x3=ts_goal.data(:,1);
y3=ts_goal.data(:,2);
 
% Read the image
ifile = '~/map.pgm';   % Image file name
I=imread(ifile);
 
% Set the size scaling
xWorldLimits = [-10 9.2];
yWorldLimits = [-10 9.2];
RI = imref2d(size(I),xWorldLimits,yWorldLimits);
 
% Plot
figure
imshow(flipud(I),RI)
set(gca,'YDir','normal')
hold on
plot(x1,y1);
hold on
plot(x2,y2);
hold on
plot(x3,y3,'r*');
legend('X&Y','AMCL','Goals');
