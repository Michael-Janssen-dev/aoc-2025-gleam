import argv
import dotenv_gleam
import gleam/int
import gleam/result
import gleam/string
import glint
import simplifile

fn template_day(template_file: String, day: String) -> String {
  simplifile.read(template_file)
  |> result.unwrap("")
  |> string.replace(each: "{{DAY}}", with: day)
}

fn generate_day_file(day: String) {
  let template_path = "template/day.txt"
  let path = string.append("src/aoc_2025/day", day) |> string.append(".gleam")
  let assert Ok(_) = simplifile.create_file(path)
  template_day(template_path, day)
  |> simplifile.write(to: path)
}

fn generate_test_file(day: String) {
  let template_path = "template/test.txt"
  let path = string.append("test/day", day) |> string.append(".gleam")
  let assert Ok(_) = simplifile.create_file(path)
  template_day(template_path, day)
  |> simplifile.write(to: path)
}

fn generate_day() -> glint.Command(Nil) {
  let day_flag =
    glint.int_flag("day")
    |> glint.flag_help("Select the day for which to download the input")

  use day <- glint.flag(day_flag)
  use _, _, flags <- glint.command()
  let assert Ok(day) = day(flags)

  let left_padded_day = string.pad_start(int.to_string(day), to: 2, with: "0")

  let assert Ok(_) = generate_day_file(left_padded_day)
  let assert Ok(_) = generate_test_file(left_padded_day)
  Nil
}

pub fn main() {
  let assert Ok(Nil) = dotenv_gleam.config()
  glint.new()
  |> glint.with_name("hello")
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: [], do: generate_day())
  |> glint.run(argv.load().arguments)
}
