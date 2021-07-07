    function [temp_pattern, unresolved_group] = find_pattern(g1, g2, g3, g4)

length_group1 = length(g1);
length_group2 = length(g2);
group1 = g1;
group2 = [];
group3 = g3;
group4 = g4;

for i = 1:length_group2
    if g2(i) == 0
        length_group2 = length_group2 - 1;
    else
        group2 = [group2, g2(i)];
    end
end

pattern_temp = 0;
pattern_found = 0;

for i = 1: length_group1
    for j = 1: length_group2
        if i+2 <= length_group1 & j+2 <= length_group2
            if pattern_temp == 0
                if group1(i) == group2(j) & group1(i+1) == group2(j+1) & group1(i+2) == group2(j+2)
                    temp = group4;
                    group4 = [];
                    if i == j
                        if length_group1 >= length_group2
                            group4 = [group4, group1];
                        else
                            group4 = [group4, group2];
                        end
                        pattern_temp = 1;
                    elseif i < j
                        for k = 1: j-1
                            group4 = [group4, group2(k)];
                        end
                        if length_group1 - i <= length_group2 - j
                            for k = j:length_group2
                                group4 = [group4, group2(k)];
                            end
                        else
                            for k = i: length_group1
                                group4 = [group4, group1(k)];
                            end
                        end
                        pattern_temp = 1;
                    elseif i > j
                        for k = 1: i-1
                            group4 = [group4, group1(k)];
                        end
                        if length_group1 - i <= length_group2 - j
                            for k = j: length_group2
                                group4 = [group4, group2(k)];
                            end
                        else
                            for k = i : length_group1
                                group4 = [group4, group1(k)];
                            end
                        end
                        pattern_temp = 1;
                    end
                end
            else
                break;
            end
        end
    end
end

if pattern_temp == 1
    temp_pattern = group4;
    unresolved_group = group3;
else
    temp_pattern = group1;
    group1_temp = group3;
    group2_temp = group2;
    if length(group1_temp) == 0
        group3 = group2;
        unresolved_group = group3;
    else
        group3 = [];
        for i = 1:length(group1_temp)
            for j = 1:length(group2_temp)
                if i+2 <= length(group1_temp) & j+2<= length(group2_temp)
                    if pattern_found == 0
                        if group1_temp(i) == group2_temp(j) & group1_temp(i+1) == group2_temp(j+1) & group1_temp(i+2) == group2_temp(j+2)
                            
                            if i == j
                                if length(group1_temp) >= length(group2_temp)
                                    group3 = [group3, group1_temp];
                                else
                                    group3 = [group3, group2_temp];
                                end
                                pattern_found = 1;
                            elseif i < j
                                for k = 1: j-1
                                    group3 = [group3, group2_temp(k)];
                                end
                                if length(group1_temp) - i <= length(group2_temp) - j
                                    for k = j:length(group2_temp)
                                        group3 = [group3, group2_temp(k)];
                                    end
                                else
                                    for k = i: length(group1_temp)
                                        group3 = [group3, group1_temp(k)];
                                    end
                                end
                                pattern_found = 1;
                            elseif i > j
                                for k = 1: i-1
                                    group3 = [group3, group1_temp(k)];
                                end
                                if length(group1_temp) - i <= length(group2_temp) - j
                                    for k = j: length(group2_temp)
                                        group3 = [group3, group2_temp(k)];
                                    end
                                else
                                    for k = i : length(group1_temp)
                                        group3 = [group3, group1_temp(k)];
                                    end
                                end
                                pattern_found = 1;
                            end
                        end
                    else
                        break;
                    end
                end
            end
        end
        unresolved_group = group3;
    end
end