using Distances

TARGET_1= 2000000

function parse_sensors()
    sensor_list = []
        open("./inputs/input_day15.txt") do file
            for l in eachline(file)
                sensor_data = split(l)

                sensor_x, sensor_y = sensor_data[3], sensor_data[4]
                sensor_x = parse(Int, chop(sensor_x; head=2, tail=1))
                sensor_y = parse(Int, chop(sensor_y; head=2, tail=1))

                beacon_x, beacon_y = sensor_data[end-1], sensor_data[end]
                beacon_x = parse(Int, chop(beacon_x; head=2, tail=1))
                beacon_y = parse(Int, chop(beacon_y; head=2, tail=0))

                push!(sensor_list,[(sensor_x, sensor_y), (beacon_x, beacon_y)])
            end
        end
    sensor_list
end

function solution_15_1()
    sensor_list = parse_sensors()
    
    starting_positions = reduce(vcat, sensor_list)
    reserved_positions = Set(starting_positions)
    
    for (sensor, beacon) in sensor_list
        manhattan_dist = cityblock(sensor, beacon)
        if TARGET_1 in sensor[2]-manhattan_dist:sensor[2]+manhattan_dist
            diff_y = abs(TARGET_1 - sensor[2])
            for diff_x in 0:manhattan_dist-diff_y
                push!(reserved_positions, (sensor[1]+diff_x, TARGET_1))
                push!(reserved_positions, (sensor[1]-diff_x, TARGET_1))
            end
        end
    end
    length(setdiff(reserved_positions,Set(reduce(vcat, starting_positions))))
end


function check_uncovered(sensors_and_dists, coord, source_sensor)
    x, y = coord
    if x < 0 || x > BOUND_2
        return false
    elseif y < 0 || y > BOUND_2
        return false
    end

    for (sensor, dist) in sensors_and_dists
        if sensor != source_sensor
            manhattan_dist = cityblock(sensor, coord)
            if manhattan_dist <=dist return false end
        end
    end
    return true
end

BOUND_2= 4000000
function solution_15_2()
    sensor_list = parse_sensors()
    
    # calculate distances covered for each sensor
    sensors_and_dists = []
    for (sensor, beacon) in sensor_list
        manhattan_dist = cityblock(sensor, beacon)
        push!(sensors_and_dists, (sensor, manhattan_dist))
    end

    # iterate through border of each sensor
    for (sensor, covered_dist) in sensors_and_dists 
        println("COvering sensor $sensor")
        covered_dist += 1
        for x in 0:covered_dist
            y = covered_dist-x
            to_check = [sensor .- (x,y), sensor .+ (x,y), (sensor[1]+x,sensor[2]-y), (sensor[1]-x,sensor[2]+y)]
           
            for pos in to_check
                if check_uncovered(sensors_and_dists, pos, sensor) 
                    return BOUND_2*pos[1]+pos[2]
                end
            end
        end
    end
end

println("Solution to task 15-1:", solution_15_1())
println("Solution to task 15-2:", solution_15_2())