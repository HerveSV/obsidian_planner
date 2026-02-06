using Dates


function generate_week(num::Int, dates, path)
    open("$path/Week $num.md", "w") do io
        for d in dates
            text = "$(dayname(d)), $(day(d)) $(monthabbr(d))"#Dates.format(d, "EEEE, dd mm")
            println(io, "## $text")
            println(io, "- [ ] this is a task")
        end
    end

end


function weeks_of_year(year::Int)
    weeks = Dict{Int, Vector{Date}}()

    for d in Date(year,1,1):Day(1):Date(year,12,31)
        w = week(d)
        push!(get!(weeks, w, Date[]), d)
    end

    return weeks
end

#
#print(weeks[6])
#generate_week(6, weeks[6])


year = parse(Int, ARGS[1])
println(year)

keycap_emojis = Dict([('0', "0️⃣"), ('1', "1️⃣"), ('2', "2️⃣"), ('3', "3️⃣"), ('4', "4️⃣"), ('5', "5️⃣"), ('6', "6️⃣"), ('7', "7️⃣"), ('8', "8️⃣"), ('9', "9️⃣")])
function int2emoji(num)
    str = string(num)
    x = []
    for s in str
        push!(x, keycap_emojis[s])
    end
    
    xs = join(x)
    return xs
end

weeks = weeks_of_year(year)
mkpath("Planner $year")
mkpath("Planner $year/weeks")
path = "Planner $year/weeks"

# create week files
for (weeknum, days) in weeks
    generate_week(weeknum, days, path)
end

open("Planner $year/Planner $year.md", "w") do io
    println(io, "# Past")
    println(io, "# Current")
    println(io, "# Future")
    for (weeknum, days) in sort(collect(weeks))
        emoji = int2emoji(weeknum)
        start = "$(monthabbr(days[1])) $(day(days[1]))"
        fin = "$(monthabbr(days[end])) $(day(days[end]))"
        println(io, "[[Week $weeknum|$emoji: $start - $fin]]")
    end
end