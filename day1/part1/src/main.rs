use std::fs::read_to_string;

fn main() {
    let input = read_to_string("../input").unwrap();
    let ints = input
        .split("\n")
        .into_iter()
        .filter(|l| l != &"")
        .map(|l| l.parse::<i32>().unwrap())
        .collect::<Vec<i32>>();
    let mut diff_count = 0;
    for i in 0..ints.len() - 1 {
        if ints[i + 1] > ints[i] {
            diff_count += 1;
        }
    }
    println!("{}", diff_count);
}
