import aoc_2025/day01
import aoc_2025/util
import gleam/int
import gleam/io

pub fn main() -> Nil {
  io.println(
    util.read_file("inp/day01.txt") |> day01.part1() |> int.to_string(),
  )
  io.println(
    util.read_file("inp/day01.txt") |> day01.part2() |> int.to_string(),
  )
}
