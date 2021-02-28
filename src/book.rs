use crate::models::*;
use rocket::response::content; 
use rocket::State; 

#[get("/books")]
pub fn list() -> String {
    let mut db = get_client(); 
    let books = db.query("SELECT id, name FROM book", &[])
        .expect("idk what happened");

    for row in books {
        let id: i32 = row.get(0); 
        let name: &str = row.get(1); 
        println!("books: {}, {}", id, name); 
    }
        
    format!("need to return json") 
}
