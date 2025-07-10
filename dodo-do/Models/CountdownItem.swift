import Foundation

struct CountdownItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var initialDuration: TimeInterval // 初始总时长（秒为单位）
    var remainingDuration: TimeInterval // 剩余时长（实时更新）
    var isRunning: Bool // 是否正在运行
    let createdAt: Date // 倒计时创建时间，用于排序
    var endTime: Date? // 倒计时预计结束时间，用于精确计算剩余时间，当isRunning为true时设置
}
