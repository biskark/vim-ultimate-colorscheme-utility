" File: browser.vim
" Author: Kevin Biskar
" Version: 0.2.2
"
" Plugin that allows for easy browsing of different installed colorschemes.
" Also allows for the global or filetype based favorites that enables 
" automatic color switching when changing buffers.
"
" DO NOT MODIFY THIS FILE DIRECTLY.
" Instead, change the global variables in your vimrc file.

if exists('did_browser_vim') || &cp || version < 700
    finish
endif
let did_browser_vim = 1

" Global Variables and Default Settings {{{
" Read the help docs for more information on these effects.

" Sets the default key bindings. If this option is not set, you must set all
" the key bindings in your vimrc manually. Any option you don't set is
" functionality you cannot get.
" If it is set, you may still set some key bindings and allow 
" Ultimate-Colorscheme-Utility to set the rest.
if !exists('g:ulti_color_default_keys')
    let g:ulti_color_default_keys = 1
endif

" Uses filetype specific favorites.
if !exists('g:ulti_color_filetype')
    let g:ulti_color_filetype = 1
endif

" Automatically saves favorites on Vim exit.
if !exists('g:ulti_color_auto_save')
    let g:ulti_color_auto_save = 1
endif

" Automatically loads favorites on Vim start.
if !exists('g:ulti_color_auto_load')
    let g:ulti_color_auto_load = 1
endif

" Adds favorite colorscheme to 'global' favorites in addition to filetype
" favorites.
if !exists('g:ulti_color_quick_add')
    let g:ulti_color_quick_add = 1
endif

" Echoes messages
if !exists('g:ulti_color_verbose')
    let g:ulti_color_verbose = 1
endif

" Removes favorite colorscheme or font from 'global' favorites in addition to
" filetype favorites.
if !exists('g:ulti_color_quick_remove')
    let g:ulti_color_quick_remove = 0
endif

" Chooses a random favorite colorscheme (and font) on each buf enter.
if !exists('g:ulti_color_always_random')
    let g:ulti_color_always_random = 0
endif

" Enable the font favorites feature.
if !exists('g:ulti_color_font_enable')
    let g:ulti_color_font_enable = 1
endif

" Enable modifying the GVim menus.
if !exists('g:ulti_color_gui_menu')
    let g:ulti_color_gui_menu = 1
endif

if !exists('g:ulti_color_excluded')
    let g:ulti_color_excluded = ['minibufexpl', 'qf']
endif
" END Global Variables }}}

" Default Key Mappings {{{
if g:ulti_color_default_keys
    " Colorscheme favorite settings
    if !exists('g:ulti_color_Next_Global')
        let g:ulti_color_Next_Global = '<leader><leader>n'
    endif
    if !exists('g:ulti_color_Prev_Global')
        let g:ulti_color_Prev_Global = '<leader><leader>N'
    endif
    if !exists('g:ulti_color_Next_Fav')
        let g:ulti_color_Next_Fav = '<leader><leader>f'
    endif
    if !exists('g:ulti_color_Prev_Fav')
        let g:ulti_color_Prev_Fav = '<leader><leader>F'
    endif
    if !exists('g:ulti_color_Next_Global_Fav')
        let g:ulti_color_Next_Global_Fav = '<leader><leader>g'
    endif
    if !exists('g:ulti_color_Prev_Global_Fav')
        let g:ulti_color_Prev_Global_Fav = '<leader><leader>G'
    endif
    if !exists('g:ulti_color_Add_Fav')
        let g:ulti_color_Add_Fav = '<leader><leader>a'
    endif
    if !exists('g:ulti_color_Remove_Fav')
        let g:ulti_color_Remove_Fav = '<leader><leader>A'
    endif
    " Plugin utility settings
    if !exists('g:ulti_color_Write_Fav')
        let g:ulti_color_Write_Fav = '<leader><leader>s'
    endif
    if !exists('g:ulti_color_Load_Fav')
        let g:ulti_color_Load_Fav = '<leader><leader>S'
    endif
    if !exists('g:ulti_color_See_Fav')
        let g:ulti_color_See_Fav = '<leader><leader>q'
    endif
    " Font favorite settings
    if !exists('g:ulti_color_Font_Next_Fav')
        let g:ulti_color_Font_Next_Fav = '<leader><leader>e'
    endif
    if !exists('g:ulti_color_Font_Prev_Fav')
        let g:ulti_color_Font_Prev_Fav = '<leader><leader>E'
    endif
    if !exists('g:ulti_color_Font_Next_Global_Fav')
        let g:ulti_color_Font_Next_Global_Fav = '<leader><leader>r'
    endif
    if !exists('g:ulti_color_Font_Prev_Global_Fav')
        let g:ulti_color_Font_Prev_Global_Fav = '<leader><leader>R'
    endif
    if !exists('g:ulti_color_Font_Add_Fav')
        let g:ulti_color_Font_Add_Fav = '<leader><leader>t'
    endif
    if !exists('g:ulti_color_Font_Remove_Fav')
        let g:ulti_color_Font_Remove_Fav = '<leader><leader>T'
    endif
