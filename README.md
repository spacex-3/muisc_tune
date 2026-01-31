# TuneHub Subsonic Proxy

一个将 TuneHub 音乐 API 转换为 Subsonic 协议的代理服务器，让你可以使用任何支持 Subsonic 协议的音乐播放器（如音流、Symfonium、Ultrasonic 等）来播放网易云音乐和 QQ 音乐。

## ✨ 特性

- 🎵 **多平台支持** - 网易云音乐、QQ音乐
- � **Subsonic 兼容** - 支持所有 Subsonic 协议播放器
- 🎨 **封面自动获取** - 搜索结果和播放列表都有封面
- 📝 **歌词支持** - 自动获取并显示歌词
- 💾 **本地音频缓存** - 听过的歌曲保存到本地，再次播放不消耗 API 积分
- 🎼 **高品质支持** - 支持 128k/320k/FLAC/FLAC 24bit
- ⚡ **智能缓存** - 歌曲元数据、URL、音频文件多级缓存

## � 前置要求

1. **TuneHub API Key** - 从 [TuneHub](https://tunehub.sayqz.com) 获取
2. **Python 3.8+**
3. **Subsonic 兼容播放器** - 推荐 [音流](https://apps.apple.com/app/id1517694605)

## 🚀 安装

```bash
# 克隆项目
git clone https://github.com/YOUR_USERNAME/muisc_tune.git
cd muisc_tune

# 创建虚拟环境
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 安装依赖
pip install -r requirements.txt

# 配置环境变量
cp .env.example .env
# 编辑 .env 填入你的 TuneHub API Key
```

## 🐳 Docker 部署

### 使用 Docker Compose (推荐)

```bash
# 创建目录
mkdir -p config cache

# 创建 .env 文件
cat > .env << EOF
TUNEHUB_API_KEY=your_api_key_here
SUBSONIC_USER=admin
SUBSONIC_PASSWORD=admin
DEFAULT_QUALITY=flac
AUDIO_CACHE_MAX_SIZE=10737418240
EOF

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f
```

### 使用 Docker 命令

```bash
docker run -d \
  --name tunehub-proxy \
  -p 4040:4040 \
  -e TUNEHUB_API_KEY=your_api_key_here \
  -e SUBSONIC_USER=admin \
  -e SUBSONIC_PASSWORD=admin \
  -e DEFAULT_QUALITY=flac \
  -e AUDIO_CACHE_MAX_SIZE=10737418240 \
  -v ./config:/app/config \
  -v ./cache:/app/cache \
  ghcr.io/spacex-3/music_tune:latest
```

### 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `TUNEHUB_API_KEY` | TuneHub API Key (必填) | - |
| `SUBSONIC_USER` | Subsonic 用户名 | admin |
| `SUBSONIC_PASSWORD` | Subsonic 密码 | admin |
| `DEFAULT_QUALITY` | 默认音质 (128k/320k/flac/flac24bit) | flac |
| `AUDIO_CACHE_MAX_SIZE` | 缓存大小限制 (字节) | 10737418240 (10GB) |

### 挂载目录

| 路径 | 说明 |
|------|------|
| `./config:/app/config` | 配置文件目录 |
| `./cache:/app/cache` | 缓存目录 (音频/数据/日志) |

### 镜像地址

```
ghcr.io/spacex-3/music_tune:latest
```

## ⚙️ 配置

编辑 `.env` 文件：

```bash
# TuneHub API Key (必填)
TUNEHUB_API_KEY=your_api_key_here

# Subsonic 认证 (用于连接播放器)
SUBSONIC_USER=admin
SUBSONIC_PASSWORD=admin

# 默认平台: netease | qq | kuwo
DEFAULT_PLATFORM=netease

# 默认音质: 128k | 320k | flac | flac24bit
DEFAULT_QUALITY=flac

# 服务器设置
SERVER_HOST=0.0.0.0
SERVER_PORT=4040

# 音频缓存大小限制 (默认 10GB)
AUDIO_CACHE_MAX_SIZE=10737418240
```

## 🎮 使用

### 启动服务器

```bash
source venv/bin/activate
python server.py
```

服务器将在 `http://0.0.0.0:4040` 启动。

### 配置播放器

以音流 (Musiver) 为例：

1. 添加服务器
2. 服务器地址: `http://你的IP:4040`
3. 用户名: `admin` (对应 SUBSONIC_USER)
4. 密码: `admin` (对应 SUBSONIC_PASSWORD)

### 功能说明

| 功能 | 说明 |
|-----|------|
| 歌单 | 显示热搜榜单，点击查看歌曲列表 |
| 搜索 | 同时搜索网易云和QQ音乐，结果带平台前缀 |
| 播放 | 自动获取高品质音源，后台下载到本地缓存 |
| 封面 | 自动获取并显示专辑封面 |
| 歌词 | 自动获取并同步显示歌词 |

## 📁 项目结构

```
muisc_tune/
├── server.py           # 主服务器 (Flask)
├── tunehub_client.py   # TuneHub API 客户端
├── subsonic_formatter.py # Subsonic XML 格式化
├── config.py           # 配置管理
├── .env.example        # 环境变量示例
├── requirements.txt    # Python 依赖
└── cache/
    └── audio/          # 本地音频缓存目录
```

## 🔧 API 积分使用

| 操作 | 积分消耗 |
|-----|---------|
| 搜索 | 0 积分 |
| 播放列表 | 0 积分 |
| 获取封面/歌词 | 0 积分 |
| **首次播放歌曲** | **1 积分** |
| 30分钟内重播 | 0 积分 (URL缓存) |
| 本地缓存命中 | 0 积分 (永久) |

## 📝 日志说明

```
[LOCAL CACHE HIT]  - 从本地文件播放 (0积分)
[URL CACHE HIT]    - 使用缓存URL (0积分)
[API CALL - 1 CREDIT] - 调用TuneHub获取新URL (1积分)
[DOWNLOAD]         - 后台下载到本地缓存
```

## 🐛 常见问题

**Q: 搜索没有结果？**
A: 检查 TuneHub API Key 是否正确配置。

**Q: 播放失败？**
A: 检查服务器日志，确认 TuneHub 账户有足够积分。

**Q: 封面不显示？**
A: 首次播放后封面会被缓存，刷新列表即可显示。

## 📄 License

MIT License

## 🙏 致谢

- [TuneHub](https://tunehub.sayqz.com) - 音乐 API 服务
- [Subsonic](http://www.subsonic.org/) - 音乐流媒体协议
