--
-- a simple Lua/Corona joystick module based on Rob Miracle's code:
-- http://forums.coronalabs.com/topic/32941-virtual-joystick-module-for-games/
-- simplified some of the code, removing some nice-ities, but it still works

local Joystick = {}

local nave
local limiteX
local limiteY

function Joystick.new( innerRadius, outerRadius )
    local stage = display.getCurrentStage()
    
    local joyGroup = display.newGroup()
    
    local bgJoystick = display.newCircle( joyGroup, 0,0, outerRadius )
    bgJoystick:setFillColor( .2,.2,.2 )
    
    local radToDeg = 180/math.pi
    local degToRad = math.pi/180
    local joystick = display.newCircle( joyGroup, 0,0, innerRadius )
    joystick:setFillColor( .8,.8,.8 )

    -- for easy reference later:
    joyGroup.joystick = joystick
    
    -- where should joystick motion be stopped?
    local stopRadius = outerRadius - innerRadius
    
    -- return a direction identifier, angle, distance
    local directionId = 0
    local angle = 0
    local distance = 0
    function joyGroup.getDirection()
    	return directionId
    end
    function joyGroup:getAngle()
    	return angle
    end
    function joyGroup:getDistance()
    	return distance/stopRadius
    end
    
    
    function joystick:touch(event)
        local phase = event.phase
        local borderX = display.actualContentWidth
        local borderY = display.actualContentHeight
        local speed = 0.1
  
        if( (phase=='began') or (phase=="moved") ) then
        	if( phase == 'began' ) then
            	stage:setFocus(event.target, event.id)
            end
            local parent = self.parent
            local posX, posY = parent:contentToLocal(event.x, event.y)
            angle = (math.atan2( posX, posY )*radToDeg)-90
            if( angle < 0 ) then
            	angle = 360 + angle
            end

            --[[ could expand to include more directions (e.g. 45-deg)
            if( (angle <= 45) and (angle >= 0) ) then
                if( nave.x + 10 < borderX )then
                    nave.x = nave.x + 10
                end
                if( nave.y > 0 ) then
                    nave.y = nave.y - 10
                end
			elseif( (angle>=45) and (angle<90) ) then
                --directionId = 2
                if ( nave.x < borderX )then
                    nave.x = nave.x + 10
                end
                if ( nave.y > 0 ) then
                    nave.y = nave.y - 10
                end
            elseif ( (angle>=90) and (angle<135) ) then
                if (nave.x < 0) then
                    nave.x = nave.x - 10
                end
                if ( nave.y > 0 )then
                    nave.y = nave.y - 10
                end
			elseif( (angle>=135) and (angle<180) ) then
                --directionId = 3
                if (nave.x > 0 ) then
                    nave.x = nave.x - 10
                end
                if (nave.y > 0 )then
                    nave.y = nave.y + 10
                end
			elseif( (angle>=180) and (angle<225) ) then
                --directionId = 4
                if ( nave.x > 0 )then
                    nave.x = nave.x - 10
                end
                if (nave.y < borderY ) then 
                    nave.y = nave.y + 10
                end
            elseif( (angle>=225) and (angle<315) ) then
                if( nave.x > 0 ) then
                    nave.x = nave.x - 10
                end
                if ( nave.y < borderY ) then
                    nave.y = nave.y + 10
                end
			else
                --directionId = 1
                if( nave.x < borderX )then
                    nave.x = nave.x + 10
                end
                if( nave.y < borderY )then
                    nave.y = nave.y + 10
                end
			end
			--]]
			-- could emit "direction" events here
			--Runtime:dispatchEvent( {name='direction',directionId=directionId } )
            
            distance = math.sqrt((posX*posX)+(posY*posY))
            
            if( distance >= stopRadius ) then
                distance = stopRadius
                local radAngle = angle*degToRad
                self.x = distance*math.cos(radAngle)
                self.y = -distance*math.sin(radAngle)
                local x = nave.x + self.x 
                local y = nave.y + self.y
                if ( x > 40 and x < limiteX ) then nave.x = x end
                if ( y > 20 and y < limiteY - 20 ) then nave.y = y end

            else
                self.x = posX
                self.y = posY
                if ( nave ~= nil ) then
                    local x = nave.x + self.x 
                    local y = nave.y + self.y
                    if ( x > 20 and x < limiteX ) then nave.x = x end
                    if ( y > 10 and y < limiteY ) then nave.y = y end
                end
            end
            
        else
            self.x = 0
			self.y = 0
            stage:setFocus(nil, event.id)
            
            directionId = 0
            angle = 0
            distance = 0
        end

        --return self
        return true
    end
    
    function joyGroup:activate(spaceship, largura, altura)
        nave = spaceship
        limiteX = largura
        limiteY = altura

        self:addEventListener("touch", self.joystick )
        --self:addEventListener( "touch", onMove)
        --self.touchHandler = nave.touchHandler
        self.directionId = 0
        self.angle = 0
        self.distance = 0
        --onMove = 

    end
    function joyGroup:deactivate()
        self:removeEventListener("touch", self.joystick )
        self.directionId = 0
        self.angle = 0
        self.distance = 0
    end

    return( joyGroup )
end

return Joystick