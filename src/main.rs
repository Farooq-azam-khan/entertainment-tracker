#![feature(proc_macro_hygiene, decl_macro)]

#[cfg(test)] 
mod tests; 


extern crate dotenv; 

#[macro_use]
extern crate rocket;

use dotenv::dotenv; 
use std::env;

pub mod book;

pub mod models; 


/* pub fn establish_connection() -> PgConnection {
    dotenv().ok(); 

    let database_url = env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set");

    PgConnection::establish(&database_url)
        .expect(&format!("Error connecting to {}", database_url)) 
}*/

//use reqwest::header::USER_AGENT;
use rocket::response::content;
//use rocket::response::Redirect;
use rocket::State; 

use std::sync::atomic::{AtomicUsize, Ordering};

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


#[get("/count")]
fn count(hit_count: State<HitCount>) -> String {
    hit_count.0.load(Ordering::Relaxed).to_string()
}

fn main() {
    rocket::ignite()
                .mount("/", routes![
                    index, count, 
                    book::list, 
                    // book::new, book::insert, book::update, book::delete
                ])
                .manage(HitCount(AtomicUsize::new(0)))
                .launch();    
}

