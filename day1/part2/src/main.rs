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
    for i in 0..ints.len() - 3 {
        if ints[i..i + 3].into_iter().fold(0, |i, j| i + j)
            < ints[i + 1..i + 4].into_iter().fold(0, |i, j| i + j)
        {
            diff_count += 1;
        }
    }
    println!("{}", diff_count);
}
