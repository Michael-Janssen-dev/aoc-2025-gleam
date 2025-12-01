import gleam/result
import gleam/string
import simplifile

pub fn read_file(path: String) {
  simplifile.read(path)
  |> result.unwrap("")
  |> string.replace(each: "\r\n", with: "\n")
}
