#!/bin/fish

set sum 0

set -a special_numbers 2 3 4 7
set -a chars a b c d e f g

for line in (cat ../input)
    set components (string split " | " "$line")

    set occurs_eight_times ""

    set input $components[1]
    for char in $chars
        set num_occurences (string replace -ar "[^$char]" '' "$input" | string length)
        switch $num_occurences
            case 4
                set left_bottom $char
            case 6
                set left_top $char
            case 7
            case 8
                if test -z "$occurs_eight_times"
                    set occurs_eight_times $char
                else
                    set also_occurs_eight_times $char
                end
            case 9
                set right_bottom $char
            case '*'
                echo "unsupported occurences of $char"
                exit 1
        end
    end

    set curr_num ""

    set output $components[2]
    for val in (string split " " $output)
        set len (string length "$val")
        switch $len
            case 2
                set curr_num $curr_num"1"
            case 3
                set curr_num $curr_num"7"
            case 4
                set curr_num $curr_num"4"
            case 5
                if string match -r "$left_bottom" "$val" >/dev/null
                    set curr_num $curr_num"2"
                else if string match -r "$left_top" "$val" >/dev/null
                    set curr_num $curr_num"5"
                else
                    set curr_num $curr_num"3"
                end
            case 6
                if ! string match -r "$left_bottom" "$val" >/dev/null
                    set curr_num $curr_num"9"
                else if string match -r "$occurs_eight_times" "$val" >/dev/null && string match -r "$also_occurs_eight_times" "$val" >/dev/null
                    set curr_num $curr_num"0"
                else
                    set curr_num $curr_num"6"
                end
            case 7
                set curr_num $curr_num"8"
            case '*'
                echo "unsupported output length $len"
                exit 1
        end
    end

    set sum (math "$sum" + "$curr_num")
end

echo "$sum"
