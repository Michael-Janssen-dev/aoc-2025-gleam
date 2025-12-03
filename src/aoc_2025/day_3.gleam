import gleam/int
import gleam/list
import gleam/string

pub fn pt_1(input: List(List(Int))) {
  input
  |> list.map(max_voltage(_, 2))
  |> int.sum
}

pub fn pt_2(input: List(List(Int))) {
  input
  |> list.map(max_voltage(_, 12))
  |> int.sum
}

fn max_voltage(bank: List(Int), batteries: Int) -> Int {
  let res =
    list.range(batteries, 1)
    |> list.fold(#(bank, 0), fn(acc, batteries) {
      let #(bank, res) = acc
      let assert Ok(max) =
        bank
        |> list.take(list.length(bank) - batteries + 1)
        |> list.max(int.compare)
      let new_bank =
        bank
        |> list.drop_while(fn(x) { x < max })
        |> list.drop(1)
      #(new_bank, res * 10 + max)
    })
  res.1
}

pub fn parse(input: String) -> List(List(Int)) {
  input
  |> string.trim
  |> string.split(on: "\n")
  |> list.map(string.trim)
  |> list.map(fn(line) {
    line
    |> string.to_graphemes()
    |> list.map(fn(char) {
      let assert Ok(x) = char |> int.parse
      x
    })
  })
}
