function buildType() {
    typeset log_header="${log_header}[buildType]"
    typeBuf+="\t\t\t\t\t{
\t\t\t\t\t\t\"type\": \"${1}\",
\t\t\t\t\t\t\"imgFileListFile\": \"img.d/${1}/imgFileList.json\"
\t\t\t\t\t},"
    log i "已加入 ${1} 到缓冲区"
}
