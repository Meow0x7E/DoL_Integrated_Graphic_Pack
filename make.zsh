#!/usr/bin/zsh

typeset log_header="[make]"
typeset -A Log=()

#[AutomaticDerive]
Log[n,level]='Noice'
#[AutomaticDerive]
Log[i,level]='Info'
#[AutomaticDerive]
Log[w,level]='Warn'
#[AutomaticDerive]
Log[e,level]='Error'
#[AutomaticDerive]
Log[f,level]='Fail'

# 决定每个日志级别的颜色
# 详见 https://www.detailedpedia.com/wiki-ANSI_escape_code#3-bit_and_4-bit
# Set the color of each log level
# See https://www.detailedpedia.com/wiki-ANSI_escape_code#3-bit_and_4-bit
Log[n,color]=35
Log[i,color]=37
Log[w,color]=33
Log[e,color]=31
Log[f,color]=91

Log[show]="n,i,w,e,f"

function log() {
    (( ${(s:,:)${Log[show]}[(I)${1}]} )) \
    && print -u 2 -f "[%s;1m[%s]%s: %s[0m\n" $Log[$1,color] $Log[$1,level] $log_header $2
}

typeset -ar ModeListData=(
    # 游戏原版图片包
    'GameOriginalImagePack;1'
    # BEEESSS 美化
    'Degrees of Lewdity Graphics Mod;1;https://gitgud.io/BEEESSS/degrees-of-lewdity-graphics-mod'
    # BEEESSS 社区补充
    'BEEESSS Community Sprite Compilation;1;https://gitgud.io/Kaervek/kaervek-beeesss-community-sprite-compilation'
    # BEEESSS 基本身体重新着色
    'BEEESSS Wax;1;https://gitgud.io/GTXMEGADUDE/beeesss-wax'
    # 战斗美化
    '通用战斗美化;1;https://github.com/site098/mysterious'
    # BJ 特写
    'Saver Meal;1;https://gitgud.io/GTXMEGADUDE/double-cheeseburger'
    # 庫褲子BJ美化包髮型擴充
    'DOL_BJ_hair_extend;1;https://github.com/zubonko/DOL_BJ_hair_extend'
    # 庫褲子BJ美化包刺青擴充
    'Tattoo;1;https://github.com/zubonko/DOL_BJ_hair_extend'
)

typeset -a ModeListFromName=()
typeset -A ModeList=()

typeset -a includeFile=(
    'README.json'
    'boot.json'
)
typeset -a additionFileBuf=()
typeset -a additionBinaryFileBuf=()
typeset -a additionDirBuf=()
typeset -a typeBuf=()

for i ({$#ModeListData..1}) {
    typeset -a array=(${(s:;:)${ModeListData[${i}]}})
    ModeListFromName+=${array[1]}
    ModeList[${array[1]},enable]=$array[2]
    ModeList[${array[1]},from]=$array[3]
}

print "# DoL_Integrated_Graphic_Pack\n" > README.md

for i ({$#ModeListFromName..1}) {
    typeset name=${ModeListFromName[${i}]}
    print "\- ${name}
\- from: ${ModeList[${name},from]}
" >> README.md
}

#print -a -C 2 ${(kv)ModeList}

function genImgFileListFile() {
    typeset log_header="[genImgFileListFile]"
    log i "构建 ${1}..."
    typeset -a list=(img.d/${1}/img/**/*(.))

    list=(${list#"img.d/${1}/"})
    list=(${list/#/\\t\"})
    list=(${list/%/\",})
    list[-1]=${list[-1]/%,/}

    log i "输出到 imgFileListFile.d/${1}.json"
    print -x 1 -l -n '[' $list ']' > img.d/${1}/imgFileList.json

    additionFileBuf+="img.d/${1}/imgFileList.json"
    additionDirBuf+="img.d/${1}/img"
}

function genType() {
    typeset log_header="[genType]"
    typeBuf+="\t\t\t\t\t{
\t\t\t\t\t\t\"type\": \"${1}\",
\t\t\t\t\t\t\"imgFileListFile\": \"img.d/${1}/imgFileList.json\"
\t\t\t\t\t},"
    log i "已加入 ${1} 到缓冲区"
}

#genType $ModeListFromName[1]

for name (${ModeListFromName}) {
    genImgFileListFile $name
    genType $name
}

log i "开始合并缓冲区..."

typeBuf[-1]="${typeBuf[-1]/%,/}"

includeFile+=($additionFileBuf)
includeFile+=($additionBinaryFileBuf)
includeFile+=(${additionDirBuf/%/'/'})

additionFileBuf=(${additionFileBuf/#/"\t\t\""})
additionFileBuf=(${additionFileBuf/%/\",})
additionFileBuf[-1]="${additionFileBuf[-1]/%,/}"

additionBinaryFileBuf=(${additionBinaryFileBuf/#/"\t\t\""})
additionBinaryFileBuf=(${additionBinaryFileBuf/%/\",})
additionBinaryFileBuf[-1]="${additionBinaryFileBuf[-1]/%,/}"

additionDirBuf=(${additionDirBuf/#/"\t\t\""})
additionDirBuf=(${additionDirBuf/%/\",})
additionDirBuf[-1]="${additionDirBuf[-1]/%,/}"


typeset -a bootBuf=(
    "{"
    "\t\"name\": \"DoL_Integrated_Graphic_Pack\","
    "\t\"version\": \"0.1.0\","
    "\t\"styleFileList\": [],"
    "\t\"scriptFileList\": [],"
    "\t\"tweeFileList\": [],"
    "\t\"imgFileList\": [],"
    "\t\"additionFile\": ["
)
bootBuf+=($additionFileBuf)
bootBuf+=(
    "\t],"
    "\t\"additionBinaryFile\": ["
)
bootBuf+=($additionBinaryFileBuf)
bootBuf+=(
    "\t],"
    "\t\"additionDir\": ["
)
bootBuf+=($additionDirBuf)
bootBuf+=(
    "\t],"
    "\t\"addonPlugin\": ["
    "\t\t{"
    "\t\t\t\"modName\": \"BeautySelectorAddon\","
    "\t\t\t\"addonName\": \"BeautySelectorAddon\","
    "\t\t\t\"modVersion\": \"^2.1.0\","
    "\t\t\t\"params\": {"
    "\t\t\t\t\"types\": ["
)
bootBuf+=($typeBuf)
bootBuf+=(
    "\t\t\t\t]"
    "\t\t\t}"
    "\t\t}"
    "\t],"
    "\t\"dependenceInfo\": ["
    "\t\t{"
    "\t\t\t\"modName\": \"ModLoader\","
    "\t\t\t\"version\": \"^2.18.3\""
    "\t\t},"
    "\t\t{"
    "\t\t\t\"modName\": \"GameVersion\","
    "\t\t\t\"version\": \"^0.5.0.6\""
    "\t\t},"
    "\t\t{"
    "\t\t\t\"modName\": \"BeautySelectorAddon\","
    "\t\t\t\"version\": \"^2.1.0\""
    "\t\t}"
    "\t]"
    "}"
)

log i "将缓冲区写入到文件"
print -x 1 -l -n $bootBuf > boot.json

log i "开始打包..."
#zip -r "../mods/DoL_Integrated_Graphic_Pack.mod.zip" $includeFile
