
local imagens = require("src.carregarImagens")
local disparo = require("src.disparo.disparo")
local uiDisp = require("src.display.uiDisplay")

Heroi = {tipo = nil, imagem = nil, municao = 0 , vidas = nil, died = false, escudo = false }

function Heroi:new (o, tipo,municao, grupo, vidas)

    o = o or {}
    setmetatable(o,self)
    self.__index = self;
    self.tipo = tipo;
    self.municao = municao;
    self.imagem = imagens.carregarHeroi(grupo, self:getTipo());
    self.vidas = vidas
    --self.imagem.myName = "nave";
    return o
end

function Heroi:setMunicao(tipo)

    if(tipo == 2) then
        self.municao = 99;
    else
        self.municao = 10;
    end
end

function Heroi:setVidas(valor)

    self.vidas = valor;
end

function Heroi:getVidas()
    return self.vidas
end

function Heroi:Recarregar()

    if(self.tipo ~= 2) then
        self.municao = 10;
        uiDisp.Recarregou();
    end
end

function Heroi:setEscudo(valor)
    
    if (valor == 1 ) then
        self.escudo = true
    elseif( valor == 0 )then
        self.escudo = false
    end
end

function Heroi:getEscudo()

    return self.escudo
end

function Heroi:getMunicao()
    return self.municao;
end
function Heroi:setMunicao(valor)
    self.municao = valor;
end

function Heroi:getTipo()
    return self.tipo;
end

function Heroi:Disparar(grupo)

    --local municao = self.getMunicao();
    disparo.Heroi(self.imagem,self.tipo,grupo,self.municao);
    if( self.tipo ~= 2) then
        local municao = self.municao - 1;
        self:setMunicao(municao);
    end
end

return Heroi