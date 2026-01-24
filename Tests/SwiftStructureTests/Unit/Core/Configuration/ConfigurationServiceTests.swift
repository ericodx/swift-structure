import Foundation
import Testing

@testable import SwiftStructure

@Suite("ConfigurationService Tests")
struct ConfigurationServiceTests {

    // MARK: - Load from Config File

    @Test(
        "Given a specified file path with configuration, when loading with ConfigurationService, then loads configuration from specified file path"
    )
    func loadsFromSpecifiedPath() throws {
        let yaml = """
            version: 2
            ordering:
              members:
                - initializer
            """
        let mockReader = MockFileReader(content: yaml)
        let service = ConfigurationService(fileReader: mockReader)

        let config = try service.load(configFile: "/path/to/config.yaml")

        #expect(config.version == 2)
        #expect(config.memberOrderingRules.count == 1)
        #expect(mockReader.lastReadPath == "/path/to/config.yaml")
    }

    @Test(
        "Given a non-existent config file path, when loading with ConfigurationService, then throws error when config file not found"
    )
    func throwsWhenFileNotFound() throws {
        let mockReader = MockFileReader(shouldThrow: true)
        let service = ConfigurationService(fileReader: mockReader)

        #expect(throws: Error.self) {
            _ = try service.load(configFile: "/nonexistent/config.yaml")
        }
    }

    @Test(
        "Given a configuration with custom extensions strategy, when loading with ConfigurationService, then loads configuration with custom extensions strategy"
    )
    func loadsWithCustomExtensionsStrategy() throws {
        let yaml = """
            version: 1
            extensions:
              strategy: merge
              respect_boundaries: false
            """
        let mockReader = MockFileReader(content: yaml)
        let service = ConfigurationService(fileReader: mockReader)

        let config = try service.load(configFile: "/path/to/config.yaml")

        #expect(config.extensionsStrategy == .merge)
        #expect(config.respectBoundaries == false)
    }

    // MARK: - Load with Directory Search

    @Test(
        "Given a directory without config files, when loading with ConfigurationService, then returns default configuration when no config file in directory hierarchy"
    )
    func returnsDefaultWhenNoConfigFile() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let service = ConfigurationService()
        let config = try service.load(from: tempDir.path)

        #expect(config == Configuration.default)
    }

    @Test(
        "Given a directory with config file, when loading with ConfigurationService, then finds and loads config file from directory"
    )
    func findsConfigFileInDirectory() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let configContent = """
            version: 3
            ordering:
              members:
                - deinitializer
            """
        let configPath = tempDir.appendingPathComponent(".swift-structure.yaml")
        try configContent.write(to: configPath, atomically: true, encoding: .utf8)

        let service = ConfigurationService()
        let config = try service.load(from: tempDir.path)

        #expect(config.version == 3)
        #expect(config.memberOrderingRules.count == 1)
    }

    // MARK: - Load with Optional Config Path

    @Test(
        "Given an optional config path with value, when loading with ConfigurationService, then loads from specified path"
    )
    func loadsFromOptionalConfigPath() throws {
        let yaml = """
            version: 4
            ordering:
              members:
                - typealias
            """
        let mockReader = MockFileReader(content: yaml)
        let service = ConfigurationService(fileReader: mockReader)

        let config = try service.load(configPath: "/custom/path/config.yaml")

        #expect(config.version == 4)
        #expect(mockReader.lastReadPath == "/custom/path/config.yaml")
    }

    @Test(
        "Given an optional config path with nil, when loading with ConfigurationService, then uses default search"
    )
    func loadsFromNilConfigPath() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let originalDir = FileManager.default.currentDirectoryPath
        FileManager.default.changeCurrentDirectoryPath(tempDir.path)
        defer { FileManager.default.changeCurrentDirectoryPath(originalDir) }

        let service = ConfigurationService()
        let config = try service.load(configPath: nil)

        // Should return default config since no config file exists
        #expect(config == Configuration.default)
    }
}
