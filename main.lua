local PongP1 = {}
PongP1.width = 20
PongP1.height = 80
PongP1.x = 10
PongP1.y = 10
PongP1.speed = 1

local PongP2 = {}
PongP2.width = 20
PongP2.height = 80
PongP2.x = 10
PongP2.y = 10
PongP2.speed = 1

local ball = {}
ball.width = 20
ball.height = 20
ball.x = 20
ball.y = 20
ball.speed_x = 1
ball.speed_y = 1

WIDTH_SCREEN = 800
HEIGHT_SCREEN = 600

local scoreP1 = 0
local scoreP2 = 0

LeaveP1 = false
LeaveP2 = false

listTrail = {}

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    --CONSOLE
    print("Width : " .. love.graphics.getWidth())
    print("Height : " .. love.graphics.getHeight())
    --FINCONSOLE

    WIDTH_SCREEN = love.graphics.getWidth()
    HEIGHT_SCREEN = love.graphics.getHeight()

    --Centrage PongP1
    PongP1.x = 10
    PongP1.y = HEIGHT_SCREEN / 2 - PongP1.height / 2
    --Centrage PongP2
    PongP2.x = (WIDTH_SCREEN - PongP2.width) - 10
    PongP2.y = HEIGHT_SCREEN / 2 - PongP2.height / 2

    --Centrage ball
    CentreBall()
end

function love.update(dt)
    --Gestion Déplacement P1
    if love.keyboard.isDown("s") then
        PongP1.y = PongP1.y + PongP1.speed
    end

    if love.keyboard.isDown("z") then
        PongP1.y = PongP1.y - PongP1.speed
    end

    --Gestion Déplacement P2
    if love.keyboard.isDown("down") then
        PongP2.y = PongP2.y + PongP2.speed
    end

    if love.keyboard.isDown("up") then
        PongP2.y = PongP2.y - PongP2.speed
    end

    --Bloquage déplacement du PongP1
    if PongP1.y + PongP1.height > HEIGHT_SCREEN then
        PongP1.y = HEIGHT_SCREEN - PongP1.height
    end
    if PongP1.y < 0 then
        PongP1.y = 0
    end

    --Bloquage déplacement du PongP2
    if PongP2.y + PongP2.height > HEIGHT_SCREEN then
        PongP2.y = HEIGHT_SCREEN - PongP2.height
    end
    if PongP2.y < 0 then
        PongP2.y = 0
    end

    for n = #listTrail, 1, -1 do
        local t = listTrail[n]
        t.life = t.life - dt --0.16s (dt = 1/60)
        if t.life < 0 then
            table.remove(listTrail, n)
        end
    end

    --Trainée
    local trail = {}
    trail.x = ball.x
    trail.y = ball.y
    trail.life = 0.3
    table.insert(listTrail, trail)

    --Déplacement Ball
    ball.x = ball.x + ball.speed_x
    ball.y = ball.y + ball.speed_y

    --Bloquage Ball en Y
    if ball.y + ball.height > HEIGHT_SCREEN and ball.x + ball.width < WIDTH_SCREEN then
        ball.speed_y = -ball.speed_y
    end
    if ball.y < 0 and ball.x + ball.width > 0 then
        ball.speed_y = -ball.speed_y
    end

    --Si la balle sort
    if ball.x + ball.width > WIDTH_SCREEN then
        LeaveP2 = true
        scoreP1 = scoreP1 + 1
        CentreBall()
    end

    if ball.x <= 0 then
        LeaveP1 = true
        CentreBall()
        scoreP2 = scoreP2 + 1
    end

    --Bloquage Ball sur PongP1
    if ball.x + ball.width <= PongP1.x + PongP1.width then
        if ball.y + ball.height > PongP1.y and ball.y + ball.height < PongP1.y + PongP1.height then
            ball.speed_x = -ball.speed_x
            --Ball au bord de la raquette pour eviter bug collision
            ball.x = PongP1.x + PongP1.width
        end
    end

    --Bloquage Ball sur PongP2
    if ball.x + ball.width > PongP2.x then
        if ball.y + ball.height > PongP2.y and ball.y + ball.height < PongP2.y + PongP2.height then
            ball.speed_x = -ball.speed_x
            --Ball au bord de la raquette pour eviter bug collision
            ball.x = PongP2.x - ball.width
        end
    end
end

function love.draw()
    --Dessin PONG
    love.graphics.rectangle("fill", PongP1.x, PongP1.y, PongP1.width, PongP1.height)
    love.graphics.rectangle("fill", PongP2.x, PongP2.y, PongP2.width, PongP2.height)

    --DESSIN TRAINEE
    for n = 1, #listTrail do
        local t = listTrail[n]
        love.graphics.setColor(0, 0, 255, t.life / 2)
        love.graphics.rectangle("fill", t.x, t.y, ball.width - 5, ball.height - 5)
    end

    --Dessin BALL
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)

    love.graphics.print("Player 1 : " .. tostring(scoreP1), 10, 0)
    love.graphics.print("Player 2 : " .. tostring(scoreP2), WIDTH_SCREEN - 80, 0)
end

--Fonctions--

function CentreBall()
    ball.x = WIDTH_SCREEN / 2 - ball.width / 2
    ball.y = HEIGHT_SCREEN / 2 - ball.height / 2
    if LeaveP2 == true then
        ball.speed_x = ball.speed_x * 1.05
        ball.speed_x = -ball.speed_x
        LeaveP2 = false
    end
    if LeaveP1 == true then
        ball.speed_x = ball.speed_x * 1.05
        ball.speed_x = -ball.speed_x
        LeaveP1 = false
    end
end
