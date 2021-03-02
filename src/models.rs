use crate::schema::*;
use serde::{Deserialize, Serialize};
#[derive(Debug, Serialize, Deserialize, Clone, Queryable)]
pub struct Author {
    pub id: i32,
    pub name: String,
}

#[derive(
    Identifiable, Associations, Queryable, Serialize, Deserialize, Debug, Clone, PartialEq,
)]
#[table_name = "book"]
#[belongs_to(Author)]
pub struct Book {
    pub id: i32,
    pub title: String,
    pub author_id: Option<i32>,
}

#[derive(Debug, Deserialize, Insertable)]
#[table_name = "book"]
pub struct NewBook {
    pub title: String,
    pub author_id: i32,
}

#[derive(Debug, Deserialize, Insertable)]
#[table_name = "author"]
pub struct NewAuthor {
    pub name: String,
}
