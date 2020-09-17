local function padcomment(s)
    -- pad literal '%s' with space on both sides
    -- '/*%s*/' -> '/* %s */'
    return s:gsub('(%%s)([^%s])', '%1 %2'):gsub('([^%s])(%%s)', '%1 %2')
end

local function getfmt()
    local commentstring = vim.bo.commentstring
    local commentaryfmt = nil

    if (vim.b["commentary_format"] ~= nil)
    then
        commentaryfmt = vim.b["commentary_format"]
    else
        commentaryfmt = padcomment(commentstring)
    end

    return commentaryfmt
end

local function split(s, sep)
    local t = {}

    for subs in s:gmatch('([^'..sep..']+)') do
        -- insert into table t
        t[#t + 1] = subs
    end

    return t
end

local function surroundings(fmt)
    return split(fmt, '%%s')
end

local function testprint()
    local fmt = getfmt()
    print(vim.inspect(surroundings(fmt)))
end

return {
    testprint = testprint,
}
