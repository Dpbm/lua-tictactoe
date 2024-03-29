require("constants")

function love.conf(t)
  t.title = "TicTacToe"
  t.version = 11.5
  t.console = false
  t.window.width = WIDTH
  t.window.height = HEIGHT
  t.window.vsync = 0
end
