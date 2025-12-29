import filepath
import gleam/int
import gleam/result
import global_value
import simplifile
import snag

pub fn find_root() -> String {
  global_value.create_with_unique_name("project_root", fn() {
    find_root_loop("./")
  })
}

fn find_root_loop(path: String) -> String {
  case simplifile.is_file(filepath.join(path, "gleam.toml")) {
    Ok(True) -> path
    Ok(False) | Error(_) -> find_root_loop(filepath.join(path, "../"))
  }
}

fn build_path(year: Int, day: Int) -> String {
  let root = find_root()
  root
  |> filepath.join("inputs")
  |> filepath.join(int.to_string(year))
  |> filepath.join(int.to_string(day) <> ".txt")
}

/// Reads file if the file exists, returns a string or an error if the file does
/// not exist or the program does not have any permission to access the file
pub fn get_raw_input(year year: Int, day day: Int) -> snag.Result(String) {
  let file = build_path(year, day)

  simplifile.read(file)
  |> result.map_error(fn(err) {
    case err {
      simplifile.Enoent ->
        snag.new("File not found: " <> file)
        |> snag.layer(
          "Check that inputs/"
          <> int.to_string(year)
          <> "/"
          <> int.to_string(day)
          <> ".txt exists",
        )
      simplifile.Eacces ->
        snag.new("Permission denied: " <> file)
        |> snag.layer("Check file permissions")
      _ -> snag.new("Failed to read input file")
    }
  })
}
