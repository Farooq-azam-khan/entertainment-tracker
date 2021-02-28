module Types exposing (..)

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

type UniqueIdentifier = Int | String 
type ISBN = ISBN String 
type Language = Language String 
type BookType = Novel | NonFiction | Fiction
type Genre = Genre String 
type alias Book = {
        id : Maybe UniqueIdentifier
        , title : String
        , subtitle : Maybe String
        , description : Maybe String
        , authors : List Author 
        , publisher : Publisher
        , isbn : Maybe ISBN
        , language : Language 
        , publishedDate : String 
        , bookType : BookType
        , genre : Genre 
    }
    
type Publisher = Publisher String 

type alias Author = { 
        firstname : String
      , lastname : String}
      
createAuthor : String -> String -> Author
createAuthor fn ln =
    { firstname = fn, lastname = ln }

authorFullName : Author -> String
authorFullName author =
    author.firstname ++ " " ++ author.lastname


aBook : Book 
aBook = { id = Nothing
        , title = "Book 1"
        , subtitle = Nothing 
        , description = Nothing
        , authors = [Author "author 1" "author ln"]
        , publisher = Publisher ""
        , language = Language "en"
        , publishedDate = ""
        , isbn = Nothing
        , bookType = Novel 
        , genre = Genre "Fantasy"
        }
