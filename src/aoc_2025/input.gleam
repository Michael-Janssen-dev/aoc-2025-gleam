import argv
import dotenv_gleam
import envoy
import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/result
import gleam/string
import glint
import simplifile

const base_url = "https://adventofcode.com/2025/day/"

fn fetch_input_http(
  day: Int,
  session_cookie: String,
) -> Result(String, httpc.HttpError) {
  let url =
    string.append(base_url, int.to_string(day)) |> string.append("/input")
  let assert Ok(base_req) = request.to(url)
  let req = request.set_cookie(base_req, "session", session_cookie)
  use resp <- result.try(httpc.send(req))
  Ok(resp.body)
}

fn save_input(body: String, day: Int) {
  let path =
    string.append(
      "inp/day",
      string.pad_start(int.to_string(day), to: 2, with: "0"),
    )
    |> string.append(".txt")
  let assert Ok(_) = simplifile.create_file(path)
  let assert Ok(_) = body |> simplifile.write(to: path)
  Nil
}

fn fetch_input() -> glint.Command(Nil) {
  let day_flag =
    glint.int_flag("day")
    |> glint.flag_help("Select the day for which to download the input")

  use day <- glint.flag(day_flag)
  use _, _, flags <- glint.command()

  let assert Ok(day) = day(flags)
  let assert Ok(cookie) = envoy.get("FETCH_COOKIE")
  let assert Ok(body) = fetch_input_http(day, cookie)
  save_input(body, day)
}

pub fn main() {
  let assert Ok(Nil) = dotenv_gleam.config()
  glint.new()
  |> glint.with_name("hello")
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: [], do: fetch_input())
  |> glint.run(argv.load().arguments)
}
