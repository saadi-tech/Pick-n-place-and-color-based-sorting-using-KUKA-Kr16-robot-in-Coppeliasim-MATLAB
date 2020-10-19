function  gripper( clientID, msg )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
vrep = remApi('remoteApi');



%this function controls the gripper by sending signals to 'request'
%topic...

[res,replyData]=vrep.simxQuery(clientID,'request',msg,'reply',5000);
if (res==0)
            if (strcmp(msg,'on'))
                disp('Gripper closed..')
            elseif (strcmp(msg,'off'))
                disp('Gripper opened..')
            end
end
pause(1)
end

