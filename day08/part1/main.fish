#!/bin/fish

set count 0

set -a special_numbers 2 3 4 7

for line in (cat ../input)
    set components (string split " | " "$line")
    set output $components[2]
    for val in (string split " " $output)
        set len (string length "$val")
        if contains $len $special_numbers
            set count (math $count + 1)
        end
    end
end

echo "$count"
