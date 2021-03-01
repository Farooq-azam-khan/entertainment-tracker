use crate::models::*;
//use rocket::response::content; 
use crate::schema::*; 
use diesel::prelude::*; 
use rocket_contrib::json::Json; 

#[get("/books")]
pub fn list() -> Json<Vec<Book>> {
    let books: Vec<Book> = book::table
        .select(book::all_columns)
        .load::<Book>(&crate::establish_connection())
        .expect("Could not get all books");
    Json(books) 
}
