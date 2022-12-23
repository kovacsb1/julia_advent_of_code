function set_pos!(pos_list, rock_pos)
    for (p_i, p_j) in rock_pos
        pos_list[p_i, p_j] = true
    end
end


function move(pos_list, rock_pos, curr_movement)
    if curr_movement != "d"
        move_vec = curr_movement == '>' ? (0, 1) : (0, -1)
    else
        move_vec = (-1, 0)
    end
    new_pos = map(x-> x.+move_vec, rock_pos)

    for p in new_pos
        if ~checkbounds(Bool, pos_list, p[1], p[2]) || pos_list[p[1], p[2]]
            return rock_pos
        end
    end
    new_pos
end

function solution_17_1()
    move_strings = read("./inputs/input_day17.txt", String)
    println(length(move_strings))
    # first one is row(y axis), second is column(x axis)
    rock1 = [(0,-1), (0,0), (0,1), (0,2)]
    rock2 = [(1,-1), (1,0), (1,1), (0,0), (2,0)]
    rock3 = [(0,-1), (0,0), (0,1), (1,1), (2,1)]
    rock4 = [(3,-1), (2,-1), (1,-1), (0,-1)]
    rock5 = [(1,-1), (0,-1), (1,0), (0,0)]
    rocks = [rock1, rock2, rock3, rock4, rock5]
    
    current_height, offset = 0, 4
    pos_list = BitMatrix(undef, 0,7)
    num_steps = 0 
    
    for i in 0:2021
        # rock starts to fall
        curr_rock = rocks[i%5+1]
        rock_pos = [p.+(current_height+offset,4) for p in curr_rock]

        plus_zeros = maximum([p[1] for p in curr_rock])
        size_diff = offset+plus_zeros+current_height - size(pos_list,1)
        if size_diff > 0; pos_list = [pos_list ; falses(size_diff,7)] end
        
        halted = false
        while ~halted
            curr_movement = move_strings[num_steps % length(move_strings)+1]
            num_steps+=1
            new_pos = move(pos_list, rock_pos, curr_movement)
            dest = move(pos_list, new_pos, "d")
            if dest == new_pos 
                halted = true
                set_pos!(pos_list, dest)
                current_height = max(maximum([p[1] for p in rock_pos]), current_height)
            else
                rock_pos = dest
            end
        end
    end
    current_height
end

println("Solution to task 17-1:", solution_17_1())
#println("Solution to task 17-2:", solution_17_2())