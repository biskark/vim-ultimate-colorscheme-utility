" File: browser.vim
" Author: Kevin Biskar
" Version: 0.0.0
"
" Plugin that allows for easy browsing of different installed colorschemes

" Temporary Key Mappings {{{
nnoremap <leader>b :call <SID>SetNextColor()<cr>
nnoremap <leader>r :call <SID>AddFavorite()<cr>
nnoremap <leader>k :call <SID>RemoveFavorite('global')<cr>
nnoremap <leader>s :call <SID>SeeFavorites()<cr>
nnoremap <leader>w :call <SID>WriteFavorites()<cr>
nnoremap <leader>l :call <SID>LoadFavorites()<cr>
" END Temporary Key Mappings }}}

" Script Variables {{{
let s:index = -1
let s:all_colors = []
let s:favorites = {}
let s:data_loaded = 0
let s:data_file = expand('<sfile>:p:r') . '.csv'
let s:default_file = expand('<sfile>:p:h') . '/default.csv'
""" END script variables }}}

" s:GetAllColors() {{{
" Main function for getting list of colorschemes.
" If no list is given, it goes through all installed colorschemes instead.
function! s:GetAllColors()
    let s:file_list = split(globpath(&rtp, 'colors/*.vim'), '\n')
    for i in s:file_list
        call add(s:all_colors, fnamemodify(i, ":t:r"))
    endfor
endfunction
""" END GetAllColors }}}

" s:SetNextColor() {{{
" Function
function! s:SetNextColor()
    if len(s:all_colors) == 0
        execute 'call <SID>GetAllColors()'
    endif
    let s:index += 1
    if s:index >= len(s:all_colors)
        let s:index = 0
    endif
    try
        execute 'colorscheme '. s:all_colors[s:index]
    catch /E185:/
        echo 'Invalid colorscheme ' . s:all_colors[s:index]
    endtry
endfunction
""" END SetNextColor }}}

" s:AddFavorite(...) {{{
" Add a color to the global favorites list, if no color given
" uses the current scheme. Doesn't add duplicates.
function! s:AddFavorite(...)
    let name = ''
    if a:0 == 0
        let name = g:colors_name
    else
        let name = a:1
    endif
    if !has_key(s:favorites, 'global')
        let s:favorites['global'] = []
    endif
    if index(s:favorites['global'], name) == -1
        call add(s:favorites['global'], name)
        echo "'" . name . "' added to favorites."
    else
        echo "'" . name . "' was already in favorites."
    endif
endfunction
""" END AddFavorites }}}

" s:RemoveFavorite(type, ...) {{{
" Removes a color from the favorites list from the given category.
" If no color given, attempts to remove the current scheme.
function! s:RemoveFavorite(type, ...)
    let name = ''
    if a:0 == 0
        let name = g:colors_name
    else
        let name = a:1
    endif
    let i = index(s:favorites[a:type], name)
    if i != -1
        unlet s:favorites[a:type][i]
        echo "'" . name . "' removed from " . a:type . " favorites."
    else
        echo "'" . name . "' was not in favorites."
    endif
endfunction
""" END RemoveFavorites }}}

" s:SeeFavorites() {{{
" Function that lists currently stored favorites.
function! s:SeeFavorites()
    echo s:favorites
endfunction
""" END SeeFavorites }}}

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
""" END WriteFavorites }}}

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
""" END LoadFavorites }}}

" Automatically called on load {{{
call <SID>GetAllColors()
call <SID>LoadFavorites()
" END Automatic calls }}}
