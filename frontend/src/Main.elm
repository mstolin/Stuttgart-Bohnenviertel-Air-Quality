module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (Decoder, field, float, map4, string)



-- Main


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type Model
    = Failure Http.Error
    | Loading
    | Success String



-- Init


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getAirQualityData )



-- Update


type Msg
    = GotQualityData (Result Http.Error Blabla)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotQualityData result ->
            case result of
                Ok temp ->
                    ( Success (String.fromFloat temp.pm10), Cmd.none )

                Err error ->
                    ( Failure error, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- View


view : Model -> Html Msg
view model =
    div [] [ viewAirQuality model ]


viewAirQuality : Model -> Html Msg
viewAirQuality model =
    case model of
        Failure error ->
            div [] [ text (getErrorMessage error) ]

        Loading ->
            text "Loading ..."

        Success temp ->
            div [] [ text temp ]


getErrorMessage : Http.Error -> String
getErrorMessage error =
    case error of
        Http.BadUrl message ->
            "BADURL: " ++ message

        Http.Timeout ->
            "TIMEOUT"

        Http.NetworkError ->
            "NETWORK ERROR"

        Http.BadStatus code ->
            "BAD STATUS: " ++ String.fromInt code

        Http.BadBody message ->
            "BADBODY: " ++ message



-- Http


type alias Metrics =
    { pm10 : Int
    , o3 : Int
    , no2 : Int
    , temperature : Int
    }


type alias LastUpdate =
    { date : String
    , timezone : String
    }


type alias AirQualityResponse =
    { metrics : List Metrics
    , lastUpdate : List LastUpdate
    }


type alias Blabla =
    { pm10 : Float
    , o3 : Float
    , no2 : Float
    , temperature : Float
    }


getAirQualityData : Cmd Msg
getAirQualityData =
    Http.get
        { url = "http://127.0.0.1:1337/airquality?lat=48.7746335&lng=9.1815713"
        , expect = Http.expectJson GotQualityData airQualityDecoder
        }


airQualityDecoder : Decoder Blabla
airQualityDecoder =
    map4 Blabla
        (field "metrics" (field "pm10" float))
        (field "metrics" (field "o3" float))
        (field "metrics" (field "no2" float))
        (field "metrics" (field "temperature" float))
