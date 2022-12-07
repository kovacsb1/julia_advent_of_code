using AbstractTrees

mutable struct FileTreeNode  # make your own trees
    name::String
    size::Int
    children::Vector{FileTreeNode}
    parent::Union{Nothing,FileTreeNode}
end;

AbstractTrees.children(t::FileTreeNode) = t.children;
AbstractTrees.nodevalue(t::FileTreeNode) = "$(t.name) : $(t.size)"
AbstractTrees.parent(n::FileTreeNode) = n.parent

function build_tree()
    tree = nothing
    open("./inputs/input_day7.txt") do file
        
        for line in eachline(file)
            words = split(line)
            if words[1] == "\$"
                if words[2] == "cd"
                    if words[3] == ".."
                        tree = tree.parent
                    else
                        new_node = FileTreeNode(words[3], 0, [], tree)
                        if tree !== nothing
                            push!(tree.children, new_node)
                        end
                        tree = new_node
                    end
                end
            elseif tryparse(Int, words[1]) !== nothing
                tree.size += parse(Int, words[1])
            end
        end
    end
    while tree.parent !== nothing
        tree = tree.parent
    end
    tree
end

function accumulate_sizes!(tree)
    if length(tree.children) == 0 
        tree.size
    else
        res = [accumulate_sizes!(c) for c in tree.children]
        tree.size += sum(res)
        tree.size
    end
end

function solution_7_1()
    tree = build_tree()
    #print_tree(tree)

    function traverse_tree(tree)
        if length(tree.children) == 0
            (tree.size, tree.size <= 100000 ? tree.size : 0)
        else
            res = [traverse_tree(c) for c in tree.children]
            child_sum = sum([r[1] for r in res])
            sum_so_far = sum([r[2] for r in res])
            curr_size = tree.size + child_sum
            curr_size, curr_size <= 100000 ? curr_size + sum_so_far : sum_so_far
        end
    end
    traverse_tree(tree)[2]
end        

function solution_7_2()
    tree = build_tree()

    accumulate_sizes!(tree)
    # print_tree(tree)
    total_occupied = tree.size
    min_size = tree.size

    function preorder_minsearch(tree, min_size)
        if total_occupied - tree.size <= 40000000 
            if tree.size < min_size
                min_size = tree.size
            end
            child_mins = [preorder_minsearch(ch, min_size) for ch in tree.children]
            min_size = minimum(push!(child_mins, min_size))
        end
        min_size
    end
    preorder_minsearch(tree, min_size)
end

println("Solution to task 7-1:", solution_7_1())
println("Solution to task 7-2:", solution_7_2())