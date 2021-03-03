module Types exposing (Book, Token(..))


type Token
    = Token String


type alias Book =
    { id : Int, title : String, author : Int, total_pages : Int, total_chapters : Int }
