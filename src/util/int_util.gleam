import gleam/float
import gleam/int
import gleam/list
import gleam/string

pub fn repeat(x: Int, times: Int) -> Int {
  let string_x = int.to_string(x)
  let assert Ok(res) = string.repeat(string_x, times) |> int.parse
  res
}

pub fn digits(x: Int) -> Int {
  x
  |> int.to_string()
  |> string.length()
}

pub fn all_numbers(sized: Int) -> List(Int) {
  list.range(int_power(10, sized - 1), repeat(9, sized))
}

pub fn int_power(base: Int, exponent: Int) -> Int {
  let assert Ok(float_result) = int.power(base, int.to_float(exponent))
  float.round(float_result)
}

pub fn ten_to_the_power(x: Int) -> Int {
  let assert Ok(val) = string.pad_end("1", x + 1, with: "0") |> int.parse
  val
}

pub fn must_parse(x: String) -> Int {
  let assert Ok(x) = int.parse(x)
  x
}
