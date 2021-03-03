port module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation exposing (Key, load, pushUrl)
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as D exposing (Decoder, field, int, map5, string)
import Route exposing (Route)
import Types exposing (..)
import Url exposing (Url)



-- tailwindcss


css path =
    node "link" [ rel "stylesheet", href path ] []



-- flags


type alias Flags =
    { storedToken : Maybe String }



-- Main


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = onUrlChange
        }



-- url change


onUrlChange : Url -> Msg
onUrlChange url =
    let
        _ =
            Debug.log "changed url" url
    in
    UrlChanged url



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Types


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url
    | GetBooks (Result Http.Error (List Book))


type alias Model =
    { token : Maybe Token
    , key : Key
    , route : Route
    , books : List Book
    }


client_id : String
client_id =
    "165a569192ce7a520b0a"


githubOAuthLink : String
githubOAuthLink =
    "https://github.com/login/oauth/authorize?client_id=" ++ client_id



-- init


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        -- page =
        --     Route.parseUrl url
        -- token =
        --     case page of
        --         Route.Login (Just githubToken) ->
        --             Just (Token githubToken)
        --         _ ->
        --             case flags.storedToken of
        --                 Just githubToken ->
        --                     Just (Token githubToken)
        --                 Nothing ->
        --                     Nothing
        model =
            { route = Route.parseUrl url
            , token = Nothing -- token
            , key = key
            , books = []
            }

        -- commands =
        --     case token of
        --         Just (Token tok) ->
        --             sendTokenToStorage tok
        --         Nothing ->
        --             Cmd.none
    in
    ( model
    , Cmd.batch [ getBooksCommand ]
    )


bookDecoder : Decoder Book
bookDecoder =
    map5 Book (field "id" int) (field "title" string) (field "author_id" int) (field "total_pages" int) (field "total_chapters" int)


getBooksCommand : Cmd Msg
getBooksCommand =
    Http.get
        { url = "/api/api/books"
        , expect = Http.expectJson GetBooks (D.list bookDecoder)
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetBooks result ->
            let
                _ =
                    Debug.log "result" result
            in
            case result of
                Ok data ->
                    ( { model | books = data }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        LinkClicked url ->
            let
                _ =
                    Debug.log "linke clicked" url
            in
            case url of
                Browser.Internal internalUrl ->
                    ( model, pushUrl model.key (Url.toString internalUrl) )

                Browser.External href ->
                    ( model, load href )

        UrlChanged url ->
            let
                _ =
                    Debug.log "url changed" url

                newroute =
                    Route.parseUrl url

                _ =
                    Debug.log "parsed url" newroute

                token =
                    case newroute of
                        Route.Login (Just tok) ->
                            Just (Token tok)

                        _ ->
                            Nothing
            in
            ( { model | route = newroute, token = token }, Cmd.none )



-- view


view : Model -> Document Msg
view model =
    { title =
        case model.route of
            Route.HomePage ->
                "Home Page"

            Route.Login _ ->
                "Login Oauth"

            Route.BookPage ->
                "Book Page"

            Route.NotFound ->
                "Page not found"
    , body =
        [ div []
            [ css "http://localhost:8000/tailwind.css"
            , div [] (List.map showBook model.books)
            ]
        ]
    }


showBook : Book -> Html Msg
showBook book =
    h2 [] [ text book.title ]


showGithubButton : Model -> Html Msg
showGithubButton model =
    case model.token of
        Just tok ->
            div [] [ text "welcome you are logged in" ]

        Nothing ->
            div [ class "flex w-screen items-center h-screen justify-center" ]
                [ a
                    [ class "bg-red-900 text-white px-5 py-3 rounded-full text-lg shadow-xl"
                    , href githubOAuthLink
                    ]
                    [ text "Login with Github" ]
                ]


port sendTokenToStorage : String -> Cmd msg
