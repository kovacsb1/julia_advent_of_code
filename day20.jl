function read_input()
    num_list = []
    open("./inputs/input_day20.txt",) do file
        for l in eachline(file)
            push!(num_list, parse(Int, l))
        end
    end
    num_list
end

function solution_20_1()
    input_list = read_input()

    traversed = falses(length(input_list))

    while ~all(traversed)
        idx = findfirst(.~traversed)
        item = input_list[idx]
        deleteat!(input_list, idx)
        deleteat!(traversed, idx)

        mod =  mod1(item+idx, length(input_list))
        insert_idx = mod == 1 ? length(input_list)+1 : mod
        insert!(input_list,insert_idx, item)
        insert!(traversed,insert_idx, true)
    end
    zero_idx = findfirst(input_list .== 0)

    coord_arr = []
    for i in 1000:1000:3000
         push!(coord_arr, input_list[(zero_idx+i)%length(input_list)])
    end
    sum(coord_arr)
end

# use doubly linked list
mutable struct ListNode
    value:: Int
    left::Union{ListNode, Nothing}
    right::Union{ListNode, Nothing}
    function ListNode(value)
        return new(value, nothing, nothing)
    end
end

function solution_20_2()
    dec_key = 811589153
    input_list = read_input()
    nodes = [ListNode(num*dec_key) for num in input_list]

    for (i, node) in enumerate(nodes)
        node.left = nodes[mod1(i-1, length(nodes))]
        node.right = nodes[mod1(i+1, length(nodes))]
    end

    for _ in 1:10
        for node in nodes
            temp = node
            num_moves = mod1(node.value, (length(nodes) - 1))

            # if we would switch with itself; return
            if num_moves == (length(nodes) - 1); continue end
            
            for _ in 1:num_moves
                temp = temp.right
            end
           
            # unconnect node
            node.right.left = node.left
            node.left.right = node.right
            
            # insert node
            temp.right.left = node
            node.right = temp.right
            temp.right = node
            node.left = temp
        end
    end
    zero_node = filter(n-> n.value == 0, nodes)[1]

    sum = 0
    for _ in 1:3
        for _ in 1:1000
            zero_node = zero_node.right
        end
        sum += zero_node.value
    end
    sum
end

println("Solution to task 20-1:", solution_20_1())
println("Solution to task 20-2:", solution_20_2())