endif
" END Default Key Mappings }}}

" Assign Mappings to Functions {{{
" Colorscheme Mappings
if exists('g:ulti_color_Next_Global')
    exec 'nnoremap <silent> ' . g:ulti_color_Next_Global .
                \ ' :call <SID>CycleAll(1)<cr>'
endif

if exists('g:ulti_color_Prev_Global')
    exec 'nnoremap <silent> ' . g:ulti_color_Prev_Global . 
                \ ' :call <SID>CycleAll(-1)<cr>'
endif

if exists('g:ulti_color_Next_Fav')
    exec 'nnoremap <silent> ' . g:ulti_color_Next_Fav . 
                \ ' :call <SID>CycleFileFavorites(1)<cr>'
endif

if exists('g:ulti_color_Prev_Fav')
    exec 'nnoremap <silent> ' . g:ulti_color_Prev_Fav . 
                \ ' :call <SID>CycleFileFavorites(-1)<cr>'
endif

if exists('g:ulti_color_Next_Global_Fav')
    exec 'nnoremap <silent> ' . g:ulti_color_Next_Global_Fav . 
                \ ' :call <SID>CycleGlobalFavorites(1)<cr>'
endif

if exists('g:ulti_color_Prev_Global_Fav')
    exec 'nnoremap <silent> ' . g:ulti_color_Prev_Global_Fav . 
                \ ' :call <SID>CycleGlobalFavorites(-1)<cr>'
endif

if exists('g:ulti_color_Add_Fav')
    exec 'nnoremap <silent> ' . g:ulti_color_Add_Fav . 
                \ ' :call <SID>AddFavorite()<cr>'
endif

if exists('g:ulti_color_Remove_Fav')
    exec 'nnoremap <silent> ' . g:ulti_color_Remove_Fav . 
                \ ' :call <SID>RemoveFavorite()<cr>'
endif

" Utility mappings
if exists('g:ulti_color_Write_Fav')
    exec 'nnoremap <silent> ' . g:ulti_color_Write_Fav . 
                \ ' :call <SID>WriteFavorites()<cr>'
endif

if exists('g:ulti_color_Load_Fav')
    exec 'nnoremap <silent> ' . g:ulti_color_Load_Fav . 
                \ ' :call <SID>LoadFavorites()<cr>'
endif

if exists('g:ulti_color_See_Fav')
    exec 'nnoremap <silent> ' . g:ulti_color_See_Fav . 
                \ ' :call <SID>SeeFavorites()<cr>'
endif

