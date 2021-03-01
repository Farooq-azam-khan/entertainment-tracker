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

#[post("/books", format="json", data="<new_book>")]
pub fn create_book(new_book: Json<NewBook>) -> Json<String> {
    let insert = diesel::insert_into(book::table)
        .values(new_book.into_inner()).execute(&crate::establish_connection()); 
    match insert {
        Ok(val) => Json(format!("added book")),
        Err(_) => Json(format!("an error occured"))
    }
}
