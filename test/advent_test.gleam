import advent.{type Config, Config}
import gleam/option.{None, Some}
import gleam/string
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

/// Opaque reference to an ETS table for collecting output.
type OutputCollector

/// Creates an ETS table to collect output strings.
@external(erlang, "advent_test_ffi", "new_collector")
fn new_collector() -> OutputCollector

/// Appends a string to the collector.
@external(erlang, "advent_test_ffi", "append")
fn append(collector: OutputCollector, value: String) -> Nil

/// Gets all collected strings in order.
@external(erlang, "advent_test_ffi", "get_all")
fn get_all(collector: OutputCollector) -> List(String)

/// Creates a test config with custom args and an output collector.
/// Returns the config and a function to retrieve collected output.
fn test_config(args: List(String)) -> #(Config, fn() -> List(String)) {
  let collector = new_collector()

  let config =
    Config(argv_provider: fn() { args }, output_handler: fn(msg) {
      append(collector, msg)
    })

  #(config, fn() { get_all(collector) })
}

pub fn run_test() {
  let #(config, _get_output) = test_config([])
  advent.year(2025)
  |> advent.add_day(day())
  |> advent.run_with_config(config)
}

pub fn show_help_message_test() {
  let #(config, get_output) = test_config(["--help"])
  advent.year(2025) |> advent.add_day(day()) |> advent.run_with_config(config)

  let output = get_output() |> string.join("\n")
  // Should contain the help text from clip
  assert string.contains(output, "advent") == True
  assert string.contains(output, "Advent of Code runner") == True
}

pub fn should_capture_error_output_test() {
  // Use day 99 which has no input file - this should produce an error message
  let #(config, get_output) = test_config([])
  advent.year(2025)
  |> advent.add_day(day_without_input())
  |> advent.run_with_config(config)

  let output = get_output() |> string.join("\n")
  // Should capture the "file not found" error from our output handler
  assert string.contains(output, "File not found") == True
}

fn day_without_input() -> advent.Day {
  advent.day(
    day: 99,
    parse: fn(_) { Nil },
    part_a: fn(_) { 0 },
    expected_a: None,
    part_b: fn(_) { 0 },
    expected_b: None,
  )
}

pub fn day() -> advent.Day {
  advent.day(
    day: 22,
    parse:,
    part_a:,
    expected_a: Some(42),
    part_b:,
    expected_b: Some(24),
  )
}

pub fn parse(_: String) {
  "0100001"
}

pub fn part_a(_: String) {
  42
}

pub fn part_b(_: String) {
  42
}
