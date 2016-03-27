display.setStatusBar(display.HiddenStatusBar)

local physics = require("physics")
physics.start( )

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local height = display.contentHeight
local width = display.contentWidth

local bg = display.newImage("bg.jpg", centerX, centerY)
bg.width = width + 50
bg.height = height + 120

time = 10
timerText = display.newText("Time : "..time, 70, 20, "Akashi", 20)

score = 0
scoreText = display.newText("Score : "..score, width - 70, 20, "Akashi", 20)

function bombTouched(event)
	if (event.phase == "began") then
        event.target:removeSelf()
        score = math.floor(score * 0.5)
        scoreText.text = "Score : "..score
	end
end


function balloonTouched(event)
	if (event.phase == "began") then
        event.target:removeSelf()
		score = score + 10
		scoreText.text = "Score : "..score
	end
end


function addNewBalloonOrBomb()
	randomX = math.random(10, width)

	if (math.random(1,5) == 1 or math.random(1,5) == 2) then
		--Bomb
		bomb = display.newImage("bomb.png", randomX, -300)
		bomb.height = 80
		bomb.width = 80
		bomb.rotation = 40
		physics.addBody(bomb, "dynamic")
        bomb:addEventListener( "touch", bombTouched )
        bomb.type = "bomb"
    else
        -- Balloon
        balloon = display.newImage( "red_balloon.png", randomX, -300)
        physics.addBody( balloon, "dynamic" )
        balloon:addEventListener( "touch", balloonTouched )
        balloon.type = "balloon"
    end

end

function offScreen(event)
	if (event.phase == "began") then
		if (balloon.y > 100 ) then
			balloon:releaseSelf( )
		end
		if (bomb.y > 100 ) then
			bomb:releaseSelf( )
		end
	end
end

Runtime:addEventListener("enterframe", offScreen)

function timerCheck()
	time = time - 1
	timerText.text = "Time : "..time
	scoreText.text = "Score : "..score
	if(time <= 0) then
		time = 1
		score = score
		balloon:removeEventListener( "touch", balloonTouched )
		bomb:removeEventListener( "touch", bombTouched )
		physics.stop( )
		go = display.newText("Game Over!", centerX,  centerY , 0, 180, "Akashi", 50)
		transition.fadeIn( go, {time=4000})
	end
end


timer.performWithDelay( 1000, timerCheck, 0)

addNewBalloonOrBomb()

timer.performWithDelay( 500, addNewBalloonOrBomb, 0)

























