use crate::models::*;
use crate::schema::*;
use diesel::prelude::*;
use rocket_contrib::json::{Json, JsonError};

#[get("/authors")]
pub fn list_authors() -> Json<Vec<Author>> {
    let authors: Vec<Author> = author::table
        .select(author::all_columns)
        .load::<Author>(&crate::establish_connection())
        .expect("Could not get all books");

    Json(authors)
}

#[post("/authors", format = "json", data = "<new_author_result>")]
pub fn create_author(new_author_result: Result<Json<NewAuthor>, JsonError>) -> Json<String> {
    match new_author_result {
        Ok(new_author) => {
            let insert = diesel::insert_into(author::table)
                .values(new_author.into_inner())
                .execute(&crate::establish_connection());
            match insert {
                Ok(val) => {
                    println!("{:?}", val);
                    Json(format!("added author"))
                }
                Err(err) => {
                    println!("{:?}", err);
                    Json(format!("an error occured"))
                }
            }
        }
        Err(err) => match err {
            JsonError::Io(err) => Json(format!("io error: {:?}", err)),
            JsonError::Parse(_, se) => Json(format!("parse error: {:?}", se)),
        },
    }
}