" Font mappings
if has('gui_running')
    if exists('g:ulti_color_Font_Add_Fav')
        exec 'nnoremap <silent> ' . g:ulti_color_Font_Add_Fav .
                    \ ' :call <SID>AddFontFavorite()<cr>'
    endif

    if exists('g:ulti_color_Font_Remove_Fav')
        exec 'nnoremap <silent> ' . g:ulti_color_Font_Remove_Fav .
                    \ ' :call <SID>RemoveFontFavorite()<cr>'
    endif

    if exists('g:ulti_color_Font_Next_Fav')
        exec 'nnoremap <silent> ' . g:ulti_color_Font_Next_Fav . 
                    \ ' :call <SID>CycleFontFileFavorites(1)<cr>'
    endif

    if exists('g:ulti_color_Font_Prev_Fav')
        exec 'nnoremap <silent> ' . g:ulti_color_Font_Prev_Fav . 
                    \ ' :call <SID>CycleFontFileFavorites(-1)<cr>'
    endif

    if exists('g:ulti_color_Font_Next_Global_Fav')
        exec 'nnoremap <silent> ' . g:ulti_color_Font_Next_Global_Fav . 
                    \ ' :call <SID>CycleFontGlobalFavorites(1)<cr>'
    endif

    if exists('g:ulti_color_Font_Prev_Global_Fav')
        exec 'nnoremap <silent> ' . g:ulti_color_Font_Prev_Global_Fav . 
                    \ ' :call <SID>CycleFontGlobalFavorites(-1)<cr>'
    endif
endif

" END Assign Functions }}}

" Script Variables {{{
let s:index = -1
let s:all_colors = []
let s:favorites = {}
let s:font_favorites = {}
let s:data_loaded = 0
let s:font_data_loaded = 0
let s:data_file = expand('<sfile>:p:r') . '.csv'
let s:font_data_file = expand('<sfile>:p:h') . '/font.csv'
let s:default_file = expand('<sfile>:p:h') . '/default.csv'
let s:old_filetype = ''
" END script variables }}}

" Script Functions {{{
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
        call <SID>GetAllColors()
    endif
    " If it's STILL 0, you have a problem. Check your installed colorschemes.
    if len(s:all_colors) == 0
        redraw
        echom 'Could not load any colorschemes.'
        return -1
    endif
    if s:index == -1 && exists('g:colors_name')
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
        if g:ulti_color_verbose
            redraw
            echo s:all_colors[s:index]
        endif
    catch /E185:/
        redraw
        echom 'Invalid colorscheme ' . s:all_colors[s:index]
        return -1
    endtry
    return 0
endfunction
" END CycleAll }}}

" s:CycleFileFavorites() {{{
" Steps one by one through file favorites. Checks if the current filetype has
" it's own favorites list and uses that. If filetype doesn't have favorites,
" cycles through global favorites instead. Returns 0 if no problem or -1 if
" no favorites are set.
" If the second argument is set to 1, defaults to global list.
function! s:CycleFileFavorites(step, ...)
    if a:step != 1 && a:step != -1
        return -1
    endif

    " Set filetype to current or global
    let filetype = &filetype
    " If filetype explicitly ignored
    if g:ulti_color_filetype == 0 || (a:0 == 1 && a:1 == 1)
        let filetype = 'global'
    " Filetype in excluded
    elseif index(g:ulti_color_excluded, filetype) >= 0
        let filetype = 'global'
    " If no favorites for filetype
    elseif !has_key(s:favorites, filetype) || len(s:favorites[filetype]) == 0
        let filetype = 'global'
    endif

    " Return early if no favorites set
    if len(s:favorites[filetype]) == 0
        return -1
    endif

    let i = 0
    if exists('g:colors_name')
        let i = index(s:favorites[filetype], g:colors_name)
    endif
    " Check if last item and set it to index -1
    if i == len(s:favorites[filetype]) - 1 && a:step == 1
        let i = -1
    elseif i == 0 && a:step == -1
        let i = len(s:favorites[filetype])
    endif
    try
        execute 'colorscheme ' . s:favorites[filetype][i + a:step]
        if g:ulti_color_verbose
            redraw
            echo s:favorites[filetype][i + a:step]
        endif
    catch /E185:/
        redraw
        echom 'Invalid colorscheme ' . s:favorites[filetype][i + a:step]
        return -1
    endtry
    return 0
endfunction
" END CycleFileFavorites }}}

