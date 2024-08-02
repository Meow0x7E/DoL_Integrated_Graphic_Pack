function buildImgFileListFile() {
    typeset log_header="${log_header}[buildImgFileListFile]"
    log i "构建 ${1}..."
    typeset -a list=(img.d/${1}/img/**/*(.))

    list=(${list#"img.d/${1}/"})
    list=(${list/#/\\t\"})
    list=(${list/%/\",})
    list[-1]=${list[-1]/%,/}

    log i "输出到 img.d/${1}/imgFileList.json"
    print -x 1 -l -n '[' $list ']' > img.d/${1}/imgFileList.json

    additionFileBuf+="img.d/${1}/imgFileList.json"
    additionDirBuf+="img.d/${1}/img"
}
