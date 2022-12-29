function read_input()
    elf_positions = []
    open("./inputs/input_day23.txt") do file
        for (i, l) in enumerate(eachline(file))
            for (j,ch) in enumerate(l)
                if ch == '#'; push!(elf_positions, (i,j)) end
            end
        end
    end
    elf_positions
end

# helper function to draw elf board
function draw_elves(elf_positions)
    x_coords = [pos[1] for pos in elf_positions]
    y_coords = [pos[2] for pos in elf_positions]
    max_x, min_x = maximum(x_coords),  minimum(x_coords)
    max_y, min_y = maximum(y_coords),  minimum(y_coords)

    for i in min_x:max_x
        for j in min_y:max_y
            if (i, j) in elf_positions
                print("#")
            else
                print(".")
            end
        end
        println()
    end
    println()
end

function solve(limit)
    elf_positions = read_input()
    dir_order = [[(-1,0), (-1,-1), (-1,1)], # north
                 [(1,0), (1,1), (1,-1)],    # south
                 [(0,-1), (1,-1), (-1,-1)], # west
                 [(0,1), (1,1), (-1, 1)]]   # east
    all_pos = Set(reduce(vcat, dir_order))
    
    i = 0
    while i < limit
        considered_positions = []
        for e_pos in elf_positions
            # if all positions are free, the elf wont move
            if all([(e_pos.+d) ∉ elf_positions for d in all_pos]); 
                push!(considered_positions, nothing)
                continue
            end 
            
            # find first direction where all 3 positions are free
            found = false
            for dirs in dir_order
                if ~found && all([(e_pos.+d) ∉ elf_positions for d in dirs])
                    push!(considered_positions, e_pos.+dirs[1])
                    found = true
                end 
            end
            if ~found; push!(considered_positions, nothing) end
        end
        
        #draw_elves(elf_positions)
        
        # move all elves
        moved = false
        for (ind, pos) in enumerate(considered_positions)
            if ~isnothing(pos)
                if pos ∉ considered_positions[ind+1:end]
                    elf_positions[ind] = pos
                    moved = true
                else
                    considered_positions[[p == pos for p in considered_positions]] .= nothing
                end
            end
        end 

        # exit if not moved
        i+=1
        println("iteration $i") 
        if ~moved; return i end

        # shift order of considering directions
        dir_order = circshift(dir_order, -1)
    end

    # return area
    y_coords = [pos[1] for pos in elf_positions]
    x_coords = [pos[2] for pos in elf_positions]
    max_y, min_y = maximum(y_coords),  minimum(y_coords)
    max_x, min_x = maximum(x_coords),  minimum(x_coords)

    (max_x-min_x+1)*(max_y-min_y+1) - length(elf_positions)
end

function solution_23_1()
    solve(10)
end

function solution_23_2()
    solve(Inf)
end

println("Solution to task 23-1:", solution_23_1())
println("Solution to task 23-2:", solution_23_2())