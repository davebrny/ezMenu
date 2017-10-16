#noEnv
#singleinstance, force
sendMode input
setWorkingDir, % a_scriptDir
return ; end of auto-execute




    ; example of basic yes/no confirmation pop-up
!1::ezMenu("label_name", ".continue? `n--- `nyes `nno")


!2::    ; indentation example
example_text = 
(
level 1.1
    level 2.1    ; comment
    level 2.2
        level 3.1
    level 2.3
level 1.2
    level 2.&1    ; underline the character after &&
    level 2.&2
)
ezMenu("label_name", example_text)
return



!3::
example_text = 
(
.replace text with variables
%a_userName%
%a_computerName%
%a_appData%
---
.select brackets after text is sent
msgBox, [msg]
[[text]](link)
git commit -a -m "[message]"
)
ezMenu("send_text", example_text, "menu_mod")
return



!4::    ; get menu text from file
ezMenu("menu_return", a_scriptDir "\example.menu")
; ezMenu("menu_return", "example.menu", "menu_mod")    ; or use working directory
return


; ------------------------------


label_name:
item := item_mod(a_thisMenuItem)    ; remove comments and the first &
if (item = "yes")
     msgBox, you chose "yes"
else msgBox, you chose "%item%"
return


send_text:
item := item_mod(a_thisMenuItem)
send % item
item_select(item)    ; select brackets
return


menu_return:
return    ; do nothing


; ------------------------------


menu_mod(menu_txt) {    ; modify all menu text before menu creation
    for what, with in {  "%a_userName%"     : a_userName
                      ,  "%a_computerName%" : a_computerName
                      ,  "%a_scriptDir%"    : a_scriptDir
                      ,  "%a_appData%"      : a_appData      }
        stringReplace, menu_txt, menu_txt, % what, % with, all
    return menu_txt
}


item_mod(item) {    ; modify item text after item is clicked
    item := regExReplace(item, "^;.*$|\s+;.*$")    ; remove comments
    stringReplace, item, item, &
    return item
}


item_select(item) {    ; highlight text that has [brackets]
    if inStr(item, "[") and if inStr(item, "]")
        {
        stringGetPos, pos, item, ]
        stringMid, bracket_end, item, pos + 2
        stringGetPos, pos, item, [, R1
        stringMid, bracket_start, item, pos + 1
        end_pos := strLen(bracket_end)
        select  := strLen(bracket_start) - end_pos
        send {left %end_pos%}
        sleep 100
        send +{left %select%}
        }
}


#include, %a_scriptDir%\..\ezMenu.ahk