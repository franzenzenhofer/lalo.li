console.log('init')

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
  window.location.hash = encoded
  return true

$ ->
  $(".dial").knob();

  $(window).load(() ->

    saySo = (whatToSay) ->
      text = whatToSay ? $('#text').val() or 'please enter your message'
      amplitude = parseInt($('#amplitude').val()) or 100
      wordgap = parseInt($('#wordgap').val()) or 0
      pitch = parseInt($('#pitch').val()) or 50
      speed = parseInt($('#speed').val()) or 175
      console.log({ amplitude: amplitude, wordgap: wordgap, pitch: pitch, speed: speed })
      speak(text, { amplitude: amplitude, wordgap: wordgap, pitch: pitch, speed: speed });
      return text


    console.log('load')



    if window.location.hash
      encoded = window.location.hash.replace /^#/, ''
      base64 = encoded[0..encoded.length - 2]
      check = parseInt(encoded[encoded.length - 1..encoded.length])
      unless check == checksum(base64)
        $('#text').val(saySo('Something got corrupted!'))
      else
        deflated = Base64.fromBase64 base64
        input = RawDeflate.inflate deflated
        $('#text').val(input)
        window.setTimeout((()->saySo(input)),500)
    else
      window.setTimeout((()->saySo($('#text').val())),500)

   #window.setTimeout((()->$('#text').focus()),750)
    $("#text").focus(()->
     @select()
     )
    $("#text").get(0).focus()


    $('#speak').on('submit', (e)->
      #alert('submit')
      console.log('submit')
      try
        saySo()
      catch error
        console.log error
      finally
        #false, othrwise the GET request triggers a new page load
        return false

      #text = $('#text').val() or 'please enter your message'
      #amplitude = parseInt($('#amplitude').val()) or 100
      #wordgap = parseInt($('#wordgap').val()) or 0
      #pitch = parseInt($('#pitch').val()) or 50
      #speed = parseInt($('#speed').val()) or 175
      #try
      #  #speak(text.value, { amplitude: amplitude.value, wordgap: workgap.value, pitch: pitch.value, speed: speed.value });
      #  console.log(text)
      #  #toHash(text)
      #  console.log({ amplitude: amplitude, wordgap: wordgap, pitch: pitch, speed: speed })
      #  speak(text, { amplitude: amplitude, wordgap: wordgap, pitch: pitch, speed: speed });
      #
      #  #speak('hello world')
      #catch error
      #  console.log error
      #finally
      #  return false
      )
    $('#text').on('keyup', (e)->
      console.log('change event')
      toHash($('#text').val())
      )
    )
