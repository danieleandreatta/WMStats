extern crate time;

use std::old_io::File;
use std::old_io::BufferedReader;
use std::cmp;
use std::num;
use std::os::args;

#[derive(Show, PartialEq, Eq)]
struct WikiLine {
    page: String,
    hits: isize,
}

impl PartialOrd for WikiLine {
    fn partial_cmp(&self, other: &WikiLine) -> Option<cmp::Ordering> {
        let x = self.hits;
        other.hits.partial_cmp(&x)
    }
}

impl Ord for WikiLine {
    fn cmp(&self, other: &WikiLine) -> cmp::Ordering {
        let x = self.hits;
        other.hits.cmp(&x)
    }
}

fn analyze_line(line: String) -> Option<WikiLine> {
    let words: Vec<&str> = line.split(' ').collect();
    match words[0] {
        "en" => match num::from_str_radix(words[2], 10) {
            Some(n) if n>500 => Some(WikiLine{page: words[1].to_string(), hits: n}),
            _ => None,
        },
        _ => None,
    }
}

fn main() {
    let mut hh: Vec<WikiLine> = Vec::new();

    let t0 = time::now_utc().to_timespec();

    let fname = Path::new(args()[1].clone());

    let mut fin = BufferedReader::new(File::open(&fname));

    for line in fin.lines().map(|x|{x.ok()}) {
        match line {
            Some(l) => match analyze_line(l) {
                Some(w) => hh.push(w),
                None => {}
            },
            None => {},
        }
    }
    let mut tt = hh.as_mut_slice();
    tt.sort();

    let t1 = time::now_utc().to_timespec();

    let dd = 0.001 * (((t1.sec - t0.sec)*1000i64 + (((t1.nsec - t0.nsec)/1000000) as i64)) as f64);

    println!("Query took {} seconds", dd);

    for x in tt.iter().take(10) {
        println!("{} ({})", x.page, x.hits);
    }
}
