--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:113a1399d472aec40f6903eabb22fc02:5210c78107eed594a048f345ab7a7cf4:421cc32ce50337c0fc1d0fd14fe75b84$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- laser_alfa30x86
            x=1,
            y=1,
            width=14,
            height=86,

            sourceX = 9,
            sourceY = 0,
            sourceWidth = 30,
            sourceHeight = 86
        },
        {
            -- laser_beta30x86
            x=67,
            y=167,
            width=14,
            height=86,

            sourceX = 9,
            sourceY = 0,
            sourceWidth = 30,
            sourceHeight = 86
        },
        {
            -- laser_gama30x86
            x=69,
            y=77,
            width=14,
            height=86,

            sourceX = 9,
            sourceY = 0,
            sourceWidth = 30,
            sourceHeight = 86
        },
        {
            -- nave_alfa70x80
            x=17,
            y=1,
            width=68,
            height=74,

            sourceX = 0,
            sourceY = 3,
            sourceWidth = 70,
            sourceHeight = 80
        },
        {
            -- nave_beta70x80
            x=1,
            y=167,
            width=64,
            height=76,

            sourceX = 3,
            sourceY = 1,
            sourceWidth = 70,
            sourceHeight = 80
        },
        {
            -- nave_gama70x80
            x=1,
            y=89,
            width=66,
            height=76,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 70,
            sourceHeight = 80
        },
    },

    sheetContentWidth = 86,
    sheetContentHeight = 254
}

SheetInfo.frameIndex =
{

    ["laser_alfa30x86"] = 1,
    ["laser_beta30x86"] = 2,
    ["laser_gama30x86"] = 3,
    ["nave_alfa70x80"] = 4,
    ["nave_beta70x80"] = 5,
    ["nave_gama70x80"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
