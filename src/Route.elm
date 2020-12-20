module Route exposing (Route(..), parseUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = NotFound
    | Login String
    | LoginPage
    | HomePage


parseUrl : Url -> Route
parseUrl url =
    case Parser.parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


urlHead : String
urlHead =
    "Main.elm"


matchRoute : Parser (Route -> a) a
matchRoute =
    Parser.oneOf
        [ Parser.map HomePage (Parser.s urlHead)
        , Parser.map Login (Parser.s urlHead </> Parser.s "login" </> Parser.string)
        , Parser.map LoginPage (Parser.s urlHead </> Parser.s "login")
        ]
