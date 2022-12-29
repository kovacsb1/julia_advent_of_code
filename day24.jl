function parse_input()
    input_as_txt = read("inputs/input_day24.txt", String)
    
    lines = split(input_as_txt, "\r\n")
    
    blizzard_positions = []
    move_directions = []
    for (i, l) in enumerate(lines[2:end-1])
        for (j, ch) in enumerate(chop(l; head=1, tail=1))
            if ch == '^'
                dir = -1
            elseif ch == 'v'
                dir = 1
            elseif ch == '>'
                dir = 1*im
            elseif ch == '<'
                dir= -1*im
            else
                continue
            end 
            push!(blizzard_positions, i+j*im)
            push!(move_directions, dir)
        end
    end
    blizzard_positions, move_directions, length(lines)-2,  length(lines[1])-2
end

function move_blizzards_one_step!(blizzard_positions, move_directions, real_bound, im_bound)
    ind = 1
    for (pos, direction) in zip(blizzard_positions, move_directions)
        temp_pos = pos + direction
        if real(temp_pos) == 0
            new_pos = temp_pos + real_bound
        elseif real(temp_pos) == real_bound+1
            new_pos = temp_pos - real_bound
        elseif imag(temp_pos) == 0
            new_pos = temp_pos + im*im_bound
        elseif imag(temp_pos) == im_bound+1
            new_pos = temp_pos - im*im_bound
        else
            new_pos = temp_pos
        end
        blizzard_positions[ind] = new_pos
        ind +=1
    end             
end

# helper function to print board
function print_board(blizzard_positions, state_queue, real_bound, im_bound, iteration_num)
    println(iteration_num)
    for i in 1:real_bound
        for j in 1:im_bound
            if i+j*im in blizzard_positions; print(">")
            elseif i+j*im in state_queue; print("*")
            else print(".")
            end
        end
        println()
    end
    println()
end

function solution_24_1()
    blizzard_positions, move_directions, real_bound, im_bound = parse_input()
    start_position, end_position = 1*im, real_bound+1+im_bound*im

    function bfs!(state_queue, iteration_num, end_pos)
        # remove agents that died
        for pos in state_queue
            if pos in blizzard_positions
                pop!(state_queue, pos) 
            end
        end

        # push updated positions to state_queue
        updates = [1, -1, 1*im, -1*im]
        for pos in copy(state_queue)
            for u in updates
                new_pos = u + pos
               
                if new_pos == end_pos
                    move_blizzards_one_step!(blizzard_positions, move_directions, real_bound, im_bound)
                    return iteration_num+1 
                end

                if real(new_pos) > 0 && real(new_pos) <= real_bound && imag(new_pos) > 0 && imag(new_pos) <= im_bound
                    push!(state_queue, new_pos)
                end
            end
        end

        # move storm
        move_blizzards_one_step!(blizzard_positions, move_directions, real_bound, im_bound)
        
        # do next step
        bfs!(state_queue, iteration_num+1, end_pos)
    end

    initial_queue = Set{Complex}(start_position)
    bfs!(initial_queue, 0, end_position)
end

function solution_24_2()
    blizzard_positions, move_directions, real_bound, im_bound = parse_input()
    start_position, end_position = 1*im, real_bound+1+im_bound*im


    function bfs!(state_queue, iteration_num, end_pos)
        # remove agents that died
        for pos in state_queue
            if pos in blizzard_positions
                pop!(state_queue, pos) 
            end
        end

        # push updated positions to state_queue
        updates = [1, -1, 1*im, -1*im]
        for pos in copy(state_queue)
            for u in updates
                new_pos = u + pos
               
                if new_pos == end_pos
                    move_blizzards_one_step!(blizzard_positions, move_directions, real_bound, im_bound)
                    return iteration_num+1 
                end

                if real(new_pos) > 0 && real(new_pos) <= real_bound && imag(new_pos) > 0 && imag(new_pos) <= im_bound
                    push!(state_queue, new_pos)
                end
            end
        end

        # move storm
        move_blizzards_one_step!(blizzard_positions, move_directions, real_bound, im_bound)
        
        # do next step
        bfs!(state_queue, iteration_num+1, end_pos)
    end

    initial_queue = Set{Complex}(start_position)
    reach_end =bfs!(initial_queue, 0, end_position)
    initial_queue = Set{Complex}(end_position)
    go_back =bfs!(initial_queue, 0, start_position)
    initial_queue = Set{Complex}(start_position)
    final_end =bfs!(initial_queue, 0, end_position)
    println("go to end: $reach_end, go back to start: $go_back, reach_end again: $final_end")
    reach_end+go_back+final_end
end

println("Solution to 24-1: ", solution_24_1())
println("Solution to 24-2: ", solution_24_2())