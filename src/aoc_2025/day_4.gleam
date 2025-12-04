import gleam/function
import gleam/list
import gleam/set
import gleam/string

pub fn pt_1(input: set.Set(#(Int, Int))) {
  set.size(fewer_than_4(input, input).0)
}

pub fn pt_2(input: set.Set(#(Int, Int))) {
  pt_2_inner(input, input)
}

fn pt_2_inner(rolls: set.Set(#(Int, Int)), to_check: set.Set(#(Int, Int))) {
  let #(removed_rolls, to_check) = fewer_than_4(rolls, to_check)
  let new_rolls = set.difference(rolls, removed_rolls)
  // Only check rolls that are still rolls
  let to_check = set.intersection(to_check, new_rolls)
  case set.size(removed_rolls) {
    0 -> 0
    x -> x + pt_2_inner(new_rolls, to_check)
  }
}

fn fewer_than_4(rolls: set.Set(#(Int, Int)), to_check: set.Set(#(Int, Int))) {
  set.fold(to_check, #(set.new(), set.new()), fn(acc, roll) {
    let adjacent_rolls =
      adjacent(roll)
      |> list.filter(set.contains(rolls, _))
    case list.length(adjacent_rolls) {
      x if x < 4 -> {
        #(
          set.insert(acc.0, roll),
          set.union(acc.1, set.from_list(adjacent_rolls)),
        )
      }
      _ -> acc
    }
  })
}

fn adjacent(coordinate: #(Int, Int)) {
  let #(x, y) = coordinate
  [
    #(x - 1, y - 1),
    #(x - 1, y),
    #(x - 1, y + 1),
    #(x, y - 1),
    #(x, y + 1),
    #(x + 1, y - 1),
    #(x + 1, y),
    #(x + 1, y + 1),
  ]
}

pub fn parse(input: String) -> set.Set(#(Int, Int)) {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.index_map(fn(line, y) {
    line
    |> string.trim()
    |> string.to_graphemes()
    |> list.index_map(fn(char, x) {
      case char {
        "@" -> Ok(#(x, y))
        "." -> Error(Nil)
        _ -> panic as "Unexpected character"
      }
    })
  })
  |> list.flatten()
  |> list.filter_map(function.identity)
  |> set.from_list
}
