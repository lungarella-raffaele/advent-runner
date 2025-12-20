# advent_runner

[![Open Source Saturday](https://img.shields.io/badge/%E2%9D%A4%EF%B8%8F-open%20source%20saturday-F64060.svg)](https://www.meetup.com/it-IT/Open-Source-Saturday-Milano/)

Runner for advent of code repositories

# TODO

- [ ] Define an interface for how one day must be structured;
- [ ] Define where to find inputs for a given day;
- [ ] The days must run in parallel;
- [ ] The output should be continuous and the days should be automatically sorted;
- [ ] The output should have:
  - [ ] year maybe in the table caption;
  - [ ] number of day;
  - [ ] time to parse the input;
  - [ ] time to complete part a;
  - [ ] time to complete part b;
- [ ] The program should run the current year (tell the user);
- [ ] The program should accept --all to run all years;
- [ ] The program should accept --year to run a specific year;
- [ ] The program should accept --day to run a specific day, can be combined with year. If no year it will use the current year;
- [ ] The program should work like vitest. Where there is a print/debug statement the program should print `stdout | year - day`
- [ ] The program should be able to print a md table of the output

  
day | t parse | t a | t b | expec | received

[![Package Version](https://img.shields.io/hexpm/v/advent_runner)](https://hex.pm/packages/advent_runner)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/advent_runner/)

```sh
gleam add advent_runner@1
```
```gleam
import advent_runner

pub fn main() -> Nil {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/advent_runner>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
