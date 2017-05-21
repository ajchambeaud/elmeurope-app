module App.View exposing (..)

import NativeUi as Ui exposing (Node)
import NativeUi.Style as Style exposing (defaultTransform)
import NativeUi.Elements as Elements exposing (..)
import NativeUi.Image as Image exposing (..)
import NativeUi.Properties exposing (horizontal, pagingEnabled)
import NativeApi.Dimensions exposing (window)
import App.Types exposing (..)
import RemoteData exposing (..)
import Date.Extra as Date


breakTimeView : BreakTime -> Node Msg
breakTimeView item =
    let
        dateStr =
            Date.toFormattedString "E, h:mm a" item.start

        transform =
            { defaultTransform | perspective = Just window.width }

        transformChild =
            { defaultTransform | perspective = Just window.width, rotateY = Just "30deg" }
    in
        Elements.view
            [ Ui.style
                [ Style.alignItems "stretch"
                , Style.flexDirection "row"
                , Style.width window.width
                , Style.transform transform
                ]
            ]
            [ Elements.view
                [ Ui.style
                    [ Style.flex 1
                    , Style.backgroundColor "#f0ad00"
                    , Style.justifyContent "center"
                    , Style.alignItems "center"
                    , Style.transform transformChild
                    ]
                ]
                [ text
                    [ Ui.style
                        [ Style.textAlign "center"
                        , Style.fontSize 20
                        ]
                    ]
                    [ Ui.string dateStr
                    ]
                ]
            , Elements.view
                [ Ui.style
                    [ Style.flex 1
                    , Style.justifyContent "center"
                    , Style.alignItems "center"
                    ]
                ]
                [ text
                    [ Ui.style
                        [ Style.textAlign "center"
                        , Style.fontSize 28
                        , Style.color "black"
                        ]
                    ]
                    [ Ui.string item.title
                    ]
                ]
            ]


userView : Speaker -> Node Msg
userView speaker =
    let
        imageUrl =
            speaker.image
                |> String.dropLeft 8

        imageSource =
            { uri = "https://images.weserv.nl/?url=" ++ imageUrl ++ "&w=64&h=64"
            , cache = Just ForceCache
            }
    in
        Elements.view
            [ Ui.style
                [ Style.alignItems "flex-start"
                , Style.backgroundColor "black"
                , Style.flexDirection "row"
                , Style.justifyContent "space-between"
                , Style.padding 5
                , Style.marginBottom 10
                , Style.alignSelf "center"
                , Style.width (window.width / 1.5)
                ]
            ]
            [ image
                [ Ui.style
                    [ Style.height 64
                    , Style.width 64
                    ]
                , source imageSource
                ]
                []
            , Elements.view
                [ Ui.style
                    [ Style.alignItems "center"
                    , Style.justifyContent "space-around"
                    , Style.flex 1
                    , Style.alignSelf "stretch"
                    ]
                ]
                [ text
                    [ Ui.style
                        [ Style.color "#f0ad00"
                        , Style.fontSize 18
                        ]
                    ]
                    [ Ui.string speaker.name
                    ]
                ]
            ]


talkHeader : Talk -> Node Msg
talkHeader talk =
    let
        dateStr =
            Date.toFormattedString "E, h:mm a" talk.start

        transform =
            { defaultTransform | skewY = Just "-5deg", translateY = Just 25 }

        transformText =
            { defaultTransform | skewY = Just "5deg" }
    in
        Elements.view
            [ Ui.style
                [ Style.alignItems "stretch"
                , Style.backgroundColor "black"
                ]
            ]
            [ Elements.view
                [ Ui.style
                    [ Style.alignItems "stretch"
                    , Style.justifyContent "space-between"
                    , Style.flexDirection "column"
                    , Style.backgroundColor "black"
                    , Style.transform transform
                    ]
                ]
                [ text
                    [ Ui.style
                        [ Style.color "white"
                        , Style.textAlign "left"
                        , Style.fontSize 18
                        , Style.paddingLeft 30
                        , Style.backgroundColor "transparent"
                        , Style.transform { transformText | translateY = Just 15 }
                        ]
                    ]
                    [ Ui.string dateStr
                    ]
                , text
                    [ Ui.style
                        [ Style.color "#f0ad00"
                        , Style.textAlign "center"
                        , Style.fontSize 28
                        , Style.padding 30
                        , Style.backgroundColor "transparent"
                        , Style.transform transformText
                        ]
                    ]
                    [ Ui.string talk.title
                    ]
                ]
            ]


