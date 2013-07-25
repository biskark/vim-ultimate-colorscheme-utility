" File: browser.vim
" Author: Kevin Biskar
" Version: 0.0.0
"
" Plugin that allows for easy browsing of different installed colorschemes

" Temporary Key Mappings {{{
nnoremap <leader>b :call <SID>CycleAll(1)<cr>
nnoremap <leader>r :call <SID>AddFavorite()<cr>
nnoremap <leader>k :call <SID>RemoveFavorite()<cr>
nnoremap <leader>s :call <SID>SeeFavorites()<cr>
nnoremap <leader>w :call <SID>WriteFavorites()<cr>
nnoremap <leader>l :call <SID>LoadFavorites()<cr>
nnoremap <leader>ff :call <SID>CycleFavorites()<cr>
" END Temporary Key Mappings }}}

" Script Variables {{{
let s:index = -1
let s:all_colors = []
let s:favorites = {}
let s:data_loaded = 0
let s:data_file = expand('<sfile>:p:r') . '.csv'
let s:default_file = expand('<sfile>:p:h') . '/default.csv'
" END script variables }}}

" s:GetAllColors() {{{
" Main function for getting list of colorschemes.
" If no list is given, it goes through all installed colorschemes instead.
" Treats s:all_colors as a set.
function! s:GetAllColors()
    let s:file_list = split(globpath(&rtp, 'colors/*.vim'), '\n')
    for i in s:file_list
        let color = fnamemodify(i, ":t:r")
        " Checks for duplicates
        if index(s:all_colors, color) == -1
            call add(s:all_colors, color)
        endif
    endfor
    call sort(s:all_colors)
endfunction
" END GetAllColors }}}

" s:CycleAll() {{{
" Walks through all installed colorschemes alphabetically starting at the
" scheme loaded when vim starts.
" The step parameter should be the number of slots to move. Should be either
" 1 or -1.
function! s:CycleAll(step)
    if a:step != 1 && a:step != -1
        return -1
    endif

    if len(s:all_colors) == 0
        call <SID>GetAllColors()'
    endif
    " If it's STILL 0, you have a problem. Check your installed colorschemes.
    if len(s:all_colors) == 0
        echom 'Could not load any colorschemes.'
        return -1
    endif
    if s:index == -1
        let s:index = index(s:all_colors, g:colors_name)
    endif
    let s:index += a:step
    if s:index >= len(s:all_colors)
        let s:index = 0
    elseif s:index < 0
        let s:index = len(s:all_colors - 1)
    endif
    try
        execute 'colorscheme '. s:all_colors[s:index]
    catch /E185:/
        echom 'Invalid colorscheme ' . s:all_colors[s:index]
        return -1
    endtry
    return 0
endfunction
" END CycleAll }}}

" s:CycleFavorites() {{{
" Steps one by one through favorites. Checks if the current filetype has
" it's own favorites list and uses that. If filetype doesn't have favorites,
" cycles through global favorites instead. Returns 0 if no problem or -1 if
" no favorites are set.
function! s:CycleFavorites()
    " Set filetype to current or global
    let filetype = &filetype
    if !has_key(s:favorites, filetype)
        let filetype = 'global'
    elseif len(s:favorites[filetype]) == 0
        let filetype = 'global'
    endif
    " Return early if no favorites set
    if len(s:favorites[filetype]) == 0
        return -1
    endif

    let i = index(s:favorites[filetype], g:colors_name)
    " Check if last item and set it to index -1
    if i == len(s:favorites[filetype]) - 1
        let i = -1
    endif
    try
        execute 'colorscheme ' . s:favorites[filetype][i + 1]
    catch /E185:/
        echom 'Invalid colorscheme ' . s:favorites[filetype][i + 1]
        return -1
    endtry
    return 0
endfunction
" END CycleFavorites }}}

" s:AddFavorite() {{{
" Add a color to the favorites list, if no color given. Doesn't add duplicates.
" If filetype is set, adds to global and current filetype. Else, adds only
" to global
function! s:AddFavorite()
    let name = g:colors_name
    if !has_key(s:favorites, 'global')
        let s:favorites['global'] = []
    endif
    if index(s:favorites['global'], name) == -1
        call add(s:favorites['global'], name)
        echo "'" . name . "' added to global favorites."
    else
        echo "'" . name . "' was already in global favorites."
    endif

    let ft = &filetype
    if ft !=# ''
        if !has_key(s:favorites, ft)
            let s:favorites[ft] = []
        endif
        if index(s:favorites[ft], name) == -1
            call add(s:favorites[ft], name)
            echo "'" . name . "' added to " . ft . " favorites."
        else
            echo "'" . name . "' was already in " . ft . " favorites."
        endif
    endif
