use crate::schema::*; 

use serde::{Serialize, Deserialize};


#[derive(Debug, Serialize, Queryable)]
pub struct Book {
    pub id: i32, 
    pub title: String
}

#[derive(Debug, Deserialize, Insertable)]
#[table_name="book"]
pub struct NewBook {
    pub title: String
}


