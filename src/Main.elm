module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
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
    | UpdateTitle String
    | CreateEntertainment


type OAuth
    = Success String
    | Failure
    | Loading


type alias Model =
    { tracker : List Entertainment, showTracker : Bool, githubOauth : OAuth, newPlaceholderTitle : String }



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
    ( { newPlaceholderTitle = ""
      , tracker = [ gameOfThrones, gameOfThrones, gameOfThrones ]
      , showTracker = True
      , githubOauth = Loading
      }
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



-- views


view : Model -> Html Msg
view model =
    div []
        [ css "tailwind.css"
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
