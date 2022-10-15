function param = SetUIParams(p)

    %Params from "Multiband compression example app"
    p(1).Name = 'Band 1 Compression Factor';
    p(1).InitialValue = 5;
    p(1).Limits =  [1, 100];
    p(2).Name = 'Band 1 Threshold (dB)';
    p(2).InitialValue = -5;
    p(2).Limits = [-80, 0];
    p(3).Name = 'Band 1 Attack Time (s)';
    p(3).InitialValue = 0.005;
    p(3).Limits =  [0, 4];
    p(4).Name = 'Band 1 Release Time (s)';
    p(4).InitialValue = 0.100;
    p(4).Limits = [0, 4];
    p(5).Name = 'Band 2 Compression Factor';
    p(5).InitialValue = 5;
    p(5).Limits =  [1, 100];
    p(6).Name = 'Band 2 Threshold (dB)';
    p(6).InitialValue = -10;
    p(6).Limits = [-80, 0];
    p(7).Name = 'Band 2 Attack Time (s)';
    p(7).InitialValue = 0.005;
    p(7).Limits =  [0, 4];
    p(8).Name = 'Band 2 Release Time (s)';
    p(8).InitialValue = 0.1;
    p(8).Limits = [0, 4];
    p(9).Name = 'Band 3 Compression Factor';
    p(9).InitialValue = 5;
    p(9).Limits =  [1, 100];
    p(10).Name = 'Band 3 Threshold (dB)';
    p(10).InitialValue = -20;
    p(10).Limits = [-80, 0];
    p(11).Name = 'Band 3 Attack Time (s)';
    p(11).InitialValue = 0.002;
    p(11).Limits =  [0, 4];
    p(12).Name = 'Band 3 Release Time (s)';
    p(12).InitialValue = 0.050;
    p(12).Limits = [0, 4];
    p(13).Name = 'Band 4 Compression Factor';
    p(13).InitialValue = 5;
    p(13).Limits =  [1, 100];
    p(14).Name = 'Band 4 Threshold (dB)';
    p(14).InitialValue = -30;
    p(14).Limits = [-80, 0];
    p(15).Name = 'Band 4 Attack Time (s)';
    p(15).InitialValue = 0.002;
    p(15).Limits =  [0, 4];
    p(16).Name = 'Band 4 Release Time (s)';
    p(16).InitialValue = 0.050;
    p(16).Limits = [0, 4];
    
    %Other params (masker?)
    p(17).Name = 'Range(k)';
    p(17).InitialValue = 0.0;
    p(17).Limits = [0, 80];
    
    p(18).Name = 'ATQ influence';
    p(18).InitialValue = 0.0;
    p(18).Limits = [0, 1];

    param = p;

end
