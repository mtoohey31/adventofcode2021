use std::{collections::HashMap, fs::read_to_string};

static SIM_DAYS: i64 = 256;

fn main() {
    let input = read_to_string("../input").unwrap();
    let mut day_map = HashMap::new();
    println!(
        "{}",
        input
            .trim()
            .split(",")
            .map(|s| s.parse::<i64>().unwrap())
            .fold(0, |prev, curr| prev + days(curr, SIM_DAYS, &mut day_map))
    )
}

fn days(counter: i64, days_remaining: i64, day_map: &mut HashMap<i64, i64>) -> i64 {
    if counter >= days_remaining {
        1
    } else {
        let new_spawned = days_remaining - counter - 1;
        if let Some(val) = day_map.get(&new_spawned) {
            *val
        } else {
            let new = days(6, new_spawned, day_map) + days(8, new_spawned, day_map);
            day_map.insert(new_spawned, new);
            new
        }
    }
}
