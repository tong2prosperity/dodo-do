# Dodo-Do 产品需求文档 (PRD)
## macOS 菜单栏待办事项与倒计时应用

### 版本信息
- **文档版本**: 1.0
- **产品版本**: 1.0
- **创建日期**: 2025年7月10日
- **最后更新**: 2025年7月10日

---

## 1. 产品概述

### 1.1 产品定位
Dodo-Do 是一款专为 macOS 设计的轻量级菜单栏应用，集成待办事项管理和倒计时功能，旨在帮助用户提高工作效率和时间管理能力。

### 1.2 目标用户
- **主要用户**: macOS 用户，包括学生、职场人士、自由职业者
- **使用场景**: 日常任务管理、工作项目跟踪、学习计划安排、时间管理

### 1.3 核心价值主张
- **便捷性**: 通过菜单栏一键访问，无需打开独立应用
- **高效性**: 简洁的界面设计，快速完成任务管理操作
- **专注性**: 倒计时功能帮助用户保持专注，提高工作效率
- **轻量化**: 占用系统资源少，不影响其他应用运行

---

## 2. 功能需求

### 2.1 核心功能模块

#### 2.1.1 菜单栏集成
**功能描述**: 应用以菜单栏图标形式存在，提供快速访问入口

**具体需求**:
- 在 macOS 菜单栏显示自定义图标
- 左键点击显示主界面弹窗 (450x650 像素)
- 右键点击显示退出菜单
- 弹窗采用 transient 行为，点击外部区域自动关闭
- 支持键盘快捷键 Cmd+Q 退出应用

**技术实现**:
- 使用 NSStatusItem 创建菜单栏项目
- 使用 NSPopover 显示主界面
- 集成 NSMenu 处理右键菜单

#### 2.1.2 待办事项管理模块

**功能描述**: 完整的任务管理系统，支持任务的创建、编辑、分类和状态管理

**数据模型**:
```swift
struct TodoItem {
    let id: UUID              // 唯一标识符
    var title: String         // 任务标题 (必填)
    var content: String       // 任务详细内容 (可选)
    var isCompleted: Bool     // 完成状态
    let createdAt: Date       // 创建时间
    var dueDate: Date?        // 截止日期 (可选)
    var priority: Priority    // 优先级 (高/中/低)
    var category: String?     // 分类标签 (可选)
}
```

**核心功能**:

1. **任务创建**
   - 支持设置任务标题 (必填)
   - 支持添加详细内容描述
   - 支持设置截止日期
   - 支持选择优先级 (高/中/低)
   - 支持添加分类标签 (工作/个人等)

2. **任务展示与分组**
   - **智能分组**: 自动按时间分组显示
     - "Today" 组: 显示今天截止的任务
     - "Upcoming" 组: 显示未来截止或无截止日期的任务
   - **状态筛选**: 支持查看全部/未完成/已完成任务
   - **搜索功能**: 支持按任务标题搜索
   - **排序规则**: 按截止日期升序排列

3. **任务操作**
   - 点击复选框切换完成状态
   - 支持删除单个任务
   - 支持批量清除已完成任务
   - 任务状态实时更新

4. **用户界面**
   - 顶部显示标题 "接下来不能闲着了啊"
   - "忙起来(新todo)" 按钮创建新任务
   - 搜索栏支持实时搜索
   - 标签页切换不同筛选视图
   - 任务列表支持滚动浏览

#### 2.1.3 倒计时功能模块

**功能描述**: 精确的倒计时器，支持多个倒计时同时运行

**数据模型**:
```swift
struct CountdownItem {
    let id: UUID                    // 唯一标识符
    var title: String              // 倒计时标题
    var initialDuration: TimeInterval  // 初始时长 (秒)
    var remainingDuration: TimeInterval // 剩余时长 (秒)
    var isRunning: Bool            // 运行状态
    let createdAt: Date            // 创建时间
    var endTime: Date?             // 预计结束时间
}
```

**核心功能**:

1. **倒计时创建**
   - 支持设置倒计时标题
   - 支持设置小时、分钟、秒的精确时长
   - 使用自定义滚轮选择器设置时间

