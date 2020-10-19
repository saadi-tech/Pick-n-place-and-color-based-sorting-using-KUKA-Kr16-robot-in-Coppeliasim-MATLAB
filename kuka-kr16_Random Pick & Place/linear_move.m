function moveL( clientID, target , pos, speed  )

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% This function moves between two points linearly....
vrep = remApi('remoteApi');


%getting the position and orientation of the target dummy...
[r,p] = vrep.simxGetObjectPosition(clientID,target,-1,vrep.simx_opmode_blocking);
[r,o] = vrep.simxGetObjectOrientation(clientID,target,-1,vrep.simx_opmode_blocking);




%there are two directions to acheive any orientation, ie. positve roation
%and negative rotation..
%here wer are finding the shortest one..
for i = 1:3
    if ( (abs(pos(i+1) - o(i))) && (o(i)<0))
        o(i) = o(i)+ 2 * pi;
    elseif ((abs(pos(i+3) - o(i)) > pi) && (o(i)>0))
        o(i) = o(i)-2*pi;
    end

end


%finding the total distance.
old_pos = [p o];
delta_pos = pos - old_pos;
distance = norm(delta_pos);

%taking some samples,.. accross the way....
samples_number = 20;



for i = 1:samples_number

    %changing position gradually ...
    med_pose = old_pos + (delta_pos/samples_number);
    
    tic;
    
    while(toc < (distance / (speed * samples_number)))
    end
    
    %moving to new locations...
    vrep.simxSetObjectPosition(clientID,target,-1,med_pose,vrep.simx_opmode_blocking);
    vrep.simxSetObjectOrientation(clientID,target,-1,med_pose(4:6),vrep.simx_opmode_blocking);
    old_pos = med_pose;
end
end

