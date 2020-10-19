

%this is the main code of client side (MATLAB API)

vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);


%total boxes to count..
red_boxes = 0;
blue_boxes = 0;


%speed of the manipulator..
speed = 40;

%home position just above the center of the conveyor..(pick-up place)
home = [0.00,-0.75,0.85,0,0,0];

%two points path to red table..
%[x,y,z,alpha,beta,gamma]
red_path = [ 
    %0.00,-0.75,0.9,0,0,0;
    
   -0.4,-0.625,0.9,0,0,0;
   ];

blue_path = [ 
    %0.00,-0.75,0.9,0,0,0;
    0.4,-0.625,0.9,0,0,0;
    ];



%if connection successful...
if (clientID>-1)
        disp('Connected to remote API server');
    
        
        %creating needed handles to all required objects in the
        %simulation..
        [res,blue_path1] = vrep.simxGetObjectHandle(clientID, 'blue_path_1',vrep.simx_opmode_blocking);
        [res,blue_path2] = vrep.simxGetObjectHandle(clientID, 'blue_path_2',vrep.simx_opmode_blocking);
        [res,red_path1] = vrep.simxGetObjectHandle(clientID, 'red_path_1',vrep.simx_opmode_blocking);
        [res,red_path2] = vrep.simxGetObjectHandle(clientID, 'red_path_2',vrep.simx_opmode_blocking);
        [res,color_sensor] = vrep.simxGetObjectHandle(clientID, 'color_sensor',vrep.simx_opmode_blocking);
        [res,j1] = vrep.simxGetObjectHandle(clientID, 'ROBOTIQ_85_active1',vrep.simx_opmode_blocking);
        [res,j2] = vrep.simxGetObjectHandle(clientID, 'ROBOTIQ_85_active2',vrep.simx_opmode_blocking);
        %[res,prox] = vrep.simxGetObjectHandle(clientID, 'prox_sensor',vrep.simx_opmode_blocking);
        [res,target] = vrep.simxGetObjectHandle(clientID, 'target',vrep.simx_opmode_blocking);
        
        %[res,resolution,image] = vrep.simxGetVisionSensorImage2(clientID,color_sensor,0,vrep.simx_opmode_streaming);
       
        
       
        
        %while 20 boxes havent been sorted... change this number to pick
        %more boxes but then change the scipt of the box spawner too..
        
        while( red_boxes + blue_boxes < 20)
            
            %open gripper.
            gripper(clientID,'off');
            
            %reading box color...
            [err,signal]=vrep.simxGetAndClearStringSignal(clientID,'box_signal',vrep.simx_opmode_streaming);
            
            
            while(err == 1)
                [err,signal]=vrep.simxGetAndClearStringSignal(clientID,'box_signal',vrep.simx_opmode_streaming);
            end
            if (strcmp(signal,'red') || strcmp(signal,'blue'))
                
                disp('Box detected..');
               
                
                %reading distance using signal reading...
                [err,distance]=vrep.simxGetFloatSignal(clientID,'distance',vrep.simx_opmode_streaming);
                
                %reading distance again if there is error..
                while(err ==1 || distance <= 0.4)
                    [err,distance]=vrep.simxGetFloatSignal(clientID,'distance',vrep.simx_opmode_streaming);
                    
                end
                distance
                %going to pick
                disp('Going to pick....');
                
                %moving linearly to home position...
                moveL(clientID,target,home,speed,1);
                
                %setting pick up postion
                pick_up = home;
                
                %but Y coordinate is equal to the distance read by the
                %sensor
                pick_up(2) = -distance;
                
                %moving the gripeer above the box...
                
                %gripper(clientID,'off');
                moveL(clientID,target,pick_up,speed,1);
                
                %setting z-coord to go down...
                pick_up(3) = 0.74;
                moveL(clientID,target,pick_up,speed-20,1);
                
                %closing the gripper
                pause(0.7);
                gripper(clientID,'on');
                
                
                %checking color signal again to avoid any error...
                [err,signal]=vrep.simxGetAndClearStringSignal(clientID,'box_signal',vrep.simx_opmode_streaming);
                
                
                while(err == 1 || strcmp(signal,'none'))
                    [err,signal]=vrep.simxGetAndClearStringSignal(clientID,'box_signal',vrep.simx_opmode_streaming);
                end
                
                moveL(clientID,target,home,speed-20,1);
                disp('Going to place....');
                
                
                
                
                
                
                
                %if the bos is RED...
                if (strcmp(signal,'red'))
                   
                    
                    
                    
                    
                    
                    
                    %red box detected....
                    red_boxes = red_boxes + 1;
                    
                    
                    %READING the dropping position...
                    [x,y] = get_red_position(-0.5,-0.1725,0.08,4,3,red_boxes,0.02);
                    
                    
                    
                    
                    
                    %moving through the points..
                    %{
                    for pt = 1:size(red_path,1)
                        moveL(clientID,target,red_path(pt,:),speed,0);
                    end
                    %}
                    
                    %going to dropping point, going down and dropping...
                    moveL(clientID,target,[x,y,0.8,0,0,0],speed,-1);
                    moveL(clientID,target,[x,y,0.7,0,0,0],speed,-1);
                    disp('Destination reached...')
                    gripper(clientID,'off');
                    moveL(clientID,target,[x,y,0.8,0,0,0],speed,0);
                    moveL(clientID,target,home,speed,0);
                    %pause(0.8);
                
                
                    
                elseif (strcmp(signal,'blue'))
                    %BLUE box detected....
                    blue_boxes = blue_boxes + 1;
                    [x,y] = get_blue_position(0.65,-0.1725,0.08,4,3,blue_boxes,0.02);
                   
                    %{
                    for pt = 1:size(blue_path,1)
                        moveL(clientID,target,blue_path(pt,:),speed,0);
                    end
                   %}
                    
                    
                    moveL(clientID,target,[x,y,0.8,0,0,0],speed,-1);
                    moveL(clientID,target,[x,y,0.7,0,0,0],speed,-1);
                    disp('Destination reached...')
                    gripper(clientID,'off');
                    moveL(clientID,target,[x,y,0.8,0,0,0],speed,0);
                    moveL(clientID,target,home,speed,0);
                    %pause(0.8);
                end
                
                
                
                
            end
                

        end
        
        vrep.delete();
        disp('Job completed successfully!... ');
        





else
        disp('no connection!')
end