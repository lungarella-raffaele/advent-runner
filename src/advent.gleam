import advent/internal
import argv
import clip
import clip/help
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option}
import gleam/result
import snag

pub opaque type Year {
  Year(number: Int, days: dict.Dict(Int, Day))
}

pub type Day {
  Day(
    /// The number of the day.
    number: Int,
    /// A function that takes raw input, parses it, and solves part a.
    part_a: fn(String) -> Int,
    /// The solution for part a. If `Some`, the output of `part_a` is compared
    /// with this one to make sure it's producing the expected outcome.
    expected_a: Option(Int),
    /// A function that takes raw input, parses it, and solves part b.
    part_b: fn(String) -> Int,
    /// The solution for part b. If `Some`, the output of `part_b` is compared
    /// with this one to make sure it's producing the expected outcome.
    expected_b: Option(Int),
  )
}

/// Helper to create a Day with a shared parse function.
/// The parse function output is passed to both part_a and part_b.
pub fn day(
  day day_num: Int,
  parse parse: fn(String) -> a,
  part_a solve_a: fn(a) -> Int,
  expected_a expected_a: Option(Int),
  part_b solve_b: fn(a) -> Int,
  expected_b expected_b: Option(Int),
) -> Day {
  Day(
    number: day_num,
    part_a: fn(raw) { solve_a(parse(raw)) },
    part_b: fn(raw) { solve_b(parse(raw)) },
    expected_a: expected_a,
    expected_b: expected_b,
  )
}

/// Creates a new Year with no days.
pub fn year(year_number: Int) -> Year {
  Year(number: year_number, days: dict.new())
}

/// Adds a day to the year.
pub fn add_day(year: Year, day: Day) -> Year {
  let days = dict.insert(year.days, day.number, day)
  Year(..year, days:)
}

/// Gets the days dictionary from a Year.
pub fn get_days(year: Year) -> dict.Dict(Int, Day) {
  year.days
}

/// A function that provides command-line arguments.
pub type ArgvProvider =
  fn() -> List(String)

/// A function that handles output (e.g., printing to stdout).
pub type OutputHandler =
  fn(String) -> Nil

/// Configuration for dependency injection.
pub type Config {
  Config(argv_provider: ArgvProvider, output_handler: OutputHandler)
}

/// Runs the advent runner using the real command-line arguments and stdout.
pub fn run(year: Year) {
  run_with_config(year, default_config())
}

/// Runs the advent runner with a full custom config.
/// This allows injecting both arguments and output handler for testing.
pub fn run_with_config(year: Year, config: Config) {
  let parser = build_parser()

  case clip.run(parser, config.argv_provider()) {
    Ok(Run) -> execute(year, config.output_handler)
    Error(e) -> config.output_handler(e)
  }
}

/// Creates prod config using real argv and stdout.
pub fn default_config() -> Config {
  Config(
    argv_provider: default_argv_provider,
    output_handler: default_output_handler,
  )
}

/// Prints to stdout.
pub fn default_output_handler(msg: String) -> Nil {
  io.println(msg)
}

/// The default argument provider that reads from the actual command line.
pub fn default_argv_provider() -> List(String) {
  argv.load().arguments
}

/// Command type for CLI parsing
type Command {
  Run
}

/// Build the CLI parser
fn build_parser() -> clip.Command(Command) {
  clip.return(Run)
  |> clip.help(help.simple("advent", "Advent of Code runner"))
}

fn execute(year: Year, output: OutputHandler) -> Nil {
  case execute_all(year, output) {
    Ok(Nil) -> Nil
    Error(err) -> output(snag.pretty_print(err))
  }
}

fn execute_all(year: Year, output: OutputHandler) -> snag.Result(Nil) {
  get_days(year)
  |> dict.to_list
  |> list.try_each(fn(day) {
    let #(day_number, day_fn) = day
    use raw <- result.try(internal.get_raw_input(year.number, day_number))

    output(int.to_string(day_number))
    // TODO run them in parallel
    output(int.to_string(day_fn.part_a(raw)))
    output(int.to_string(day_fn.part_b(raw)))

    Ok(Nil)
  })
}
