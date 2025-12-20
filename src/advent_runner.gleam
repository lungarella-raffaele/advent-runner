import argv
import gleam/dict
import gleam/option.{type Option}
import glint

pub fn main() {
  glint.new()
  |> glint.with_name("runner")
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: [], do: runner())
  |> glint.run(argv.load().arguments)
}

pub type Strategy {
  All
  Specific(day: Int, year: Int)
}

pub fn runner() -> glint.Command(Nil) {
  use all <- glint.flag(all_flag())
  use day <- glint.flag(day_arg())
  use year <- glint.flag(year_arg())
  use _, _, flags <- glint.command()

  let assert Ok(all) = all(flags)
  let assert Ok(day) = day(flags)
  let assert Ok(year) = year(flags)

  let strategy = case all, day, year {
    True, _, _ -> All
    False, n, m -> Specific(day: n, year: m)
  }

  case strategy {
    Specific(d, y) -> run_day(day: d, year: y)
    All -> run_all()
  }
}

pub type Day {
  Day(
    /// The number of the day.
    day: Int,
    /// A function taking the problem input and parsing it.
    parse: fn(String) -> String,
    /// A function to solve part a.
    part_a: fn(String) -> Int,
    /// The solution for part a. If `Some`, the output of `part_a` is compared
    /// with this one to make sure it's producing the expected outcome.
    expected_a: Option(Int),
    /// Values that are known to be wrong for part a.
    wrong_answers_a: List(Int),
    /// A function to solve part b.
    part_b: fn(String) -> Int,
    /// The solution for part b. If `Some`, the output of `part_b` is compared
    /// with this one to make sure it's producing the expected outcome.
    expected_b: Option(Int),
    /// Values that are known to be wrong for part b.
    wrong_answers_b: List(Int),
  )
}

pub opaque type Year {
  Year(year: Int, days: dict.Dict(Int, Day))
}

pub fn year(year: Int) -> Year {
  Year(year:, days: dict.new())
}

pub fn add_day(year: Year, day: Day) -> Year {
  let days = dict.insert(year.days, day.day, day)
  Year(..year, days:)
}

fn run_all(year: Year) -> Nil {
  year.days
  |> dict.each(fn(k, v) {
    let input = v.parse()
  })
  todo
}

fn get_input(year year: Int, day day: Int) {
  todo
}

fn run_day(day day: Int, year year: Int) -> Nil {
  todo
}

fn all_flag() -> glint.Flag(Bool) {
  glint.bool_flag("all")
  |> glint.flag_default(False)
  |> glint.flag_help("Run all the years you have registered")
}

/// Runs the specific advent of code year. Defaults current year.
fn year_arg() -> glint.Flag(Int) {
  glint.int_flag("year")
  |> glint.flag_default(2025)
  // TODO implement get_year()
  |> glint.flag_help("Specified whicday_flagt to run")
}

/// Runs a specific day. Defaults to current day.
fn day_arg() -> glint.Flag(Int) {
  glint.int_flag("day")
  |> glint.flag_default(20)
  // TODO implement get_day()
  |> glint.flag_help("Specifies which day of the advent to run")
}
