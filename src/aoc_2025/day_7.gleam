import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/set
import gleam/string

type Input =
  #(Int, Int, set.Set(#(Int, Int)))

pub fn pt_1(input: Input) {
  let #(_, _, splitters) = input
  splitters
  |> set.filter(fn(splitter) {
    let #(x, y) = splitter
    list.range(y - 1, 0)
    |> list.fold_until(True, fn(_, y) {
      case
        set.contains(splitters, #(x - 1, y))
        || set.contains(splitters, #(x + 1, y))
      {
        True -> list.Stop(True)
        _ ->
          case set.contains(splitters, #(x, y)) {
            True -> list.Stop(False)
            _ -> list.Continue(True)
          }
      }
    })
  })
  |> set.size
}

pub fn pt_2(input: Input) {
  let #(start, length, splitters) = input
  let start = dict.from_list([#(start, 1)])
  list.range(2, length + 1)
  |> list.sized_chunk(2)
  |> list.fold(start, fn(beams, row) {
    let assert [row, _] = row
    beams
    |> dict.fold(dict.new(), fn(acc, pos, count) {
      case set.contains(splitters, #(pos, row)) {
        True -> {
          acc
          |> dict.upsert(pos - 1, dict_upsert_add(count))
          |> dict.upsert(pos + 1, dict_upsert_add(count))
        }
        False -> dict.upsert(acc, pos, dict_upsert_add(count))
      }
    })
  })
  |> dict.values
  |> int.sum
}

fn dict_upsert_add(count: Int) {
  fn(exist) {
    case exist {
      option.None -> count
      option.Some(prev) -> count + prev
    }
  }
}

pub fn parse(input: String) -> Input {
  let lines =
    input
    |> string.trim
    |> string.split(on: "\n")

  let splitters =
    lines
    |> list.index_map(fn(line, y) {
      string.to_graphemes(line)
      |> list.index_map(fn(char, x) {
        case char {
          "^" -> Ok(#(x, y))
          _ -> Error(Nil)
        }
      })
      |> result.values
    })
    |> list.flatten
    |> set.from_list

  let assert Ok(first) = list.first(lines)
  #(string.length(first) / 2, list.length(lines), splitters)
}
