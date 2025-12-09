import gleam/result
import gleam/int
import gleam/list
import gleam/string

pub fn pt_1(input: List(#(Int, Int))) {
  input
    |> list.combination_pairs
    |> list.map(rectangle)
    |> list.max(int.compare)
    |> result.unwrap(or: 0)
}

fn rectangle(inp: #(#(Int, Int),#(Int, Int))) {
  let #(a, b) = inp
  {int.absolute_value(a.0 - b.0) + 1} * {int.absolute_value(a.1 - b.1) + 1}
}

pub fn pt_2(input: List(#(Int, Int))) {
  let vertical_lines = input
  |> list.sized_chunk(2)
  |> list.map(list.sort(_, fn(a, b) {
    int.compare(a.1, b.1)
  }))
  
  let upper_gap = #(94927, 50365)
  let lower_gap = #(94927, 48406)
  let lowest = input
  |> list.filter(fn (x) {x.1 < lower_gap.1})
  |> biggest_rectangle(vertical_lines, lower_gap)
  
  let highest = input
  |> list.filter(fn(x) {x.1 > upper_gap.1})
  |> biggest_rectangle(vertical_lines, upper_gap)
  
  echo lowest
  echo highest
  int.max(lowest, highest)
}

fn biggest_rectangle(points: List(#(Int, Int)), vertical_lines: List(List(#(Int, Int))), start_point: #(Int, Int)) {
  points
  |> list.map(fn (x) {#(x, rectangle(#(x, start_point)))})
  |> list.sort(fn (a, b) {int.compare(b.1, a.1)})
  |> list.map(fn (x) {x.0})
  |> list.fold_until(0, fn(_, x) {
    let is_in = list.range(x.1, start_point.1)
    |> list.all(fn (y) {
      let c = #(x.0, y)
      let d = #(start_point.0, y)
      let c_count = list.count(vertical_lines, fn(line) {
        let assert [a, b] = line
         c.0 >= a.0 && c.1 >= a.1 && c.1 < b.1
      })
      let d_count = list.count(vertical_lines, fn(line) {
        let assert [a, b] = line
        d.0 >= a.0 && d.1 >= a.1 && d.1 < b.1
      })
      {c_count % 2 == 1 || list.contains(points, c)} && {d_count % 2 == 1 || list.contains(points, d)}
    })
    case is_in {
      True -> list.Stop(rectangle(#(x, start_point)))
      False -> list.Continue(0)
    }
  })
}

pub fn parse(input: String) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(string.split_once(_, ","))
  |> list.map(fn(x) {
    let assert Ok(#(a, b)) = x
    let assert Ok(a) = int.parse(a)
    let assert Ok(b) = int.parse(b)
    #(a, b)
  })
}
