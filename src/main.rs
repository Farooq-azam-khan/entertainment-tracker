#![feature(proc_macro_hygiene, decl_macro)]

extern crate chrono;
extern crate dotenv;
#[macro_use]
extern crate rocket;

#[macro_use]
extern crate diesel;

pub mod author;
pub mod book;
pub mod models;
pub mod reading_history;
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
                reading_history::list,
                reading_history::create_reading_history
            ],
        )
        .mount("/", routes![index])
        .launch();
}