endfunction
" END AddFavorite }}}

" s:RemoveFavorite() {{{
" Removes a the current scheme from the favorites list from the given category.
function! s:RemoveFavorite()
    let name = g:colors_name
    let ft = &filetype
    let i = index(s:favorites[ft], name)
    if i != -1
        unlet s:favorites[ft][i]
        echo "'" . name . "' removed from " . ft . " favorites."
    else
        echo "'" . name . "' was not in " . ft . " favorites."
    endif
    let j = index(s:favorites['global'], name)
    if j != -1
        unlet s:favorites['global'][i]
        echo "'" . name . "' removed from global favorites."
    else
        echo "'" . name . "' was not in global favorites."
    endif
endfunction
" END RemoveFavorites }}}

" s:SeeFavorites() {{{
" Function that lists currently stored favorites.
function! s:SeeFavorites()
    echo s:favorites
endfunction
" END SeeFavorites }}}

" s:WriteFavorites() {{{
" Writes the stored favorites to the customizable data_file.
" If the function can't write to the file, returns -1.
function! s:WriteFavorites()
    let retval = 0
    if !filewritable(s:data_file)
        let retval = writefile([], s:data_file)
        if retval != 0
            echo "Cannot write to file " . s:data_file . "."
            return retval
        endif
    endif
    if filewritable(s:data_file)
        let data = []
        for type in keys(s:favorites)
            call add(data, type . ',' . join(s:favorites[type], ','))
        endfor
        let retval = writefile(data, s:data_file)
        return retval
    else
        echo s:data_file . " either doesn't exist or cannot be written to."
        return -1
    endif
endfunction
" END WriteFavorites }}}

" s:LoadFavorites() {{{
" Function that reads favorites from plugin directory.
" If no favorites found, loads a default file.
" If default not found, complains and returns -1.
function! s:LoadFavorites()
    if !s:data_loaded
        let file = ''
        if filereadable(s:data_file)
            let file = s:data_file
        elseif filereadable(s:default_file)
            let file = s:default_file
        else
            echo "Cannot load favorites, config file not readable"
            return -1
        endif

        let s:data_loaded = 1
        for line in readfile(file)
            let type = split(line, ',')[0]
            let prefs = split(line, ',')[1:]
            if !has_key(s:favorites, type)
                let s:favorites[type] = []
            endif
            let s:favorites[type] += prefs
        endfor
    endif
endfunction
" END LoadFavorites }}}

" s:InFavorites() {{{
" Returns a boolean answer to whether the current colorscheme is in the
" filetype favorites.
function! s:InFavorites()
    let ft = &filetype
    if has_key(s:favorites, ft) && index(s:favorites[ft], g:colors_name) != -1
        return 1
    endif
    return 0
endfunction
" END InFavorites }}}

" s:SetFavorite {{{
" Function that detects filetype and sets the colorscheme to a preferred color
" for that filetype.
function! s:SetFavorite()
    let ft = &filetype
    if has_key(s:favorites, ft) && index(s:favorites[ft], g:colors_name) == -1
        call <SID>RandomFavorite()
    endif
endfunction
" END SetFavorite }}}

" s:RandomFavorite {{{
" Function that randomnly chooses a favorite for the selected filetype or
" chooses a random global if no normal filetype exists
function! s:RandomFavorite()
    let ft = &filetype
    let limit = len(s:favorites[ft])
    let index = str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % limit
    try
        execute 'colorscheme '. s:favorites[ft][index]
    catch /E185:/
        echom 'Invalid colorscheme ' . s:favorites[ft][index]
        return -1
    endtry
    return 0
endfunction
" END RandomFavorite }}}

" Automatically called on load {{{
call <SID>GetAllColors()
call <SID>LoadFavorites()
" END Automatic calls }}}

" Automatically called on quit {{{
augroup UltiVimColor
    autocmd!
    autocmd BufWinLeave * :call <SID>WriteFavorites()
augroup END
" END Automatic called on quit }}}

" Automatically called on buffer enter {{{
" Useful for automatic filetype list choosing
augroup UltiVimFileType
    autocmd! BufEnter * call <SID>SetFavorite()
augroup END
" END Automatic called on buffer enter }}}
