import gleam/int
import util/int_util
import gleam/list
import gleam/string

pub fn pt_1(regions: List(Region)) {
  regions
  |> list.count(fits)
}

fn fits(region: Region) -> Bool {
  let Region(area:, presents:) = region
  int.sum(presents) * 9 <= area
}

pub fn pt_2(input: List(Region)) {
  pt_1(input)
}

pub type Region {
  Region(area: Int, presents: List(Int))
}

pub fn parse(input: String) -> List(Region) {
  let assert [
    _,
    _,
    _,
    _,
    _,
    _,
    regions
  ] = input |> string.trim() |> string.split("\n\n")
  regions |> string.split("\n") |> list.map(fn (x) {
    let assert Ok(#(area, presents)) = string.split_once(x, ": ")
    let assert [x, y] = string.split(area, "x")
    let area = int_util.must_parse(x) * int_util.must_parse(y)
    let presents = string.split(presents, " ") |> list.map(int_util.must_parse)
    Region(area:, presents:)
  })
}