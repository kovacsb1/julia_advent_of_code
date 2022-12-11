mutable struct Monkey
    items
    operation
    test
    num_inspected
    function Monkey(items, operation, test)
        return new(items, operation, test, 0)
    end
end

NUM_ROUNDS_1 = 20
DIV_1 = 3
NUM_ROUNDS_2 = 10000

function read_monkeys()
    input_as_str = read("./inputs/input_day11.txt", String)
    input_as_str = replace(input_as_str, "," => "")
    monkey_texts = split(input_as_str, "\r\n\r\n")
    monkeys = []
    test_divisors = []
    for mt in monkey_texts
        _, start_items, operation_txt, test, test_true, test_false = split(mt, "\r\n")
        
        # parse items
        items = [] 
        for item_str in split(start_items)[3:end]
            push!(items, parse(Int, item_str))
        end

        # parse operation
        operation_items = split(operation_txt)
        op = operation_items[end-1]
        arg_2 = operation_items[end]
        operation = function(x)
            if op == "*"
                x * (arg_2 == "old" ? x : parse(Int, arg_2))
            else
                x + (arg_2 == "old" ? x : parse(Int, arg_2))
            end
        end

        # parse test
        test_modulo = parse(Int, last(split(test)))
        true_target= parse(Int, last(split(test_true)))
        false_target = parse(Int, last(split(test_false)))
        test = x -> x % test_modulo == 0 ? true_target : false_target 
        push!(monkeys, Monkey(items, operation, test))
        push!(test_divisors, test_modulo)
    end
    monkeys, test_divisors
end

function calculate_level_of_monkey_business(monkeys, num_rounds, worry_reduction_fn)
    for _ in 1:num_rounds
        for m in monkeys
            for item in m.items
                current_worry = worry_reduction_fn(m.operation(item))
                target = m.test(current_worry)
                push!(monkeys[target+1].items, current_worry)
                m.num_inspected += 1
            end
            m.items = []
        end
    end
    prod(sort([m.num_inspected for m in monkeys])[end-1:end])
end

function solution_11_1() 
    monkeys, _ = read_monkeys()
    worry_reduction_fn = x -> x ÷ 3
    calculate_level_of_monkey_business(monkeys, NUM_ROUNDS_1, worry_reduction_fn)
end 

function solution_11_2() 
    monkeys, test_integers = read_monkeys()
    div = reduce(lcm, [i for i in test_integers]) # get lcm
    worry_reduction_fn = x -> x % div
    calculate_level_of_monkey_business(monkeys, NUM_ROUNDS_2, worry_reduction_fn)
end 

println("Solution to task 11-1:", solution_11_1())
println("Solution to task 11-2:", solution_11_2())