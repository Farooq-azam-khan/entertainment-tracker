module Main exposing (Msg(..), main, update, view)

import Browser
import Html exposing (Html, button, div, pre, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type Msg
    = Increment
    | Decrement
    | Increment2
    | Decrement2
    | GotText (Result Http.Error String)


type Book
    = Failure
    | Loading
    | Success String


type alias Model =
    { counter : Int, book : Book }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { counter = 0, book = Loading }
    , Http.get
        { url = "https://elm-lang.org/assets/public-opinion.txt"
        , expect = Http.expectString GotText
        }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | counter = model.counter + 1 }, Cmd.none )

        Decrement ->
            ( { model | counter = model.counter - 1 }, Cmd.none )

        Increment2 ->
            ( { model | counter = model.counter + 2 }, Cmd.none )

        Decrement2 ->
            ( { model | counter = model.counter - 2 }, Cmd.none )

        GotText result ->
            case result of
                Ok fullText ->
                    ( { model | book = Success fullText }, Cmd.none )

                Err _ ->
                    ( { model | book = Failure }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "bg-gray-100" ]
        [ button [ onClick Decrement ] [ text "-" ]
        , button [ onClick Decrement2 ] [ text "-2" ]
        , div [] [ text (String.fromInt model.counter) ]
        , button [ onClick Increment ] [ text "+" ]
        , button [ onClick Increment2 ] [ text "+2" ]
        , displayBook model.book
        ]


displayBook : Book -> Html Msg
displayBook book =
    case book of
        Failure ->
            text "unable to get book"

        Loading ->
            text " loading book "

        Success fullText ->
            pre [] [ text fullText ]
