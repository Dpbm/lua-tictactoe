require("tictactoe")

WIDTH = 900
HEIGHT = 600

SQUARE_H = HEIGHT/3
SQUARE_W = WIDTH/3

function love.conf(t)
  t.console = true
end

function love.load()
	love.window.setMode(WIDTH, HEIGHT, {resizable=false})
  font = love.graphics.newFont("assets/pressstart.ttf", 30)
  boardFont = love.graphics.newFont("assets/pressstart.ttf", 50)
  scoreFont = love.graphics.newFont("assets/pressstart.ttf", 20)
  status = "start"
end

function love.draw()
  if(game.finished() == true) then
    status = "finished"
  end
  
  if(status == "start") then
    love.graphics.print("X tic-tac-toe O", font, (WIDTH/2)-220, (HEIGHT/2)-200)
    love.graphics.print(string.format("player 1 symbol: %s", game.players[1].symbol), font, (WIDTH/2)-250, (HEIGHT/2)-100) 
    love.graphics.print(string.format("player 2 symbol: %s", game.players[2].symbol), font, (WIDTH/2)-250, (HEIGHT/2)) 
    love.graphics.rectangle("line", (WIDTH/2)-250, (HEIGHT/2)+100, 540, 60)
    love.graphics.print("start", font, (WIDTH/2)-60, (HEIGHT/2)+120)
  elseif(status == 'playing') then
  

    
    love.graphics.print(string.format("p1 %d",game.players[1].score), scoreFont, 10, 10)
    love.graphics.print(string.format("p2 %d",game.players[2].score), scoreFont, 10, 50)

    createBoard()
    showBoard()
  
  else
    if(game.players[1].status == 'won') then
        love.graphics.print("Player 1 won!", font, (WIDTH/2)-200, (HEIGHT/2)-100)
    elseif(game.players[2].status == 'won') then
        love.graphics.print("Player 2 won!", font, (WIDTH/2)-200, (HEIGHT/2)-100)
    else
        love.graphics.print("TIE", font, (WIDTH/2)-50, (HEIGHT/2)-100)
    end

    love.graphics.print("Click to start next game!", font, (WIDTH/2)-370, (HEIGHT/2))
    love.graphics.print("Press 'Esc' to restart", font, (WIDTH/2)-300, (HEIGHT/2)+50)
  end
end

function createBoard()
    for i=1,3 do
        love.graphics.line(40, SQUARE_H*i, WIDTH-40, SQUARE_H*i)
        love.graphics.line(SQUARE_W*i, 40, SQUARE_W*i, HEIGHT-40)
    end
end

function showBoard()
  local stepy = 0.5
  for i=1,3 do
      local stepx = 0.5
      for j=1,3 do
          if(game.board[i][j] ~= game.defaultValue) then
              love.graphics.print(game.board[i][j], boardFont, (SQUARE_W*stepx)-20, (SQUARE_H*stepy)-20)
          end
          stepx = stepx+1
      end
      stepy = stepy+1
  end
end

function love.mousepressed(x, y, button, istouch)
  print(string.format("clicked %d on x:%d y: %d", button, x,y))

  if button == 1 and status == "start" then
    if((x >= 710 and x <= 740 and y >= 210 and y <= 230) or 
      (x >= 710 and x <= 740 and y >= 310 and y <= 330)) then
      game.switchSymbols()
    elseif(x >= 200 and x <= 745 and y >= 405 and y <= 465)then
      status = "playing"
    end

  elseif button == 1 and status== "finished" then
    restartGame()
  elseif button == 1 and status == "playing" then
    getPlayPosition(x,y)
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" and status == "finished" then
    resetGame()
  end
end

function resetGame()
  print("reseting...")
  status = "start"
  game.reset()
end

function restartGame()
  print("restarting...")
  status = "playing"
  game.restart()
end

function getPlayPosition(x,y)
  if(x <= SQUARE_W and y <= SQUARE_H) then
      game.play(1,1)
  elseif(x <= SQUARE_W*2 and y <= SQUARE_H) then
      game.play(1,2)
  elseif(x <= SQUARE_W*3 and y <= SQUARE_H) then
      game.play(1,3)
  elseif(x <= SQUARE_W and y <= SQUARE_H*2) then
      game.play(2,1)
  elseif(x <= SQUARE_W*2 and y <= SQUARE_H*2) then
      game.play(2,2)
  elseif(x <= SQUARE_W*3 and y <= SQUARE_H*2) then
      game.play(2,3)
  elseif(x <= SQUARE_W and y <= SQUARE_H*3) then
      game.play(3,1)
  elseif(x <= SQUARE_W*2 and y <= SQUARE_H*3) then
      game.play(3,2)
  elseif(x <= SQUARE_W*3 and y <= SQUARE_H*3) then
      game.play(3,3)
  end
end
