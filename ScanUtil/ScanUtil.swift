//
//  ScanUtil.swift
//  ScanUtil
//
//  Created by Михаил Фокин on 02.07.2021.
//

import Foundation
import AppKit

class ScanUtil {
    
    var files: [URL]
    var info: Info
    
    init() {
        self.files = [URL]()
        self.info = Info()
    }
    
    // Перечисление, строки, которые нужно найти в файлах.
    enum Suspicious: String {
        case js = "<script>evil_script()</script>"
        case unix = "rm-rf~/documents"
        case macOS = "system(\"launchctlload/library/launchagents/com.malware.agent\")"
    }
    
    /// Запуск программы.
    /// - Parameters:
    ///     - path: Путь до папки, в которой осуществляется поиск
    /// - Returns: Результат анализа папки в виде строки.
    func run(path: String) -> String {
        info.startTime()
        do {
            try getContentPath(path: path)
        } catch  {
            return "Invalid path: \(path)"
        }
        checkFiles()
        info.endTime()
        return info.getInfo()
    }
    
    /// Создает массив из URL файлов
    /// - Parameters:
    ///     - path: Путь до папки
    private func getContentPath(path: String) throws {
        let fileManager = FileManager.default
        let content = try fileManager.contentsOfDirectory(atPath: path)
        let urlFolder = URL(fileURLWithPath: path)
        self.files = content.map { return urlFolder.appendingPathComponent($0) }
    }
    
    /// Проверка всех файлов на наличие угроз
    private func checkFiles() {
        for file in self.files {
            do {
                try checkFile(file: file)
            } catch {
                self.info.incrementError(file: file)
            }
            self.info.incrementAllFiles()
        }
    }
    
    /// Проверка файла на ниличие угроз
    /// - Parameters:
    ///     - file: URL файла, который нужно проверить
    private func checkFile(file: URL) throws {
        if !file.isFileURL { return }
        let data = try String(contentsOf: file).removeWhitespace().lowercased()
        if data.contains(Suspicious.js.rawValue) && file.pathExtension == "js" {
            self.info.incrementJS(file: file)
        } else if data.contains(Suspicious.unix.rawValue) {
            self.info.incrementUnix(file: file)
        } else if data.contains(Suspicious.macOS.rawValue) {
            self.info.incrementMacOS(file: file)
        }
    }
    
    /// Читение файла
    /// - Parameters:
    ///     - file: URL файла, который нужно прочитать
    /// - Returns: Строка с содержимым файла.
    private func readFile(file: URL) throws -> String {
        return try String(contentsOf: file)
    }
}

extension String {
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
