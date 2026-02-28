# 禅意天气 🌤️

一个融合中国传统文化的天气应用，用诗意的方式感受天气变化。

[![CI](https://github.com/yourusername/zen-weather/workflows/CI/badge.svg)](https://github.com/yourusername/zen-weather/actions)
[![Release](https://github.com/yourusername/zen-weather/workflows/Release/badge.svg)](https://github.com/yourusername/zen-weather/releases)
[![Flutter](https://img.shields.io/badge/Flutter-3.24.0+-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## ✨ 特色功能

### 🎨 禅意美学
- 水墨风格配色（竹绿、宣纸白、梅粉等）
- 浅色/深色主题自动适配
- 优雅的动画效果

### 📖 文化底蕴
- **60+首古诗词** - 根据天气智能匹配
- **24节气系统** - 识别当前节气并展示节气诗词
- **四季主题** - 春夏秋冬自动切换配色
- **天气动画** - 雨、雪、云、晴等生动效果

### 🌍 实用功能
- 实时天气查询
- 24小时预报
- 7天预报
- 多城市管理
- 详细天气信息

## 🚀 快速开始

### 前置要求

- Flutter 3.24.0+
- Dart 3.0+
- WeatherAPI.com API Key（免费）

### 安装步骤

1. **克隆项目**
   ```bash
   git clone https://github.com/yourusername/zen-weather.git
   cd zen-weather
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **配置 API Key**
   
   编辑 `lib/utils/constants.dart`：
   ```dart
   static const String weatherApiKey = '你的API密钥';
   ```
   
   获取免费 API Key：[WeatherAPI.com](https://www.weatherapi.com/)

4. **运行应用**
   ```bash
   flutter run
   ```

## 📱 应用截图

> 待添加截图

## 🛠️ 技术栈

- **Flutter** - 跨平台 UI 框架
- **GetX** - 状态管理、路由管理
- **Dio** - 网络请求
- **WeatherAPI.com** - 天气数据

## 📂 项目结构

```
lib/
├── app/
│   ├── components/          # 通用组件
│   ├── data/               # 数据层
│   ├── modules/            # 功能模块
│   ├── routes/             # 路由配置
│   └── services/           # 服务层
├── config/
│   └── theme/              # 主题配置
├── utils/                  # 工具类
└── main.dart               # 应用入口
```

## 🧪 开发命令

```bash
# 代码格式化
dart format .

# 代码分析
flutter analyze

# 运行测试
flutter test

# 构建 APK
flutter build apk --release
```

## 📖 文档

- [快速启动指南](docs/快速测试指南.md)
- [API 配置指南](docs/API配置指南.md)
- [CI/CD 指南](docs/CICD指南.md)
- [快速参考](docs/快速参考.md)

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'feat: 添加某个功能'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

提交信息请遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范。

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [Flutter](https://flutter.dev/) - 跨平台框架
- [GetX](https://pub.dev/packages/get) - 状态管理
- [WeatherAPI.com](https://www.weatherapi.com/) - 天气数据

---

**感受天气的诗意，享受禅意的生活** 🌸
