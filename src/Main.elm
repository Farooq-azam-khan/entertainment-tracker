module Main exposing (main)

import Browser
import Html exposing (Html, button, div, input, pre, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
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
    | GotResponse (Result Http.Error String)
    | UpdateTitle String


type OAuth
    = Success String
    | Failure
    | Loading


type alias Model =
    { tracker : List Entertainment, showTracker : Bool }



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


fetchOauth =
    Http.get { url = githubOAuthLink, expect = Http.expectString GotResponse }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { tracker = [ gameOfThrones ], showTracker = True, githubOauth = Loading }
    , Cmd.none
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

        UpdateTitle string ->
            ( model, Cmd.none )



-- views


view : Model -> Html Msg
view model =
    div []
        [ addEntertainment
        , if model.showTracker then
            showTracker model.tracker

          else
            button [ onClick ShowTracker ] [ text "Show Tracker" ]
        ]


addEntertainment : Html Msg
addEntertainment =
    div []
        [ input [ placeholder "Title", value "", onInput UpdateTitle ] []
        , button [] [ text "Add Entertainmet" ]
        ]


showTracker : List Entertainment -> Html Msg
showTracker tracker =
    div []
        (List.map
            renderEntertainment
            tracker
        )


renderEntertainment : Entertainment -> Html Msg
renderEntertainment enter =
    case enter of
        Book title _ ->
            div []
                [ text "Book:"
                , text title
                ]

        Movie title ->
            div [] [ text "Movie:", text title ]

        Play title _ ->
            div [] [ text title ]

        TV title ->
            div [] [ text title ]
