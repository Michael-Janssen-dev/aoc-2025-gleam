import aoc_2025/day01

const test_case = "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"

pub fn part_1_test() {
  assert day01.part1(test_case) == 3
}

pub fn part_2_test() {
  assert day01.part2(test_case) == 6
}
