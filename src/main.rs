#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;

extern crate dotenv;

use dotenv::dotenv;
use std::env;

#[get("/my-secret")]
fn get_secret() -> String {
        String::from(env::var("MY_SECRET").unwrap().as_str())
}

#[get("/")]
fn index() -> &'static str {
        "Hello, World"
}

fn main() {
        dotenv().ok();
        rocket::ignite()
                .mount("/", routes![index, get_secret])
                .launch();
}
