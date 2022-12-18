function add_if_unique!(surface, cubes, it, curr_cube)
    if it in cubes
        deleteat!(surface, findall(x->x==curr_cube,surface))
    else
        push!(surface, it)
    end 
end

function get_surface()
    surface = []
    cubes = Set()
    open("./inputs/input_day18.txt") do file
        for l in eachline(file)
            nums = split(l, ",")

            coords = (parse(Int, nums[1]), parse(Int, nums[2]), parse(Int, nums[3]))
            
            for i in [+1, -1]
                it = (coords[1]+i, coords[2], coords[3])
                add_if_unique!(surface, cubes, it, coords)
                
                it = (coords[1], coords[2]+i, coords[3])
                add_if_unique!(surface, cubes, it, coords)

                it = (coords[1], coords[2], coords[3]+i)
                add_if_unique!(surface, cubes, it, coords)
            end
            push!(cubes, coords)
        end
    end
    surface, cubes
end

function solution_18_1()
    surface, _ = get_surface()
    length(surface)
end


function solution_18_2()
    surface, cubes = get_surface()
    coords_per_axis = [[s[i] for s in surface] for i in 1:3]
    bounds = extrema(reduce(hcat,coords_per_axis); dims=1)
    reachable = falses(size(surface,1))
    
    border_idx = findfirst(x-> x[1] == bounds[1][1], surface)
    reachable[border_idx] = true
    to_inspect = Set([surface[border_idx]])
    inspected = Set()

    while ~isempty(to_inspect)
        curr = pop!(to_inspect)
        push!(inspected, curr)
        for i in [-1, 1] 
            for inc in [(i,0,0), (0,i,0), (0,0,i)]
                curr_inc = curr .+ inc
                if all([curr_inc[i] >= bounds[i][1] && curr_inc[i] <= bounds[i][2] for i in 1:3])
                    if curr_inc ∉ inspected
                        if curr_inc ∉ cubes; push!(to_inspect, curr_inc) end
                        if curr_inc in surface
                            mask = findall(x-> x==curr_inc, surface)
                            reachable[mask] .= true
                        end
                    end
                end
            end
        end
    end
    sum(reachable)
end

println("Solution to task 18-1:", solution_18_1())
println("Solution to task 18-2:", solution_18_2())