module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (Decoder, field, float, map2, map4, string)



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
    | Success AirQualityData



-- Init


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getAirQualityData )



-- Update


type Msg
    = GotQualityData (Result Http.Error AirQualityData)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotQualityData result ->
            case result of
                Ok model ->
                    ( Success model, Cmd.none )

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

        Success data ->
            div []
                [ div []
                    [ div [] [ text ("PM10: " ++ String.fromFloat data.metrics.pm10) ]
                    , div [] [ text ("O3: " ++ String.fromFloat data.metrics.o3) ]
                    , div [] [ text ("NO2: " ++ String.fromFloat data.metrics.no2) ]
                    , div [] [ text ("Temperature: " ++ String.fromFloat data.metrics.temperature) ]
                    , div [] [ text ("Last update: " ++ data.lastUpdate.date ++ " " ++ data.lastUpdate.timezone) ]
                    ]
                ]


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
    { pm10 : Float
    , o3 : Float
    , no2 : Float
    , temperature : Float
    }


type alias LastUpdate =
    { date : String
    , timezone : String
    }


type alias AirQualityData =
    { metrics : Metrics
    , lastUpdate : LastUpdate
    }


getAirQualityData : Cmd Msg
getAirQualityData =
    Http.get
        { url = "http://127.0.0.1:1337/airquality?lat=48.7746335&lng=9.1815713"
        , expect = Http.expectJson GotQualityData airQualityDecoder
        }


airQualityDecoder : Decoder AirQualityData
airQualityDecoder =
    map2 AirQualityData
        metricsDecoder
        lastUpdateDecoder


metricsDecoder : Decoder Metrics
metricsDecoder =
    map4
        Metrics
        (field "metrics" (field "pm10" float))
        (field "metrics" (field "o3" float))
        (field "metrics" (field "no2" float))
        (field "metrics" (field "temperature" float))


lastUpdateDecoder : Decoder LastUpdate
lastUpdateDecoder =
    map2
        LastUpdate
        (field "last_update" (field "date" string))
        (field "last_update" (field "timezone" string))
