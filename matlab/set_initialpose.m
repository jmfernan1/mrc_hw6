function set_initialpose(x,y,yaw);
initialpose = rospublisher('/amcl_pose');
msg = rosmessage(initialpose);
 
q = eul2quat(yaw);

%Pose array
msg.Pose.Pose.Position.X = x; 
msg.Pose.Pose.Position.Y = y; 
msg.Pose.Pose.Position.Z = 0; 
%Yaw Point
msg.Pose.Pose.Orientation.X = q(1);
msg.Pose.Pose.Orientation.Y = q(2);
msg.Pose.Pose.Orientation.Z = q(3);
msg.Pose.Pose.Orientation.W = q(4);

%Covariance
msg.Pose.Covariance =  [0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.0, 0.0,...
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,...
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,...
    0.06853891945200942];
 
send(initialpose,msg);
end
