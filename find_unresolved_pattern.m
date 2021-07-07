function [temp_pattern, unresolved_group] = find_unresolved_pattern(g1, g2, g3, g4)

length_group1 = length(g1);
length_group2 = length(g2);
group1 = g1;
group2 = [];
group4 = g4;

for i = 1:length_group2
    if g2(i) == 0
        length_group2 = length_group2 - 1;
    else
        group2 = [group2, g2(i)];
    end
end

pattern_temp = 0;

for i = 1: length_group1
    for j = 1: length_group2
        if i+2 <= length_group1 & j+2 < length_group2
            if pattern_temp == 0
                if group1(i) == group2(j) & group1(i+1) == group2(j+1) & group1(i+2) == group2(j+2)
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
    unresolved_group = [];
else
    temp_pattern = group1;
    unresolved_group = group2;
end