import gleam/int
import gleam/list
import gleam/string

pub fn pt_1(input: List(Int)) -> Int {
  let result =
    input
    |> list.fold(#(50, 0), apply_direction_part1)
  result.1
}

pub fn pt_2(input: List(Int)) -> Int {
  let result =
    input
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
  let assert Ok(new_number) = int.modulo(start.0 + rotation, 100)
  #(new_number, start.1 + new_rotations)
}

pub fn parse(input: String) -> List(Int) {
  input
  |> string.split(on: "\n")
  |> list.filter(fn(x) { x != "" })
  |> list.map(fn(x) {
    case x {
      "L" <> x -> -parse_direction(x)
      "R" <> x -> parse_direction(x)
      _ -> panic
    }
  })
}

fn parse_direction(x: String) -> Int {
  let assert Ok(dir) = int.parse(x)
  dir
}
