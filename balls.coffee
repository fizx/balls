class Balls
  constructor: (@data, @groups) -> 
    @colors = ["red", "blue", "purple"]

  draw: (canvas) ->
    $canvas = $(canvas)
    @w = $canvas.width()
    @h = $canvas.height()
    @canvas = Raphael($canvas[0], @w, @h)
    x = 100
    y = @h / 2 
    @index = {}
    @last = {}
    for ball in data
      @index[ball.name] = ball
    @recurse data[0], x, y

  recurse: (element, x, y) ->  
    c = 100
    element.y = y
    y = element.y
    total = element.size()
    r = element.r()
    offset = 0
    for count, i in element.counts
      delta = 2 * Math.PI * count / total
      this.sector(x, element.y, r, offset, offset+delta, {fill: @colors[i], "stroke-opacity":0})
      offset += delta
            
    nextx = x + 200
    nexty = y - element.children.length * 100 / 4
    
    if @last[element.name]
      [lx, ly, lr] = @last[element.name]    
      @canvas.path("M"+(lx-lr)+" "+ly+"C"+(lx-lr-c)+" "+ly+" "+(x+r+c)+" "+y+" "+(x+r)+" "+y).attr("stroke-width": 4, "stroke": "white").toBack()
    
    @last[element.name] = [x, y, r]
    
    for name in element.children
      next = @index[name]
      nextr = next.r()
      @canvas.path("M"+(x+r)+" "+y+"C"+(x+r+c)+" "+y+" "+(nextx-nextr-c)+" "+nexty+" "+(nextx-nextr)+" "+nexty).attr("stroke-width": 4, "stroke": "white").toBack()
      @recurse next, nextx, nexty
      nexty += 100
      
    @canvas.text(x+r-5, element.y-r+5, element.name).attr({"text-anchor": "start", "font-size": "20px"})
    
  sector: (cx, cy, r, startAngle, endAngle, params) ->
    console.log(startAngle, endAngle)
    rad = 1#Math.PI / 180
    x1 = cx + r * Math.cos(-startAngle * rad)
    x2 = cx + r * Math.cos(-endAngle * rad)
    y1 = cy + r * Math.sin(-startAngle * rad)
    y2 = cy + r * Math.sin(-endAngle * rad)
    return @canvas.path(["M", cx, cy, "L", x1, y1, "A", r, r, 0, +(endAngle - startAngle > Math.PI), 0, x2, y2, "z"]).attr(params)
    
    

class Ball
  constructor: (@name, @counts, @children) ->
  
  size: ->
    n = 0
    for i in @counts
      n += i
    n
  r: -> 
    @size() / 2

data = [
  new Ball("home", [50, 50], ["login", "leave"]),
  new Ball("login", [5, 45], ["recover", "timeline"]),
  new Ball("recover", [5, 45], ["timeline", "leave"]),
  new Ball("timeline", [5, 45], []),
  new Ball("leave", [5, 45], [])
]

window.balls = new Balls(data, ["IE7", "other"])
window.balls.draw("#canvas")