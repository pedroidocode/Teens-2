-- Abstract: HelloPhysics project
--
-- Demonstrates creating phyiscs bodies
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
--	Supports Graphics 2.0
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
	
	crate[numCaixas] = display.newImage( "crate.png", 180, -50 )
	crate[numCaixas].rotation = numCaixas*10
	physics.addBody( crate[numCaixas], { density=3.0, friction=0.5, bounce=elasticidade } )
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