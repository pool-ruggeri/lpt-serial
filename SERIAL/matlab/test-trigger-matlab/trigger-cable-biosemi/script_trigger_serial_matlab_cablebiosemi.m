%% inspired from biosemi website

% define things for biosemi trigger cable 
port_num = input('Quel numero de port com pour le trigger ','s') ;
port = ['COM',port_num];
usb = serial(port,'BaudRate',115200,'DataBits',8, 'StopBits', 1, 'Parity', 'none');
get(usb);
fopen(usb);

% send trigger
fwrite(usb,50);

% close COM port
fclose(usb);

% NB: the port seems not to close ! one should reboot matlab.. to be
% checked. I think that if we manage to modify the functions done for the
% MMBTS to include the biosemi trigger cable, this issue is solved 


%% alternatives
% I think that the functions downloaded from gitub for the MMBTS are also
% working for the biosemi trigger cable, I think that one needs to change
% the baudrate. To test. One can take those functions and implement the
% option for the baudrate of the biosemi trigger cable, so that the same
% functions cn be used for both biosemi and neurospec trigger cables ! 