2. **倒计时控制**
   - **播放/暂停**: 支持随时暂停和继续倒计时
   - **重置功能**: 一键重置到初始时长
   - **实时显示**: 以 HH:MM:SS 格式显示剩余时间
   - **状态指示**: 运行中显示绿色，暂停显示灰色

3. **批量管理**
   - 支持同时运行多个倒计时
   - "Clear All" 功能一键清除所有倒计时
   - 倒计时按创建时间排序显示

4. **完成提醒**
   - 倒计时结束时发送 macOS 系统通知
   - 播放系统提示音 ("Glass" 音效)
   - 自动停止计时器并更新状态

#### 2.1.4 数据持久化模块

**功能描述**: 确保用户数据的安全存储和快速加载

**技术实现**:
- 使用 JSON 格式存储数据
- 数据保存在 ~/Library/Application Support/dodo-do/ 目录
- 分别存储 todos.json 和 countdowns.json
- 支持原子写入，防止数据损坏

**存储策略**:
- 待办事项: 数据变更后 0.5 秒自动保存
- 倒计时: 状态变更后 0.5 秒自动保存
- 应用启动时自动加载历史数据
- 倒计时重启后自动恢复运行状态

---

## 3. 非功能性需求

### 3.1 性能需求
- **启动时间**: 应用启动时间 < 2 秒
- **响应时间**: 界面操作响应时间 < 100ms
- **内存占用**: 运行时内存占用 < 50MB
- **CPU 占用**: 空闲状态 CPU 占用 < 1%

### 3.2 兼容性需求
- **系统要求**: macOS 11.0 或更高版本
- **架构支持**: 支持 Intel 和 Apple Silicon 处理器
- **分辨率适配**: 支持不同分辨率和缩放比例

### 3.3 可用性需求
- **界面语言**: 支持中文界面
- **操作简便**: 核心功能 3 步内完成
- **视觉设计**: 遵循 macOS Human Interface Guidelines
- **无障碍**: 支持 VoiceOver 等辅助功能

### 3.4 可靠性需求
- **数据安全**: 数据丢失概率 < 0.1%
- **崩溃率**: 应用崩溃率 < 0.5%
- **数据恢复**: 支持异常退出后数据恢复

---

## 4. 技术架构

### 4.1 开发技术栈
- **编程语言**: Swift 5.0+
- **UI 框架**: SwiftUI + AppKit
- **架构模式**: MVVM (Model-View-ViewModel)
- **数据存储**: JSON + FileManager
- **系统集成**: UserNotifications, NSStatusBar

### 4.2 项目结构
```
dodo-do/
├── dodo_doApp.swift              # 应用入口和菜单栏设置
├── ContentView.swift             # 主界面 Tab 切换
├── Models/                       # 数据模型层
│   ├── TodoItem.swift           # 待办事项数据结构
│   └── CountdownItem.swift      # 倒计时数据结构
├── ViewModels/                   # 业务逻辑层
│   ├── TodoListViewModel.swift  # 待办事项业务逻辑
│   └── CountdownListViewModel.swift # 倒计时业务逻辑
├── Views/                        # 用户界面层
│   ├── Todo/                    # 待办事项界面
│   ├── Countdown/               # 倒计时界面
│   └── Components/              # 通用组件
├── Services/                     # 服务层
│   └── PersistenceService.swift # 数据持久化服务
└── Assets.xcassets/             # 应用资源
```

### 4.3 核心技术实现

#### 4.3.1 菜单栏集成
```swift
// 使用 NSStatusItem 创建菜单栏图标
statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
statusItem.button?.image = NSImage(named: "MenuBarIcon")

// 使用 NSPopover 显示主界面
popover = NSPopover()
popover.contentSize = NSSize(width: 450, height: 650)
popover.behavior = .transient
```

#### 4.3.2 倒计时精确计算
```swift
// 使用 Timer 实现秒级精度
Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
    // 更新剩余时间
    countdown.remainingDuration -= 1
}

// 通过 endTime 处理应用非活跃状态
countdown.endTime = Date().addingTimeInterval(remainingDuration)
```

#### 4.3.3 数据持久化
```swift
// JSON 编码存储
let encoder = JSONEncoder()
let data = try encoder.encode(todos)
try data.write(to: fileURL, options: [.atomicWrite])
```

---

## 5. 用户界面设计

