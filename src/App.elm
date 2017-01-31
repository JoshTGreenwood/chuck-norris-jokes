module App exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error)
import Json.Decode exposing (..)


type alias Model =
    String


type alias Response =
    { id : Int
    , joke : String
    , categories : List String
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( "fetching joke....", randomJoke )


type Msg
    = Joke (Result Http.Error Response)
    | NewJoke


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke (Ok response) ->
            ( toString (response.id) ++ " " ++ response.joke, Cmd.none )

        Joke (Err err) ->
            ( (toString err), Cmd.none )

        NewJoke ->
            ( "fetching joke....", randomJoke )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick NewJoke ] [ text "New Joke Please!" ]
        , div [] [ text model ]
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
            Http.get url responseDecoder

        cmd =
            Http.send Joke request
    in
        cmd


decoder : Decoder String
decoder =
    at [ "value", "joke" ] string


responseDecoder : Decoder Response
responseDecoder =
    map3 Response
        (field "id" int)
        (field "joke" string)
        (field "categories" (list string))
        |> at [ "value" ]
