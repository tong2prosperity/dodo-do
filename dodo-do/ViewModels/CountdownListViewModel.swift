import Foundation
import AppKit
import Combine
import UserNotifications

class CountdownListViewModel: ObservableObject {
    @Published var countdowns: [CountdownItem] = []
    private var timers: [UUID: Timer] = [:]
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.countdowns = PersistenceService.shared.loadCountdowns()
        recalculateRemainingDurations()
        
        $countdowns
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] updatedCountdowns in
                PersistenceService.shared.saveCountdowns(updatedCountdowns)
            }
            .store(in: &cancellables)
        
        requestNotificationPermission()
    }
    
    deinit {
        timers.values.forEach { $0.invalidate() }
    }

    func createCountdown(title: String, duration: TimeInterval) {
        let newCountdown = CountdownItem(
            id: UUID(),
            title: title,
            initialDuration: duration,
            remainingDuration: duration,
            isRunning: false,
            createdAt: Date(),
            endTime: nil
        )
        countdowns.insert(newCountdown, at: 0)
    }

    func deleteCountdown(at offsets: IndexSet) {
        let idsToDelete = offsets.map { countdowns[$0].id }
        idsToDelete.forEach { id in
            timers[id]?.invalidate()
            timers.removeValue(forKey: id)
        }
        countdowns.remove(atOffsets: offsets)
    }

    func togglePlayPause(for countdown: CountdownItem) {
        guard let index = countdowns.firstIndex(where: { $0.id == countdown.id }) else { return }
        
        countdowns[index].isRunning.toggle()

        if countdowns[index].isRunning {
            countdowns[index].endTime = Date().addingTimeInterval(countdowns[index].remainingDuration)
            startTimer(for: &countdowns[index])
        } else {
            timers[countdown.id]?.invalidate()
            timers.removeValue(forKey: countdown.id)
            if let endTime = countdowns[index].endTime {
                let newRemaining = endTime.timeIntervalSinceNow
                countdowns[index].remainingDuration = max(0, newRemaining)
            }
            countdowns[index].endTime = nil
        }
    }

    func resetCountdown(for countdown: CountdownItem) {
        guard let index = countdowns.firstIndex(where: { $0.id == countdown.id }) else { return }
        
        timers[countdown.id]?.invalidate()
        timers.removeValue(forKey: countdown.id)
        
        countdowns[index].isRunning = false
        countdowns[index].remainingDuration = countdowns[index].initialDuration
        countdowns[index].endTime = nil
    }

    func clearAllCountdowns() {
        // Invalidate all running timers
        timers.values.forEach { $0.invalidate() }
        timers.removeAll()
        
        // Clear the countdowns array
        countdowns.removeAll()
    }

    private func startTimer(for countdown: inout CountdownItem) {
        let countdownID = countdown.id
        timers[countdownID] = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let index = self.countdowns.firstIndex(where: { $0.id == countdownID }) else { return }
            
            if self.countdowns[index].remainingDuration > 1 {
                self.countdowns[index].remainingDuration -= 1
            } else {
                self.countdowns[index].remainingDuration = 0
                self.countdowns[index].isRunning = false
                self.timers[countdownID]?.invalidate()
                self.timers.removeValue(forKey: countdownID)
                self.sendNotification(for: self.countdowns[index])
                NSSound(named: "Glass")?.play() // Play sound on completion
            }
        }
    }
    
    private func recalculateRemainingDurations() {
        for i in 0..<countdowns.count {
            if countdowns[i].isRunning, let endTime = countdowns[i].endTime {
                let remaining = endTime.timeIntervalSinceNow
                if remaining > 0 {
                    countdowns[i].remainingDuration = remaining
                    startTimer(for: &countdowns[i])
                } else {
                    countdowns[i].remainingDuration = 0
                    countdowns[i].isRunning = false
                }
            }
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    private func sendNotification(for countdown: CountdownItem) {
        let content = UNMutableNotificationContent()
        content.title = "Countdown Finished!"
        content.body = "'\(countdown.title)' has ended."
        content.sound = .default

        let request = UNNotificationRequest(identifier: countdown.id.uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
    
    func format(duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
