-- Abstract: HelloPhysics project
--
-- Demonstrates creating phyiscs bodies
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
--  Supports Graphics 2.0
---------------------------------------------------------------------------------------

local physics = require( "physics" )
local widget  = require( "widget")

physics.start()

local sky = display.newImage( "bkg_clouds.png", 160, 195 )

local ground = display.newImage( "ground.png", 160, 445 )
ground.width = 360

physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )


-- Criar botão
local crate = {}
local numCaixas = 1

--physics.setDrawMode( "hybrid")

local function derrubaCaixa()
    
    crate[numCaixas] = display.newImage( "soccer-ball.png", 180, -50 )
    --crate[numCaixas].rotation = numCaixas*10
    crate[numCaixas].width = 50
    crate[numCaixas].height = 50
    crate[numCaixas].x = math.random(0,320)
    physics.addBody( crate[numCaixas], { density=3.0, friction=0.5, radius=crate[numCaixas].width/2, bounce=0.9 } )
    numCaixas = numCaixas+1

end

-- Criar botão que altera a gravidade

local gravidade = 1.6
local gravidadeTexto = display.newText(gravidade .. "m/s²", 160, 65, "Comic Sans MS", 30)
gravidadeTexto:setFillColor(1, 1, 1, 0.8)

gravidadeTexto.text = gravidade .. "m/s²"
physics.setGravity(0, gravidade)

local function aumentaGravidade()

    gravidade = gravidade + 0.1
    gravidadeTexto.text = gravidade .. "m/s²"
    physics.setGravity(0, gravidade)

end

-- Criar novo player

local player = display.newImage("ronaldinho.png")
player.width = 80
player.height = 200
player.x = 160
player.y = 300

local pentagonShape = {-23,100, 30,100, 20,60, 40,-68, 14,-98, -18,-98, -40,-45, -40,65}
physics.addBody( player, "dynamic", { density=20, friction=0.5, bounce=0.1, shape=pentagonShape } )

-- Variáveis de Movimento
speed = 20; -- Set Walking Speed

-- Stop character movement when no arrow is pushed
 local function detectMovement (event)
    if event.phase == "began" then
        if event.x > player.x then
            player.x = player.x+speed;
        else
            player.x = player.x-speed;
        end
    end
 end

 Runtime:addEventListener("touch", detectMovement )

 -- Colisão e sistema de pontuação
local pontos = 0
local pontuacaoTexto = display.newText(pontos, 160, 20, "Comic Sans MS", 60)
pontuacaoTexto:setFillColor(1, 1, 0, 0.8)

local function colisaoPlayerBola( self, event )

    if event.phase == "began" and event.target == player and event.other ~= ground and event.other.y < 240 then
        pontos = pontos+1
        print(pontos) 
    end

    pontuacaoTexto.text = pontos

end

player.collision = colisaoPlayerBola
player:addEventListener( "collision" )

local function colisaoBolaChao( self, event )

    if event.phase == "began" and event.target == ground and event.other ~= player then
        pontos = pontos-1
        print(pontos) 
    end

    pontuacaoTexto.text = pontos

end

ground.collision = colisaoBolaChao
ground:addEventListener( "collision" )

timer.performWithDelay( 3000, derrubaCaixa, 0 )
timer.performWithDelay( 500, aumentaGravidade, 0)
