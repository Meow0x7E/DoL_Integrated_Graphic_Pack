typeset -a additionFileBuf=()
typeset -a additionBinaryFileBuf=()
typeset -a additionDirBuf=()
typeset -a typeBuf=()

for name (${EnableList}) { buildImgFileListFile $name }

for name (${EnableList}) { buildType $name }

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
    "\t\"version\": \"${version}\","
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
print -x 1 -l -n $bootBuf > build/boot.json

includeFile+='boot.json'
