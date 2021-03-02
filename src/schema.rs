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
    }
}

joinable!(book -> author (author_id));

allow_tables_to_appear_in_same_query!(
    author,
    book,
);
