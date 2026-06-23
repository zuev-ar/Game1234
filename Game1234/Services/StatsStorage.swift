// /Services/StatsStorage.swift
import Foundation

/// Хранилище истории партий (для экрана статистики).
protocol StatsStorageProtocol {
    /// Все сохранённые записи (новые — первыми).
    func allRecords() -> [GameRecord]
    /// Добавить запись. Хранилище само обрежет историю до лимита.
    func append(_ record: GameRecord)
    /// Очистить всю историю (для будущей кнопки "Reset").
    func clearAll()
}

final class UserDefaultsStatsStorage: StatsStorageProtocol {

    /// Максимум записей в истории.
    static let historyLimit = 50

    private let defaults: UserDefaults
    private let key = "game1234.stats.history.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func allRecords() -> [GameRecord] {
        guard let data = defaults.data(forKey: key),
              let records = try? JSONDecoder().decode([GameRecord].self, from: data) else {
            return []
        }
        return records
    }

    func append(_ record: GameRecord) {
        var records = allRecords()
        records.insert(record, at: 0)
        if records.count > Self.historyLimit {
            records = Array(records.prefix(Self.historyLimit))
        }
        if let data = try? JSONEncoder().encode(records) {
            defaults.set(data, forKey: key)
        }
    }

    func clearAll() {
        defaults.removeObject(forKey: key)
    }
}
