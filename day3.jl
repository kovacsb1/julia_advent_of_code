a_int_value = Int(codepoint.('a'))

function get_char_priority(char)
    char_val = 0
    if isuppercase(char)
        char_val += 26
        char = lowercase(char)
    end
    char_val += Int(codepoint.(char)) - a_int_value + 1
end

function solution_3_1()
    function get_missing_items(rucksack)
        char_list = split(rucksack, "")
        half_idx = convert(Int, length(char_list)/2)
        first_half = char_list[begin:half_idx]
        second_half = char_list[(half_idx+1):end]
        only(intersect(first_half, second_half)[1])
    end
    
    open("./inputs/input_day3.txt") do file
        missing_items = get_missing_items.(eachline(file))
        sum(get_char_priority.(missing_items))
    end  
end

function solution_3_2()
    groups = []
    open("./inputs/input_day3.txt") do file
        temp = []
        for l in eachline(file)
            push!(temp, l)
            if length(temp) == 3
                push!(groups, copy(temp))
                temp = []
            end
        end
    end  

    matches = []
    for g in groups
        match = only(intersect(g[1], g[2], g[3])[1])
        push!(matches, match)
    end
    sum(get_char_priority.(matches))

end


println("Solution to task 3-1:", solution_3_1())
println("Solution to task 3-2:", solution_3_2())