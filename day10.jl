function solution_10_1()
    sig_strengths = []
    open("./inputs/input_day10.txt") do file
        num_cycle = 0
        register_value = 1
        for l in eachline(file)
            command = split(l)
            if command[1] == "noop"
                # do cycle
                num_cycle +=1
                if num_cycle % 40 == 20 
                    push!(sig_strengths, num_cycle*register_value)
                end
            else
                for _ in 1:2
                    # do cycle
                    num_cycle +=1
                    if num_cycle % 40 == 20 
                        push!(sig_strengths, num_cycle*register_value)
                    end
                end

                # update register value
                ammount = parse(Int, command[2])
                register_value += ammount
            end

            # check if 220th cycle has been passed
            if num_cycle >= 220
                return sum(sig_strengths)
            end    
        end
    end    
end

function draw_cycle(screen, register_value, num_cycle)
    if register_value in num_cycle%40-1:num_cycle%40+1
        push!(screen, '#')
    else
        push!(screen, '.')
    end
end

function draw_screen(screen)
    screen = permutedims(reshape(screen, (40, :)), (2,1))
    for row in eachrow(screen)
        println(row)
    end
end

function solution_10_2()
    screen = []
    open("./inputs/input_day10.txt") do file
        num_cycle = 0
        register_value = 1
        for l in eachline(file)
            command = split(l)
            if command[1] == "noop"
                # do cycle
                draw_cycle(screen, register_value, num_cycle)
                num_cycle +=1
            else
                for _ in 1:2
                    # do cycle
                    draw_cycle(screen, register_value, num_cycle)
                    num_cycle +=1
                end
                
                # update register value
                ammount = parse(Int, command[2])
                register_value += ammount
            end  
        end
    end
    draw_screen(screen)
end


println("Solution to task 10-1:", solution_10_1())
println("Solution to task 10-2:", solution_10_2())