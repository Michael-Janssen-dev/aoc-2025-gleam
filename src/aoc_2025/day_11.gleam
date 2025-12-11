import gleam/dict
import gleam/list
import gleam/string

pub fn pt_1(input: dict.Dict(String, List(String))) {
  let #(paths, _) = all_paths(input, "you", "out", dict.new())
  paths
}

fn all_paths(graph: dict.Dict(String, List(String)), from: String, to: String, cache: dict.Dict(#(String, String), Int)) {
  case dict.get(cache, #(from, to)) {
    Ok(c) -> #(c, cache)
    _ -> {
      let assert Ok(neighbours) = dict.get(graph, from)
      let direct = list.count(neighbours, fn (x) {x == to})
      let other_neighbours = list.filter(neighbours, fn (x) {x != to})
      let #(paths, cache) = other_neighbours
      |> list.fold(#(0, cache), fn(acc, x) {
         let #(paths, cache) = acc
         let #(new, cache) = all_paths(graph, x, to, cache)
         #(paths + new, cache)
      })
      #(paths + direct, dict.insert(cache, #(from ,to), paths + direct))
    }
  }
}

pub fn pt_2(input: dict.Dict(String, List(String))) {
  let #(paths_fft, cache) = all_paths(input, "svr", "fft", dict.new())
  let #(paths_dac, cache) = all_paths(input, "svr", "dac", cache)
  let #(paths_fft_dac, cache) = all_paths(input, "fft", "dac", cache)
  let #(paths_dac_fft, cache) = all_paths(input, "dac", "fft", cache)
  let #(paths_fft_dac_out, cache) = all_paths(input, "dac", "out", cache)
  let #(paths_dac_fft_out, _) = all_paths(input, "fft", "out", cache)
  {paths_fft * paths_fft_dac * paths_fft_dac_out} + {paths_dac * paths_dac_fft * paths_dac_fft_out}
}

pub fn parse(input: String) {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.fold(dict.new(), fn (acc, line) {
    let assert Ok(#(start, end)) = string.split_once(line, ": ")
    let end = string.split(end, " ")
    dict.insert(acc, start, end)
  })
  |> dict.insert("out", [])
}
