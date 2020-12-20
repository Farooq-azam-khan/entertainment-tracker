module Route exposing (Route(..), parseUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), (<?>), Parser, s)
import Url.Parser.Query as Query


type Route
    = NotFound
    | Login (Maybe String)
    | HomePage


parseUrl : Url -> Route
parseUrl url =
    case Parser.parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    Parser.oneOf
        [ Parser.map HomePage (s "/home")
        , Parser.map Login (s "login" <?> Query.string "access_token")
        ]
