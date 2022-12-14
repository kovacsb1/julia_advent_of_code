function parse_coordinate_list()
    coordinate_list = []
    open("./inputs/input_day14.txt") do file
        for l in eachline(file)
            curr_cord_list = []
            corrdinates = split(l, "->")
            for c in corrdinates
                push!(curr_cord_list, reverse([parse(Int, num_str) for num_str in split(c, ",")]))
            end
            push!(coordinate_list,curr_cord_list)
        end
    end
    coordinate_list
end

function drop_sand_1!(map, pos, floor)
    pos_x, pos_y = pos
    if pos_x == floor
        return true
    end
    if map[pos_x+1, pos_y] == 0
        drop_sand_1!(map,(pos_x+1, pos_y), floor)
    elseif map[pos_x+1, pos_y-1] == 0
        drop_sand_1!(map,(pos_x+1, pos_y-1), floor)
    elseif map[pos_x+1, pos_y+1] == 0
        drop_sand_1!(map,(pos_x+1, pos_y+1), floor)
    else 
        map[pos_x, pos_y] = 1
        return false
    end
end

function drop_sand_2!(map, pos, floor)
    pos_x, pos_y = pos
    if pos_x+1 == floor
        map[pos_x, pos_y] = 1
        return false
    end
    if map[pos_x+1, pos_y] == 0
        drop_sand_2!(map,(pos_x+1, pos_y), floor)
    elseif map[pos_x+1, pos_y-1] == 0
        drop_sand_2!(map,(pos_x+1, pos_y-1), floor)
    elseif map[pos_x+1, pos_y+1] == 0
        drop_sand_2!(map,(pos_x+1, pos_y+1), floor)
    else 
        if pos == start_pos
            return true
        else
            map[pos_x, pos_y] = 1
            return false
        end
    end
end

function initialize_map(coordinate_lst, floor)
    map = zeros(floor, 1000)

    for coords in coordinate_lst
        for (ind, coord1) in enumerate(coords[1:end-1])
            coord2 = coords[ind+1]
            if coord1[1] > coord2[1]
                coord1, coord2 = coord2, coord1
            elseif coord1[2] > coord2[2]
                coord1, coord2 = coord2, coord1
            end
            map[coord1[1]:coord2[1], coord1[2]:coord2[2]] .= 1
        end
    end
    
    map
end

start_pos = (0, 500)

function solution_14_1()
    cordinate_lst = parse_coordinate_list()
    floor = maximum([x[1] for lst in cordinate_lst for x in lst])
    floor +=1
    map = initialize_map(cordinate_lst, floor)

    ammount_fallen = 0
    is_infinite = false
    while ~is_infinite
        is_infinite = drop_sand_1!(map, start_pos, floor)
        ammount_fallen +=1
    end
    ammount_fallen - 1
end

function solution_14_2()
    cordinate_lst = parse_coordinate_list()

    floor = maximum([x[1] for lst in cordinate_lst for x in lst])
    floor += 2
    map = initialize_map(cordinate_lst, floor+1)

    ammount_fallen = 0
    is_infinite = false
    while ~is_infinite
        is_infinite = drop_sand_2!(map, start_pos, floor)
        ammount_fallen +=1
    end
    ammount_fallen
end

println("Solution to task 14-1:", solution_14_1())
println("Solution to task 14-2:", solution_14_2())