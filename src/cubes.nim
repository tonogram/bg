import random, fidget

type
  Color = tuple[top, bottom: string]
  Rect = object
    color: Color
    w, h, x, y, v, s: int # width, height, x-pos, y-pos, velocity, shadow size
    t: float # divisor for top half

const colors: array[4, Color] = [
  (top: "#F8A1EC", bottom: "#ED91CB"),
  (top: "#9FA2BF", bottom: "#8F8FB5"),
  (top: "#F8E986", bottom: "#EDCF7B"),
  (top: "#A1E68C", bottom: "#A0CF88")
]

var rects: seq[Rect] # sequence of rect objects

proc drawMain*() =

  var valid: seq[Rect] # rects that are onscreen

  for i, rect in rects:
    # animate
    rects[i].y -= rects[i].v

    # draw
    rectangle "top":
      box rect.x, rect.y, rect.w, rect.h.float / rect.t
      fill rect.color.top
    rectangle "bottom":
      box rect.x, rect.y, rect.w, rect.h
      fill rect.color.bottom
    rectangle "shadow":
      box rect.x, rect.y + rect.h, rect.w, rect.s
      fill "#000000", 0.05

    # cleanup
    if rects[i].y + rects[i].h >= 0: # if rect is visible
      valid.add(rects[i])
  rects = valid

  # generate
  while rects.len < 25: # there should always be 25 rect objects
    rects.add(
      Rect(
        color: sample(colors),
        w: rand(20..100), # width
        h: rand(20..100), # height
        x: rand(-19..1279), # x-pos
        y: rand(720..1000), # y-pos
        v: rand(1..5), # velocity
        s: rand(10..20), # shadow size
        t: rand(1.1..3.0) # divisor for top half
      )
    )

  # draw background
  rectangle "background":
    box 0, 0, 1280, 720
    fill "#F2F2F2"

when isMainModule:
  import fidget/opengl/base

  randomize()

  proc loadMain() =
    setTitle("PROCEDURAL BACKGROUND")

  startFidget(
    draw=drawMain,
    load=loadMain,
    w=1280,
    h=720,
    mainLoopMode=RepaintOnFrame
  )