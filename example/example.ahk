#noEnv
#singleinstance, force
sendMode input
setWorkingDir, % a_scriptDir
return ; end of auto-execute





!1::ezMenu("label_name", "one `ntwo `nthree")


!2::
example_text = 
(
level 1.1
    level 2.1    ; comment
    level 2.2
        level 3.1
    level 2.3
level 1.2
    level 2.&1
    level 2.&2
)
ezMenu("label_name", example_text)
return


!3::
ezMenu("label_name", a_scriptDir "\example.menu", "menu_mod")
; ezMenu("label_name", "example.menu", "menu_mod")
return


; ------------------------------


label_name:
item := item_mod(a_thisMenuItem)
send % item
item_select(item)
return


label_b:
msgBox, you clicked %a_thisMenuItem%
return


menu_mod(menu_txt) {    ; modify menu text before menu creation
    for what, with in {  "%a_userName%"     : a_userName
                      ,  "%a_computerName%" : a_computerName
                      ,  "%a_appData%"      : a_appData      }
        stringReplace, menu_txt, menu_txt, % what, % with, all
    return menu_txt
}


item_mod(item) {    ; modify item text before sending
    item := regExReplace(item, "^;.*$|\s+;.*$")    ; remove comments
    ; stringReplace, item, item, &, , all
    return item
}


item_select(item) {    ; highlight text that has [brackets]
    if inStr(item, "[") and if inStr(item, "]")
        {
        stringGetPos, pos, item, ]
        stringMid, bracket_end, item, pos + 2
        stringGetPos, pos, item, [
        stringMid, bracket_start, item, pos + 1
        end_pos := strLen(bracket_end)
        select  := strLen(bracket_start) - end_pos
        send {left %end_pos%}
        sleep 100
        send +{left %select%}
        }
}


#include, %a_scriptDir%\..\ezMenu.ahk