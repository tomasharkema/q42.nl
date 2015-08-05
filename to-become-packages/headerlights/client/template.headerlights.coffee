Template.headerlights.onCreated ->
  @autorun ->
    newColor = "#" + Lights.find({}, {sort: date: -1}).fetch()[0].hex
    setLightingStyle newColor, getColor2FromHex newColor

getColor2FromHex = (hex) ->
  num = parseInt(hex.replace("#", ""), 16)
  r = num >> 16
  g = num & 0x0000ff
  b = (num >> 8) & 0x00ff
  r1 = r * .5
  g1 = g
  b1 = b * .3
  String("000000" + (g1 | (b1 << 8) | (r1 << 16)).toString(16)).slice(-6)

hex2rgba = (hex, op) ->
  hex = hex.replace '#',''
  r = parseInt hex.substring(0,2), 16
  g = parseInt hex.substring(2,4), 16
  b = parseInt hex.substring(4,6), 16
  "rgba(#{r},#{g},#{b},#{op/100})"

setLightingStyle = (col1, col2) ->
  rgba1 = hex2rgba col1, 30
  rgba2 = hex2rgba col2, 30
  selector = ".block-small .body > h2"
  rule = "background-image: linear-gradient(180deg, #{rgba1}, #{rgba2})"
  document.styleSheets[0].insertRule(
    "#{selector} {#{rule}}",
    document.styleSheets[0].cssRules.length
  )

  rgba1 = hex2rgba col1, 20
  rgba2 = hex2rgba col2, 20
  selector = ".container .block-large > .body"
  g = "radial-gradient(closest-corner,rgba(16,47,70,0) 60%,rgba(16,47,70,0.26))"
  rule = "background-image: #{g}, linear-gradient(180deg, #{rgba1}, #{rgba2})"
  rule += ", linear-gradient(0deg, rgba(0,0,0,0.9), rgba(0,0,0,0.5))"
  document.styleSheets[0].insertRule(
    "#{selector} {#{rule}}",
    document.styleSheets[0].cssRules.length
  )

Template.headerlights.events
  "click #lights-color": (evt) ->
    if not supportsInputTypeColor()
      $(document.body).toggleClass("show-colorpicker")

  # XXX: the input event sometimes doesn't fire the first time you select
  # a color in the picker in Chrome.
  "input #lights-color": (evt) ->
    color = $(evt.target).val().replace("#", "")
    return unless color
    $.get "http://huelandsspoor.nl/api/lamps/setcolor?color=#{color}", ->
      $.get("/updateLightbar")

Template.headerlights.helpers
  lightsColor: -> "#" + Lights.find({}, {sort: {date: -1}}).fetch()[0].hex
  supportsInputTypeColor: -> supportsInputTypeColor()
  explanation: ->
    if Session.equals("lang", "en")
      "en_explanation"
    else
      "explanation"

Template.backgrounds.helpers
  color: -> Lights.find({}, {sort: {date: 1}})
  col1: -> @hex
  col2: -> getColor2FromHex @hex
