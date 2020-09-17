function! Annotate()
    lua for k in pairs(package.loaded) do if k:match("^annotate") then package.loaded[k] = nil end end
    lua require("annotate").testprint()
    lua require("annotate").attach()
endfun

augroup Annotate
    autocmd!
augroup end
