
function solution_1_1()
    max_sum = 0
    open("./inputs/input_day1.txt") do file
        # split arrs
        curr_sum = 0
        for l in eachline(file)
            if l == ""
                if curr_sum > max_sum
                    max_sum = curr_sum
                end
                curr_sum = 0
            else
                curr_sum += parse(Int, l)
            end
        end
    end
    max_sum
end

function solution_1_2()
    max_sums = [0,0,0]
    open("./inputs/input_day1.txt") do file
        curr_sum = 0
        for l in eachline(file)
            println(l)
            if l == ""
                println("sum", curr_sum)
                sorted_idx = searchsorted(max_sums, curr_sum, rev=true)
                if curr_sum > max_sums[3] && curr_sum > sorted_idx.start
                    pop!(max_sums)
                    insert!(max_sums, sorted_idx.start, curr_sum)
                end
                curr_sum = 0
            else
                curr_sum += parse(Int, l)
            end
        end
    end
    sum(max_sums)
end

println("Solution to task 1-1:", solution_1_1())
println("Solution to task 1-2:", solution_1_2())