" s:CycleGlobalFavorites() {{{
" Steps through the global favorites list.
function! s:CycleGlobalFavorites(step)
    call <SID>CycleFileFavorites(a:step, 1)
endfunction
" END CycleGlobalFavorites() }}}

" s:AddFavorite() {{{
" Add a color to the favorites list, if no color given. Doesn't add duplicates.
" If filetype is set, adds to current filetype. Else, adds only to global.
" If g:ulti_color_quick_add is set, also adds colorscheme to 'global'
" favorites.
" If g:ulti_color_quick_add is not set, only adds to 'global' if the
" colorscheme is already in the filetype favorites.
function! s:AddFavorite()
    if !exists('g:colors_name')
        return -1
    endif
    let name = g:colors_name
    " Adds to filetype favorites
    if g:ulti_color_filetype
        let ft = &filetype
        " Doesn't trigger if 'no ft' or filetype is specifically excluded
        if ft !=# '' && index(g:ulti_color_excluded, ft) == -1
            if !has_key(s:favorites, ft)
                let s:favorites[ft] = []
            endif
            if index(s:favorites[ft], name) == -1
                call add(s:favorites[ft], name)
                if g:ulti_color_verbose
                    echo "'" . name . "' added to " . ft . " favorites."
                endif
                if g:ulti_color_quick_add == 0
                    return 0
                endif
            elseif g:ulti_color_verbose
                echo "'" . name . "' already in " . ft . " favorites."
            endif
        endif
    endif

    " Adds to global favorites
    if !has_key(s:favorites, 'global')
        let s:favorites['global'] = []
    endif
    if index(s:favorites['global'], name) == -1
        call add(s:favorites['global'], name)
        if g:ulti_color_verbose
            echo "'" . name . "' added to global favorites."
        endif
    elseif g:ulti_color_verbose
        echo "'" . name . "' already in global favorites."
    endif
    return 0
endfunction
" END AddFavorite }}}

" s:RemoveFavorite() {{{
" Removes a the current scheme from the favorites list from the given filetype.
" If g:ulti_color_quick_remove is set, will also remove from global favorites.
" If g:ulti_color_quick_remove is not set, will only remove from global
" favorites if it is not currently in the filetype favorites.
function! s:RemoveFavorite()
    if !exists('g:colors_name')
        return -1
    endif
    let name = g:colors_name
    let ft = &filetype
    if has_key(s:favorites, ft) && index(s:favorites[ft], name) != -1
        unlet s:favorites[ft][index(s:favorites[ft], name)]
        if g:ulti_color_verbose
            echo "'" . name . "' removed from " . ft . " favorites."
        endif
        if g:ulti_color_quick_remove == 0
            return 0
        endif
    elseif g:ulti_color_verbose
        echo "'" . name . "' wasn't in " . ft . " favorites."
    endif
    if has_key(s:favorites, 'global') &&
                \ index(s:favorites['global'], name) != -1
        unlet s:favorites['global'][index(s:favorites['global'], name)]
        if g:ulti_color_verbose
            echo "'" . name . "' removed from global favorites."
        endif
    elseif g:ulti_color_verbose
        echo "'" . name . "' wasn't in global favorites."
    endif
    return 0
endfunction
" END RemoveFavorite }}}

" s:SeeFavorites() {{{
" Function that lists currently stored favorites.
function! s:SeeFavorites()
    echo "Colorscheme Favorites:"
    for language in keys(s:favorites)
        echo language
        for scheme in s:favorites[language]
            echo "  " . scheme
        endfor
    endfor
    if has('gui_running') && g:ulti_color_font_enable
        echo "\nFont Favorites:"
        for language in keys(s:font_favorites)
            echo language
            for font in s:font_favorites[language]
                echo " " . font
            endfor
        endfor
    endif
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
            redraw
            echom "Cannot write to file " . s:data_file . "."
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
        redraw
        echom s:data_file . " either doesn't exist or cannot be written to."
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
            redraw
            echom "Cannot load favorites, config file not readable"
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
    if has_key(s:favorites, ft) && exists('g:colors_name') &&
                \ index(s:favorites[ft], g:colors_name) != -1
        return 1
    endif
    return 0
