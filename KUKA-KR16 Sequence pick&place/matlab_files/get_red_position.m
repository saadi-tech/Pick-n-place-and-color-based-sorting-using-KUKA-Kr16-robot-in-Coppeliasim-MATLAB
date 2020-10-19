function [ x,y ] = get_red_position( startx,starty,box_size,rows,cols,box_number,offset )


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


%for red table.... 
%{
----> y-AXIS
| 7 8 9
| 4 5 6 
| 1 2 3 
|X-axis,..

%}

%so X,Y positions...
y = starty + (box_size + offset)*(X-1);
x = startx - (box_size + offset)*(Y-1);


end

