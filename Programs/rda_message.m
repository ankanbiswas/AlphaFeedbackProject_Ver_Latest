   
function rawData = rda_message(sock,hdr)
%% Getting information for the header
    Fs = hdr.Fs;  % getting the sampling frquency of the data   
    resolution = hdr.resolutions(1,1);  % Assuming the resolution is same across the channels, change this if otherwise
    chanindx = hdr.chanindx;
    X = []; 
    SQN = [];
    col = 0;
    rawData = [];
    
%     for i = 1:1000
    while (col < Fs) % here check how brainAmp is solving the problem
    % read the message header
        msg       = [];
        msg.uid   = tcpread_new(sock, 16, 'uint8',0);
        msg.nSize = tcpread_new(sock, 1, 'int32',0);
        msg.nType = tcpread_new(sock, 1, 'int32',0);

        % read the message body
        switch msg.nType
            case 4
                % this is a 32 bit floating point data block
                msg.nChannels     = hdr.orig.nChannels;
                msg.nBlocks       = tcpread_new(sock, 1, 'int32',0);    % this we want to check fo rany potential data loss
                                                                           % as it specifies the curretn block number 
                                                                           % since the start of monitoring
                msg.nPoints       = tcpread_new(sock, 1, 'int32',0);
                msg.fData         = tcpread_new(sock, [msg.nChannels msg.nPoints], 'single',0);
                msg.nMarkers      = tcpread_new(sock, 1, 'int32',0);
            case 3
                display('acquisition has stopped');
                break

            otherwise
                % ignore all other message types
        end    

        %% Converting the data from the RDA message into data 
        dat     = []; % the main variable inside which the data will be stored
        seqno   = [];
        if msg.nType == 4 && msg.nPoints > 0
            % FIXME should I apply the calibration here?
            dat     = msg.fData(chanindx,:);
            seqno   = msg.nBlocks;
        end

        if ~isempty(dat) % if the dat is nonemepty then
            dat = double(dat*resolution); 
            X  = [X dat];
            SQN = [SQN seqno];
            [~,col]= size(X);
        end        
    end 
    rawData = X;
end