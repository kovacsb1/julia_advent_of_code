function read_arr()
    arr = Vector{Vector{Int}}()
    open("./inputs/input_day8.txt") do file
        for l in eachline(file)
            curr_arr = Vector{Int}()
            push!(arr, curr_arr)
            for ch in l
                push!(curr_arr, parse(Int, ch))
            end
        end
    end
    mapreduce(permutedims, vcat, arr)
end

function is_visible_rows(arr)
    ret = similar(arr, Int64)

    for (i, row) in enumerate(eachrow(arr))
        max_item = row[1] 
        max_ind = 1
        for (j, item) in enumerate(row)
            if item > max_item
                max_item = item
                max_ind = j
            end
            ret[i, j] = j-max_ind
        end
    end
    ret
end

function num_visible_rows(arr)
    visible = similar(arr, Int64)

    for (i, row) in enumerate(eachrow(arr))
        for (j, item) in enumerate(row)
            visible[i, j] = 0
            ind = j-1
            bigger_found = false
            
            while ~bigger_found && ind > 0
                visible[i, j] += 1
                bigger_found = arr[i, ind] >= arr[i, j] 
                ind-=1
            end
        end
    end
    visible
end

function solution_8_1()
    arr = read_arr()
    
    covers_left = is_visible_rows(arr)
    covers_top = is_visible_rows(arr')'
    
    rev_arr = arr[end:-1:1,end:-1:1]
    covers_right = is_visible_rows(rev_arr)[end:-1:1,end:-1:1]
    covers_bottom = is_visible_rows(rev_arr')'[end:-1:1,end:-1:1]
    hide_maps  =[covers_left;;; covers_top;;; covers_right;;; covers_bottom]
    
    reduced = mapslices(minimum, hide_maps; dims=3)
    sum(reduced .== 0)

end

function solution_8_2()
    arr = read_arr()
    
    covers_left = num_visible_rows(arr)
    covers_top = num_visible_rows(arr')'
    
    rev_arr = arr[end:-1:1,end:-1:1]
    covers_right = num_visible_rows(rev_arr)[end:-1:1,end:-1:1]
    covers_bottom = num_visible_rows(rev_arr')'[end:-1:1,end:-1:1]
    hide_maps = [covers_left;;; covers_top;;; covers_right;;; covers_bottom]
    maximum(prod(hide_maps, dims=3))

end


println("Solution to task 7-1:", solution_8_1())
println("Solution to task 7-2:", solution_8_2())