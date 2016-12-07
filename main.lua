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

local elasticidade = 0.3

physics.start()

local sky = display.newImage( "bkg_clouds.png", 160, 195 )

local ground = display.newImage( "ground.png", 160, 445 )

physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )


-- Criar botão
local crate = {}
local numCaixas = 1

--physics.setDrawMode( "hybrid")

local function derrubaCaixa( event )
    
    crate[numCaixas] = display.newImage( "soccer-ball.png", 180, -50 )
    --crate[numCaixas].rotation = numCaixas*10
    crate[numCaixas].width = 50
    crate[numCaixas].height = 50
    crate[numCaixas].x = 160
    physics.addBody( crate[numCaixas], { density=3.0, friction=0.5, radius=crate[numCaixas].width/2, bounce=elasticidade } )
    numCaixas = numCaixas+1

end

local botao = widget.newButton(
    {
        x = 50,
        y = 350,
        label = "+",
        fontSize = 50,
        shape = "circle",
        radius = 30,
        fillColor = { default={1, 1, 1, 0.7}, over={0.8, 0.8, 0.8, 0.5}},
        onPress = derrubaCaixa
    }
)

-- Criar slider que altera elasticidade das caixas

local function alteraElasticidade( event )
    elasticidade = event.value/100
end

local elasticidadeSlider = widget.newSlider(

    {
        x = 50,
        y = 200,
        orientation = "vertical",
        height = 100,
        listener = alteraElasticidade
    }
)

-- Criar botão que altera a gravidade

local gravidadeInicial = 9.81
local gravidadeTexto = display.newText(gravidadeInicial .. "m/s²", 240, 5, "Comic Sans MS", 30)
gravidadeTexto:setFillColor(1, 1, 1, 0.8)

local function alteraGravidade(event)

    if (event.phase == "increment") then
        gravidadeInicial = gravidadeInicial+2
    elseif (event.phase == "decrement") then
        gravidadeInicial = gravidadeInicial-2
    end

    gravidadeTexto.text = gravidadeInicial .. "m/s²"
    physics.setGravity(0, gravidadeInicial)

end

local botaoGravidade = widget.newStepper(

    {
        x = 240,
        y = 40,
        minimumValue = -20,
        maximumValue = 100,
        initialValue = 0,
        onPress = alteraGravidade
    }

)

-- Criar novo player

physics.setDrawMode("hybrid")

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
local pontuacaoTexto = display.newText(pontos, 50, 20, "Comic Sans MS", 50)
gravidadeTexto:setFillColor(1, 1, 1, 0.8)

local function colisaoLocal( self, event )

    if event.phase == "began" and event.target == player and event.other ~= ground and event.other.x > 150 then
        pontos = pontos+1
        print(pontos)        
    end

    pontuacaoTexto.text = pontos

end

player.collision = colisaoLocal
player:addEventListener( "collision" )

