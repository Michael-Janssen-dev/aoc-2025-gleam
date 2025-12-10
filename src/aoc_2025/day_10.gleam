import simplifile
import gleam/int
import util/int_util
import gleam/set
import gleam/list
import gleam/string

pub fn pt_1(input: Input) {
  input
  |> list.index_map(fn (line, i) {
    let #(ind, but, _) = line
    let buttons = list.map(but, to_bit_flag)
    let ind = to_bit_flag(ind)
    let assert Ok(x) = list.range(1, list.length(buttons))
    |> list.find_map(fn (i) {
      buttons
      |> list.combinations(i)
      |> list.find_map(fn (buttons) {
        case list.reduce(buttons, apply) {
          Ok(x) if x == ind -> Ok(i)
          _ -> Error(Nil)
        }
      })
    })
    x
  })
  |> int.sum
}

fn to_bit_flag(seq: set.Set(Int)) {
  set.fold(seq, 0, fn(acc, i) {
    int.bitwise_or(acc, int.bitwise_shift_left(1, i))
  })
}

fn apply(ind: Int, but: Int) {
  int.bitwise_exclusive_or(ind, but)
}

pub fn pt_2(input: Input) {
  todo as "part 2 not implemented"
}

pub type Input = List(#(set.Set(Int), List(set.Set(Int)), set.Set(Int)))

pub fn parse(input:String) -> Input {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(fn (line) {
    let assert [indicators, ..buttons] = string.split(line, " ")
    let assert [voltage, ..buttons] = list.reverse(buttons)
    let buttons = list.map(buttons, fn(x) {x |> parse_int_list |> set.from_list})
    let voltage = parse_int_list(voltage) |> set.from_list
    let indicators = indicators
      |> string.drop_start(1)
      |> string.drop_end(1)
      |> string.to_graphemes()
      |> list.index_fold(set.new(), fn(acc, x, i) {
        case x {
          "#" -> set.insert(acc, i)
          "." -> acc
          _ -> panic
        }
      })
    #(indicators, buttons, voltage)
  })
}

fn parse_int_list(inp: String) -> List(Int) {
  case string.split(inp, ",") {
    [] -> []
    [first] -> [int_util.must_parse(string.drop_end(string.drop_start(first, 1), 1))]
    [first, ..rest] -> [int_util.must_parse(string.drop_start(first, 1)), ..parse_int_list_helper(rest)]
  }
}

fn parse_int_list_helper(inp: List(String)) -> List(Int) {
  case inp {
    [first] -> [int_util.must_parse(string.drop_end(first, 1))]
    [first, ..rest] -> [int_util.must_parse(first), ..parse_int_list_helper(rest)]
    _ -> []
  }
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/2025/10.txt")
  echo pt_1(parse(input))
}