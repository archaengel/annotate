local function padcomment(s)
    -- pad literal '%s' with space on both sides
    -- '/*%s*/' -> '/* %s */'
    return s:gsub('(%%s)([^%s])', '%1 %2'):gsub('([^%s])(%%s)', '%1 %2')
end

local function getfmt()
    local commentstring = vim.bo.commentstring
    local commentaryfmt = nil

    if (vim.b["commentary_format"] ~= nil) then
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

local function tocomment(currline)
    local fmt = getfmt()
    local splits = surroundings(fmt)
    local line = splits[1]..currline

    if (#splits > 1) then
        line = line..splits[2]
    end

    return line
end

local function apply(comment, lnum)
    vim.api.nvim_buf_set_lines(0, lnum - 1,lnum, 1, {comment})
end

local function attach()
    vim.api.nvim_set_keymap(
        'n',
        'hcc',
        ':lua require("annotate").annotate()<CR>',
        {silent = true}
    )
end

local function annotate()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    local currline = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, 1)[1]

    apply(tocomment(currline), lnum)
end

local function testprint()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    local currline = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, 1)[1]
    local commented = tocomment(currline)
    print(commented)
end

return {
    annotate = annotate,
    attach = attach,
    testprint = testprint,
}
