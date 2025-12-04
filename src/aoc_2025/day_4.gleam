import gleam/function
import gleam/list
import gleam/set
import gleam/string

pub fn pt_1(input: set.Set(#(Int, Int))) {
  set.size(fewer_than_4(input))
}

pub fn pt_2(input: set.Set(#(Int, Int))) {
  let new_rolls = fewer_than_4(input)
  case set.size(new_rolls) {
    0 -> 0
    x -> x + pt_2(set.difference(input, new_rolls))
  }
}

fn fewer_than_4(rolls: set.Set(#(Int, Int))) {
  set.fold(rolls, set.new(), fn(acc, roll) {
    let adjacent_rolls =
      adjacent(roll)
      |> list.count(set.contains(rolls, _))
    case adjacent_rolls {
      x if x < 4 -> {
        set.insert(acc, roll)
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
