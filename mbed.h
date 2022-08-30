import mbed.*% Open a serial connection to mbed on port COM4
mymbed = SerialRPC('COM4', 9600);
mymbed.reset();
pause(0.5);
ME = []; % exception vector for try-catch
try
% Here we attach Matlab to the RPCFunction on mbed
set_LED_car_mbed = RPCFunction(mymbed, 'set_LED_car_mbed');
set_LED_pedestrian_mbed = RPCFunction(mymbed,
'set_LED_pedestrian_mbed');
% Run the mbed function continuously
while (char(label)==pedestrian)
set_LED_car_mbed.run ('') ;
set_LED_pedestrian_mbed.run ('') ;
end
catch ME
disp('Error:');
disp(ME.message);
end
% cleanup
mymbed.delete;
clear;