endfunction
" END InFavorites }}}

" s:SetFavorite() {{{
" Function that detects filetype and sets the colorscheme to a preferred color
" for that filetype. On startup, g:colors_name may not be set, so checks for
" that to. Called only when always_random is set to 0.
function! s:SetFavorite()
    let ft = &filetype
    if !exists('g:colors_name')
        let g:colors_name = 'default'
    endif
    " If ... filetype in dictionary, the current scheme isn't in those
    " favorites, the filetype is not excluded specifically, and the filetype
    " has at least one stored favorite.
    if (has_key(s:favorites, ft) && 
                \ index(s:favorites[ft], g:colors_name) == -1 &&
                \ len(s:favorites[ft]) > 0)
        call <SID>RandomFavorite()
    " If ... global in dictionary, the current scheme isn't in it, and
    " favorites has at least one stored.
    elseif has_key(s:favorites, 'global') && 
                \ index(s:favorites['global'], g:colors_name) == -1 &&
                \ len(s:favorites['global']) > 0
        call <SID>RandomFavorite()
    endif
endfunction
" END SetFavorite }}}

" s:RandomFavorite() {{{
" Function that randomnly chooses a favorite for the selected filetype or
" chooses a random global if no normal filetype exists. If no global favorites
" set, returns -1.
function! s:RandomFavorite()
    let ft = &filetype
    if g:ulti_color_filetype == 0 ||
                \ has_key(s:favorites, ft) == 0 ||
                \ len(s:favorites[ft]) == 0
        if len(s:favorites['global']) == 0
            return -1
        endif
        let ft = 'global'
    endif
    let limit = len(s:favorites[ft])
    let index = str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) 
                \ % limit
    try
        execute 'colorscheme '. s:favorites[ft][index]
        if g:ulti_color_verbose
            redraw
            echo s:favorites[ft][index]
        endif
    catch /E185:/
        echom 'Invalid colorscheme ' . s:favorites[ft][index]
        return -1
    endtry
    return 0
endfunction
" END RandomFavorite }}}

" s:SituationalRandomFavorite() {{{
" Function that randomnly chooses a favorite for the selected filetype or
" chooses a random global if no normal filetype exists IF the new filetype is
" not the same as the old filetype. If no global favorites set, returns -1 via
" the call to RandomFavorite()
function! s:SituationalRandomFavorite()
    let ft = &filetype
    let retval = 0
    let is_first_time = 0
    " Initialize at startup on infrequent or unfavorited filetypes
    if s:old_filetype ==# ''
        let retval = s:RandomFavorite()
        let is_first_time = 1
    endif
    " If current ft is the same as the last one, if current ft is considered
    " blank, or if it is excluded by user
    if ft ==# s:old_filetype ||
                \ ft ==# '' ||
                \ index(g:ulti_color_excluded, ft) >= 0
        return retval
    else
        let s:old_filetype = ft
        if is_first_time
            return retval
        else
            return s:RandomFavorite()
    endif
endfunction
" END SituationalRandomFavorite }}}

" s:LoadFontFavorites() {{{
" Function that reads font favorites from plugin directory.
" If no favorites found, loads a default file.
" If default not found, complains and returns -1.
function! s:LoadFontFavorites()
    if !s:font_data_loaded
        let file = ''
        if filereadable(s:font_data_file)
            let file = s:font_data_file
        elseif filereadable(s:default_file)
            let file = s:default_file
        else
            redraw
            echom "Cannot load font favorites, config file not readable"
            return -1
        endif

        let s:font_data_loaded = 1
        for line in readfile(file)
            let type = split(line, ',')[0]
            let prefs = split(line, ',')[1:]
            if !has_key(s:font_favorites, type)
                let s:font_favorites[type] = []
            endif
            let s:font_favorites[type] += prefs
        endfor
    endif
endfunction
" END LoadFontFavorites }}}

