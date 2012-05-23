window.Waveform = (options={}) ->
  patchCanvasForIE = (canvas) ->
    if typeof window.G_vmlCanvasManager != "undefined"
     canvas = window.G_vmlCanvasManager.initElement(canvas)
     oldGetContext = canvas.getContext
     canvas.getContext = (a) ->
       ctx = oldGetContext.apply(canvas, arguments)
       canvas.getContext = oldGetContext
       ctx

  createCanvas = (container) ->
    canvas = document.createElement("canvas")
    container.appendChild(canvas)
    canvas.style.width  = container.clientWidth + "px"
    canvas.style.height = container.clientHeight + "px"
    canvas

  @container = options.container
  @canvas    = options.canvas
  @data      = options.data || []
  background = options.background || "#ffff00"
  foreground = options.foreground || "#0000ff"

  if !@canvas?
    if @container
      @canvas = createCanvas(@container) unless @canvas?
    else
      throw "Either canvas or container option must be passed"

  patchCanvasForIE(@canvas)
  ctx = @canvas.getContext("2d")
  width  = parseInt ctx.canvas.width, 10
  height = parseInt ctx.canvas.height, 10

  { # Public
    canvas:    @canvas
    container: @container
    data:      @data
    clear: ->
      ctx.fillStyle = background
      ctx.fillRect(0, 0, width, height)

    setDataWithLimit: (data, limit, defaultValue=0.0) ->
      if data.length > limit
        @data = data.slice(data.length - limit, data.length)
      else
        @data = []
        for i in [0..limit-1]
          @data[i] = data[i] || defaultValue

    redraw: () ->
      @clear()
      ctx.fillStyle = foreground
      middle = height / 2
      i = 0
      for d in @data
        t = width / @data.length
        #ctx.fillRect i, middle - middle * d, 1, (middle * d * 2)
        if foreground == "transparent"
          ctx.clearRect t*i, middle - middle * d, t, (middle * d * 2)
        else
          ctx.fillRect t*i, middle - middle * d, t, (middle * d * 2)
        i++
  }
