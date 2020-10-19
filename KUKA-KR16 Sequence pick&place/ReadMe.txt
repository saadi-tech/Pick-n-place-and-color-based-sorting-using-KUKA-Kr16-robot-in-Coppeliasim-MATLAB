

So basically it has only one scene file working_filev2.ttt which will run along with 
MATLAB as MATLAB will interact through its API.

How to set that up?

- If you are using 64bits Windows OS, then no worries it is all figured.
- Else follow this:

	- Go to Coppelia directory then go to:
	 programming/remoteApiBindings/matlab/matlab/

	- Then copy and replace remApi,remoteApiProto into the directory I have sent (which has matlab codes) (Replace the files there)
	
	- Then go to programming/remoteApiBindings/lib/lib/ then choose your OS, and then copy that .dll file into the directory too.

Everything is setup now.


Open the scene file and start the simulation, the boxes will start to drop.
While keeping it running, run the main matlab file ("main.m") in MATLAB.

Then see it doing its magic! :) 