" s:WriteFontFavorites() {{{
" Writes the stored font favorites to the customizable data_file.
" If the function can't write to the file, returns -1.
function! s:WriteFontFavorites()
    let retval = 0
    if !filewritable(s:font_data_file)
        let retval = writefile([], s:font_data_file)
        if retval != 0
            redraw
            echom "Cannot write to file " . s:font_data_file . "."
            return retval
        endif
    endif
    if filewritable(s:font_data_file)
        let data = []
        for type in keys(s:font_favorites)
            call add(data, type . ',' . join(s:font_favorites[type], ','))
        endfor
        let retval = writefile(data, s:font_data_file)
        return retval
    else
        redraw
        echom s:font_data_file . " either doesn't exist or cannot be written to."
        return -1
    endif
endfunction
" END WriteFontFavorites }}}

" s:SetFontFavorite() {{{
" Function that detects filetype and sets the font to a preferred font
" for that filetype.
function! s:SetFontFavorite()
    let ft = &filetype
    if (has_key(s:font_favorites, ft) && 
                \ index(s:font_favorites[ft], &guifont) == -1 &&
                \ len(s:font_favorites[ft]) > 0)
        call <SID>RandomFontFavorite()
    elseif has_key(s:font_favorites, 'global') && 
                \ index(s:font_favorites['global'], &guifont) == -1 &&
                \ len(s:font_favorites['global']) > 0
        call <SID>RandomFontFavorite()
    endif
endfunction
" END SetFontFavorite }}}

" s:RandomFontFavorite() {{{
" Function that randomnly chooses a favorite font for the selected filetype or
" chooses a random global if no normal filetype exists. If no global favorites
" set, returns -1.
function! s:RandomFontFavorite()
    let ft = &filetype
    if g:ulti_color_filetype == 0 || has_key(s:font_favorites, ft) == 0 ||
                \ len(s:font_favorites[ft]) == 0
        if len(s:font_favorites['global']) == 0
            return -1
        endif
        let ft = 'global'
    endif
    let limit = len(s:font_favorites[ft])
    let index = str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) 
                \ % limit
    execute 'let &guifont = ' . "'" . s:font_favorites[ft][index] . "'"
    if g:ulti_color_verbose
        redraw
        echo s:font_favorites[ft][index]
    endif
    return 0
endfunction
" END RandomFontFavorite }}}

" s:AddFontFavorite() {{{
" Add current font to the favorites list. Doesn't add duplicates.
" If filetype is set, adds to current filetype. Else, adds only to global.
" If g:ulti_color_quick_add is set, also adds font to 'global' favorites.
" If g:ulti_color_quick_add is not set, only adds to 'global' if the
" font is already in the filetype favorites.
function! s:AddFontFavorite()
    let name = &guifont
    if g:ulti_color_filetype
        " Adds to filetype favorites
        let ft = &filetype
        if ft !=# ''
            if !has_key(s:font_favorites, ft)
                let s:font_favorites[ft] = []
            endif
            if index(s:font_favorites[ft], name) == -1
                call add(s:font_favorites[ft], name)
                if g:ulti_color_verbose
                    echo "'" . name . "' added to " . ft . " favorites."
                endif
                if g:ulti_color_quick_add == 0
                    return 0
                endif
            elseif g:ulti_color_verbose
                echo "'" . name . "' already in " . ft . " favorites."
            endif
        endif
    endif

    if !has_key(s:font_favorites, 'global')
        let s:font_favorites['global'] = []
    endif
    if index(s:font_favorites['global'], name) == -1
        call add(s:font_favorites['global'], name)
        if g:ulti_color_verbose
            echo "'" . name . "' added to global favorites."
        endif
    elseif g:ulti_color_verbose
        echo "'" . name . "' already in global favorites."
    endif
    return 0
endfunction
" END AddFontFavorite }}}

