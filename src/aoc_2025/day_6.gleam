import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/int_util

pub fn pt_1(input: String) {
  let input = parse_pt1(input)
  list.fold(input, 0, fn(acc, calc) {
    let assert Ok(x) = list.reduce(calc.1, calc.0)
    acc + x
  })
}

pub fn pt_2(input: String) {
  let input = parse_pt2(input)
  list.fold(input, 0, fn(acc, calc) {
    let assert Ok(x) = list.reduce(calc.1, calc.0)
    acc + x
  })
}

type Calculation =
  #(fn(Int, Int) -> Int, List(Int))

fn parse_pt1(input: String) -> List(Calculation) {
  let lines =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.map(string.split(_, on: " "))
    |> list.map(list.filter(_, fn(x) { x != "" }))
  let operators =
    lines
    |> list.last
    |> result.unwrap(or: [""])
    |> list.map(fn(op) {
      case op {
        "+" -> int.add
        "*" -> int.multiply
        _ -> panic
      }
    })

  let calcs =
    lines
    |> list.take(list.length(lines) - 1)
    |> list.map(list.map(_, int_util.must_parse))
    |> list.transpose

  list.zip(operators, calcs)
}

fn parse_pt2(input: String) -> List(Calculation) {
  let lines =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.map(string.split(_, on: " "))
    |> list.map(list.filter(_, fn(x) { x != "" }))

  let operators =
    lines
    |> list.last
    |> result.unwrap(or: [""])
    |> list.map(fn(op) {
      case op {
        "+" -> int.add
        "*" -> int.multiply
        _ -> panic
      }
    })

  let calcs =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.take(list.length(lines) - 1)
    |> list.map(string.to_graphemes)
    |> list.transpose
    |> list.map(string.join(_, ""))
    |> list.map(string.trim)
    |> list.map(int.parse)
    |> list.fold(#([], []), fn(acc, item) {
      case item {
        Ok(num) -> #(acc.0, [num, ..acc.1])
        Error(_) -> #([acc.1, ..acc.0], [])
      }
    })

  list.zip(list.reverse(operators), [calcs.1, ..calcs.0])
}
