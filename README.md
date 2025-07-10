# Dodo-Do - macOS 菜单栏待办事项与倒计时应用

一个轻量级的 macOS 菜单栏应用程序，提供便捷的任务管理和倒计时功能。通过菜单栏快速访问，帮助用户保持专注和高效。

## 功能特性

### 📝 待办事项管理 (Todo List)
- **任务创建**: 支持标题、内容、截止日期、优先级和分类
- **智能分组**: 自动按"今天"和"即将到来"分组显示任务
- **状态管理**: 轻松标记任务完成/未完成状态
- **搜索功能**: 快速搜索任务标题
- **筛选视图**: 支持查看全部、未完成、已完成任务
- **优先级系统**: 高、中、低三级优先级管理
- **分类标签**: 支持工作、个人等自定义分类

### ⏰ 倒计时功能 (Countdown)
- **自定义倒计时**: 设置小时、分钟、秒的精确倒计时
- **实时显示**: 倒计时实时更新显示
- **播放控制**: 支持暂停、继续、重置操作
- **完成提醒**: 倒计时结束时发送系统通知和声音提示
- **持久化**: 应用关闭后重新打开仍保持倒计时状态
- **批量管理**: 支持一键清除所有倒计时

## 技术架构

### 开发环境
- **语言**: Swift
- **框架**: SwiftUI + AppKit
- **平台**: macOS
- **最低系统要求**: macOS 11.0+

### 项目结构
```
dodo-do/
├── dodo_doApp.swift              # 应用入口和菜单栏设置
├── ContentView.swift             # 主界面 Tab 切换
├── Models/                       # 数据模型
│   ├── TodoItem.swift           # 待办事项数据结构
│   └── CountdownItem.swift      # 倒计时数据结构
├── ViewModels/                   # 视图模型 (MVVM)
│   ├── TodoListViewModel.swift  # 待办事项业务逻辑
│   └── CountdownListViewModel.swift # 倒计时业务逻辑
├── Views/                        # 用户界面
│   ├── Todo/                    # 待办事项相关视图
│   │   ├── TodoListView.swift   # 任务列表主界面
│   │   ├── TodoRowView.swift    # 单个任务行视图
│   │   ├── AddTodoView.swift    # 添加任务界面
│   │   └── TodoDetailView.swift # 任务详情界面
│   ├── Countdown/               # 倒计时相关视图
│   │   ├── CountdownListView.swift    # 倒计时列表
│   │   └── CreateCountdownView.swift  # 创建倒计时界面
│   └── Components/              # 通用组件
│       └── WheelPickerView.swift # 自定义滚轮选择器
├── Services/                     # 服务层
│   └── PersistenceService.swift # 数据持久化服务
└── Assets.xcassets/             # 应用资源
    ├── AppIcon.appiconset/      # 应用图标
    └── MenuBarIcon.imageset/    # 菜单栏图标
```

### 核心技术实现

#### 1. 菜单栏集成
- 使用 `NSStatusItem` 创建菜单栏图标
- 通过 `NSPopover` 显示主界面
- 支持左键点击显示界面，右键显示退出菜单

#### 2. 数据持久化
- 使用 `FileManager` 和 `Codable` 协议
- JSON 格式存储在应用支持目录
- 自动保存和加载用户数据

#### 3. 倒计时精确计算
- 使用 `Timer` 实现秒级精度更新
- 通过 `endTime` 属性处理应用非活跃状态
- 防止计时器在应用关闭时丢失精度

#### 4. 系统通知
- 集成 `UserNotifications` 框架
- 倒计时结束时发送系统通知
- 播放系统声音提示

## 数据模型

### TodoItem 结构
```swift
struct TodoItem: Identifiable, Codable, Equatable {
    let id: UUID                 // 唯一标识符
    var title: String           // 任务标题
    var content: String         // 任务内容
    var isCompleted: Bool       // 完成状态
    let createdAt: Date         // 创建时间
    var dueDate: Date?          // 截止日期（可选）
    var priority: Priority      // 优先级（高/中/低）
    var category: String?       // 分类标签（可选）
}
```

### CountdownItem 结构
```swift
struct CountdownItem: Identifiable, Codable, Equatable {
    let id: UUID                    // 唯一标识符
    var title: String              // 倒计时标题
    var initialDuration: TimeInterval  // 初始时长（秒）
    var remainingDuration: TimeInterval // 剩余时长（秒）
    var isRunning: Bool            // 运行状态
    let createdAt: Date            // 创建时间
    var endTime: Date?             // 预计结束时间
}
```

## 安装和运行

### 系统要求
- macOS 11.0 或更高版本
- Xcode 13.0 或更高版本（开发）

### 构建步骤
1. 克隆项目到本地
```bash
git clone [repository-url]
cd dodo-do
```

2. 使用 Xcode 打开项目
```bash
open dodo-do.xcodeproj
```

3. 选择目标设备为 "My Mac" 并运行项目

### 应用权限
首次运行时，应用会请求以下权限：
- **通知权限**: 用于倒计时结束提醒
- **文件系统访问**: 用于数据持久化存储

## 使用指南

### 待办事项管理
1. **添加任务**: 点击"忙起来(新todo)"按钮
2. **查看任务**: 任务自动按时间分组显示
3. **完成任务**: 点击任务右侧的复选框
4. **搜索任务**: 使用顶部搜索栏快速查找
5. **筛选任务**: 使用标签页切换不同状态的任务

### 倒计时使用
1. **创建倒计时**: 点击"+"按钮，设置标题和时长
2. **控制倒计时**: 使用播放/暂停按钮控制
3. **重置倒计时**: 点击重置按钮恢复初始时长
4. **批量清理**: 使用"Clear All"清除所有倒计时

## 特色功能

### 🎨 用户界面
- **现代化设计**: 采用 SwiftUI 原生设计语言
- **响应式布局**: 适配不同屏幕尺寸
- **流畅动画**: 丰富的过渡动画效果
- **深色模式**: 自动适配系统外观设置

### 🔧 自定义组件
- **滚轮选择器**: 自定义的时间选择滚轮
- **智能分组**: 自动按时间和状态分组
- **实时更新**: 倒计时实时刷新显示

### 💾 数据管理
- **自动保存**: 数据变更时自动保存
- **防丢失**: 应用异常退出时数据不丢失
- **轻量存储**: 使用 JSON 格式，占用空间小

## 开发计划

### 已完成功能 ✅
- [x] 基础菜单栏应用框架
- [x] 待办事项 CRUD 操作
- [x] 倒计时创建和管理
- [x] 数据持久化
- [x] 系统通知集成
- [x] 用户界面优化

### 计划中功能 🚧
- [ ] 任务详情编辑界面
- [ ] 更多倒计时模板
- [ ] 数据导入导出
- [ ] 快捷键支持
- [ ] 主题自定义
- [ ] 统计和分析功能

## 贡献指南

欢迎提交 Issue 和 Pull Request 来改进这个项目！

### 开发环境设置
1. Fork 项目到你的 GitHub 账户
2. 创建新的功能分支
3. 提交你的更改
4. 创建 Pull Request

### 代码规范
- 遵循 Swift 官方编码规范
- 使用有意义的变量和函数命名
- 添加必要的注释和文档
- 确保代码通过所有测试

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 联系方式

如有问题或建议，请通过以下方式联系：
- 提交 GitHub Issue
- 发送邮件至 [your-email@example.com]

---

**Dodo-Do** - 让你的时间管理更高效！ 🚀