" s:RemoveFontFavorite() {{{
" Removes a the current scheme from the favorites list from the given filetype.
" If g:ulti_color_quick_remove is set, will also remove from global favorites.
" If g:ulti_color_quick_remove is not set, will only remove from global
" favorites if it is not currently in the filetype favorites.
function! s:RemoveFontFavorite()
    let name = &guifont
    let ft = &filetype
    if has_key(s:font_favorites, ft) && index(s:font_favorites[ft], name) != -1
        unlet s:font_favorites[ft][index(s:font_favorites[ft], name)]
        if g:ulti_color_verbose
            echo "'" . name . "' removed from " . ft . " favorites."
        endif
        if g:ulti_color_quick_remove == 0
            return 0
        endif
    elseif g:ulti_color_verbose
        echo "'" . name . "' wasn't in " . ft . " favorites."
    endif
    if has_key(s:font_favorites, 'global') &&
                \ index(s:font_favorites['global'], name) != -1
        unlet s:font_favorites['global'][index(s:font_favorites['global'], name)]
        if g:ulti_color_verbose
            echo "'" . name . "' removed from global favorites."
        endif
    elseif g:ulti_color_verbose
        echo "'" . name . "' wasn't in global favorites."
    endif
    return 0
endfunction
" END RemoveFontFavorite }}}

" s:CycleFontFileFavorites() {{{
" Steps one by one through font favorites. Checks if the current filetype has
" it's own favorites list and uses that. If filetype doesn't have favorites,
" cycles through global favorites instead. Returns 0 if no problem or -1 if
" no favorites are set.
" If the second argument is set to 1, defaults to global list.
function! s:CycleFontFileFavorites(step, ...)
    if a:step != 1 && a:step != -1
        return -1
    endif

    " Set filetype to current or global
    let filetype = &filetype
    " If filetype explicitly ignored
    if g:ulti_color_filetype == 0 || (a:0 == 1 && a:1 == 1)
        let filetype = 'global'
    " If no favorites for filetype
    elseif !has_key(s:font_favorites, filetype) || len(s:font_favorites[filetype]) == 0
        let filetype = 'global'
    endif

    " Return early if no favorites set
    if len(s:font_favorites[filetype]) == 0
        return -1
    endif

    let i = index(s:font_favorites[filetype], &guifont)
    " Check if last item and set it to index -1
    if i == len(s:font_favorites[filetype]) - 1 && a:step == 1
        let i = -1
    elseif i == 0 && a:step == -1
        let i = len(s:font_favorites[filetype])
    endif
    execute 'let &guifont = ' . "'" . s:font_favorites[filetype][i + a:step] . "'"
    if g:ulti_color_verbose
        redraw
        echo s:font_favorites[filetype][i + a:step]
    endif
    return 0
endfunction
" END CycleFontFileFavorites }}}

" s:CycleFontGlobalFavorites() {{{
" Steps through the global favorites list.
function! s:CycleFontGlobalFavorites(step)
    call <SID>CycleFontFileFavorites(a:step, 1)
endfunction
" END CycleFontGlobalFavorites() }}}

