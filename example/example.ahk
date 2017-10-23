#noEnv
#singleinstance, force
sendMode input
setWorkingDir, % a_scriptDir
return ; end of auto-execute




    ; example of basic yes/no confirmation pop-up
!1::ezMenu("menu_name", ".continue? `n--- `nyes `nno")

    ; if the menu text contains only 1 line then | can be used for better readability
; !1::ezMenu("menu_name", ".continue? | --- | yes | no")



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
ezMenu("indentation", example_text)
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
return    ; the menu name "send_text" is used as the default label



!4::    ; custom label names syntax
example_text = 
(
!label_a!    ; set label_a as the default for every item below
item a1
             ; set label_b for a single item
item b1   !label_b
item a2
             ; change the default to label_c
item c1   !label_c!
item c2
item c3
)
ezMenu("set labels", example_text)
return    ; this menu name isnt being used as a label so it can have spaces



!5::    ; get menu text from file
ezMenu("syntax", "example.menu")                  ; if file is in the working directory
; ezMenu("syntax", path_to_file "\example.menu")  ; otherwise specify the full path
return                                            ; file types: .txt | .menu | .menu.ahk


; ------------------------------


menu_name:
indentation:
item := item_mod(a_thisMenuItem)    ; remove comments and the first &
if (item = "yes")
     msgBox, label:  %a_thisLabel% `n`nyou chose "yes"
else msgBox, label:  %a_thisLabel% `n`nyou chose "%item%"
return


send_text:
item := item_mod(a_thisMenuItem)
send % item
item_select(item)    ; select brackets
return


label_a:
label_b:
label_c:
msgBox, % a_thisLabel "`n" a_thisMenuItem
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