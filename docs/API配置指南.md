# API 配置指南

## 天气 API 配置

禅意天气使用 WeatherAPI.com 提供天气数据服务。

### 1. 注册 WeatherAPI 账号

1. 访问 [WeatherAPI.com](https://www.weatherapi.com/)
2. 点击右上角 "Sign Up" 注册账号
3. 注册成功后，登录账号

### 2. 获取 API Key

1. 登录后，进入 Dashboard
2. 在页面中找到 "Your API Key" 部分
3. 复制你的 API Key

### 3. 配置 API Key

打开项目文件 `lib/utils/constants.dart`，找到以下代码：

```dart
static const String weatherApiKey = 'YOUR_API_KEY_HERE';
```

将 `YOUR_API_KEY_HERE` 替换为你的 API Key：

```dart
static const String weatherApiKey = '你的API密钥';
```

### 4. API 免费额度

WeatherAPI 免费计划包括：
- 每月 100 万次 API 调用
- 实时天气数据
- 3 天天气预报
- 天气历史数据（7 天）
- 天气警报
- 空气质量数据

对于个人开发和测试完全够用！

## 替代方案

如果你想使用其他天气 API，可以选择：

### 1. OpenWeatherMap

- 网址：https://openweathermap.org/
- 免费额度：每分钟 60 次调用
- 优点：数据全面，文档完善
- 缺点：免费版只有 5 天预报

### 2. 和风天气（中国）

- 网址：https://www.qweather.com/
- 免费额度：每天 1000 次调用
- 优点：中国本土服务，数据准确
- 缺点：需要实名认证

### 3. Visual Crossing Weather

- 网址：https://www.visualcrossing.com/
- 免费额度：每天 1000 次调用
- 优点：历史数据丰富
- 缺点：响应速度较慢

## 修改 API 服务

如果要切换到其他 API，需要修改以下文件：

1. `lib/utils/constants.dart` - 修改 API 基础 URL 和 Key
2. `lib/app/services/weather_service.dart` - 修改 API 请求逻辑
3. `lib/app/data/models/weather_model.dart` - 修改数据模型以匹配新 API

## 测试 API

配置完成后，运行以下命令测试：

```bash
flutter run
```

如果配置正确，应用会：
1. 请求定位权限
2. 获取当前位置
3. 显示当前位置的天气数据

## 常见问题

### Q: API Key 无效？
A: 检查是否正确复制了 API Key，确保没有多余的空格。

### Q: 无法获取天气数据？
A: 
1. 检查网络连接
2. 确认 API Key 是否有效
3. 查看控制台日志，确认错误信息

### Q: 定位失败？
A: 
1. 确认已授予定位权限
2. 检查设备定位服务是否开启
3. 在模拟器上测试时，需要手动设置位置

### Q: API 调用次数超限？
A: 
1. 检查是否频繁刷新
2. 考虑添加缓存机制
3. 升级到付费计划

## 安全提示

⚠️ **重要**：不要将 API Key 提交到公共代码仓库！

建议做法：
1. 使用环境变量存储 API Key
2. 在 `.gitignore` 中忽略包含 API Key 的文件
3. 使用 Flutter 的 `--dart-define` 参数传递 API Key

示例：
```bash
flutter run --dart-define=WEATHER_API_KEY=你的密钥
```

然后在代码中使用：
```dart
static const String weatherApiKey = String.fromEnvironment('WEATHER_API_KEY');
```

## 下一步

配置完成后，你可以：
1. 测试应用功能
2. 查看天气数据展示
3. 体验诗词匹配功能
4. 继续开发其他功能

---

如有问题，请查看 [WeatherAPI 文档](https://www.weatherapi.com/docs/)
