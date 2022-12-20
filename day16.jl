using Graphs, Combinatorics

# bit of a hack to represent AA-ZZ in 1-25*26+26
# as I didn't find an easy way to add properties to graphs
GRAPH_SIZE = 25*26+26
function convert_nodename_indexing(nn)
    (nn[1]-'A')*26+(nn[2]-'A')+1
end

function read_graph()
    g = Graph()
    [add_vertex!(g) for _ in 1:GRAPH_SIZE]

    rewards = zeros(Int, GRAPH_SIZE)
    open("./inputs/input_day16.txt") do file
        i = 1
        for l in eachline(file)
            tokens = split(l)
            n = tokens[2]
            reward = chop(split(tokens[5], "=")[2])
            reward = parse(Int, reward)
            rewards[convert_nodename_indexing(n)] = reward

            for t in tokens[10:end]
                add_edge!(g, convert_nodename_indexing(n), convert_nodename_indexing(t))
            end
            i += 1
        end
    end
    g, rewards
end

function get_shortest_paths(g)
    shortest_dists = []
    for node in vertices(g)
        paths = dijkstra_shortest_paths(g, node)
        push!(shortest_dists, paths.dists)
    end
    shortest_dists  
end

function solution_16_1()
    g, rewards = read_graph()
   
    shortest_paths = get_shortest_paths(g) 
    
    # we only care about vertices with nonzero rewards
    nonzero_reward_mask = rewards .> 0
    nonzero_nodes = Set(vertices(g)[nonzero_reward_mask]) 

    limit = 30
    function dfs(current_node, iteration_num, reward, is_open, curr_max)
        
        reward_per_turn = isempty(is_open) ? 0 : sum([rewards[i] for i in is_open])
        for nbhd in setdiff(nonzero_nodes, is_open)
            iterations_to_get_there = shortest_paths[current_node][nbhd]+1
            
            updated_iterations = iteration_num + iterations_to_get_there
            if updated_iterations < limit
                updated_reward = reward + iterations_to_get_there * reward_per_turn
                curr_max = max(curr_max, dfs(nbhd, updated_iterations, updated_reward, union(is_open, Set(nbhd)), curr_max))
            end
        end
        
        # staying here as no neighbors can be reached
        return max(curr_max, reward + (limit - iteration_num) * reward_per_turn)
    end

   dfs(1, 0, 0, Set(), -Inf)

end

function solution_16_2()
    g, rewards = read_graph()
   
    shortest_paths = get_shortest_paths(g) 
    
    # we only care about vertices with nonzero rewards
    nonzero_reward_mask = rewards .> 0
    nonzero_nodes = Set(vertices(g)[nonzero_reward_mask]) 

    limit = 26
    # separate node, time and valves opened for each player
    function dfs(current_player_node, player_iteration_num, other_node, other_iteration_num, reward, is_open_player, is_open_other, curr_max)
        # player at less iteration moves first
        if player_iteration_num <= other_iteration_num
            player_actor = true
            current_node = current_player_node
            iteration_num = player_iteration_num
            reward_per_turn = isempty(is_open_player) ? 0 : sum([rewards[i] for i in is_open_player])
        else 
            player_actor = false
            current_node = other_node
            iteration_num = other_iteration_num
            reward_per_turn = isempty(is_open_other) ? 0 : sum([rewards[i] for i in is_open_other])
        end

        for nbhd in setdiff(setdiff(nonzero_nodes, is_open_player), is_open_other)
            iterations_to_get_there = shortest_paths[current_node][nbhd]+1
            
            updated_iterations = iteration_num + iterations_to_get_there
            if updated_iterations < limit
                updated_reward = reward + iterations_to_get_there * reward_per_turn
                if player_actor
                    curr_max = max(curr_max, dfs(nbhd, updated_iterations, other_node, other_iteration_num, updated_reward, union(is_open_player, Set(nbhd)), is_open_other, curr_max))
                else
                    curr_max = max(curr_max, dfs(current_player_node, player_iteration_num, nbhd, updated_iterations, updated_reward, is_open_player, union(is_open_other, Set(nbhd)), curr_max))
                end
            end
        end
        
        # let other player complete
        if player_actor
            return max(curr_max, reward + (limit - iteration_num) * reward_per_turn + (limit - other_iteration_num) * (isempty(is_open_other) ? 0 : sum([rewards[i] for i in is_open_other]))) #+ dfs(current_player_node, limit, other_node, other_iteration_num, reward, is_open_player, is_open_other, curr_max)
        else
            return max(curr_max, reward + (limit - iteration_num) * reward_per_turn + (limit - player_iteration_num) * (isempty(is_open_player) ? 0 : sum([rewards[i] for i in is_open_player])))
        end
    end

   dfs(1, 0, 1, 0, 0, Set(), Set(), -Inf)

end

println("Solution to task 16-1:", solution_16_1())
println("Solution to task 16-2:", solution_16_2())