talkBody : Talk -> Node Msg
talkBody talk =
    Elements.view
        [ Ui.style
            [ Style.justifyContent "center"
            , Style.backgroundColor "transparent"
            , Style.flexDirection "column"
            , Style.width window.width
            , Style.flex 1
            ]
        ]
        [ text
            [ Ui.style
                [ Style.color "black"
                , Style.textAlign "justify"
                , Style.fontSize 12
                , Style.padding 15
                ]
            ]
            [ Ui.string talk.description
            ]
        , userView talk.speaker
        ]


talkView : Talk -> Node Msg
talkView talk =
    Elements.view
        [ Ui.style
            [ Style.justifyContent "space-between"
            , Style.backgroundColor "white"
            , Style.flexDirection "column"
            , Style.width window.width
            ]
        ]
        [ talkHeader talk
        , talkBody talk
        ]


activityView : Activity -> Node Msg
activityView activity =
    case activity of
        TalkActivity talk ->
            talkView talk

        BreakTimeActivity bt ->
            breakTimeView bt


header : Node Msg
header =
    let
        imageSource =
            { uri = "https://images.weserv.nl/?url=seeklogo.com%2Fimages%2FE%2Felm-logo-9DEF2A830B-seeklogo.com.png&w=64&h=64"
            , cache = Just ForceCache
            }
    in
        Elements.view
            [ Ui.style
                [ Style.alignItems "flex-start"
                , Style.backgroundColor "black"
                , Style.flexDirection "row"
                , Style.justifyContent "space-between"
                , Style.marginTop 30
                , Style.padding 5
                , Style.alignSelf "stretch"
                ]
            ]
            [ image
                [ Ui.style
                    [ Style.height 64
                    , Style.width 64
                    ]
                , source imageSource
                ]
                []
            , Elements.view
                [ Ui.style
                    [ Style.alignItems "center"
                    , Style.justifyContent "space-around"
                    , Style.flex 1
                    , Style.alignSelf "stretch"
                    ]
                ]
                [ text
                    [ Ui.style
                        [ Style.color "#63b4c9"
                        , Style.fontSize 24
                        ]
                    ]
                    [ Ui.string "Elm Europe Schedule"
                    ]
                ]
            ]


footer : Node Msg
footer =
    Elements.view
        [ Ui.style
            [ Style.backgroundColor "black"
            , Style.flexDirection "column"
            , Style.justifyContent "center"
            , Style.height 45
            ]
        ]
        [ text
            [ Ui.style
                [ Style.textAlign "center"
                , Style.color "#63b4c9"
                ]
            ]
            [ Ui.string "Made with 🌳 and ❤ by @ajchambeaud"
            ]
        ]


loadingView : Node Msg
loadingView =
    Elements.view
        [ Ui.style
            [ Style.alignItems "center"
            , Style.width window.width
            ]
        ]
        [ activityIndicator
            [ Ui.style
                [ Style.width 80
                , Style.height 80
                ]
            ]
            []
        ]


errorView : String -> Node Msg
errorView err =
    Elements.view
        [ Ui.style
            [ Style.alignItems "center"
            , Style.backgroundColor "red"
            , Style.width window.width
            ]
        ]
        [ text [] [ Ui.string <| "Error: " ++ err ]
        ]


view : Model -> Node Msg
view model =
    let
        mainView =
            case model.activities of
                Loading ->
                    loadingView

                Failure err ->
                    errorView (toString err)

                Success activities ->
                    Elements.scrollView [ horizontal True, pagingEnabled True ] <|
                        List.map
                            (\activity -> activityView activity)
                            activities

                _ ->
                    loadingView
    in
        Elements.view
            [ Ui.style
                [ Style.alignItems "stretch"
                , Style.flexDirection "column"
                , Style.justifyContent "space-between"
                , Style.backgroundColor "white"
                , Style.flex 1
                ]
            ]
            [ header
            , mainView
            , footer
            ]
