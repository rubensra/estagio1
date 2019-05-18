
local itens = {}


-- Folha de sprites das naves e seus tiros --
local itemSheetOptions = 
{
    frames = {
    
        {
            -- 1) AntiVirus-60x70 
            x=0,
            y=0,
            width=60,
            height=70,
        },
        {
            -- 2) Escudo-90x100
            x=0,
            y=70,
            width=90,
            height=100,
        },
        {
            -- 3) Firewall-60x70
            x=0,
            y=170,
            width=60,
            height=70,
        },
        {
            -- 4) tiro especial 60x80
            x=60,
            y=170,
            width=60,
            height=80,
        },
    },
}
-- Carregando a folha de imagens --
local itemSheet = graphics.newImageSheet( "images/itens/powerUps.png", itemSheetOptions )


function itens.Especial(parametros)

    return display.newImageRect(parametros.grupo, itemSheet, parametros.tipo, 60, 80 )
end

function itens.antiVirus(parametros)

    local antiVirus = display.newImageRect(parametros.grupo, itemSheet, parametros.tipo, 60, 70 )
    antiVirus.x = math.random(50,260)
    antiVirus.y = -100
    physics.addBody( antiVirus, "dynamic", { radius = 10, isSensor=true } )
    antiVirus.myName = "escudo"
    antiVirus.xScale = 0.5
    antiVirus.yScale = 0.5
    transition.to(antiVirus, {y = display.contentHeight + 100, time = 5000, onComplete = function() display.remove(antiVirus) end } )
end

function itens.Escudo(parametros)

    return display.newImageRect(parametros.grupo, itemSheet, parametros.tipo, 90, 100 )
end

function itens.fireWall(parametros)

    return display.newImageRect(parametros.grupo, itemSheet, parametros.tipo, 60, 70 )
end

function itens.remove(obj)

    transition.cancel(obj)
    display.remove(obj)
end

return itens