input DAY:
  gleam run -m aoc_2025/input -- --day={{DAY}}

run DAY:
  gleam run -m aoc_2025/day$(printf "%02d" {{DAY}})

generate DAY:
  gleam run -m aoc_2025/gen -- --day={{DAY}}

prepare DAY:
  generate DAY
  input DAY
