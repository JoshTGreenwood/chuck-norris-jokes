module App exposing (..)

import Html exposing (Html, text, div, img)
import Http exposing (Error)


type alias Model =
    { joke : String
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( { joke = "Your Elm App is working!" }, randomJoke )


type Msg
    = Joke (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke (Ok string) ->
            ( { model | joke = string }, Cmd.none )

        Joke (Err err) ->
            ( { model | joke = "something bad happened" }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model.joke ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


randomJoke : Cmd Msg
randomJoke =
    let
        url =
            "http://api.icndb.com/jokes/random"

        request =
            Http.getString url

        cmd =
            Http.send Joke request
    in
        cmd
