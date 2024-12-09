#!/bin/sh
#### Original script by: raexera. Edited by: Areia Night

workspaces() {

    # Nombres de workspaces
    ws1="I"
    ws2="II"
    ws3="III"
    ws4="IV"
    ws5="V"
    ws6="VI"

    # Clases por defecto
    class1="ws-unoccupied"
    class2="ws-unoccupied"
    class3="ws-unoccupied"
    class4="ws-unoccupied"
    class5="ws-unoccupied"
    class6="ws-unoccupied"

    # Verifica si están ocupados
    [ "$(bspc query -D -d .occupied --names | grep "$ws1")" ] && class1="ws-occupied"
    [ "$(bspc query -D -d .occupied --names | grep "$ws2")" ] && class2="ws-occupied"
    [ "$(bspc query -D -d .occupied --names | grep "$ws3")" ] && class3="ws-occupied"
    [ "$(bspc query -D -d .occupied --names | grep "$ws4")" ] && class4="ws-occupied"
    [ "$(bspc query -D -d .occupied --names | grep "$ws5")" ] && class5="ws-occupied"
    [ "$(bspc query -D -d .occupied --names | grep "$ws6")" ] && class6="ws-occupied"

    # Verifica si están enfocados
    [ "$(bspc query -D -d focused --names | grep "$ws1")" ] && class1="ws-focused"
    [ "$(bspc query -D -d focused --names | grep "$ws2")" ] && class2="ws-focused"
    [ "$(bspc query -D -d focused --names | grep "$ws3")" ] && class3="ws-focused"
    [ "$(bspc query -D -d focused --names | grep "$ws4")" ] && class4="ws-focused"
    [ "$(bspc query -D -d focused --names | grep "$ws5")" ] && class5="ws-focused"
    [ "$(bspc query -D -d focused --names | grep "$ws6")" ] && class6="ws-focused"

    # Genera el contenido para Eww
    echo "(box :class \"workspaces\" \
        :orientation \"h\" \
        :halign \"start\" \
        :valign \"start\" \
        :space-evenly \"true\" \
        :spacing \"10\" \
        (button :onclick \"bspc desktop -f $ws1\" :class \"$class1\" \"\") \
        (button :onclick \"bspc desktop -f $ws2\" :class \"$class2\" \"\") \
        (button :onclick \"bspc desktop -f $ws3\" :class \"$class3\" \"\") \
        (button :onclick \"bspc desktop -f $ws4\" :class \"$class4\" \"\") \
        (button :onclick \"bspc desktop -f $ws5\" :class \"$class5\" \"\") \
        (button :onclick \"bspc desktop -f $ws6\" :class \"$class6\" \"\"))"
}

# Ejecuta la función una vez para inicializar
workspaces

# Actualiza automáticamente cada vez que cambien los desktops
bspc subscribe desktop node_transfer | while read -r _; do
    workspaces
done
