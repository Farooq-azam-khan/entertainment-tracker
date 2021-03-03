table! {
    author (id) {
        id -> Int4,
        name -> Varchar,
    }
}

table! {
    book (id) {
        id -> Int4,
        title -> Varchar,
        author_id -> Nullable<Int4>,
        total_pages -> Int4,
        total_chapters -> Int4,
    }
}

table! {
    reading_history (id) {
        id -> Int4,
        book_id -> Nullable<Int4>,
        end_page -> Int4,
        created_at -> Timestamp,
    }
}

joinable!(book -> author (author_id));
joinable!(reading_history -> book (book_id));

allow_tables_to_appear_in_same_query!(
    author,
    book,
    reading_history,
);
