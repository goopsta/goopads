--stdout:write("test")

local log = {}

local stdout = _G.process.stdout.handle

log.colors = {
    ['BLACK']   = 30,
    ['RED']     = 31,
    ['GREEN']   = 32,
    ['YELLOW']  = 33,
    ['BLUE']    = 34,
    ['MAGENTA'] = 35,
    ['CYAN']    = 36,
    ['WHITE']   = 37,
}


function log.msg(txt,clr)
    local color = clr or "WHITE"
    stdout:write(string.format('\27[%i;%im%s\27[0m', 1, log.colors[color], txt).."\n")
end

function log.trail(txt,clr)
    local color = clr or "WHITE"
    stdout:write(string.format('\27[%i;%im%s\27[0m', 1, log.colors[color], txt))
end

return log
