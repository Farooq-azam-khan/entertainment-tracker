use crate::models::*;
use crate::schema::*;
use diesel::prelude::*;
use rocket_contrib::json::{Json, JsonError};

#[get("/reading_history")]
pub fn list() -> Json<Vec<ReadingHistory>> {
    let hist: Vec<ReadingHistory> = reading_history::table
        .select(reading_history::all_columns)
        .load::<ReadingHistory>(&crate::establish_connection())
        .expect("Could not load the history");
    Json(hist)
}

#[post(
    "/reading_history",
    format = "json",
    data = "<new_reading_history_result>"
)]
pub fn create_reading_history(
    new_reading_history_result: Result<Json<NewReadingHistory>, JsonError>,
) -> Json<String> {
    match new_reading_history_result {
        Ok(new_reading_history) => {
            let insert = diesel::insert_into(reading_history::table)
                .values(new_reading_history.into_inner())
                .execute(&crate::establish_connection());
            match insert {
                Ok(_) => Json(format!("added history")),
                Err(err) => Json(format!("{:?}", err)),
            }
        }
        Err(err) => match err {
            JsonError::Io(ioerr) => Json(format!("io error: {:?}", ioerr)),
            JsonError::Parse(_, se) => Json(format!("parse error: {:?}", se)),
        },
    }
}
