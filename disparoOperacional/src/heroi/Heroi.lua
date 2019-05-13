
local imagens = require("src.carregarImagens")
local disparo = require("src.disparo.disparo")
local uiDisp = require("src.display.uiDisplay")

Heroi = {tipo = nil, imagem = nil, municao = 0 , vidas = 3, died = false }

function Heroi:new (o, tipo,municao, grupo)

    o = o or {}
    setmetatable(o,self)
    self.__index = self;
    self.tipo = tipo;
    self.municao = municao;
    self.imagem = imagens.carregarHeroi(grupo, self:getTipo());
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