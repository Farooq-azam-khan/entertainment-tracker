#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;
use postgres::{Client, Error, NoTls};
use reqwest::header::USER_AGENT;
use rocket::response::content;
use rocket::response::Redirect;
use serde::{Deserialize, Serialize};

extern crate dotenv;

use dotenv::dotenv;
use std::env;

use std::collections::HashMap;

#[get("/my-secret")]
fn get_secret() -> String {
        String::from(env::var("MY_SECRET").unwrap().as_str())
}

#[derive(Deserialize, Serialize, Debug)]
struct User {
        name: String,
        email: Option<String>,
}
#[get("/")]
fn index() -> &'static str {
        "Hello, World"
}

fn get_client() -> Result<Client, Error> {
        Ok(Client::connect(
                env::var("DATABASE_URL").unwrap().as_str(),
                NoTls,
        )?)
}
fn connect_to_database() -> Result<(), Error> {
        let result_client = get_client();
        match result_client {
                Ok(mut client) => client.batch_execute(
                        "
                        CREATE TABLE user IF NOT EXISTS (
                                id SERIAL PRIMARY KEY, 
                                name VARCHAR(200), 
                                email VARCHAR(400), 
                                access_token VARCHAR(500)
                        )
                ",
                )?,
                Err(_) => println!("was not able to connect to client"),
        };
        Ok(())
}

// TODO: use std::sync::atomic::AtomicUsize; 
struct HitCount {
    count: usize 
}
#[get("/count")]
fn count(hit_count: State<HitCount>) -> String {
    format!("Number of visits: {}", hit_count.count)
}

fn main() {
        dotenv().ok();

        connect_to_database();
        rocket::ignite()
                .manage(HitCount {count: 0})
                .mount(
                        "/",
                        routes![
                                index,
                        ]
                      )
                .launch();
}
