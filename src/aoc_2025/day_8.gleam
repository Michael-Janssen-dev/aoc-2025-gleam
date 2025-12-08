import gleam/int
import gleam/list
import gleam/set
import gleam/string
import util/int_util

pub fn pt_1(input: List(Vec3d)) {
  input
  |> list.combination_pairs()
  |> list.sort(by: fn(a, b) { int.compare(dist(a.0, a.1), dist(b.0, b.1)) })
  |> list.take(1000)
  |> list.fold(list.map(input, set.insert(set.new(), _)), fn(circuits, pair) {
    merge_circuits(circuits, pair)
  })
  |> list.sort(fn(a, b) { int.compare(set.size(b), set.size(a)) })
  |> list.take(3)
  |> list.fold(1, fn(acc, x) { acc * set.size(x) })
}

fn merge_circuits(circuits: List(set.Set(Vec3d)), pair: #(Vec3d, Vec3d)) {
  case
    list.partition(circuits, fn(c) {
      set.contains(c, pair.0) || set.contains(c, pair.1)
    })
  {
    #([c], circuits) -> [c, ..circuits]
    #([c, d], circuits) -> [set.union(c, d), ..circuits]
    _ -> panic as "Expected to find one or two circuits"
  }
}

pub fn pt_2(input: List(Vec3d)) {
  let res =
    input
    |> list.combination_pairs()
    |> list.sort(by: fn(a, b) { int.compare(dist(a.0, a.1), dist(b.0, b.1)) })
    |> list.fold_until(
      #(
        list.map(input, set.insert(set.new(), _)),
        Vec3d(0, 0, 0),
        Vec3d(0, 0, 0),
      ),
      fn(acc, pair) {
        let #(circuits, _, _) = acc
        let new_circuits = merge_circuits(circuits, pair)
        case list.length(new_circuits) {
          1 -> list.Stop(#(new_circuits, pair.0, pair.1))
          _ -> list.Continue(#(new_circuits, pair.0, pair.1))
        }
      },
    )
  { res.1 }.x * { res.2 }.x
}

pub type Vec3d {
  Vec3d(x: Int, y: Int, z: Int)
}

fn from_list(list: List(Int)) -> Vec3d {
  let assert [x, y, z] = list
  Vec3d(x, y, z)
}

fn dist(a: Vec3d, b: Vec3d) {
  let dx = int.absolute_value(a.x - b.x)
  let dy = int.absolute_value(a.y - b.y)
  let dz = int.absolute_value(a.z - b.z)
  dx * dx + dy * dy + dz * dz
}

pub fn parse(input: String) -> List(Vec3d) {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(string.split(_, ","))
  |> list.map(list.map(_, int_util.must_parse))
  |> list.map(from_list)
}
