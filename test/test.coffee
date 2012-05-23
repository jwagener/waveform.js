module "Waveform",
test "Waveform should exist", ->
  ok(window.Waveform, "present")

test "Should create new (fitting) canvas if container is passed", ->
  waveform = new Waveform
    container: document.getElementById("qunit-fixture")
  window.bla = waveform
  equal waveform.canvas.style.width, "100px"
  equal waveform.canvas.style.height, "100px"

test "Should reuse the existing canvas if passed", ->
  canvas = document.createElement("canvas")
  document.getElementById("qunit-fixture").appendChild(canvas)
  waveform = new Waveform
    canvas: canvas
  equal waveform.canvas, canvas

test "#setDataWithLimit should fill up to limit", ->
  waveform = new Waveform
    container: document.getElementById("qunit-fixture")
  waveform.setDataWithLimit([1.0, 2.0, 3.0], 5)
  deepEqual(waveform.data, [1.0, 2.0, 3.0, 0.0, 0.0])

test "#setDataWithLimit should only set recent data if over limit", ->
  waveform = new Waveform
    container: document.getElementById("qunit-fixture")
  waveform.setDataWithLimit([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], 5)
  deepEqual(waveform.data, [2.0, 3.0, 4.0, 5.0, 6.0])
