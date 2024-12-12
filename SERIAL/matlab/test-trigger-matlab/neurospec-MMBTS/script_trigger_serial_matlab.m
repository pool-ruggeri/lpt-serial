clear all
close all
clc


addpath('C:\Users\pruggeri\Documents\Useful_triggers\SERIAL\matlab\NeurospecTriggerBox-master')

% open COM port 
port = open_ns_port(3);

% send trigger
send_ns_trigger(10,port)
pause(0.015)
send_ns_trigger(0,port)

% close port
close_ns_port(port)