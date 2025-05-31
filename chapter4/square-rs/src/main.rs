unsafe extern "C" {
    fn square(a: u64) -> u64;
}

fn main() {
    println!("Hello, world! {}", unsafe { square(5) });
}
