function solution_25_1()
    numbers = []
    open("inputs/input_day25.txt") do f
        for l in eachline(f)
            curr_num = 0
            exponent = 1
            for ch in reverse(l)
                if ch == '='
                    curr_num -= 2*exponent
                elseif ch == '-'
                    curr_num -= exponent
                else
                    curr_num += parse(Int, ch) * exponent
                end 
                exponent *= 5
            end
            push!(numbers, curr_num)
        end
    end
    num = sum(numbers)
    output = ""

    while num > 0
        rem = num % 5

        if rem == 3
            output = "=" * output
            num = num÷5 + 1
        elseif rem == 4
            output = "-" * output
            num = num÷5 + 1
        else
            output = string(rem) * output
            num = num÷5
        end
    end
    output
end

println("Solution to 25-1: ", solution_25_1())