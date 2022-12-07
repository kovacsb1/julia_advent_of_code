
function get_unique_seq_end(input_str, size)
    for i in 1:length(input_str)
        if length(Set(input_str[i:i+size-1])) == size
            return i+size-1
        end
    end
end

function solution_6_1()
    input_as_str = read("./inputs/input_day6.txt", String)

    get_unique_seq_end(input_as_str, 4)
end

function solution_6_2()
    input_as_str = read("./inputs/input_day6.txt", String)

    get_unique_seq_end(input_as_str, 14)
end

println("Solution to task 6-1:", solution_6_1())
println("Solution to task 6-2:", solution_6_2())