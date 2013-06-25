require('zappajs') ->
  @get '/': ->
    @render index: layout: no

  @on 'set nickname': ->
    @client.nickname = @data.nickname
    @emit said: {nickname: 'moderator', msg: 'Your name is ' + @data.nickname}
  
  @on 'set room': ->
    @leave @client.room if @client.room
    @client.room = @data.room
    @join @data.room
    @emit 'said', {nickname: 'moderator', msg: 'You joined room ' + @data.room}


  @on said: ->
    @broadcast_to @client.room, 'said', {nickname: @client.nickname, msg: @data.msg}

  @client '/index.js': ->
    @connect()

    @on said: ->
      $("#panel").append "<p>#{@data.nickname} said: #{@data.msg}</p>"
    
    $ =>
      @emit 'set nickname': {nickname: prompt 'Pick a nick!'}
      @emit 'set room': {room: prompt 'Pick a room!'}

      $box = $("#box").focus()
      
      $('button.send').click (e) =>
        @emit said: {msg: $box.val()}
        $box.val('').focus()
        e.preventDefault()

      $('button.change').click (e) =>
        @emit 'set room': {room: prompt 'Pick a room!'}
        $box.val('').focus()
        e.preventDefault()


  @view index: ->
    doctype 5
    html ->
      head ->
        title 'PicoChat Rooms'
        script src: '/zappa/Zappa-simple.js'
        script src: '/index.js'
      body ->
        div id: 'panel'
        form ->
          input id: 'box'
          button class: 'send', -> 'Send!'
          button class: 'change', -> 'Change!'

    
        

    
