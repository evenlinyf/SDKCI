#本文件放在fastlane文件夹中， 所以先cd到有 .xcodeproject 文件的路径
cd ..

SDKBuildDate=`date +%Y%m%d%H%M`

CONFIGURATION="release"

#用于打包输出 SDK 的文件夹
SDK_DIR_NAME=SDKName${SDKBuildDate}

#项目中用于存放 SDK 文件的文件夹
SDK_PATH=./SDKFilePath

#输出路径
BUILD_DIR=build/SDKBuild${SDKBuildDate}
OUTPUT_DIR=${BUILD_DIR}/${SDK_DIR_NAME}

mkdir -p ${OUTPUT_DIR}

for SCHEME_NAME in "YFSDK1" "YFSDK2"
do

echo ${SCHEME_NAME}

LIBNAME="lib${SCHEME_NAME}.a"

IPHONEOS_DIR=${BUILD_DIR}/Build/Products/Release-iphoneos/${LIBNAME}
SIMULATOR_DIR=${BUILD_DIR}/Build/Products/Release-iphonesimulator/${LIBNAME}

xcodebuild \
OTHER_CFLAGS="-fembed-bitcode" \
GCC_GENERATE_DEBUGGING_SYMBOLS=NO \
-scheme ${SCHEME_NAME} \
-derivedDataPath ${BUILD_DIR} \
-configuration ${CONFIGURATION} \
-sdk iphoneos \
clean build

xcodebuild \
OTHER_CFLAGS="-fembed-bitcode" \
GCC_GENERATE_DEBUGGING_SYMBOLS=NO \
-scheme ${SCHEME_NAME} \
-derivedDataPath ${BUILD_DIR} \
-configuration ${CONFIGURATION} \
-sdk iphonesimulator \
build

#合并 SDK
lipo -create ${IPHONEOS_DIR} ${SIMULATOR_DIR} -output ${OUTPUT_DIR}/${LIBNAME}

done


#将 SDK 头文件以及资源文件复制到 SDK 文件夹中
cp -r ${SDK_PATH}/ ${OUTPUT_DIR}

#去除.svn 文件
find ${OUTPUT_DIR} -type d -name ".svn"|xargs rm -rf

#压缩.h .bundle .a
cd ${BUILD_DIR}
rm -rf *.zip
zip -r ${SDK_DIR_NAME}.zip ${SDK_DIR_NAME}
open ${SDK_DIR_NAME}/..
