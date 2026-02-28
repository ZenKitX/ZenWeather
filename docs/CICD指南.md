# CI/CD 指南

本文档介绍禅意天气项目的持续集成和持续部署流程。

## 📋 目录

- [工作流概览](#工作流概览)
- [CI - 代码质量检查](#ci---代码质量检查)
- [PR Check - Pull Request 检查](#pr-check---pull-request-检查)
- [Release - 发布流程](#release---发布流程)
- [本地测试](#本地测试)
- [常见问题](#常见问题)

## 🔄 工作流概览

项目包含 3 个主要的 GitHub Actions 工作流：

| 工作流 | 触发条件 | 用途 |
|--------|---------|------|
| `ci.yml` | Push/PR 到 main/develop | 代码质量检查和构建 |
| `pr-check.yml` | 创建/更新 PR | PR 验证和大小检查 |
| `release.yml` | 推送版本标签 (v*.*.*) | 自动发布和部署 |

## 🔍 CI - 代码质量检查

### 触发条件

```yaml
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
```

### 执行步骤

#### 1. 代码分析 (analyze)

- ✅ 代码格式检查 (`flutter format`)
- ✅ 静态代码分析 (`flutter analyze`)
- ✅ 运行单元测试 (`flutter test`)
- ✅ 生成覆盖率报告

#### 2. 构建 Android (build-android)

- ✅ 构建 Release APK
- ✅ 上传 APK 到 Artifacts（保留 7 天）

#### 3. 构建 iOS (build-ios)

- ✅ 构建 iOS 应用（无签名）
- ✅ 创建 IPA 文件
- ✅ 上传 IPA 到 Artifacts（保留 7 天）

#### 4. 构建 Web (build-web)

- ✅ 构建 Web 应用
- ✅ 上传构建产物到 Artifacts（保留 7 天）

### 查看构建产物

1. 进入 GitHub Actions 页面
2. 选择对应的工作流运行
3. 在 "Artifacts" 部分下载构建产物

## ✅ PR Check - Pull Request 检查

### 触发条件

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened]
```

### 执行步骤

#### 1. PR 验证 (pr-validation)

- ✅ 检查提交信息格式（Conventional Commits）
- ✅ 代码格式检查
- ✅ 代码分析
- ✅ 运行测试
- ✅ 检查大文件

#### 2. 构建大小检查 (size-check)

- ✅ 构建 APK
- ✅ 检查 APK 大小
- ✅ 在 PR 中添加大小报告评论

### 提交信息规范

必须遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```
<type>(<scope>): <subject>

<body>
```

**有效的类型**：
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建/工具相关
- `assets`: 资源文件

**示例**：
```bash
git commit -m "feat(weather): 添加24小时预报功能"
git commit -m "fix(ui): 修复深色模式下的文字对比度问题"
git commit -m "docs: 更新 API 配置指南"
```

## 🚀 Release - 发布流程

### 创建发布版本

#### 1. 更新版本号

编辑 `pubspec.yaml`：

```yaml
version: 1.0.0+1  # 版本号+构建号
```

#### 2. 更新 CHANGELOG

在 `CHANGELOG.md` 中添加新版本的更新内容。

#### 3. 提交更改

```bash
git add pubspec.yaml CHANGELOG.md
git commit -m "chore: 准备发布 v1.0.0"
git push origin main
```

#### 4. 创建标签

```bash
# 创建标签
git tag -a v1.0.0 -m "Release v1.0.0"

# 推送标签
git push origin v1.0.0
```

### 自动化流程

推送标签后，GitHub Actions 会自动：

1. ✅ 创建 GitHub Release
2. ✅ 构建 Android APK 和 App Bundle
3. ✅ 构建 iOS IPA
4. ✅ 构建并部署 Web 版本到 GitHub Pages
5. ✅ 上传所有构建产物到 Release

### 发布产物

发布完成后，在 GitHub Releases 页面可以下载：

- `zen-weather-v1.0.0-android.apk` - Android APK
- `zen-weather-v1.0.0-android.aab` - Android App Bundle
- `zen-weather-v1.0.0-ios.ipa` - iOS IPA（需要签名）
- Web 版本自动部署到 GitHub Pages

## 🧪 本地测试

在推送代码前，建议在本地运行相同的检查：

### 代码格式

```bash
# 检查格式
dart format --set-exit-if-changed .

# 自动格式化
dart format .
```

### 代码分析

```bash
flutter analyze
```

### 运行测试

```bash
# 运行所有测试
flutter test

# 生成覆盖率报告
flutter test --coverage
```

### 构建检查

```bash
# Android
flutter build apk --release

# iOS (需要 macOS)
flutter build ios --release --no-codesign

# Web
flutter build web --release
```

## 🔧 配置说明

### 必需的 Secrets

项目使用以下 GitHub Secrets（已自动配置）：

- `GITHUB_TOKEN` - GitHub 自动提供，用于创建 Release

### 可选配置

#### 1. 代码签名（Android）

如需自动签名 Android 应用，需要配置：

```yaml
# 在 .github/workflows/release.yml 中添加
- name: 配置签名
  run: |
    echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/app/keystore.jks
    echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" >> android/key.properties
    echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
    echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
    echo "storeFile=keystore.jks" >> android/key.properties
```

需要在 GitHub Secrets 中添加：
- `KEYSTORE_BASE64` - Keystore 文件的 Base64 编码
- `KEYSTORE_PASSWORD` - Keystore 密码
- `KEY_PASSWORD` - Key 密码
- `KEY_ALIAS` - Key 别名

#### 2. 代码签名（iOS）

iOS 签名需要 Apple Developer 账号和证书，建议使用 Fastlane。

#### 3. 自定义域名（Web）

编辑 `.github/workflows/release.yml`：

```yaml
- name: 部署到 GitHub Pages
  uses: peaceiris/actions-gh-pages@v3
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    publish_dir: ./build/web
    cname: your-domain.com  # 替换为你的域名
```

## 📊 状态徽章

在 README.md 中添加状态徽章：

```markdown
![CI](https://github.com/yourusername/zen-weather/workflows/CI/badge.svg)
![Release](https://github.com/yourusername/zen-weather/workflows/Release/badge.svg)
```

## ❓ 常见问题

### Q: 为什么 CI 失败了？

**A**: 检查以下几点：
1. 代码格式是否正确（运行 `flutter format .`）
2. 是否有代码分析错误（运行 `flutter analyze`）
3. 测试是否通过（运行 `flutter test`）
4. 提交信息是否符合规范

### Q: 如何跳过 CI 检查？

**A**: 不建议跳过 CI 检查。如果确实需要，可以在提交信息中添加 `[skip ci]`：

```bash
git commit -m "docs: 更新文档 [skip ci]"
```

### Q: 构建产物在哪里？

**A**: 
- **CI 构建**：在 Actions 页面的 Artifacts 中（保留 7 天）
- **Release 构建**：在 GitHub Releases 页面

### Q: 如何修改 Flutter 版本？

**A**: 编辑工作流文件中的 `flutter-version`：

```yaml
- name: 设置 Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.24.0'  # 修改这里
    channel: 'stable'
```

### Q: 如何添加环境变量？

**A**: 在工作流文件中添加 `env` 部分：

```yaml
- name: 构建应用
  env:
    WEATHER_API_KEY: ${{ secrets.WEATHER_API_KEY }}
  run: flutter build apk --release
```

然后在 GitHub Secrets 中添加对应的密钥。

## 📚 相关资源

- [GitHub Actions 文档](https://docs.github.com/cn/actions)
- [Flutter CI/CD 最佳实践](https://docs.flutter.dev/deployment/cd)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [语义化版本](https://semver.org/lang/zh-CN/)

---

**提示**：首次设置 CI/CD 后，建议创建一个测试 PR 来验证所有工作流是否正常运行。
