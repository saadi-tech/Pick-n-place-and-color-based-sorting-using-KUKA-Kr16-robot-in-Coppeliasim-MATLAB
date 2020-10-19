function [ out ] = getting_random_position( input )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%this function gives a random position on the table given input = [
%   [xmin,xmax, ymin,ymax]
x = input(1) + (input(2)-input(1)).*rand(1,1);
y = input(3) + (input(4) - input(3)).*rand(1,1);

out = [x,y];
end

