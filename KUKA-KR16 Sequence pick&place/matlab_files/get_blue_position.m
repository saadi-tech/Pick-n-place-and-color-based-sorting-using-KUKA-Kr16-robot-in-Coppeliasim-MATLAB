function [ x,y ] = get_blue_position( startx,starty,box_size,rows,cols,box_number,offset )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%this function tells the X,Y position of the space on the table to sort the
%objects...

%first we take a grid of row*cols dimension, and then find the posiion of
%incoming box in the grid...

total = 0;

X = 0;
Y = 0;
for row = 1:rows
    
    for col = 1:cols
        total= total+1;
        
        if (total == box_number)
            X = col;
            Y = row;
            break;
        end
    if X~=0
        break
    end
    end
end



%for blue table.... 
%{
<---- y-AXIS
| 9 8 7
| 6 5 4 
| 3 2 1 
|X-axis,..

%}

%so X,Y positions...
y = starty + (box_size + offset)*(X-1);
x = startx + (box_size + offset)*(Y-1);


end

