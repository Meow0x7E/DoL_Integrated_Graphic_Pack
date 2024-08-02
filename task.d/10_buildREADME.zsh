typeset -a readmeBuf=()
readmeBuf+="# DoL_Integrated_Graphic_Pack\n"

for i ({$#ModeListFromName..1}) {
    typeset name=${ModeListFromName[${i}]}
    readmeBuf+="\- ${name}"
    readmeBuf+="  \- from: ${ModeList[${name},from]}"
}

print -l $readmeBuf > build/README.md

includeFile+='README.md'
log i "Done"