" s:MakeGuiMenu() {{{
function! s:MakeGuiMenu()
    :anoremenu Favorites.Browse\ Colorschemes.Next :call <SID>CycleAll(1)<CR>
    :anoremenu Favorites.Browse\ Colorschemes.Previous :call <SID>CycleAll(-1)<CR>

    if g:ulti_color_filetype
        :anoremenu Favorites.Favorite\ Colorschemes.Next\ Filetype-Specific :call <SID>CycleFileFavorites(1)<CR>
        :anoremenu Favorites.Favorite\ Colorschemes.Previous\ Filetype-Specific :call <SID>CycleFileFavorites(-1)<CR>
    endif
    :anoremenu Favorites.Favorite\ Colorschemes.Next\ Global :call <SID>CycleGlobalFavorites(1)<CR>
    :anoremenu Favorites.Favorite\ Colorschemes.Previous\ Global :call <SID>CycleGlobalFavorites(-1)<CR>
    :menu Favorites.Favorite\ Colorschemes.-Colorscheme- :
    :anoremenu Favorites.Favorite\ Colorschemes.Add\ to\ Favorites :call <SID>AddFavorite()<CR>
    :anoremenu Favorites.Favorite\ Colorschemes.Remove\ from\ Favorites :call <SID>RemoveFavorite()<CR>

    if g:ulti_color_font_enable
        if g:ulti_color_filetype
            :anoremenu Favorites.Favorite\ Fonts.Next\ Filetype-Specific :call <SID>CycleFontFileFavorites(1)<CR>
            :anoremenu Favorites.Favorite\ Fonts.Previous\ Filetype-Specific :call <SID>CycleFontFileFavorites(-1)<CR>
        endif
        :anoremenu Favorites.Favorite\ Fonts.Next\ Global :call <SID>CycleFontGlobalFavorites(1)<CR>
        :anoremenu Favorites.Favorite\ Fonts.Previous\ Global :call <SID>CycleFontGlobalFavorites(-1)<CR>
        :menu Favorites.Favorite\ Fonts.-Font- :
        :anoremenu Favorites.Favorite\ Fonts.Add\ Font\ to\ Favorites :call <SID>AddFontFavorite()<CR>
        :anoremenu Favorites.Favorite\ Fonts.Remove\ Font\ from\ Favorites :call <SID>RemoveFontFavorite()<CR>
    endif

    :anoremenu Favorites.Manual\ Save/Load.Load\ Colorscheme\ Favorites<Tab> :call <SID>LoadFavorites()<CR>
    :anoremenu Favorites.Manual\ Save/Load.Save\ Colorscheme\ Favorites<Tab> :call <SID>WriteFavorites()<CR>
    :anoremenu Favorites.Manual\ Save/Load.Load\ Font\ Favorites<Tab> :call <SID>LoadFontFavorites()<CR>
    :anoremenu Favorites.Manual\ Save/Load.Save\ Font\ Favorites<Tab> :call <SID>WriteFontFavorites()<CR>
    :menu Favorites.-Read/Write- :

    :anoremenu Favorites.See\ Favorites :call <SID>SeeFavorites()<CR>
endfunction

" END MakeGuiMenu }}}
" END Script Functions }}}

" Auto Commands {{{
" Automatically called on startup {{{
call <SID>GetAllColors()
if g:ulti_color_auto_load
    call <SID>LoadFavorites()
    if has('gui_running')
        if g:ulti_color_font_enable
            call <SID>LoadFontFavorites()
        endif
        if g:ulti_color_gui_menu
            call <SID>MakeGuiMenu()
        endif
    endif
endif
" END Automatic calls }}}

" Automatically called on quit {{{
augroup UltiVimColor
    autocmd!
    if g:ulti_color_auto_save
        autocmd BufWinLeave * :call <SID>WriteFavorites()
        if has('gui_running') && g:ulti_color_font_enable
            autocmd BufWinLeave * :call <SID>WriteFontFavorites()
        endif
    endif
augroup END
" END Automatic called on quit }}}

" Automatically called on buffer enter {{{
" Used for automatic colorscheme choosing,
" A setting of 1 means Random is called everytime.
" A setting of 2 means Random is called when changing filetypes.
" A setting of 0 means Random is called only if the current scheme isn't in 
" the favorites list for the specific filetype.
augroup UltiVimAutoScheme
    autocmd!
    if g:ulti_color_always_random == 1
        autocmd BufEnter * call <SID>RandomFavorite()
        if has('gui_running') && g:ulti_color_font_enable
            autocmd BufEnter * call <SID>RandomFontFavorite()
        endif
    elseif g:ulti_color_always_random == 2
        autocmd BufEnter * call <SID>SituationalRandomFavorite()
        if has('gui_running') && g:ulti_color_font_enable
            autocmd BufEnter * call <SID>SetFontFavorite()
        endif
    else
        autocmd BufEnter * call <SID>SetFavorite()
        if has('gui_running') && g:ulti_color_font_enable
            autocmd BufEnter * call <SID>SetFontFavorite()
        endif
    endif
augroup END
" END Automatic called on buffer enter }}}
" END Auto Commands }}}
