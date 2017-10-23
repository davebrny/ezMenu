/*
[script info]
version     = 1.2.1
description = easy menu creation using indentation and markdown-like syntax
ahk version = 1.1.26.01
author      = davebrny
source      = https://github.com/davebrny/ezMenu
*/

ezMenu_init:
global menu_created, default_label, default_item, disabled_item, tab_width, s_tab
default_label := ""
tab_width = 4
loop, % tab_width
    s_tab .= a_space
return


ezMenu(menu_name, string_or_file, modify_func="") {
    goSub, ezMenu_init

    if fileExist(string_or_file)
         menu_text := ezMenu_get(string_or_file)
    else menu_text := trim(string_or_file, "`n")
    if (menu_text = "")
        error_return("""" menu_name """ menu is empty")

    if !inStr(menu_text, "`n") and inStr(menu_text, "|") 
        stringReplace, menu_text, menu_text, |, `n, all

    if isFunc(modify_func)
        menu_text := %modify_func%(menu_text)

    loop, parse, menu_text, `n, `r
        {
        if a_loopfield is space
            continue    ; if whitespace or empty
        if (inStr(LTrim(a_loopfield), ";") = 1)
            continue    ; if commented
        line_text := a_loopfield
        menu_level(line_text, level)    ; (byRef: line_text, level)
        error_check(line_text, level, a_index)
        menu_add(menu_name, line_text, level)
        }
    menu_created := true

    menu, % menu_name, show
    menu, % menu_name, delete
}



ezMenu_get(filepath) {
    fileRead, contents, % filepath
    stringReplace, contents, contents, `r`n, `n, all
    if (subStr(filepath, -8, 9) = ".menu.ahk")
        {
        if !inStr(contents, "[ezMenu]")
            error_return("[ezMenu] not found")
        else if !inStr(contents, "[ezMenu_end]")
            error_return("[ezMenu_end] not found")
        stringGetPos, pos, contents, [ezMenu], L1
        stringMid, right_text, contents, pos + 9
        stringGetPos, pos, right_text, [ezMenu_end], L1
        stringMid, menu_text, right_text, pos, , L
        }
    else menu_text := contents
    return trim(menu_text, "`n")
}



error_return(msg) {
    msgBox, % msg
    exit
}



menu_level(byRef line_text, byRef level) {
    line_text   := rTrim(line_text)
    line_text   := strReplace(line_text, a_tab, s_tab)   ; replace tabs with spaces
    replaced    := line_text
    line_text   := LTrim(line_text)
    white_space := strLen(replaced) - strLen(line_text)  ; (whitespace count before text)
    level       := (white_space // tab_width) + 1        ; use floor divide to move incorrectly indented item up or down 1 level
}



error_check(line_text, level, line_number) {
    static last_level

    if (line_number = 1)
        last_level := "0"

    if (level > 21)
        error_return("Error on menu line " line_number " `n" line_text " `n`n"
            . "Maximum levels allowed: 21")

    if (level > last_level) and (level > last_level + 1)
        error_return("Error on menu line " line_number " `n" line_text " `n`n"
            . "Item has no parent menu")

    last_level := level
}



menu_add(menu_name, item_name, menu_level) {
    if (menu_level = "")
        menu_level := "1"
    if (default_label = "")
        default_label := menu_name
    item_label := default_label

        ;# default menu item
    if (inStr(LTrim(item_name), "*") = 1)
        {
        stringTrimLeft, item_name, item_name, 1
        default_item := true
        }
        ;# disable menu item
    if (inStr(LTrim(LTrim(item_name, "*")), ".") = 1)
        {
        stringTrimLeft, item_name, item_name, 1
        disabled_item := true
        }

        ;# custom label action
    item_name := LTrim(item_name)
    if instr(item_name, "!")
        {
        loop, parse, % item_name, !, % a_space
            {
            if (a_index = 1)
                continue
            first_word := strSplit(a_loopField, a_space)
            if isLabel(first_word[1])
                found_label := first_word[1]
            }
        until (found_label)
        if (found_label)
            {
            item_label := found_label
            if inStr(item_name, "!" found_label "!")     ; if setting a new global default
                {
                default_label := found_label
                if (inStr(item_name, "!" found_label "!") = 1)   ; if at start, then skip menu add
                    return
                item_name := strReplace(item_name, "!" found_label "!", "")
                }
            else if inStr(item_name, "!" found_label)    ; if setting a custom label for this line
                item_name := strReplace(item_name, "!" found_label, "")
            }
        item_name := trim(item_name)
        }

        ;# save value for later use
    save_value(item_name, menu_level)

        ;# add item to menu
    if (menu_level = 1)
        {
        if (trim(item_name) = "---")
            menu(menu_name, separator)
        last_menu := item_label
        }
    else if (menu_level > 1)
        {
        loop,    ; loop down through levels
            {
            sub_item    := stored_value("menu" menu_level)
            parent_item := stored_value("menu" menu_level - 1)
            item_action := (a_index = 1) ? (item_label) : (last_menu)
            if (trim(item_name) = "---") and (menu_created != true)
                menu(parent_item, separator)
            else if (trim(item_name) != "---")
                menu(parent_item, sub_item, item_action)
            last_menu := ":" parent_item
            --menu_level
            }
        until (menu_level = 1)
        }

        ;# add final root level (level 1)
    final_menu := stored_value("menu" menu_level)
    if (trim(item_name) != "---")
        menu(menu_name, final_menu, last_menu)

    disabled_item := ""
    item_label    := ""
}   ; end of menu_add()



save_value(item_name, menu_level) {
    global
    menu%menu_level% := item_name
}


stored_value(name) {
    stored_value := %name%
    return stored_value
}


menu(menu, item="", action="") {
    menu, % menu, add, % item, % action
    if (disabled_item = true)
        menu, % menu, disable, % item
    if (default_item = true)
        menu, % menu, default, % item
    disabled_item := ""
    default_item  := ""
}