-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local scores = 0


local physics = require("physics")

physics.start()

-- Load the background
local background = display.newImageRect("background.jpg", 1125,2243)
background.x = display.contentCenterX

background.y = display.contentCenterY

-- Load the bascket
local cesta = display.newImageRect( "cesta.png", 80, 80 )
cesta.x = display.contentCenterX
cesta.y = display.contentHeight-20
cesta.myName = "bascket"
-- Load the ball

-- Change the opacity of the bascket
cesta.alpha = 0.8

physics.setGravity( 0, 0 )


physics.addBody(cesta, {radious = 30, isSensor = true})

-- Load balls 

local balls = {}



local TextScores = display.newText( scores, display.contentCenterX, 20, native.systemFont, 40 )
TextScores:setFillColor( 1, 1, 1 )

local function upScores()
    TextScores.text = scores
        
end 
math.randomseed( os.time() )



local ball  



local function createBall()
    bola = display.newImageRect( "bola.png", 60,60 )
    
    physics.addBody( bola, "dynamic", { radius=50, bounce=0.3, isSensor = true } )

    bola.alpha = 0.8


    local number = math.random(1,3)

    if (number == 1) then
        
        table.insert(balls, bola)
        bola.x = -60
        bola.y = math.random(300)
        bola:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
        table.insert(balls,ball)
        bola.myName = "ball"

    elseif (number == 2) then
        --local bola = display.newImageRect( "bola.png", 60,60 )
        bola.alpha = 0.8

        bola.x = math.random( display.contentWidth )
        bola.y = -60
        bola:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
        
        table.insert(balls,ball)
        bola.myName = "ball"
    elseif (number == 3) then
        --local bola = display.newImageRect( "bola.png", 60,60 )
        bola.alpha = 0.8

        bola.x = display.contentWidth + 60
        bola.y = math.random( 500 )
        bola:setLinearVelocity( math.random( -100,-40 ), math.random( 20,60 ) )
        table.insert(balls,ball)
        bola.myName = "ball"

    
    end
    bola:applyTorque( math.random( -6,6 ) )

    --print(number)    
end


local function moveBascket(event)
    
    cesta = event.target

    local mudanca = event.phase

    if("began" == mudanca) then

        display.currentStage:setFocus(cesta)
        cesta.touchOffsetX = event.x - cesta.x
    
    elseif ( "moved" == mudanca ) then
        --
        cesta.x = event.x - cesta.touchOffsetX
    elseif ( "ended" == mudanca or "cancelled" == mudanca ) then
        
        display.currentStage:setFocus( nil )

    end

    return true
end

cesta:addEventListener( "touch", moveBascket )



local function loop()

    createBall()

    for i = #balls, 1, -1 do

        local this = balls[i]

        if (this.x < -100 or this.x > 100
            or this.y < -100 or display.contentHeight > 100)
        
        then
            display.remove(this)
            table.remove(balls, i)
            
            if (scores> 0) then
                
                scores = scores-1
                upScores()
            end

        end

        
    end
end

loopTimer = timer.performWithDelay( 1000,loop, 0)



local function hit(event) 
    
    --scores = scores+1
  
    if(event.phase == "began") then
        local obj1 = event.object1
        local obj2 = event.object2
        --scores = scores+1
        
        if(obj1.myName == "bascket" and obj2.myName == "ball") then

            

            display.remove(obj2)

            for i = #balls, 1,-1 do
                table.remove(balls, i)
            end
            
            scores = scores+1
            
            
        
        elseif (obj2.myName == "bascket" and obj1.myName == "ball") then
    
                
            scores = scores+1

            display.remove(obj1)

            for i = #balls,1,-1 do
                table.remove(balls,i)
            end

            scores = scores+1
            
        end
            
        upScores()        
        
    end
    print("Scores:",scores)
        
end







Runtime:addEventListener( "collision", hit
 )
