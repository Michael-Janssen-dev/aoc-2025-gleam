import gleam/int
import gleam/list
import gleam/result
import gleam/string

type Direction {
  Left(Int)
  Right(Int)
}

fn apply_direction_part1(start: #(Int, Int), to: Direction) -> #(Int, Int) {
  let new_number =
    case to {
      Left(x) -> start.0 - x
      Right(x) -> start.0 + x
    }
    |> int.modulo(100)
    |> result.unwrap(or: 0)

  case new_number {
    0 -> #(0, start.1 + 1)
    x -> #(x, start.1)
  }
}

fn apply_direction_part2(start: #(Int, Int), to: Direction) -> #(Int, Int) {
  let new_number = case to {
    Left(x) -> start.0 - x
    Right(x) -> start.0 + x
  }
  let new_rotations = case new_number {
    x if x <= 0 -> {
      let new_value =
        x
        |> int.divide(100)
        |> result.unwrap(or: 0)
        |> fn(x) { x - 1 }
        |> fn(x) {
          case start.0 {
            0 -> x + 1
            _ -> x
          }
        }
        |> int.absolute_value
      start.1 + new_value
    }
    x if x >= 100 -> {
      let new_value =
        x
        |> int.divide(100)
        |> result.unwrap(or: 0)
      start.1 + new_value
    }
    _ -> start.1
  }
  let new_number = new_number |> int.modulo(100) |> result.unwrap(0)
  #(new_number, new_rotations)
}

fn parse_input(input: String) {
  input
  |> string.split(on: "\n")
  |> list.filter(fn(x) { x != "" })
  |> list.map(fn(x) {
    case string.first(x) {
      Ok("L") ->
        Left(
          string.drop_start(x, up_to: 1)
          |> int.parse()
          |> result.unwrap(or: 0),
        )
      Ok("R") ->
        Right(
          string.drop_start(x, up_to: 1)
          |> int.parse()
          |> result.unwrap(or: 0),
        )
      x -> { echo x } |> panic
    }
  })
}

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
