using CSV, DataFrames

function solution_4_1()
    input_as_str = read("./inputs/input_day4.txt", String)
    input_as_str = replace(input_as_str, "-" => ",")
    elf_data = DataFrame(CSV.File(IOBuffer(input_as_str), delim=",", header=false))
    first_contains_second = sum(elf_data[:, 1] .<= elf_data[:, 3] .&& (elf_data[:, 2] .>= elf_data[:, 4]))
    second_contains_first = sum(elf_data[:, 1] .>= elf_data[:, 3] .&& (elf_data[:, 2] .<= elf_data[:, 4]))
    exact_overlap = sum(elf_data[:, 1] .== elf_data[:, 3] .&& (elf_data[:, 2] .== elf_data[:, 4]))
    first_contains_second + second_contains_first - exact_overlap
end

function solution_4_2()
    input_as_str = read("./inputs/input_day4.txt", String)
    input_as_str = replace(input_as_str, "-" => ",")
    elf_data = DataFrame(CSV.File(IOBuffer(input_as_str), delim=",", header=false))
    start_overlap = max.(elf_data[:, 1], elf_data[:, 3])
    end_overlap = min.(elf_data[:, 2], elf_data[:, 4])
    is_overlap = (end_overlap .- start_overlap) .>= 0 
    sum(is_overlap)
end

println("Solution to task 4-1:", solution_4_1())
println("Solution to task 4-2:", solution_4_2())