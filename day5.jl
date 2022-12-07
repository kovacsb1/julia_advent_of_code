using CSV, DataStructures

function read_starting_positions(pos_str)
    ## read initial positions
    start_positions = split(pos_str, "\r\n")
    crane_nums_str = strip(pop!(start_positions))
    crane_nums_str = reverse(crane_nums_str)
    max_crane_str = reduce(*, (Iterators.takewhile(x -> isdigit(x), crane_nums_str)))
    max_crane = parse(Int, max_crane_str)
    max_crane

    stacks = SortedDict(i => Stack{Char}() for i in 1:max_crane)

    [push!(stacks[fld(ind, 4)+1], c[ind]) for c in reverse(start_positions) for ind in 2:4:length(c) if isletter(c[ind])]

    stacks
end

function solution_5_1()
    input_as_str = read("./inputs/input_day5.txt", String)
    splitted = split(input_as_str, "\r\n\r\n")
    
    stacks = read_starting_positions(splitted[1])
        
    ## read and apply moves
    moves = split(splitted[2], "\r\n")
    pop!(moves)
    for move in moves
        _, ammount, _ , from, _, to = split(move)
        from = parse(Int, from)
        to = parse(Int, to)
        for _ in 1:parse(Int, ammount)
            item = pop!(stacks[from])
            push!(stacks[to], item) 
        end
    end

    # create return string
    reduce(*, [first(s) for (_,  s) in stacks])
    
end

function solution_5_2()
    input_as_str = read("./inputs/input_day5.txt", String)
    splitted = split(input_as_str, "\r\n\r\n")
    
    stacks = read_starting_positions(splitted[1])


    ## read and apply moves
    moves = split(splitted[2], "\r\n")
    pop!(moves) # remove last empty line
    for move in moves
        _, ammount, _ , from, _, to = split(move)
        from = parse(Int, from)
        to = parse(Int, to)

        items = [pop!(stacks[from]) for _ in 1:parse(Int, ammount)]
        [push!(stacks[to], item) for item in reverse(items)]
    end

    # create return string
    reduce(*, [first(s) for (_,  s) in stacks])
    
end

println("Solution to task 5-1:", solution_5_1())
println("Solution to task 5-2:", solution_5_2())