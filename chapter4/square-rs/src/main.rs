use std::u64;

unsafe extern "C" {
    fn square(a: u64) -> u64;
}

fn main() {
    for n in 0..1_000_000_000 {
        assert!(unsafe { square(n) } == u64::pow(n, 2));
    }
    println!("Paased!");
}
