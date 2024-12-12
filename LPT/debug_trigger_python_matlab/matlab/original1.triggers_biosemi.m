LPT1_Port = '3FE8'; % memory location (look at gestionnaire de periph. and search LTP ports)
address = hex2dec(LPT1_Port);

config_io;

% Send marker to Parallel port
outp(address,10); 
% Reset Parallel port
outp(address,0);