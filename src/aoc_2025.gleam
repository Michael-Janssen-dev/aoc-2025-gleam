import dotenv_gleam
import gladvent

pub fn main() {
  let assert Ok(_) = dotenv_gleam.config()
  gladvent.run()
}
