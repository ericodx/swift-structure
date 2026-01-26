import Foundation

// MARK: - File Helpers

func createTempFile(content: String) -> String {
    let tempDir = FileManager.default.temporaryDirectory
    let fileName = UUID().uuidString + ".swift"
    let filePath = tempDir.appendingPathComponent(fileName).path

    FileManager.default.createFile(
        atPath: filePath,
        contents: content.data(using: .utf8)
    )

    return filePath
}

func removeTempFile(_ path: String) {
    try? FileManager.default.removeItem(atPath: path)
}

// MARK: - Directory Helpers

func createTempDirectory() -> String {
    let tempDir = FileManager.default.temporaryDirectory
    let dirName = UUID().uuidString
    let dirPath = tempDir.appendingPathComponent(dirName).path

    try? FileManager.default.createDirectory(
        atPath: dirPath,
        withIntermediateDirectories: true
    )

    return dirPath
}

func removeTempDirectory(_ path: String) {
    try? FileManager.default.removeItem(atPath: path)
}
