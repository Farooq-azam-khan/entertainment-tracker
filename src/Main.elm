module Main exposing (main)

import Browser
import Html exposing (Html, button, div, pre, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Types exposing (..)



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


type alias Model =
    { tracker : List Entertainment, showTracker : Bool }



-- init


gameOfThrones : Entertainment
gameOfThrones =
    Book "Game of Thrones" (createAuthor "George" "Martin")


init : () -> ( Model, Cmd Msg )
init _ =
    ( { tracker = [ gameOfThrones ], showTracker = False }
    , Cmd.none
    )



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowTracker ->
            ( { model | showTracker = True }, Cmd.none )



-- views


view : Model -> Html Msg
view model =
    div []
        [ if model.showTracker then
            showTracker model.tracker

          else
            button [ onClick ShowTracker ] [ text "Show Tracker" ]
        ]


showTracker : List Entertainment -> Html Msg
showTracker tracker =
    div [] [ text "todo" ]
