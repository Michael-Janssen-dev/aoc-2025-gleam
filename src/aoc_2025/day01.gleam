import aoc_2025/util
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub fn part1(input: String) -> Int {
  let result =
    parse_input(input)
    |> list.fold(#(50, 0), apply_direction_part1)
  result.1
}

pub fn part2(input: String) -> Int {
  let result =
    parse_input(input)
    |> list.fold(#(50, 0), apply_direction_part2)
  result.1
}

fn apply_direction_part1(start: #(Int, Int), to: Int) -> #(Int, Int) {
  let new_number = { start.0 + to } % 100
  case new_number {
    0 -> #(0, start.1 + 1)
    x -> #(x, start.1)
  }
}

fn apply_direction_part2(start: #(Int, Int), rotation: Int) -> #(Int, Int) {
  let new_rotations = case rotation {
    x if x < 0 -> {
      { { { 100 - start.0 } % 100 } - x } / 100
    }
    x -> {
      { start.0 + x } / 100
    }
  }
  let new_number = int.modulo(start.0 + rotation, 100) |> result.unwrap(0)
  #(new_number, start.1 + new_rotations)
}

fn parse_input(input: String) {
  input
  |> string.split(on: "\n")
  |> list.filter(fn(x) { x != "" })
  |> list.map(fn(x) {
    case string.first(x) {
      Ok("L") -> -parse_direction(x)
      Ok("R") -> parse_direction(x)
      _ -> panic
    }
  })
}

fn parse_direction(x: String) -> Int {
  string.drop_start(x, up_to: 1)
  |> int.parse()
  |> result.unwrap(or: 0)
}

pub fn main() -> Nil {
  io.println(util.read_file("inp/day01.txt") |> part1() |> int.to_string())
  io.println(util.read_file("inp/day01.txt") |> part2() |> int.to_string())
}
