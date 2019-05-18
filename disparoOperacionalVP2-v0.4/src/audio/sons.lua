local sons = {}


function sons.somTema()

    local somTema = audio.loadSound("audio/inicio/Intro_Tema.wav")
    audio.play(somTema, { channel = 1 , loops = -1 } )

end

function sons.fimJogo()
    local fimJogo = audio.loadSound("audio/fim/fim_tema.wav")
    audio.play(fimJogo, { channel = 1, loops = -1 } )
end

function sons.GameOver()
    local gameOver = audio.loadSound("audio/fim/Game_Over.wav")
    audio.play(gameOver, { channel = 1, loops = 1 } )
end


function sons.temaChefe()
    local somChefe = audio.loadSound("audio/musicaChefe.wav")
    audio.play(somChefe, { channel = 3 })
end

function sons.somFase1()
    local somFase = audio.loadSound("audio/fase01/fase_principal.wav")
    audio.play(somFase, { loops = -1, fadein = 2000, channel = 1 } )
end


function sons.somFase2()
    local somFase = audio.loadSound("audio/fase02/Tema_2aFase.wav")
    audio.play(somFase, { loops = -1, fadein = 2000, channel = 1 } )
end

function sons.somFase3()
    local somFase = audio.loadSound("audio/fase03/Tema_3aFase.wav")
    audio.play(somFase, { loops = -1, fadein = 2000, channel = 1 } )
end

function sons.somDisparo()
    local somDisparo = audio.loadSound("audio/efeitos/heroiLaser.wav")
    audio.play(somDisparo, { channel = 2} )
end

function sons.morteChefe()
    local somMorteChefe = audio.loadSound("audio/efeitos/morteChefe.wav")
    audio.play(somMorteChefe, { channel = 4 } )
end

function sons.onClose( event )
    audio.stop();
end

return sons