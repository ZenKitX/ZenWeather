# Git 提交指南

## 📋 提交策略

本项目采用分阶段提交策略，将开发过程按功能模块分为 9 个步骤提交。

## 🚀 快速开始

### 方式一：使用自动化脚本（推荐）

#### Windows (PowerShell)
```powershell
.\commit_steps.ps1
```

#### Linux/macOS (Bash)
```bash
chmod +x commit_steps.sh
./commit_steps.sh
```

### 方式二：手动分步提交

按照以下步骤手动执行提交：

## 📝 提交步骤详解

### 步骤 1: 项目配置文件

提交项目的基础配置文件和文档。

```bash
git add .gitignore .metadata analysis_options.yaml pubspec.yaml
git add README.md docs/禅意天气应用-调研报告.md
git commit -m "chore: 初始化项目配置

- 添加 Flutter 项目配置文件
- 添加项目调研报告
- 配置 .gitignore 排除参考项目"
```

### 步骤 2: 阶段一 - 项目基础搭建

提交主题系统、路由配置、启动页等基础功能。

```bash
git add lib/main.dart
git add lib/config/
git add lib/app/data/local/storage_service.dart
git add lib/app/routes/
git add lib/app/modules/splash/
git add lib/app/modules/home/bindings/
git add lib/app/modules/home/controllers/
git add docs/阶段一完成总结.md
git commit -m "feat(阶段一): 项目基础搭建

- 实现禅意主题系统（水墨配色）
- 配置 GetX 路由系统
- 实现本地存储服务
- 创建启动页和首页框架
- 添加屏幕适配和动画效果"
```

### 步骤 3: 阶段二 - 核心功能开发

提交天气 API、数据模型、服务层等核心功能。

```bash
git add lib/app/data/models/weather_model.dart
git add lib/app/services/
git add lib/app/components/loading_widget.dart
git add lib/app/components/error_widget.dart
git add lib/utils/constants.dart
git add android/app/src/main/AndroidManifest.xml
git add docs/阶段二完成总结.md
git add docs/API配置指南.md
git commit -m "feat(阶段二): 核心功能开发

- 创建天气数据模型
- 实现 API 服务层（WeatherAPI.com）
- 集成定位服务
- 创建加载和错误组件
- 配置 Android 定位权限
- 更新 HomeController 集成真实数据"
```

### 步骤 4: 阶段三 - 禅意特色功能

提交诗词数据库、节气系统、四季主题等特色功能。

```bash
git add lib/app/data/local/poem_database.dart
git add lib/utils/solar_terms.dart
git add lib/config/theme/seasonal_themes.dart
git add lib/app/components/weather_animation.dart
git add lib/app/components/poem_card.dart
git add lib/app/modules/home/views/home_view.dart
git add docs/阶段三完成总结.md
git commit -m "feat(阶段三): 禅意特色功能

- 创建诗词数据库（60+首古诗词）
- 实现节气识别系统（24节气）
- 配置四季主题自动切换
- 创建天气动画组件（雨、雪、云、晴）
- 实现智能诗词匹配
- 创建增强诗词卡片组件"
```

### 步骤 5: 阶段四 - 高级功能开发

提交城市管理、设置系统等高级功能。

```bash
git add lib/app/data/models/city_model.dart
git add lib/app/modules/cities/
git add lib/app/modules/settings/
git add lib/app/components/city_card.dart
git add docs/阶段四完成总结.md
git add docs/阶段四规划.md
git add docs/阶段四快速指南.md
git commit -m "feat(阶段四): 高级功能开发

- 实现多城市管理系统
- 创建城市搜索功能
- 实现设置系统（主题、单位、语言）
- 创建城市卡片组件
- 更新路由配置
- 完善首页入口"
```

### 步骤 6: 阶段五 - 天气详情页

提交天气详情页面和预报功能。

```bash
git add lib/app/modules/weather_detail/
git add docs/阶段五完成总结.md
git commit -m "feat(阶段五): 天气详情页

- 创建天气详情页面
- 实现24小时预报展示
- 实现7天预报展示
- 添加多入口访问（首页、城市管理）
- 优化城市管理交互（选项菜单）"
```

### 步骤 7: 测试和文档

提交测试文件和完整文档。

```bash
git add test/
git add docs/测试报告.md
git add docs/项目完成报告.md
git add docs/快速启动指南.md
git commit -m "docs: 添加测试和完整文档

- 添加测试文件
- 创建测试报告
- 创建项目完成报告
- 更新快速启动指南
- 完善 README 文档"
```

### 步骤 8: 平台配置文件

提交各平台的配置文件。

```bash
git add android/ ios/ linux/ macos/ windows/ web/
git commit -m "chore: 添加平台配置文件

- Android 平台配置
- iOS 平台配置
- Linux 平台配置
- macOS 平台配置
- Windows 平台配置
- Web 平台配置"
```

### 步骤 9: 资源文件

提交应用资源文件。

```bash
git add assets/
git commit -m "assets: 添加应用资源文件

- 添加字体文件
- 添加图片资源
- 添加矢量图标"
```

## 📊 提交历史查看

完成所有提交后，可以查看提交历史：

```bash
# 查看简洁的提交历史
git log --oneline

# 查看详细的提交历史
git log

# 查看图形化的提交历史
git log --graph --oneline --all
```

## 🔍 提交规范

本项目遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

### 提交类型

- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式调整（不影响功能）
- `refactor`: 代码重构
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建/工具相关
- `assets`: 资源文件

### 提交格式

```
<type>(<scope>): <subject>

<body>
```

示例：
```
feat(阶段一): 项目基础搭建

- 实现禅意主题系统
- 配置路由系统
- 创建启动页
```

## ⚠️ 注意事项

1. **参考项目不提交**
   - `flutter_weather_app-getx/` 已在 `.gitignore` 中排除
   - `Weather-App-UI-Flutter-master/` 已在 `.gitignore` 中排除

2. **IDE 文件不提交**
   - `.idea/` 已在 `.gitignore` 中排除
   - `*.iml` 已在 `.gitignore` 中排除

3. **构建文件不提交**
   - `build/` 已在 `.gitignore` 中排除
   - `.dart_tool/` 已在 `.gitignore` 中排除

4. **提交前检查**
   ```bash
   # 查看将要提交的文件
   git status
   
   # 查看文件差异
   git diff
   ```

## 🚀 推送到远程仓库

完成所有提交后，推送到远程仓库：

```bash
# 推送到主分支
git push origin main

# 或推送到 master 分支
git push origin master
```

## 📝 提交统计

完成所有步骤后，项目将有 9 个清晰的提交记录：

1. 项目配置
2. 阶段一：基础搭建
3. 阶段二：核心功能
4. 阶段三：禅意特色
5. 阶段四：高级功能
6. 阶段五：天气详情
7. 测试和文档
8. 平台配置
9. 资源文件

每个提交都有清晰的说明和完整的变更列表。

---

**提交完成后，项目将拥有清晰的版本历史，便于后续维护和协作！** 🎉
