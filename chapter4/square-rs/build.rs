fn main() {
    cc::Build::new().file("../square_c.s").compile("square_lib");
}
