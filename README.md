# SDKCI
Pack Static Library with Shell

此shell可配合jenkins + fastlane 自动化打包SDK
fastlane 中

```ruby
lane :packsdk do
	sh "bash ./packsdk.sh"
end
```

打包 iOS SDK
暂时仅支持 static library， 暂不支持 framework，可自行修改

打包后会文件会放在工程目录build文件夹

|参数|说明|
|---|---|
|CONFIGURATION|release/debug|
|SDK_DIR_NAME|打包后的SDK存放文件夹名称|
|SDK_PATH|项目中存放SDK文件的文件夹地址，比如头文件、资源文件|
|SCHEME_NAME|SDK名， 支持多个，空格隔开|