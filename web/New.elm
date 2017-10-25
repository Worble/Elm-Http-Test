import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Events.Extra exposing (..)
import Http
import Json.Decode as Decode
import Json.Encode as Encode

main =
  Html.program { view = view, update = update, subscriptions = subscriptions, init = init }

--Model

type alias Model = 
    { currentMessage : String
    , messages : List String 
    }
    
init : (Model, Cmd Msg)
init =
  ( Model "" []
  , getAllMessages
  )

--View

view : Model -> Html Msg
view model = 
    div [ class "container" ]
    [ 
        Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "bootstrap-reboot.min.css" ] []
        , Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "bootstrap-grid.min.css" ] []
        , Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "style.css" ] []
        , div [ class "row" ]
        [
            ul [ class "col-12" ] (List.map messageView (model.messages))
            , input [ class " col-9 form-control", type_ "text", onInput UpdateCurrentMessage, onEnter Update, value model.currentMessage ] [ ]
            , button [ class "btn btn-primary col-3", onClick Update ] [ text "Submit" ]
        ]
    ]

messageView : String -> Html msg
messageView message =
    li [ class "messages" ] 
    [
        span [ class "author" ] [ text "Anonymous says: "]
        , span [ class "message" ] [ text message ]
    ]

--Update

type Msg = UpdateCurrentMessage String | Update | UpdateMessages (Result Http.Error (List String))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        UpdateCurrentMessage text ->
            ({ model | currentMessage = text }, Cmd.none)

        Update ->
            (model, sendMessage model.currentMessage)

        UpdateMessages(Ok messages) ->
        ({ model | currentMessage = "", messages = messages }, Cmd.none)

        UpdateMessages(Err _) ->
        (model, Cmd.none)

getAllMessages : Cmd Msg
getAllMessages =
    let
        url =
            "http://localhost:58803/api/values"
        request =
            Http.get url decodeMessagesUrl
    in
    Http.send UpdateMessages request

-- type alias Message = { id : Int, content : String}

-- decodeMessagesUrl : Decode.Decoder (List Message)
-- decodeMessagesUrl =
--   Decode.list (Decode.map2 Message
--     (Decode.field "id" Decode.int)
--     (Decode.field "content" Decode.string))

decodeMessagesUrl : Decode.Decoder (List String)
decodeMessagesUrl =
  Decode.list (Decode.at ["message"] Decode.string)


messageEncoder : String -> Encode.Value
messageEncoder message =
    Encode.object
        [ ( "Message", Encode.string message )
        ]

sendMessage : String -> Cmd Msg
sendMessage message =
    let
        url =
            "http://localhost:58803/api/values"
        request =
            Http.post
                (url)
                (Http.stringBody "application/json" <| Encode.encode 0 <| messageEncoder message)
                (decodeMessagesUrl)
    in
    Http.send UpdateMessages request

  -- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
