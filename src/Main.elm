module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Types exposing (..)



-- tailwindcss


css path =
    node "link" [ rel "stylesheet", href path ] []



-- Main


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Types


type Msg
    = ShowTracker
    | GotResponse (Result Http.Error String)


type OAuth
    = Success String
    | Failure
    | Loading


type alias Model =
    { tracker : List Entertainment, showTracker : Bool, githubOauth : OAuth }



-- init


gameOfThrones : Entertainment
gameOfThrones =
    Book "Game of Thrones" (createAuthor "George" "Martin")


client_id : String
client_id =
    "abc"


githubOAuthLink : String
githubOAuthLink =
    "https://github.com/login/oauth/authorize?client_id=" ++ client_id


init : () -> ( Model, Cmd Msg )
init _ =
    ( { tracker = [ gameOfThrones ], showTracker = False, githubOauth = Loading }
    , Http.get { url = githubOAuthLink, expect = Http.expectString GotResponse }
    )



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowTracker ->
            ( { model | showTracker = True }, Cmd.none )

        GotResponse (Ok result) ->
            let
                _ =
                    Debug.log "Successfully got message"

                _ =
                    Debug.log result
            in
            ( { model | githubOauth = Success result }, Cmd.none )

        GotResponse (Err txt) ->
            let
                _ =
                    Debug.log "an error occured"
            in
            ( { model | githubOauth = Failure }, Cmd.none )



-- views


view : Model -> Html Msg
view model =
    div []
        [ css "./tailwind.css"
        , if model.showTracker then
            showTracker model.tracker

          else
            button [ onClick ShowTracker ] [ text "Show Tracker" ]
        ]


showTracker : List Entertainment -> Html Msg
showTracker tracker =
    div [] [ text "todo" ]