### 5.1 设计原则
- **简洁性**: 界面简洁明了，避免冗余元素
- **一致性**: 遵循 macOS 设计规范
- **可用性**: 操作流程直观，学习成本低
- **美观性**: 现代化的视觉设计

### 5.2 界面规格
- **主窗口尺寸**: 450 x 650 像素
- **字体**: 系统默认字体 (SF Pro)
- **颜色方案**: 浅色模式 (强制)
- **图标**: SF Symbols 系统图标

### 5.3 交互设计
- **Tab 切换**: 支持在待办事项和倒计时间切换
- **动画效果**: 使用 SwiftUI 动画增强用户体验
- **反馈机制**: 操作后提供视觉和听觉反馈

---

## 6. 数据流设计

### 6.1 待办事项数据流
```
用户操作 → TodoListViewModel → TodoItem 更新 → 
自动保存 (0.5s 延迟) → PersistenceService → JSON 文件
```

### 6.2 倒计时数据流
```
用户操作 → CountdownListViewModel → Timer 管理 → 
实时更新 → 自动保存 → 完成通知
```

### 6.3 应用生命周期
```
启动 → 加载数据 → 恢复倒计时状态 → 
运行 → 实时保存 → 退出 → 数据持久化
```

---

## 7. 测试需求

### 7.1 功能测试
- **待办事项**: 创建、编辑、删除、状态切换
- **倒计时**: 创建、播放、暂停、重置、完成提醒
- **数据持久化**: 保存、加载、数据完整性
- **菜单栏集成**: 显示、隐藏、退出

### 7.2 性能测试
- **大数据量**: 1000+ 待办事项的性能表现
- **长时间运行**: 24 小时连续运行稳定性
- **内存泄漏**: 长期使用内存占用情况

### 7.3 兼容性测试
- **系统版本**: macOS 11.0 - 14.0
- **硬件平台**: Intel Mac 和 Apple Silicon Mac
- **分辨率**: 不同分辨率和缩放比例

---

## 8. 发布计划

### 8.1 版本规划
- **v1.0**: 核心功能实现 (当前版本)
- **v1.1**: 任务详情编辑、快捷键支持
- **v1.2**: 数据导入导出、主题自定义
- **v2.0**: 统计分析、云同步功能

### 8.2 发布渠道
- **开发者直接分发**: 提供 .app 文件下载
- **GitHub Releases**: 开源发布
- **Mac App Store**: 后续考虑上架

---

## 9. 风险评估

### 9.1 技术风险
- **系统兼容性**: macOS 版本更新可能影响 API 兼容性
- **性能问题**: 大量倒计时同时运行可能影响性能
- **数据丢失**: 文件系统异常可能导致数据丢失

### 9.2 用户体验风险
- **学习成本**: 新用户可能需要时间适应界面
- **功能发现**: 部分功能可能不够直观

### 9.3 风险缓解措施
- 定期测试新系统版本兼容性
- 实现数据备份和恢复机制
- 提供用户使用指南和帮助文档

---

## 10. 成功指标

### 10.1 技术指标
- 应用启动时间 < 2 秒
- 界面响应时间 < 100ms
- 崩溃率 < 0.5%
- 数据丢失率 < 0.1%

### 10.2 用户体验指标
- 用户留存率 > 80% (7 天)
- 平均使用时长 > 10 分钟/天
- 功能使用率 > 60% (核心功能)

### 10.3 业务指标
- 用户满意度 > 4.5/5.0
- 推荐意愿 > 70%
- 活跃用户增长率 > 20%/月

---

## 11. 附录

### 11.1 术语表
- **PRD**: Product Requirements Document (产品需求文档)
- **MVVM**: Model-View-ViewModel (架构模式)
- **NSStatusItem**: macOS 菜单栏项目类
- **SwiftUI**: Apple 的声明式 UI 框架

### 11.2 参考资料
- [macOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

### 11.3 变更记录
| 版本 | 日期 | 变更内容 | 作者 |
|------|------|----------|------|
| 1.0 | 2025-07-10 | 初始版本创建 | 产品团队 |

---

**文档结束**

*本 PRD 基于 Dodo-Do v1.0 的实际实现功能编写，为产品的进一步开发和优化提供指导。*