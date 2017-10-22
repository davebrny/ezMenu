# ezMenu

![](example/screenshot.png)

&nbsp;

## parameters

```
ezMenu("menu_name", menu_text [, modify_func])
```

#### menu_name  

the name of the menu that all items will be added to. &nbsp;if there is no label/subroutine stated in the menu text then the menu name will become the default label that will run when a menu item is clicked  


#### menu_text  

a string containing menu text or the path of a file that contains menu text.  
the file types that menu text can be read from are: `.txt`, `.menu` and `.menu.ahk`  


#### modify_func  

the name of the function that will run just before the menu text is parsed. &nbsp;this is used for changing the menu text in some way such as replacing the names of variables with their actual contents

> run the file [**example.ahk**](example/example.ahk) to see some examples of the above parameters in use   


&nbsp;


## syntax

#### sub-menu

```
level 1.1
    level 2.1 sub-menu
    level 2.2
level 1.2
level 1.3
```
any text that is indented by 1 tab or 4 spaces will become a sub-menu.


#### separator  
lines that contain only 3 dashes `---` will become menu separators


#### labels / subroutines  

putting an exclamation mark on either side of a label name will set that as the default label for the current item and every item below it:  

`item text    !default_label_name!`  

this can also be used on a line on its own so its not tied to any item:  

`!default_label_name!`  

to change the label for the current item only then put one exclamation on the left:

`item text    !another_label_name`

in both cases, if the label exists then `!` + label name text will be removed

> _note: if no label names are stated in the menu text then the menu name used in parameter 1 will become the default label_

#### disable an item  
`.item text`  

start the line with a full stop to have the item disabled (greyed out)


#### default item  
`*item text`  

start the line with an asterick to set the item as the default (bold text)


#### comments  
lines with a semi-colon at the start will be ignored.  
*(at the moment its not possible to comment out a parent menu item and have all its sub items ignored)*  

`item text    ; comment explaining the item`

if you want to have comments after an item then use the `item_mod()` function in [example.ahk](example/example.ahk) to strip them out once the item is clicked
