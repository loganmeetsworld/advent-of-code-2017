require 'date'

input = File.open("./input.txt").readlines

def calculate_sleep(watch_events)
    asleep_time, asleep_minutes = 0, []
    times = watch_events.join("\n").scan(/\d{2}:(\d{2})/).flatten.map(&:to_i).each_slice(2).to_a
    times.each do |time|
        if time.length == 2
            asleep_time += (time[1] - time[0])
            asleep_minutes += (time[0]...time[1]).to_a
        end
    end
    return asleep_time, asleep_minutes
end

def parse(watch)
    id = watch.scan(/#(\d+)/).flatten.first
    date = watch.scan(/\[(\d{4}-\d{2}-\d{2})/).flatten.last
    watch_events = watch.split("\n")
    asleep_time, asleep_minutes = calculate_sleep(watch_events[1..-1])

    return {:id => id, :date => date, :asleep_time => asleep_time, :asleep_minutes => asleep_minutes}
end

sorted_watches = input.map(&:chomp).sort
grouped_watches = sorted_watches.join("\n").split(/(?=\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}\] Guard)/)
parsed_watches = grouped_watches.map{ |x| parse(x) }

grouped_parsed_watches = parsed_watches.group_by{ |x| x[:id] }
sleep_totals = []
grouped_parsed_watches.values.each do |group|
    total_sleep = group.map{ |h| h[:asleep_time] }.inject(:+)
    total_minutes = group.map{ |h| h[:asleep_minutes] }.flatten
    most_repeated_minute = total_minutes.max_by { |i| total_minutes.count(i) }
    repeated_count = total_minutes.count(most_repeated_minute)
    id = group[0][:id]
    sleep_totals << {:id => id, :total_sleep => total_sleep, :repeated_count => repeated_count, :most_repeated_minute => most_repeated_minute}
end

puts "Part 1:"
biggest_sleeper_id = sleep_totals.max_by{ |x| x[:total_sleep] }[:id]
biggest_sleeper = grouped_parsed_watches[biggest_sleeper_id]
minutes = biggest_sleeper.map{ |x| x[:asleep_minutes]}.flatten
minute_most_asleep = minutes.max_by { |i| minutes.count(i) }
puts minute_most_asleep * biggest_sleeper_id.to_i

puts "Part 2:"
biggest_sleeper_by_minute = sleep_totals.max_by{ |x| x[:repeated_count] }
puts biggest_sleeper_by_minute[:id].to_i * biggest_sleeper_by_minute[:most_repeated_minute]