using Plots
direction_dict = Dict{String,Array{Int}}(
    "R" => [1,0],
    "L" => [-1, 0],
    "U" => [0,1],
    "D" => [0, -1]
) 

function parse_moves()
    moves = []
    open("./inputs/input_day9.txt") do file
        for l in eachline(file)
            direction, ammount = split(l)
            ammount = parse(Int, ammount)
            
            move = direction_dict[direction]
            [push!(moves, move) for i in 1:ammount]
        end
    end
    moves
end


function get_tail_position(head_pos, tail_pos)
    diff_x = head_pos[1] - tail_pos[1]
    diff_y = head_pos[2] - tail_pos[2]
    if abs(diff_x) > 1 || abs(diff_y) > 1 
        if diff_x == 0
            tail_pos[1], tail_pos[2]+sign(diff_y)
        elseif  diff_y == 0
            tail_pos[1]+sign(diff_x), tail_pos[2]
        else
            tail_pos[1]+sign(diff_x), tail_pos[2]+sign(diff_y) 
        end
    else
        tail_pos
    end 
end

function solution_9_1()
    moves = parse_moves()

    positions_traversed = Set()
    head_pos = [0,0]
    tail_pos = [0,0]
    for move in moves
        head_pos .+= move

        tail_pos = get_tail_position(head_pos, tail_pos)
        push!(positions_traversed, tail_pos)
    end
    length(positions_traversed)
end

NUM_KNOTS = 10

function solution_9_2()
    moves = parse_moves()

    positions_traversed = Set()
    positions = zeros(Int, NUM_KNOTS, 2)
    
    for move in moves
        positions[1, :] .+= move
        
        for i in 2:NUM_KNOTS
            positions[i, :] .= get_tail_position(positions[i-1, :], positions[i, :])
        end
        push!(positions_traversed, positions[NUM_KNOTS, :])
    end
    length(positions_traversed)
end

println("Solution to task 9-1:", solution_9_1())
println("Solution to task 9-2:", solution_9_2())