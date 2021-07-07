clear;
clc;fclose all;
close all;
index = 1;
[index_length, array] = get_P1_time_group(5e6);
length_temp = 0;
arrayA = array;
length_pattern = 0;
unresolved_Group = [];
while length_temp < 17
    if isempty(unresolved_Group) & length_pattern == 16
        break;
    else
        if index < index_length
            if index == 1
                temp = arrayA(index, :);
                temp_pattern = [];
                for i = 1: length(temp)
                    if temp(i) ~= 0
                        temp_pattern = [temp_pattern, temp(i)];
                    end
                end
                unresolved_Group = [];
                index = index + 1;
            else
                g1 = temp_pattern;
                g2 = arrayA(index,:);
                g3 = unresolved_Group;
                g4 = temp_pattern;
                [temp_pattern, unresolved_Group] = find_pattern(g1, g2, g3, g4);
                g1 = temp_pattern;
                g2 = unresolved_Group;
                g3 = unresolved_Group;
                g4 = temp_pattern;
                [temp_pattern, unresolved_Group] = find_unresolved_pattern(g1, g2, g3, g4);
                index = index + 1;
            end
        else
            break;
        end
        pattern = [];
        index_list = [];
        length_temp = length(temp_pattern);
        for i = 1: length_temp
            if i <= 16
                pattern = [pattern, temp_pattern(i)];
            end
        end
        if length(pattern) == 16
            index_list  = [index_list, index];
        end
        length_pattern = length(pattern);
    end
end

