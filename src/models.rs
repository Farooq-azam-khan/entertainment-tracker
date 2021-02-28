use serde::{Serialize}; 
use dotenv::dotenv; 

use postgres::{Client, NoTls};
use std::env; 

#[derive(Debug, Serialize)]
pub struct Book {
    pub id: i32, 
    pub name: String
}

pub struct Database {
   pub pg: Client
}

pub fn get_client() -> Client {
    dotenv().ok();
    let db_url = env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set"); 
    Client::connect(db_url.as_str(), NoTls,)
        .expect(&format!("Error connecting to database"))
}


