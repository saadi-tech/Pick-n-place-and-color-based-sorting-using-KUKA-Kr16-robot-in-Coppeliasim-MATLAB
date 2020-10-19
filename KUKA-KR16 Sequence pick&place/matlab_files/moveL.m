function moveL( clientID, target,pos, speed ,slow )

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
samples_number = 0;

if (slow == 0)
   samples_number= round(distance*30);
elseif (slow == 1)
    samples_number = round(distance*50);
else
    samples_number = round(distance*40);
end

for i = 1:samples_number

    %changing position gradually ...
    interm_pos = old_pos + (delta_pos/samples_number);
    
    tic;
    
    while(toc < (distance / (speed * samples_number)))
    end
    
    %moving to new locations...
    vrep.simxSetObjectPosition(clientID,target,-1,interm_pos,vrep.simx_opmode_blocking);
    vrep.simxSetObjectOrientation(clientID,target,-1,interm_pos(4:6),vrep.simx_opmode_blocking);
    old_pos = interm_pos;
end
end

