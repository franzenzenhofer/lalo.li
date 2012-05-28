INTRO_STRING = 'Please enter your message.'

checksum = (string) ->
    chk = 0
    for i, chr of string
      chk += chr.charCodeAt(0) * (i + 1)
    chk % 10

toHash = (input) ->
  deflated = RawDeflate.deflate input
  base64 = Base64.toBase64 deflated
  check = checksum base64
  encoded = base64 + check
  if(window.location.search or window.location.search isnt '')
    history.pushState({}, "", "/");
  window.location.hash = encoded
  return true

showError = (msg) ->
  msg = msg ? '<b>Sorry, it seems Lalo.li - Short Voice Message Service does not work correctly on your plattform.</b><br>Please download the latest desktop version of <a href="https://www.google.com/chrome">Chrome</a> or <a href="http://www.mozilla.org/en-US/firefox/new/">Firefox</a>!<br><b>Technical Background</b>: Lalo.li works with <a href="https://developer.mozilla.org/En/Using_web_workers">Webworkers</a> and <a href="https://developer.mozilla.org/en/JavaScript_typed_arrays">TypedArrays</a>.<br>These are cutting edge HTML5 features currently only <i>fully</i> supported by the browsers mentioned above.'
  $('#error').html(msg).fadeIn()
  return false

ifSpeakErrorShowError = (msg) ->
   if window.speak_error is true then showError()

makeSpeakHash = () ->
  dataobj =
    text: $('#text').val()
    amplitude: parseInt($('#amplitude').val())
    wordgap: parseInt($('#wordgap').val())
    pitch: parseInt($('#pitch').val())
    speed: parseInt($('#speed').val())
  toHash(JSON.stringify(dataobj))

saySo = (whatToSay, amplitude=null, wordgap=null, pitch=null, speed=null) ->
  text = whatToSay ? $('#text').val() or INTRO_STRING
  amplitude = amplitude ? (parseInt($('#amplitude').val()) or 100)
  wordgap = wordgap ? (parseInt($('#wordgap').val()) or 0)
  pitch = pitch ? (parseInt($('#pitch').val()) or 50)
  speed = speed ? (parseInt($('#speed').val()) or 175)
  try
    speak(text, { amplitude: amplitude, wordgap: wordgap, pitch: pitch, speed: speed });
  catch error
    window.speak_error=true
  finally
    ifSpeakErrorShowError()
    return text

$ ->
  $(".dial").knob();

  $(window).load(() ->
    # START UP
    #ok, if there is an JS error we show the user the (sad) browser message
    window.onerror = (message, url, linenumber)  -> showError()
    #sadly this does not account for the specific opera webworker bug, so we must detect opera
    if $.browser.opera then showError()

        #SET the values from the data hash
    datahash = window.location.hash or window.location.search
    if datahash
      encoded = datahash.replace(/^(#|\?)/, '')
      base64 = encoded[0..encoded.length - 2]
      check = parseInt(encoded[encoded.length - 1..encoded.length])
      unless check == checksum(base64)
        $('#text').val(saySo('Something got corrupted!'))
      else
        deflated = Base64.fromBase64 base64
        input = RawDeflate.inflate deflated
        dataobj = JSON.parse(input)
        #console.log(o)
        $('#text').val(dataobj.text)

        $('#amplitude').val(parseInt(dataobj.amplitude))
        $('#amplitude').trigger('configure')

        $('#wordgap').val(parseInt(dataobj.wordgap))
        $('wordgap').trigger('configure')

        $('#pitch').val(parseInt(dataobj.pitch))
        $('#pitch').trigger('configure')

        $('#speed').val(parseInt(dataobj.speed))
        $('#speed').trigger('configure')
        window.setTimeout((()->saySo(dataobj.text)),250)
    else
      window.setTimeout((()->saySo($('#text').val())),500)

    #if no text value is set, we set it to the default intro string!
    if $('#text').val() is '' then $('#text').val(INTRO_STRING)

    # to prevent data flickering in the knob controlls
    $('#controllarea').css('visibility','visible').hide().fadeIn('slow');

    #method to select the whole text box onload
    $("#text").focus((()->@select()))
    #set the focus to the text box
    $("#text").get(0).focus()

    #easteregg
    window.setTimeout((()->saySo('i love you')),1000*60*15)

    #EVENT HANDLERS
    $('#speak').on('submit', (e)->
      console.log('submit')
      try
        saySo()
      catch error
        showError()
      finally
        #return false anyway, otherwise the GET request triggers a new page load
        return false
      )

    $('#text').on('keyup', ((e)->makeSpeakHash()))

    #attaching an event handler to the dials is a little bit more complicated
    $(".dial").trigger('configure', {'release':((v,ipt) ->makeSpeakHash();console.log('release in dial'))})

    #as the twitter intents URL does not like hash URL we implement a shitload of quer URLs handling
    $("#twitter").on('click', ()-> @href='http://twitter.com/intent/tweet?text='+encodeURIComponent('Voice Message')+'&url=http://www.lalo.li/?'+(window.location.hash[1...] or window.location.search[1...]))
    #https://plusone.google.com/_/+1/confirm?hl=en&url=http://www.your-url/
    $("#gplus").on('click', ()-> @href='https://plus.google.com/share?url=http://www.lalo.li/?'+(window.location.hash[1...] or window.location.search[1...]))
    #https://www.facebook.com/sharer.php?u=[URL]&t=[TEXT]
    $("#facebook").on('click', ()-> @href='https://www.facebook.com/sharer.php?u=http://www.lalo.li/?'+(window.location.hash[1...] or window.location.search[1...])+'&t='+encodeURIComponent('Voice Message'))

    )




