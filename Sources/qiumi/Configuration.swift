import Foundation

struct Configuration {
    let projectId: String
    let region: String
    let endpoint: String
    let llamaModel: String

    static func load() throws -> Configuration {
        // Try to load from .env file
        let envPath = ".env"
        if let envContents = try? String(contentsOfFile: envPath, encoding: .utf8) {
            var config: [String: String] = [:]

            envContents.split(separator: "\n").forEach { line in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                // Skip comments and empty lines
                guard !trimmed.isEmpty && !trimmed.hasPrefix("#") else { return }

                let parts = trimmed.split(separator: "=", maxSplits: 1)
                if parts.count == 2 {
                    let key = String(parts[0]).trimmingCharacters(in: .whitespaces)
                    let value = String(parts[1]).trimmingCharacters(in: .whitespaces)
                    config[key] = value
                }
            }

            guard let projectId = config["PROJECT_ID"],
                  let region = config["REGION"],
                  let endpoint = config["ENDPOINT"],
                  let llamaModel = config["LLAMA_MODEL"] else {
                throw ConfigurationError.missingEnvironmentVariables
            }

            return Configuration(
                projectId: projectId,
                region: region,
                endpoint: endpoint,
                llamaModel: llamaModel
            )
        }

        throw ConfigurationError.envFileNotFound
    }
}

enum ConfigurationError: Error {
    case envFileNotFound
    case missingEnvironmentVariables
}
