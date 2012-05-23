(function() {
  window.Waveform = function(options) {
    var background, createCanvas, ctx, foreground, height, patchCanvasForIE, width;
    if (options == null) {
      options = {};
    }
    patchCanvasForIE = function(canvas) {
      var oldGetContext;
      if (typeof window.G_vmlCanvasManager !== "undefined") {
        canvas = window.G_vmlCanvasManager.initElement(canvas);
        oldGetContext = canvas.getContext;
        return canvas.getContext = function(a) {
          var ctx;
          ctx = oldGetContext.apply(canvas, arguments);
          canvas.getContext = oldGetContext;
          return ctx;
        };
      }
    };
    createCanvas = function(container) {
      var canvas;
      canvas = document.createElement("canvas");
      container.appendChild(canvas);
      canvas.style.width = container.clientWidth + "px";
      canvas.style.height = container.clientHeight + "px";
      return canvas;
    };
    this.container = options.container;
    this.canvas = options.canvas;
    this.data = options.data || [];
    background = options.background || "#ffff00";
    foreground = options.foreground || "#0000ff";
    if (!(this.canvas != null)) {
      if (this.container) {
        if (this.canvas == null) {
          this.canvas = createCanvas(this.container);
        }
      } else {
        throw "Either canvas or container option must be passed";
      }
    }
    patchCanvasForIE(this.canvas);
    ctx = this.canvas.getContext("2d");
    width = parseInt(ctx.canvas.width, 10);
    height = parseInt(ctx.canvas.height, 10);
    return {
      canvas: this.canvas,
      container: this.container,
      data: this.data,
      clear: function() {
        ctx.fillStyle = background;
        return ctx.fillRect(0, 0, width, height);
      },
      setDataWithLimit: function(data, limit, defaultValue) {
        var i, _ref, _results;
        if (defaultValue == null) {
          defaultValue = 0.0;
        }
        if (data.length > limit) {
          return this.data = data.slice(data.length - limit, data.length);
        } else {
          this.data = [];
          _results = [];
          for (i = 0, _ref = limit - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
            _results.push(this.data[i] = data[i] || defaultValue);
          }
          return _results;
        }
      },
      redraw: function() {
        var d, i, middle, t, _i, _len, _ref, _results;
        this.clear();
        ctx.fillStyle = foreground;
        middle = height / 2;
        i = 0;
        _ref = this.data;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          d = _ref[_i];
          t = width / this.data.length;
          if (foreground === "transparent") {
            ctx.clearRect(t * i, middle - middle * d, t, middle * d * 2);
          } else {
            ctx.fillRect(t * i, middle - middle * d, t, middle * d * 2);
          }
          _results.push(i++);
        }
        return _results;
      }
    };
  };
}).call(this);
