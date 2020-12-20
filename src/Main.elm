module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation exposing (Key, load, pushUrl)
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
    | UpdateTitle String
    | CreateEntertainment
    | LinkClicked UrlRequest


type alias Model =
    { tracker : List Entertainment
    , showTracker : Bool
    , token : Maybe Token
    , newPlaceholderTitle : String
    , key : Key
    , route : Route
    }


gameOfThrones : Entertainment
gameOfThrones =
    Book "Game of Thrones" (createAuthor "George" "Martin")


client_id : String
client_id =
    "165a569192ce7a520b0a"


githubOAuthLink : String
githubOAuthLink =
    "https://github.com/login/oauth/authorize?client_id=" ++ client_id



-- init


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    let
        _ =
            Debug.log "the url" url

        page =
            Route.parseUrl url

        _ =
            Debug.log "parsed url" page

        token =
            case page of
                Route.Login githubToken ->
                    Just (Token githubToken)

                _ ->
                    Nothing

        model =
            { newPlaceholderTitle = ""
            , route = Route.parseUrl url
            , tracker = []
            , showTracker = False
            , token = token
            , key = key
            }

        _ =
            Debug.log "initial model" model
    in
    ( model
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowTracker ->
            ( { model | showTracker = True }, Cmd.none )

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



-- view


view : Model -> Document Msg
view model =
    { title =
        case model.route of
            Route.HomePage ->
                "Home Page"

            Route.LoginPage ->
                "Login Page"

            Route.Login _ ->
                "nothing to see here"

            Route.NotFound ->
                "Page not found"
    , body =
        [ div []
            [ css "http://localhost:8000/tailwind.css"
            , showGithubButton model
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
