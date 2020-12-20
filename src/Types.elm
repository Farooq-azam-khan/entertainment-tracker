module Types exposing (..)


type alias Author =
    { firstname : String, lastname : String }


createAuthor : String -> String -> Author
createAuthor fn ln =
    { firstname = fn, lastname = ln }


authorFullName : Author -> String
authorFullName author =
    author.firstname ++ " " ++ author.lastname


type Token
    = Token String


type Entertainment
    = Book String Author
    | Movie String
    | Play String Author
    | TV String


createBook : String -> Author -> Entertainment
createBook title author =
    Book title author
