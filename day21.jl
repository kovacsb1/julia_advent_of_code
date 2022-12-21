using SymPy

function solution_21_1()
    input_as_str =  read("./inputs/input_day21.txt", String)
    symbol_eqs = Set([split(line, ": ") for line in split(input_as_str, "\r\n")])
    symb_vals = Dict()
    
    while ~isempty(symbol_eqs)
        for s_eq in symbol_eqs
            symbol, eq = s_eq
            if ~isnothing(tryparse(Int, eq)) 
                symb_vals[symbol] = parse(Int, eq) 
                pop!(symbol_eqs, s_eq)
            else
                x, op, y = split(eq)
                if x in keys(symb_vals) && y in keys(symb_vals)
                    lval, rval = symb_vals[x], symb_vals[y]
                    if op == "*"
                        val = lval * rval
                    elseif op == "/"
                        val = convert(Int, lval / rval)
                    elseif op == "+"
                        val = lval + rval
                    elseif op == "-"
                        val = lval - rval
                    end

                    symb_vals[symbol] = val
                    pop!(symbol_eqs, s_eq)
                end
            end
        end
    end
    symb_vals["root"]
end

function solution_21_2()
    input_as_str =  read("./inputs/input_day21.txt", String)
    lines = split(input_as_str, "\r\n")

    ### replace root operation to equality check
    lines = [(split(line, ": ")[1] == "root") ? replace(line, r"(\+|\-|\*|\/)" => "=") : line for line in lines]

    symbol_eqs = Set([split(line, ": ") for line in lines if split(line, ": ")[1] != "humn"])

    symb_vals = Dict()
    
    while ~isempty(symbol_eqs)
        for s_eq in symbol_eqs
            symbol, eq = s_eq
            if ~isnothing(tryparse(Int, eq)) 
                symb_vals[symbol] = eq 
                pop!(symbol_eqs, s_eq)
            else
                x, op, y = split(eq)
                if x == "humn" && y in keys(symb_vals)
                    symb_vals[symbol] = "($x $op $(symb_vals[y]))"
                    pop!(symbol_eqs, s_eq)
                elseif y == "humn" && x in keys(symb_vals)
                    symb_vals[symbol] = "($(symb_vals[x]) $op $y)"
                    pop!(symbol_eqs, s_eq)
                elseif x in keys(symb_vals) && y in keys(symb_vals)
                    symb_vals[symbol] = "($(symb_vals[x]) $op $(symb_vals[y]))"
                    pop!(symbol_eqs, s_eq)
                end
            end
        end
    end
    
    symb_vals["root"] = chop(symb_vals["root"]; head=1, tail=1)
    root_eq = split(symb_vals["root"], "=")
    to_parse = """ using SymPy;  humn = symbols(\"humn\"); equation = Eq($(root_eq[1]), $(root_eq[2])); solveset(equation, humn); """

    eval(Meta.parse(to_parse))
end

println("Solution to task 21-1:", solution_21_1())
println("Solution to task 21-2:", solution_21_2())