use crate::models::*;
//use rocket::response::content;
use crate::schema::*;
use diesel::prelude::*;
use rocket_contrib::json::{Json, JsonError};

#[get("/books")]
pub fn list() -> Json<Vec<Book>> {
    let books: Vec<Book> = book::table
        .select(book::all_columns)
        .load::<Book>(&crate::establish_connection())
        .expect("Could not get all books");
    Json(books)
}

#[post("/books", format = "json", data = "<new_book>")]
pub fn create_book(new_book: Result<Json<NewBook>, JsonError>) -> Json<String> {
    match new_book {
        Ok(bk_val) => {
            let insert = diesel::insert_into(book::table)
                .values(bk_val.into_inner())
                .execute(&crate::establish_connection());
            match insert {
                Ok(_val) => Json(format!("added book")),
                Err(err) => Json(format!("{:?}", err)),
            }
        }
        Err(err) => match err {
            JsonError::Io(ioerr) => Json(format!("io error: {:?}", ioerr)),
            JsonError::Parse(_, serde_err) => Json(format!("parsing error: {:?}", serde_err)),
        },
    }
}
