use crate::schema::*;
use chrono::NaiveDateTime;
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
    pub total_pages: i32,
    pub total_chapters: i32,
}

#[derive(
    Identifiable, Associations, Queryable, Serialize, Deserialize, Debug, Clone, PartialEq,
)]
#[table_name = "reading_history"]
pub struct ReadingHistory {
    pub id: i32,
    pub book_id: Option<i32>,
    pub end_page: i32,
    #[serde(with = "my_date_format")]
    pub created_at: NaiveDateTime,
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

#[derive(Debug, Deserialize, Insertable)]
#[table_name = "reading_history"]
pub struct NewReadingHistory {
    pub book_id: Option<i32>,
    pub end_page: i32,
}

// https://serde.rs/custom-date-format.html
mod my_date_format {
    use chrono::NaiveDateTime;
    use serde::{self, Deserialize, Deserializer, Serializer};

    const FORMAT: &'static str = "%Y-%m-%d %H:%M:%S";

    pub fn serialize<S>(datetime: &NaiveDateTime, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        let s = format!("{}", datetime.format(FORMAT));
        serializer.serialize_str(&s)
    }

    pub fn deserialize<'de, D>(deserializer: D) -> Result<NaiveDateTime, D::Error>
    where
        D: Deserializer<'de>,
    {
        let s = String::deserialize(deserializer)?;
        NaiveDateTime::parse_from_str(&s, FORMAT).map_err(serde::de::Error::custom)
    }
}
