use crate::schema::*; 

use serde::Serialize; 


#[derive(Debug, Serialize, Queryable)]
pub struct Book {
    pub id: i32, 
    pub title: String
}

#[derive(Debug, Insertable)]
#[table_name="book"]
pub struct NewBook<'x> {
    pub title: &'x str
}


