import gleam/int
import gleam/list
import gleam/string

pub fn pt_1(input: #(List(Range), List(Int))) {
  let #(ranges, ingredients) = input
  let ranges =
    ranges
    |> list.sort(fn(a, b) { int.compare(a.0, b.0) })

  list.count(ingredients, is_fresh(ranges, _))
}

fn is_fresh(ranges: List(Range), ingredient: Int) {
  case ranges {
    [] -> False
    [#(a, _), ..] if a > ingredient -> False
    [#(_, b), ..] if ingredient <= b -> True
    [_, ..rest] -> is_fresh(rest, ingredient)
  }
}

pub fn pt_2(input: #(List(Range), List(Int))) {
  let #(ranges, _) = input
  let ranges = list.sort(ranges, fn(a, b) { int.compare(a.0, b.0) })
  let res =
    ranges
    |> list.fold(#(0, 0), fn(acc, range) {
      let #(sum, max) = acc
      let #(l, r) = range
      case True {
        _ if l <= max && r <= max -> {
          acc
        }
        _ if l <= max -> {
          #(sum + sum_range(range) + { l - max - 1 }, r)
        }
        _ -> {
          #(sum + sum_range(range), r)
        }
      }
    })
  res.0
}

fn sum_range(range: Range) -> Int {
  range.1 - range.0 + 1
}

type Range =
  #(Int, Int)

pub fn parse(input: String) -> #(List(Range), List(Int)) {
  let assert Ok(#(ranges, ingredients)) =
    input
    |> string.split_once("\n\n")

  let ranges =
    ranges
    |> string.split("\n")
    |> list.map(fn(range) {
      let assert Ok(#(left, right)) = string.split_once(range, "-")
      let assert Ok(left) = int.parse(left)
      let assert Ok(right) = int.parse(right)
      #(left, right)
    })
  let ingredients =
    ingredients
    |> string.trim_end()
    |> string.split("\n")
    |> list.map(fn(in) {
      let assert Ok(in) = int.parse(in)
      in
    })
  #(ranges, ingredients)
}
