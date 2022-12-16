
function parse_line(line)
    levels = [[]]
    level = 0
    for item in line
        while item[1] == '['
            level += 1
            push!(levels, [])
            item = item[2:end]
        end

        stripped = rstrip(item, ']') 
        if  stripped != ""
            item_num = parse(Int, stripped)
            push!(levels[end], item_num)
        end
    
        ammount_stripped = length(item)-length(stripped)
        for _ in 1:ammount_stripped
            level -= 1
            last_level = pop!(levels)
            push!(levels[end], last_level)
        end
    end
    levels[1]
end

function comp_ord(left, right)
    if left == right
        return false
    else 
        return compare_order(left, right)
    end
end

function compare_order(left, right)
    for (i1, i2) in zip(left, right)
        if i1 isa Number && i2 isa Number
            if i1 != i2 
                return i1 < i2
            else 
                continue
            end 
        end

        if i1 isa Array && i2 isa Number
            i2 = [i2] 
        elseif i2 isa Array && i1 isa Number
            i1 = [i1]
        end

        ord = compare_order(i1, i2)
        if ~isnothing(ord) 
            return ord 
        end
    end
    if length(left) == length(right)
        return nothing
    else 
        return length(left) < length(right)
    end
end

function qsort!(a,lo,hi)
    i, j = lo, hi
    while i < hi
        pivot = a[(lo+hi)>>>1]
        while i <= j
            while comp_ord(a[i], pivot); i = i+1; end
            while comp_ord(pivot, a[j]); j = j-1; end
            if i <= j
                a[i], a[j] = a[j], a[i]
                i, j = i+1, j-1
            end
        end
        if lo < j; qsort!(a,lo,j); end
        lo, j = i, hi
    end
    return a
end

function solution_13_1()
    input_as_str = read("./inputs/input_day13.txt", String)
    pairs = split(input_as_str, "\r\n\r\n")

    sum = 0
    for (i, p) in enumerate(pairs)
         l, r = split(p, "\r\n")
         l = split(l, ",")
         left = parse_line(l)
         r = split(r, ",")
         right = parse_line(r)
         if compare_order(left, right)
            sum+=i
         end
    end
    sum
end

function solution_13_2()
    input_as_str = read("./inputs/input_day13.txt", String)
    pairs = split(input_as_str, "\r\n\r\n")

    lines = []
    for (i, p) in enumerate(pairs)
         l, r = split(p, "\r\n")
         l = split(l, ",")
         left = parse_line(l)
         r = split(r, ",")
         right = parse_line(r)
         push!(lines, left)
         push!(lines, right)
    end
    i1 = [[[2]]]
    i2 = [[[6]]]
    push!(lines, i1)
    push!(lines, i2)
    qsort!(lines, 1, length(lines))
    findall(x->lines[x]==i1, 1:length(lines)), findall(x->lines[x]==i2, 1:length(lines))
end

println("Solution to task 13-1:", solution_13_1())
println("Solution to task 13-2:", solution_13_2())