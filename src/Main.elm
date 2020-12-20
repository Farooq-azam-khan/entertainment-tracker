module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation exposing (Key)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Route exposing (Route)
import Types exposing (..)
import Url exposing (Url)



-- tailwindcss


css path =
    node "link" [ rel "stylesheet", href path ] []



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
    ShowTracker



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Types


type Msg
    = ShowTracker
    | GotResponse (Result Http.Error String)
    | UpdateTitle String
    | CreateEntertainment
    | GithubOauth
    | LinkClicked UrlRequest


type OAuth
    = Success String
    | Failure
    | Loading


type alias Model =
    { tracker : List Entertainment
    , showTracker : Bool
    , githubOauth : OAuth
    , newPlaceholderTitle : String
    , key : Key
    , route : Route
    }



-- init


gameOfThrones : Entertainment
gameOfThrones =
    Book "Game of Thrones" (createAuthor "George" "Martin")


client_id : String
client_id =
    "165a569192ce7a520b0a"


githubOAuthLink : String
githubOAuthLink =
    "https://github.com/login/oauth/authorize?client_id=" ++ client_id


getAccessToken : Cmd Msg
getAccessToken =
    Http.get
        { url = githubOAuthLink
        , expect = Http.expectString GotResponse
        }


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( { newPlaceholderTitle = ""
      , route = Route.parseUrl url
      , tracker = [ gameOfThrones, gameOfThrones, gameOfThrones ]
      , showTracker = True
      , githubOauth = Loading
      , key = key
      }
      -- , Http.get { url = githubOAuthLink, expect = Http.expectString GotResponse }
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
                    Debug.log "Successfully got message" result

                _ =
                    Debug.log result
            in
            ( { model | githubOauth = Success result }, Cmd.none )

        GotResponse (Err txt) ->
            let
                _ =
                    Debug.log "an error occured" txt
            in
            ( { model | githubOauth = Failure }, Cmd.none )

        UpdateTitle value ->
            ( { model | newPlaceholderTitle = value }, Cmd.none )

        CreateEntertainment ->
            if String.length model.newPlaceholderTitle == 0 then
                ( model, Cmd.none )

            else
                ( { model
                    | newPlaceholderTitle = ""
                    , tracker = List.append model.tracker [ createBook model.newPlaceholderTitle (createAuthor "random fn" "random ln") ]
                  }
                , Cmd.none
                )

        GithubOauth ->
            ( model, getAccessToken )

        LinkClicked url ->
            let
                _ =
                    Debug.log "linke clicked" url
            in
            ( model, Cmd.none )



-- views


view : Model -> Document Msg
view model =
    { title = "Home Page"
    , body =
        [ div []
            [ css "tailwind.css"
            , div [ class "flex w-screen items-center h-screen justify-center" ]
                [ button
                    [ class "bg-red-900 text-white px-5 py-3 rounded-full text-lg shadow-xl"
                    , onClick GithubOauth
                    ]
                    [ text "Login with Github" ]
                ]
            , div
                [ class "bg-gray-200" ]
                [ addEntertainment model.newPlaceholderTitle
                , if model.showTracker then
                    showTracker model.tracker

                  else
                    button
                        [ class "bg-gray-900 text-white px-2 py-1 rounded-md text-md"
                        , onClick ShowTracker
                        ]
                        [ text "Show Tracker" ]
                ]
            ]
        ]
    }


addEntertainment : String -> Html Msg
addEntertainment newPlaceholderTitle =
    div [ class "flex space-x-2 justify-center rounded-md" ]
        [ div [] [ input [ class "px-3 rounded-md w-full h-full", placeholder "Title", value newPlaceholderTitle, onInput UpdateTitle ] [] ]
        , button
            [ class "bg-gray-900 text-white px-2 py-1 rounded-md text-md"
            , onClick CreateEntertainment
            ]
            [ text "Add Entertainmet" ]
        ]


showTracker : List Entertainment -> Html Msg
showTracker tracker =
    div [ class "mt-10 grid grid-cols-1 sm:grid-cols-3 gap-2 sm:gap-4" ]
        (List.map
            renderEntertainment
            tracker
        )


badge : String -> Html Msg
badge t =
    span [ class "flex items-center justify-center bg-green-200 text-green-900 rounded-full px-2 py-1 text-sm font-semibold" ] [ text t ]


renderEntertainment : Entertainment -> Html Msg
renderEntertainment enter =
    div [ class "bg-white shadow-md px-2 py-1 rounded-md" ]
        [ case enter of
            Book title author ->
                div [ class "flex flex-row sm:flex-col sm:space-y-1 space-x-2 align-baseline justify-between px-1" ]
                    [ span [ class "flex space-x-3" ]
                        [ badge "Book"
                        , span [] [ text title ]
                        ]
                    , a
                        [ class "underline text-indigo-900"
                        , href "#"
                        ]
                        [ text (authorFullName author) ]
                    ]

            Movie title ->
                div [] [ text "Movie:", text title ]

            Play title _ ->
                div [] [ text title ]

            TV title ->
                div [] [ text title ]
        ]
