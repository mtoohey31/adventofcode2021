use std::fs::read_to_string;
fn main() {
    let input = read_to_string("../input").unwrap();
    let mut parts = input.splitn(2, "\n");
    let mut nums = parts
        .next()
        .unwrap()
        .split(",")
        .map(|s| s.parse::<i32>().unwrap());
    let mut blocks = parts
        .next()
        .unwrap()
        .split("\n\n")
        .map(|block| {
            block
                .trim()
                .split("\n")
                .map(|line| {
                    line.trim()
                        .split(" ")
                        .filter_map(|c| c.trim().parse::<i32>().ok())
                        .map(|i| Some(i))
                        .collect::<Vec<Option<i32>>>()
                })
                .collect::<Vec<Vec<Option<i32>>>>()
        })
        .collect::<Vec<Vec<Vec<Option<i32>>>>>();

    while blocks.len() > 1 {
        let curr_num = nums.next().unwrap();

        let mut i = 0;
        while i < blocks.len() {
            if remove_num(&mut blocks[i], curr_num) {
                blocks.remove(i);
            } else {
                i += 1;
            }
        }
    }
    let mut last = nums.next().unwrap();
    while !remove_num(&mut blocks[0], last) {
        last = nums.next().unwrap();
    }
    println!("{}", calculate_sum(&blocks[0]) * last);
}

fn calculate_sum(board: &Vec<Vec<Option<i32>>>) -> i32 {
    board.iter().fold(0, |prev, row| {
        prev + row.iter().fold(0, |prev, item| {
            prev + match item {
                Some(i) => i,
                None => &0_i32,
            }
        })
    })
}

fn remove_num(board: &mut Vec<Vec<Option<i32>>>, remove_num: i32) -> bool {
    let mut res = false;
    for row in 0..board.len() {
        for col in 0..board[row].len() {
            if board[row][col] == Some(remove_num) {
                board[row][col] = None;
                if !res {
                    res = check_done(board, row, col);
                }
            }
        }
    }
    res
}

fn check_done(board: &Vec<Vec<Option<i32>>>, row: usize, col: usize) -> bool {
    board.iter().all(|row| row[col] == None) || board[row].iter().all(|item| *item == None)
}
