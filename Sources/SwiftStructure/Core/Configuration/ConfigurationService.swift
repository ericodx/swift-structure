import Foundation

struct ConfigurationService {

    init(
        fileReader: FileReading = FileReader(),
        loader: ConfigurationLoader = ConfigurationLoader(),
        mapper: ConfigurationMapper = ConfigurationMapper()
    ) {
        self.fileReader = fileReader
        self.loader = loader
        self.mapper = mapper
    }

    private let fileReader: FileReading
    private let loader: ConfigurationLoader
    private let mapper: ConfigurationMapper
    private let configFileName = ".swift-structure.yaml"

    func load(from directory: String? = nil) throws -> Configuration {
        let startDirectory = directory ?? FileManager.default.currentDirectoryPath

        guard let configPath = findConfigFile(startingFrom: startDirectory) else {
            return .default
        }

        return try loadFromFile(at: configPath)
    }

    func load(configFile: String) throws -> Configuration {
        try loadFromFile(at: configFile)
    }

    func load(configPath: String?) throws -> Configuration {
        if let path = configPath {
            return try load(configFile: path)
        }
        return try load()
    }

    private func loadFromFile(at path: String) throws -> Configuration {
        let content = try fileReader.read(at: path)
        let raw = try loader.parse(content)
        return mapper.map(raw)
    }

    private func findConfigFile(startingFrom directory: String) -> String? {
        var currentPath = URL(fileURLWithPath: directory).standardized

        while currentPath.path != "/" {
            let configPath = currentPath.appendingPathComponent(configFileName).path
            if FileManager.default.fileExists(atPath: configPath) {
                return configPath
            }
            currentPath = currentPath.deletingLastPathComponent()
        }

        return nil
    }
}
