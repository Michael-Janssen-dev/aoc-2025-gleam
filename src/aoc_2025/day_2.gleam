import gleam/int
import gleam/list
import gleam/string
import util/int_util

pub fn pt_1(input: List(#(Int, Int))) {
  sum_invalid_ids(input, invalid_id_generator_pt_1)
}

pub fn pt_2(input: List(#(Int, Int))) {
  sum_invalid_ids(input, invalid_id_generator_pt_2)
}

pub fn parse(input: String) -> List(#(Int, Int)) {
  input
  |> string.trim
  |> string.split(on: ",")
  |> list.map(fn(s) {
    let assert [min, max] = string.split(s, on: "-")
    let assert Ok(min) = int.parse(min)
    let assert Ok(max) = int.parse(max)
    #(min, max)
  })
}

fn sum_invalid_ids(
  ranges: List(#(Int, Int)),
  invalid_ids_generator: fn(Int, Int, Int) -> List(Int),
) -> Int {
  ranges
  |> list.flat_map(fn(range) {
    get_invalid_ids(range.0, range.1, invalid_ids_generator)
  })
  |> list.unique
  |> int.sum
}

fn get_invalid_ids(
  from: Int,
  to: Int,
  invalid_ids_generator: fn(Int, Int, Int) -> List(Int),
) -> List(Int) {
  list.range(int_util.digits(from), int_util.digits(to))
  |> list.filter(keeping: fn(size) { size >= 2 })
  |> list.flat_map(invalid_ids_generator(_, from, to))
  |> list.filter(fn(x) { from <= x && x <= to })
}

fn invalid_id_generator_pt_1(length: Int, from: Int, to: Int) -> List(Int) {
  case int.is_even(length) {
    False -> []
    True ->
      list.range(from / int_util.int_power(10, length / 2), {
        to / int_util.int_power(10, length / 2)
      })
      |> list.map(int_util.repeat(_, 2))
  }
}

fn invalid_id_generator_pt_2(length: Int, from: Int, to: Int) -> List(Int) {
  list.range(1, length / 2)
  |> list.filter(fn(x) { length % x == 0 })
  |> list.flat_map(fn(x) {
    list.range(
      from / int_util.int_power(10, length - x),
      { to / int_util.int_power(10, length - x) } + 1,
    )
    |> list.map(int_util.repeat(_, length / x))
  })
}
