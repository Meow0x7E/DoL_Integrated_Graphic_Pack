#!/usr/bin/zsh

typeset version='0.2.0.1'
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

typeset -a ModeListData=(
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
typeset -a includeFile=()

for i ({$#ModeListData..1}) {
    typeset -a array=(${(s:;:)${ModeListData[${i}]}})
    ModeListFromName+=${array[1]}
    ModeList[${array[1]},from]=$array[3]
}

mkdir -p out

function runTasks() {
    typeset -a EnableList=()
    for i ({$#1..1}) {
        if [[ ${1[${i}]} == 1 ]] {
            EnableList+=${ModeListFromName[-${i}]}
        }
    }

    rm -r build
    mkdir -p build/img.d

    for task (task.d/*) {
        typeset log_header="[Task][$(print ${task:t:r} | sed -n -E -e 's/^[0-9]+_//p' )]"
        if [[ ${task:e} == 'task-collect' ]] {
            for func (${task}/func.d/*) { source $func }
            source ${task}/consum.zsh
            for func (${task}/func.d/*) { unfunction ${func:t:r} }
        } else {
            source ${task}
        }
    }

    typeset log_header="[Package]"
    log i "开始打包..."
    (
        typeset filePath="../out/DoL_Integrated_Graphic_Pack-v${version}-${1}.mod.zip"
        cd build
        [[ -f ${filePath} ]] && rm $filePath
        zip -JqrX9 ${filePath} $includeFile
    )
}

runTasks "11111111"
