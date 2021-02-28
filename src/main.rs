#![feature(proc_macro_hygiene, decl_macro)]

#[cfg(test)] 
mod tests; 

#[macro_use]
extern crate rocket;
//use postgres::{Client, Error, NoTls};
//use reqwest::header::USER_AGENT;
use rocket::response::content;
//use rocket::response::Redirect;
use rocket::State; 
//use serde::{Deserialize, Serialize};

//extern crate dotenv;
use std::sync::atomic::{AtomicUsize, Ordering};
//use dotenv::dotenv;
//use std::env;

//use std::collections::HashMap;

struct HitCount(AtomicUsize); 
/* #[get("/my-secret")]
fn get_secret() -> String {
        String::from(env::var("MY_SECRET").unwrap().as_str())
}*/

/*#[derive(Deserialize, Serialize, Debug)]
struct User {
        name: String,
        email: Option<String>,
}*/
#[get("/")]
fn index(hit_count: State<'_, HitCount>) -> content::Html<String> {
    hit_count.0.fetch_add(1, Ordering::Relaxed); 
    let msg = "Your visit has been recorded!"; 
    let count = format!("Visit: {}", count(hit_count)); 
    content::Html(format!("{}<br/>{}", msg, count))
}

/*fn get_client() -> Result<Client, Error> {
        Ok(Client::connect(
                env::var("DATABASE_URL").unwrap().as_str(),
                NoTls,
        )?)
}*/
/*
 * fn connect_to_database() -> Result<(), Error> {
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
}*/


#[get("/count")]
fn count(hit_count: State<HitCount>) -> String {
    hit_count.0.load(Ordering::Relaxed).to_string()
}

fn main() {
    rocket::ignite()
       .mount("/", routes![index, count])
        .manage(HitCount(AtomicUsize::new(0)))
        .launch();
}
