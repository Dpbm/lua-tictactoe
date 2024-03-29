local io = require("io")

player1 = {
  ["symbol"]="o",
  ["status"]="playing",
  ["score"]=0,
}

player2 = {
  ["symbol"]="x",
  ["status"]="playing",
  ["score"]=0
}

game = {
    ["players"]={
        player1, player2
    },
    ["totalPlayers"]=2,
    ["actualPlayerI"]=1,
    ["actualPlayer"]=player1,
    ["opponent"]=player2,
    ["defaultValue"]="-",
    ["board"]={
        {"-","-","-"},
        {"-","-","-"},
        {"-","-","-"}
    }
}

function game.updatePlayerStatus(tie)
    if(tie) then
        game.actualPlayer.status = 'tie'
        game.opponent.status = 'tie'
        return
    end
    
    game.actualPlayer.status = 'won'
    game.actualPlayer.score = game.actualPlayer.score+1
    game.opponent.status = 'lose'
end

function game.switchSymbols()
  local p1Symbol = player1.symbol
  player1.symbol = player2.symbol
  player2.symbol = p1Symbol
end

function game.show()
  for i=1,3 do
    for j=1,3 do
      io.write(game.board[i][j])
    end
    print()
  end
  print()
end

function game.play(x,y)
  if(game.board[x][y] ~= game.defaultValue) then
      return
  end
      
  game.board[x][y] = game.actualPlayer.symbol
  game.checkWin()
  
  if(not game.finished()) then
    game.updatePlayer()
  end
end

function game.updatePlayer()
    game.opponent = game.players[game.actualPlayerI]
    game.actualPlayerI = getNextPlayerI()
    game.actualPlayer = game.players[game.actualPlayerI]
end

function getNextPlayerI()
  local next = ((game.actualPlayerI+1)%(game.totalPlayers+1))

  if (next == 0) then
    return 1
  else
    return next
  end
end

function game.checkWin()
    local totalCheckedBoxes = 0
    
    --lines
    for i=1,3 do
        local countEqual = 0
        for j=1,3 do
            if(game.board[i][j] == game.actualPlayer.symbol) then
                countEqual = countEqual + 1
            end
            
            if(game.board[i][j]  ~= game.defaultValue) then
                totalCheckedBoxes = totalCheckedBoxes + 1
            end
            
        end
        if(countEqual == 3) then
            game.updatePlayerStatus(false)
            return
        end
    end
    
    --columns
    for j=1,3 do
        local countEqual = 0
        for i=1,3 do
            if(game.board[i][j] == game.actualPlayer.symbol) then
                countEqual = countEqual + 1
            end
        end
        if(countEqual == 3) then
            game.updatePlayerStatus(false)
            return
        end
    end

    --main diagonal
    local countEqual = 0
    for i=1,3 do
        if(game.board[i][i] == game.actualPlayer.symbol) then
            countEqual = countEqual + 1
        end
    end
    if(countEqual == 3) then
        game.updatePlayerStatus(false)
        return
    end
    
    --second diagonal
    local countEqual = 0
    for i=1,3 do
        if(game.board[i][3-(i-1)] == game.actualPlayer.symbol) then
            countEqual = countEqual + 1
        end
    end
    if(countEqual == 3) then
        game.updatePlayerStatus(false)
    end
    
    if(totalCheckedBoxes == 9) then
        game.updatePlayerStatus(true)
    end
end

function game.finished()
    return (player1.status == 'won' or player2.status == 'won' or player1.status == 'tie')
end

function game.restart()
  game.resetBoard()
  if(player1.status == "won") then
    game.actualPlayerI = 2
    game.actualPlayer = player2
    game.opponent = player1
  elseif (player2.status == "won") then
    game.actualPlayerI = 1
    game.actualPlayer = player1
    game.opponent = player2
  else
    game.opponent = game.players[game.actualPlayerI]
    game.actualPlayerI = getNextPlayerI()
    game.actualPlayer = game.players[game.actualPlayerI]
  end

  player1.status = "playing"
  player2.status = "playing"
end

function game.resetBoard()
  game.board = {
      {"-","-","-"},
      {"-","-","-"},
      {"-","-","-"}}
end

function game.reset()
  game.resetBoard()
  game.actualPlayerI = 1
  game.actualPlayer = player1
  game.opponent = player2

  player1.status = "playing"
  player2.status = "playing"
  player1.score = 0
  player2.score = 0
end

return game
