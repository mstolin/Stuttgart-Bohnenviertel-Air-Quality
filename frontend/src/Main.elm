module Main exposing (main)

import Browser
import Element exposing (Element, column, padding, paragraph, rgb255, row, spacing, text)
import Element.Background as Background
import Element.Border as Border
import Html exposing (Html)
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
    Element.layout [] (viewAirQuality model)


viewAirQuality : Model -> Element Msg
viewAirQuality model =
    case model of
        Failure error ->
            row [] [ text (getErrorMessage error) ]

        Loading ->
            text "Loading ..."

        Success data ->
            column
                [ Background.color (rgb255 210 210 210)
                , Border.rounded 3
                , padding 15
                , spacing 5
                ]
                [ paragraph [] [ text ("Air Quality: " ++ String.fromInt (calculateAirQualityIndex data.metrics)) ]
                , paragraph [] [ text ("PM10: " ++ String.fromFloat data.metrics.pm10) ]
                , paragraph [] [ text ("O3: " ++ String.fromFloat data.metrics.o3) ]
                , paragraph [] [ text ("NO2: " ++ String.fromFloat data.metrics.no2) ]
                , paragraph [] [ text ("Temperature: " ++ String.fromFloat data.metrics.temperature) ]
                , paragraph [] [ text ("Last update: " ++ data.lastUpdate.date ++ " " ++ data.lastUpdate.timezone) ]
                ]


calculateAirQualityIndex : Metrics -> Int
calculateAirQualityIndex metrics =
    if areMetricsVeryGood metrics then
        1

    else if areMetricsGood metrics then
        2

    else if areMetricsModerate metrics then
        3

    else if areMetricsPoor metrics then
        4

    else
        5


areMetricsVeryGood : Metrics -> Bool
areMetricsVeryGood metrics =
    (metrics.no2 >= 0 && metrics.no2 <= 20) && (metrics.pm10 >= 0 && metrics.pm10 <= 20) && (metrics.o3 >= 0 && metrics.o3 <= 60)


areMetricsGood : Metrics -> Bool
areMetricsGood metrics =
    (metrics.no2 >= 21 && metrics.no2 <= 40) && (metrics.pm10 >= 21 && metrics.pm10 <= 35) && (metrics.o3 >= 61 && metrics.o3 <= 120)


areMetricsModerate : Metrics -> Bool
areMetricsModerate metrics =
    (metrics.no2 >= 41 && metrics.no2 <= 100) && (metrics.pm10 >= 36 && metrics.pm10 <= 50) && (metrics.o3 >= 121 && metrics.o3 <= 180)


areMetricsPoor : Metrics -> Bool
areMetricsPoor metrics =
    (metrics.no2 >= 101 && metrics.no2 <= 200) && (metrics.pm10 >= 51 && metrics.pm10 <= 100) && (metrics.o3 >= 181 && metrics.o3 <= 240)


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
