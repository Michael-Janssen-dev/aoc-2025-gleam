import gleam/int
import util/int_util
import gleam/list
import gleam/string

pub fn pt_1(input: #(List(Int), List(Region))) {
  let #(presents, regions) = input
  regions
  |> list.count(fits(_, presents))
}

fn fits(region: Region, sizes: List(Int)) -> Bool {
  let Region(area:, presents:) = region
  int.sum(list.map2(sizes, presents, int.multiply)) <= area
}

pub fn pt_2(input: #(List(Int), List(Region))) {
  pt_1(input)
}

pub type Region {
  Region(area: Int, presents: List(Int))
}

pub fn parse(input: String) -> #(List(Int), List(Region)) {
  let assert [
    present_0,
    present_1,
    present_2,
    present_3,
    present_4,
    present_5,
    regions
  ] = input |> string.trim() |> string.split("\n\n")
  let presents = [present_0, present_1, present_2, present_3, present_4, present_5] |> list.map(string.to_graphemes) |> list.map(list.count(_, fn(x) {x == "#"}))
  let regions = regions |> string.split("\n") |> list.map(fn (x) {
    let assert Ok(#(area, presents)) = string.split_once(x, ": ")
    let assert [x, y] = string.split(area, "x")
    let area = int_util.must_parse(x) * int_util.must_parse(y)
    let presents = string.split(presents, " ") |> list.map(int_util.must_parse)
    Region(area:, presents:)
  })
  #(presents, regions)
}