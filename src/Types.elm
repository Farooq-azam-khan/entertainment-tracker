module Types exposing (..)


type alias Author =
    { firstname : String, lastname : String }


createAuthor : String -> String -> Author
createAuthor fn ln =
    { firstname = fn, lastname = ln }


type Entertainment
    = Book String Author
    | Movie String
    | Play String Author
    | TV String
