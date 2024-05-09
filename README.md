# bilibili_nfo_yt-dlp_sh

## 概述

bilibili_nfo_yt-dlp_sh 是一个 Bash 脚本，用于将来自[yt-dlp](https://github.com/yt-dlp/yt-dlp)包含视频信息的 .info.json 文件转换为 Kodi 等多媒体中心软件支持的 .nfo 文件格式。该脚本支持从标题中提取标签，并添加到 .nfo 文件中。

请使用`yt-dlp --write-info-json`来生成对应的.info.json文件。
## 功能

- 解析 .info.json 文件并提取视频信息字段。
- 将 Unix 时间戳转换为 yyyy-mm-dd 格式的日期。
- 将标题中被【】包含的标签提取并添加到 .nfo 文件中。
- 支持从 .info.json 文件中提取的标签添加到 .nfo 文件中。
- 支持检测特定目录下的 .info.json 文件并进行批量处理。
- 支持测试模式，用于输出文件中的标签信息。
### 支持的数据来源
- [x] 处理来自bilibili的元数据。
- [ ] 处理来自YouTube的元数据。
## 用法

1. Clone 该仓库到本地。
```
git clone https://github.com/malang1726/bilibili_nfo_yt-dlp_sh.git
```

2. 进入项目目录。
```
cd bilibili_nfo_yt-dlp_sh
```

3. 赋予脚本执行权限。
```
chmod +x nfo.sh
```
3. 运行脚本并按照提示输入所需参数。
```
./nfo.sh
```
4. 根据提示选择平台并查看处理结果。

## 选项

- `-g`：检测标题中的标签并添加到 .nfo 文件中。
- `-t`：测试模式，用于输出文件中的标签信息，并且跳过输入目录直接指定当前目录。

## 注意事项

- 该脚本依赖于 jq 工具，确保已经安装。
```
apt install jq
```
- 请确保 .info.json 文件位于脚本指定的目录下。

## 示例

- 处理当前目录下的所有 .info.json 文件，并检测标题中的标签。
```
./nfo.sh -gt
```
## 许可证

此项目根据 MIT 许可证授权。有关更多信息，请参阅 [LICENSE](LICENSE) 文件。
