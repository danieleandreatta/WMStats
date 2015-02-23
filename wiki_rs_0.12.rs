use std::time;
use std::io::stdio;

#[deriving(Show, PartialEq, Eq)]
struct WikiLine {
    page: String,
    hits: isize,
}

impl PartialOrd for WikiLine {
    fn partial_cmp(&self, other: &WikiLine) -> Option<Ordering> {
        let x = self.hits;
        other.hits.partial_cmp(&x)
    }
}

impl Ord for WikiLine {
    fn cmp(&self, other: &WikiLine) -> Ordering {
        let x = self.hits;
        other.hits.cmp(&x)
    }
}

fn analyze_line(line: String) -> Option<WikiLine> {
    let words: Vec<&str> = line.split(' ').collect();
    match words[0] {
        "en" => match from_str(words[2]) {
            Some(n) if n>500 => Some(WikiLine{page: words[1].to_string(), hits: n}),
            _ => None,
        },
        _ => None,
    }
}

fn main() {
    let mut hh: Vec<WikiLine> = Vec::new();

    let t0 = now_utc().to_timespec();

    for line in stdio::stdin().lines().map(|x|{x.ok()}) {
        match line {
            Some(l) => match analyze_line(l) {
                Some(w) => hh.push(w),
                None => {}
            },
            None => {},
        }
    }
    let tt = hh.deref_mut();
    tt.sort();

    let t1 = now_utc().to_timespec();

    let dd = 0.001 * (((t1.sec - t0.sec)*1000i64 + (((t1.nsec - t0.nsec)/1000000) as i64)) as f64);

    println!("Query took {} seconds", dd);

    for x in tt.iter().take(10) {
        println!("{} ({})", x.page, x.hits);
    }
}
