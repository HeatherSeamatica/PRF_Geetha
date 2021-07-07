function [index_length, array] = get_P1_time_group(Smp_Rate)
fclose all;
clc;
close all;

Const_4M = 4*1024*1024;

StartFrameNum = 1; %Starts from 0
EndFrameNum   = 100;

WindSize = (EndFrameNum - StartFrameNum) * Const_4M * 2; % "* 2" because data has I/Q for each sample 
StartFrameRead = (StartFrameNum) * Const_4M * 2 * 2;     % fseek function is based on byte and last *2 is to skeep 2 bytes for each frame

if Smp_Rate == 5e6
    fp_1030 = fopen('/home/seamatica/rx_to_file_2.dat','rb');
elseif Smp_Rate == 20e6
    fp_1030 = fopen('C:\Chronos\DataMatlab\Matlab\Data_1030_SR20M_BW20M.dat','rb');
elseif Smp_Rate == 61e6
    fp_1030 = fopen('F:\Data_1030_SR61M_BW50M.dat', 'rb');
end

fseek(fp_1030, StartFrameRead,'bof');
data_1030 = fread(fp_1030,WindSize,'int16');
fclose(fp_1030);


D1030_I = data_1030(1:2:end);
D1030_Q = data_1030(2:2:end);
% D1030_I = siglIreal;
% D1030_Q = siglQreal;
Amp_1030 = sqrt(D1030_I.^2 + D1030_Q.^2);
    
Pls_Width = round(0.8e-6*Smp_Rate); %Pulse width is 0.8us, NS = number of samples
Pls_Distance = round(0.008*Smp_Rate);
    
    % ------------- FIGURE 1 -------------- %
    figure; plot(Amp_1030);
    if Smp_Rate == 5e6
        Amp_1030_P1 = find(Amp_1030 > 27000);
    elseif Smp_Rate == 20e6
        Amp_1030_P1 = find(Amp_1030 > 3000);
    elseif Smp_Rate == 61e6
        Amp_1030_P1 = find(Amp_1030 > 3000);
    end
    
    Amp_1030_P1_Extract = Amp_1030(Amp_1030_P1);
    
    % ------------- FIGURE 2 -------------- %
    figure; stem(Amp_1030_P1, Amp_1030_P1_Extract);
    Amp_1030_diff = diff(Amp_1030_P1);
    
    Amp_1030_P3_ledg = find(Amp_1030_diff >= Pls_Distance - Pls_Width*5);
    P3_Pls = Amp_1030_P1(Amp_1030_P3_ledg);
    
    Amp_1030_P1_ledg = find(Amp_1030_diff >= 7e-6 * Smp_Rate & Amp_1030_diff <= 22e-6 * Smp_Rate);
    P1_Pls = Amp_1030_P1(Amp_1030_P1_ledg);
    
    Ref_NS_P1 = [];
    Ref_NS_P3 = [];
    % ------------- FIGURE 3 -------------- %
    figure; plot(Amp_1030);
    
    for i= 1:size(P1_Pls,1)
        Left_P1  = P1_Pls(i) - Pls_Width * (Smp_Rate / 1e6);
        Right_P1 = P1_Pls(i) + Pls_Width * (Smp_Rate / 1e6);
        Current_P1_Wind = Amp_1030(Left_P1:Right_P1);
        [Max_P1_Amp, Max_P1_index] = maxk(Current_P1_Wind,(Smp_Rate / 1e6 * 2));
        Max_P1_index = Max_P1_index + Left_P1-1;
        Ref_P1 = 0.63 * mean(Amp_1030(Max_P1_index));
        Ref_P1_Extract = find(Current_P1_Wind >= Ref_P1 );
        FirstSmp_Ref_Index_P1 = Ref_P1_Extract(1) + Left_P1-1;
        FirstSmp_Ref_Amp_P1  = Amp_1030(FirstSmp_Ref_Index_P1);
        hold on; plot(FirstSmp_Ref_Index_P1,FirstSmp_Ref_Amp_P1,'r*');
        Ref_NS_P1 = [ Ref_NS_P1 FirstSmp_Ref_Index_P1]; 
    end
    
    for i= 1:size(P3_Pls,1)
        Left_P3  = P3_Pls(i) - Pls_Width * (Smp_Rate / 1e6);
        Right_P3 = P3_Pls(i) + Pls_Width * (Smp_Rate / 1e6);
        Current_P3_Wind = Amp_1030(Left_P3:Right_P3);
        [Max_P3, Max_P3_index] = maxk(Current_P3_Wind,10);
        Max_P3_index = Max_P3_index + Left_P3-1;
        Ref_P3= 0.63 * mean(Amp_1030(Max_P3_index));
        Ref_P3_Extract = find(Current_P3_Wind >= Ref_P3);
        FirstSmp_Ref_Index_P3 = Ref_P3_Extract(1) + Left_P3-1;
        FirstSmp_Ref_Amp_P3  = Amp_1030(FirstSmp_Ref_Index_P3);
        hold on; plot(FirstSmp_Ref_Index_P3,FirstSmp_Ref_Amp_P3,'r*');
        Ref_NS_P3 = [Ref_NS_P3 FirstSmp_Ref_Index_P3];
    end
    
Ref_Time_P1 = Ref_NS_P1/Smp_Rate;
Ref_Time_P1_diff = diff(Ref_Time_P1);
Ref_NS_P1_diff = diff(Ref_NS_P1);

Ref_Time_P3 = Ref_NS_P3/Smp_Rate;
Ref_Time_P3_diff = diff(Ref_Time_P3);
Ref_NS_P3_diff = diff(Ref_NS_P3);

P1_time_interval = {};

temp_P1_time = [];

for i = 1:length(Ref_Time_P1_diff)
    if Ref_Time_P1_diff(i) ~= 0
        temp_P1_time = [temp_P1_time, Ref_Time_P1_diff(i)];
    end
end


temp_P1_time = reshape(temp_P1_time, [length(temp_P1_time), 1]);

n_P1 = 1;
k_P1 = 0;
for j = 1 : size(temp_P1_time, 1)
    if temp_P1_time(j) < 0.01
        P1_time_interval{n_P1, j-k_P1} = temp_P1_time(j);
    else
        n_P1 = n_P1 + 1;
        k_P1 = j;
    end
end

modeTime = [];
modePattern = [];
if length(P1_Pls) <= length(P3_Pls)
    length_pulse = length(P1_Pls);
else
    length_pulse = length(P3_Pls);
end
for i = 1: length_pulse
    temp = (P3_Pls(i) - P1_Pls(i))/ Smp_Rate;
    if temp > 8e-06
        temp_P = 1;
        modePattern = [modePattern, temp_P];
    else
        temp_P = 0;
        modePattern = [modePattern, temp_P];
    end
    modeTime = [modeTime, temp];
end

index_length = size(P1_time_interval,1);
array = [];
for i = 1: size(P1_time_interval, 1)
    for j = 1: size(P1_time_interval, 2)
        if length(P1_time_interval{i, j}) == 0
            array(i, j) = 0;
        else
            array(i, j) = round(P1_time_interval{i, j}, 4);
        end
    end
end

fprintf("Done\n");
fclose all;
    