function solution_22_1()
    # read board
    input_as_str =  read("./inputs/input_day22.txt", String)
    board_txt, instructions = split(input_as_str, "\r\n\r\n")
    board_txt = split(board_txt, "\r\n")
    
    num_rows = length(board_txt)
    num_cols = maximum([length(line) for line in board_txt])
    
    board = fill(-1, num_rows, num_cols)
    for (i,row) in enumerate(board_txt)
        for (j, ch) in enumerate(row)
            if ch == '.'
                board[i, j] = 1
            elseif ch == '#'
                board[i, j] = 0
            end 
        end
    end

    # create a dict containing the start positions 
    # at the other side of each direction
    left_limit, right_limit = [], []
    for row in eachrow(board)
        left_ind = findfirst(row .> -1)
        if row[left_ind] == 0
            push!(left_limit, 0)
        else 
            push!(left_limit, left_ind)
        end

        right_ind = findlast(row .> -1)
        if row[right_ind] == 0
            push!(right_limit, 0)
        else 
            push!(right_limit, right_ind)
        end
    end

    top_limit, bottom_limit = [], []
    for col in eachcol(board)
        top_ind = findfirst(col .> -1)
        if col[top_ind] == 0
            push!(top_limit, 0)
        else 
            push!(top_limit, top_ind)
        end

        bottom_ind = findlast(col .> -1)
        if col[bottom_ind] == 0
            push!(bottom_limit, 0)
        else 
            push!(bottom_limit, bottom_ind)
        end
    end

    curr_pos = (1, left_limit[1])
    direction = (0,1)

    # parse moves
    moves = []
    num = 0
    for ch in instructions 
        if ~isnothing(tryparse(Int, "$ch"))
            num *= 10
            num += parse(Int, ch)
        else
            push!(moves, num)
            push!(moves, ch)
            num = 0
        end
    end
    push!(moves, num)

    # simulate movement
    for move in moves
        if move == 'R'
            direction = (direction[2], -direction[1])
        elseif move == 'L'
            direction = (-direction[2], direction[1])
        else
            for _ in 1:move
                dest = curr_pos .+ direction

                if ~checkbounds(Bool, board, dest...) || board[dest...] == -1
                    if direction == (1,0)
                        if top_limit[dest[2]] != 0
                            curr_pos = (top_limit[dest[2]], dest[2])
                        else 
                            break
                        end
                    elseif direction == (-1,0)
                        if bottom_limit[dest[2]] != 0
                            curr_pos = (bottom_limit[dest[2]], dest[2])
                        else 
                            break
                        end
                    elseif direction == (0,1)
                        if left_limit[dest[1]] != 0
                            curr_pos = (dest[1], left_limit[dest[1]])
                        else 
                            break
                        end
                    elseif direction == (0,-1)
                        if right_limit[dest[1]] != 0
                            curr_pos = (dest[1], right_limit[dest[1]])
                        else 
                            break
                        end
                    end
                elseif board[dest...] == 1
                    curr_pos = dest
                else 
                    break
                end
            end
        end
    end
    
    1000*curr_pos[1] + 4*curr_pos[2], direction
end

println("Solution to task 22-1:", solution_22_1())
# println("Solution to task 22-2:", solution_22_2())