using CSV, DataFrames

function solution_2_1()
    map_notation = played -> played == "A" ? "X" : played == "B" ? "Y" : "Z"
    score_played = played -> played == "X" ? 1 : played == "Y" ? 2 : 3  
    
    function score_win(row)
        opp = row[1]
        me = row[2]
        
        if me == opp
            3
        else
            if opp == "X"
                me == "Y" ? 6 : 0
            elseif  opp == "Y"
                me == "Z" ? 6 : 0
            elseif opp == "Z"
                me == "X" ? 6 : 0
            end
        end
    end
     
    rock_paper_data = DataFrame(CSV.File(open("./inputs/input_day2.txt"), delim=' ', header=false))
    rock_paper_data[:, 1] = map_notation.(rock_paper_data[:, 1])
    
    rock_paper_data[:, "score"] = score_played.(rock_paper_data[:, 2])
    rock_paper_data[:, "score"] += score_win.(eachrow(rock_paper_data))
    sum(rock_paper_data[:, "score"])
end

function solution_2_2()
    map_notation = played -> played == "A" ? "X" : played == "B" ? "Y" : "Z"

    score_outcome = played -> played == "X" ? 0 : played == "Y" ? 3 : 6  
    score_played = played -> played == "X" ? 1 : played == "Y" ? 2 : 3  
    
    function get_played(row)
        opp = row[1]
        me = row[2]
        
        if me == "Y"
            opp
        else
            if me == "X"
                opp == "Y" ? "X" : opp == "Z" ? "Y" : "Z"
            elseif me == "Z"
                opp == "Y" ? "Z" : opp == "Z" ? "X" : "Y"
            end
        end
    end
     
    rock_paper_data = DataFrame(CSV.File(open("./inputs/input_day2.txt"), delim=' ', header=false))
    rock_paper_data[:, 1] = map_notation.(rock_paper_data[:, 1])
    
    rock_paper_data[:, "score"] = score_outcome.(rock_paper_data[:, 2])
    rock_paper_data[:, "played"] = get_played.(eachrow(rock_paper_data))
    rock_paper_data[:, "score"] += score_played.(rock_paper_data[:, "played"])
    sum(rock_paper_data[:, "score"])
end

println("Solution to task 2-1:", solution_2_1())
println("Solution to task 2-2:", solution_2_2())