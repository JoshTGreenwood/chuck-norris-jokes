module App exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error)
import Json.Decode exposing (..)


type alias Model =
    { joke : String
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( { joke = "Your Elm App is working!" }, randomJoke )


type Msg
    = Joke (Result Http.Error String)
    | NewJoke


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke (Ok string) ->
            ( { model | joke = string }, Cmd.none )

        Joke (Err err) ->
            ( { model | joke = "something bad happened" }, Cmd.none )

        NewJoke ->
            ( model, randomJoke )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick NewJoke ] [ text "New Joke Please!" ]
        , div [] [ text model.joke ]
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
            Http.get url (at [ "value", "joke" ] string)

        cmd =
            Http.send Joke request
    in
        cmd


decoder : Decoder String
decoder =
    at [ "value", "joke" ] string
