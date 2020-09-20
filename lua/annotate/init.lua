require 'nvim_utils'

local function padcomment(s)
    -- pad literal '%s' with space on both sides
    -- '/*%s*/' -> '/* %s */'
    return s:gsub('(%%s)([^%s])', '%1 %2'):gsub('([^%s])(%%s)', '%1 %2')
end

local function define_mappings(mapping, fn_name)
    local opts = {silent = true}
    vim.api.nvim_set_keymap(
        'n',
        mapping,
        (':lua require("annotate").%s()<CR>'):format(fn_name),
        opts
    )
end

local function attach()
    define_mappings('hc', 'text_object_comment')
end

local function comment_lines(lines)
    local commentstring = padcomment(vim.bo.commentstring)
    local commented = {}

    for _, line in ipairs(lines) do
        commented[#commented + 1] = commentstring:format(line)
    end

    return commented
end

local function text_object_comment()
    nvim_text_operator_transform_selection(comment_lines, "line")
end

local function annotate()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    local currline = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, 1)[1]
    local commented = comment_lines({currline})
    vim.api.nvim_buf_set_lines(0, lnum - 1,lnum, 1, commented)
end

local function testprint()
    print("Loaded...")
end

return {
    annotate = annotate,
    attach = attach,
    testprint = testprint,
    text_object_comment = text_object_comment,
}
