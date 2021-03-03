#![feature(proc_macro_hygiene, decl_macro)]

#[cfg(test)]
mod tests;

extern crate dotenv;

#[macro_use]
extern crate rocket;

#[macro_use]
extern crate diesel;

pub mod author;
pub mod book;
pub mod models;
pub mod schema;

use diesel::pg::PgConnection;
use diesel::Connection;
use dotenv::dotenv;
use rocket_contrib::json::Json;
use std::env;

pub fn establish_connection() -> PgConnection {
    dotenv().ok();

    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");

    PgConnection::establish(&database_url).expect(&format!("Error connecting to {}", database_url))
}

#[get("/")]
fn index() -> Json<String> {
    Json(format!("hi"))
}

fn main() {
    rocket::ignite()
        .mount(
            "/api",
            routes![
                book::list,
                book::create_book,
                author::list_authors,
                author::create_author,
            ],
        )
        .mount("/", routes![index])
        .launch();
}
