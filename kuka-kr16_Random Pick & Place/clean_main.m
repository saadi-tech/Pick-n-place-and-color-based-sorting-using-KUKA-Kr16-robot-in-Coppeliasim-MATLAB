

%this is the main code of client side (MATLAB API)

vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);



%speed of the manipulator..
speed = 40;

%home position just above the center of the conveyor..(pick-up place)
home = [0.3,0.2,01,0,0,0];

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


%middle points for RED and BLUE trajectory.
pt1b = [0.95,-0.325,1.225,0,0,0];
pt1r = [-0.25,-0.5,1.225,0,0,0];




%if connection successful...
if (clientID>-1)
        disp('Connected to remote API server');
    
        
        %creating needed handles to all required objects in the
        %simulation..
       
        [res,target] = vrep.simxGetObjectHandle(clientID, 'target',vrep.simx_opmode_blocking);
        
       
      
        
        while( 1 )
            
            %open gripper.
            [ret] = vrep.simxSetIntegerSignal(clientID,'BaxterVacuumCup_active',0,vrep.simx_opmode_oneshot);
            
            
            
            %reading box color...
            [err,signal]=vrep.simxGetAndClearStringSignal(clientID,'box_detector',vrep.simx_opmode_blocking);
            
            
            %waiting for the error to clear
            while(err == 1)
                [err,signal]=vrep.simxGetAndClearStringSignal(clientID,'box_detector',vrep.simx_opmode_blocking);
            end
            
            
            
            %if its blue or red.
            if (strcmp(signal,'red') || strcmp(signal,'blue'))
                
                disp('Box found..');
               
                
                %reading distance using signal reading...
                [err,distance]=vrep.simxGetFloatSignal(clientID,'distance',vrep.simx_opmode_streaming);
                
                %reading distance again if there is error..
                while(err ==1 || distance <= 0)
                    
                    [err,distance]=vrep.simxGetFloatSignal(clientID,'distance',vrep.simx_opmode_streaming);
                    
                end
                distance
                
                
                
        
                %if the bos is RED...
                if (strcmp(signal,'red'))
                   
                    
                    
                    
                    
                    
                    
                    %going to pick
                    disp('Going to pick....');
                
                    %moving linearly to home position...
                    
                
                    %setting pick up postion
                    pick_up = home;
                
                    %but Y coordinate is equal to the distance read by the
                    %sensor
                    pick_up(2) = distance;
                
                    %moving the gripeer above the box...
                
                    %[ret] = vrep.simxSetIntegerSignal(clientID,'BaxterVacuumCup_active',0,vrep.simx_opmode_oneshot);
                    linear_move(clientID,target,pick_up,speed);
                
                    %setting z-coord to go down...
                    % pick_up(3) = 0.785;
                     pick_up(3) = 0.785;
                
               
                    linear_move(clientID,target,pick_up,speed);
                
                    %closing the gripper
                    pause(0.7);
                    [ret] = vrep.simxSetIntegerSignal(clientID,'BaxterVacuumCup_active',1,vrep.simx_opmode_oneshot);
                
                
                
                    linear_move(clientID,target,home,speed);
                    disp('Going to place....');
                    
                   
                    %moving to point-1 of red...
                    linear_move(clientID,target,pt1r,speed);
                    
                  
                    
                    
                    %going to dropping point, going down and dropping...
                    inp = [-0.325,0.05,-1.35,-1.05];
                    data = getting_random_position(inp);
                    
                    red_pt = [data(1),data(2),0.95,0,0,0];
                        
                     linear_move(clientID,target,red_pt,speed);
                    
                    linear_move(clientID,target,red_pt - [0,0,0.1,0,0,0],speed);
                    
                    disp('Red Box dropped...')
                    
                    [ret] = vrep.simxSetIntegerSignal(clientID,'BaxterVacuumCup_active',0,vrep.simx_opmode_oneshot);
                    
                    %returing to point-1 Red, and then to home position
                    linear_move(clientID,target,pt1r,speed);
                    linear_move(clientID,target,home,speed);
                    
                
                
                    
                elseif (strcmp(signal,'blue'))
                        %BLUE box detected....
                    
                    
                    
                         %going to pick
                        disp('Going to pick....');
                
                        %moving linearly to home position...
                        %linear_move(clientID,target,home,speed);
                
                        %setting pick up postion
                        pick_up = home;
                
                        %but Y coordinate is equal to the distance read by the
                        %sensor
                        pick_up(2) = distance;
                
                        %moving the gripeer above the box...
                
                        %[ret] = vrep.simxSetIntegerSignal(clientID,'BaxterVacuumCup_active',0,vrep.simx_opmode_oneshot);
                        linear_move(clientID,target,pick_up,speed);
                
                        %setting z-coord to go down...
                        % pick_up(3) = 0.785;
                        pick_up(3) = 0.78;
                
               
                        linear_move(clientID,target,pick_up,speed);
                
                        %closing the gripper
                        pause(0.7);
                        [ret] = vrep.simxSetIntegerSignal(clientID,'BaxterVacuumCup_active',1,vrep.simx_opmode_oneshot);
                
                
                
                
                        linear_move(clientID,target,home,speed);
                        disp('Going to drop....');
                    

                        
                        
                        linear_move(clientID,target,pt1b,speed);
                        inp = [0.525,0.9,-1.1,-1.35];
                        %goind to dropping point
                        data = getting_random_position(inp);
                    
                        blue_pt = [data(1),data(2),0.95,0,0,0];
                        
                        
                        linear_move(clientID,target,blue_pt,speed);
                        linear_move(clientID,target,blue_pt - [0,0,0.1,0,0,0],speed);
                        %linear_move(clientID,target,[x,y,0.8,0,0,0],speed);
                        %linear_move(clientID,target,[x,y,0.7,0,0,0],speed);
                        disp('Destination reached...')
                        [ret] = vrep.simxSetIntegerSignal(clientID,'BaxterVacuumCup_active',0,vrep.simx_opmode_oneshot);
                        linear_move(clientID,target,pt1b,speed);
                        linear_move(clientID,target,home,speed);
                       
                end
                
                
                
              pause(0.7);  
            end
                

        end
        
        vrep.delete();
        
        





else
        disp('no connection!')
end