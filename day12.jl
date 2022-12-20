using Graphs

function read_arr()
    arr = Vector{Vector{Char}}()
    
    start_pos_ind= nothing
    end_post_ind = nothing
    ind = 1
    open("./inputs/input_day12.txt") do file
        for l in eachline(file)
            curr_arr = Vector{Char}()
            push!(arr, curr_arr)
            for ch in l
                if ch == 'S'
                    ch = 'a'
                    start_pos_ind = ind
                elseif ch == 'E'
                    ch = 'z'
                    end_post_ind = ind
                end

                push!(curr_arr, ch)
                ind +=1
            end
        end
    end
    mapreduce(permutedims, vcat, arr), start_pos_ind, end_post_ind
end

function build_graph(char_arr, task_num)
    size_x, size_y = size(char_arr)
    affinity_mtx = SimpleDiGraph(size_x *size_y)
    
    for i in 1:size_x
        for j in 1:size_y

            indices_to_check = [(i-1, j), (i, j-1), (i+1, j), (i, j+1)]
            for (x, y) in indices_to_check
                if x>=1 && y>=1 && x<=size_x && y<=size_y 
                    guard = (task_num == 1 ? char_arr[x, y] - char_arr[i, j] : char_arr[i, j] - char_arr[x, y]) <= 1 
                    if guard; add_edge!(affinity_mtx, (i-1)*size_y+j, (x-1)*size_y+y) end
                end
            end
        end
    end
    affinity_mtx
end


function solution_12_1()
    char_arr, start_pos_ind, end_post_ind = read_arr()
    affinity_mtx = build_graph(char_arr, 1)
    
    ds = dijkstra_shortest_paths(affinity_mtx, start_pos_ind)
    ds.dists[end_post_ind]
 
end


function solution_12_2()
    char_arr, _, end_post_ind = read_arr()
    affinity_mtx = build_graph(char_arr, 2)

    ds = dijkstra_shortest_paths(affinity_mtx, end_post_ind)

    is_a = reduce(vcat, transpose(char_arr .== 'a'))
    minimum(ds.dists[is_a])
end

println("Solution to task 12-1:", solution_12_1())
println("Solution to task 12-2:", solution_12_2())