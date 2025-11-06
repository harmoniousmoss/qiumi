import Foundation
import AsyncHTTPClient
import NIOCore
import NIOHTTP1

struct LlamaService {
    let configuration: Configuration
    let httpClient: HTTPClient

    struct ChatRequest: Codable {
        let model: String
        let stream: Bool
        let messages: [Message]
    }

    struct Message: Codable {
        let role: String
        let content: String
    }

    struct ChatResponse: Codable {
        let choices: [Choice]

        struct Choice: Codable {
            let message: Message
        }
    }

    func getAccessToken() async throws -> String {
        // Execute gcloud auth print-access-token
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["gcloud", "auth", "print-access-token"]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = Pipe()

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let token = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            throw LlamaServiceError.failedToGetAccessToken
        }

        return token
    }

    func sendPrompt(prompt: String) async throws -> String {
        print("🔑 Getting access token...")
        let token = try await getAccessToken()
        print("✅ Access token obtained")

        let url = "https://\(configuration.endpoint)/v1/projects/\(configuration.projectId)/locations/\(configuration.region)/endpoints/openapi/chat/completions"
        print("📡 API URL: \(url)")

        let systemPrompt = """
        You are Quimi, an AI assistant specialized in Indonesia-Australia economic relations.
        You provide insights on:
        - Trade partnerships and agreements
        - Investment opportunities and flows
        - Industrial collaboration and sector analysis
        - Policy frameworks and strategic decisions
        - Economic indicators and trends between Indonesia and Australia

        Provide clear, data-informed responses that help users understand the economic landscape
        between these two nations.
        """

        let chatRequest = ChatRequest(
            model: configuration.llamaModel,
            stream: false,
            messages: [
                Message(role: "system", content: systemPrompt),
                Message(role: "user", content: prompt)
            ]
        )

        let requestBody = try JSONEncoder().encode(chatRequest)
        print("📤 Sending request to Llama API...")

        var request = HTTPClientRequest(url: url)
        request.method = .POST
        request.headers.add(name: "Authorization", value: "Bearer \(token)")
        request.headers.add(name: "Content-Type", value: "application/json")
        request.body = .bytes(ByteBuffer(data: requestBody))

        let response = try await httpClient.execute(request, timeout: .seconds(30))
        print("📥 Response status: \(response.status.code)")

        guard response.status == .ok else {
            let responseBody = try await response.body.collect(upTo: 1024 * 1024)
            let errorBody = String(buffer: responseBody)
            print("❌ API Error (\(response.status.code)): \(errorBody)")
            throw LlamaServiceError.apiError(statusCode: response.status.code, message: errorBody)
        }

        let responseBody = try await response.body.collect(upTo: 1024 * 1024) // 1MB
        let responseBodyString = String(buffer: responseBody)
        print("📄 Response body: \(responseBodyString)")

        let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: Data(buffer: responseBody))

        guard let firstChoice = chatResponse.choices.first else {
            throw LlamaServiceError.noResponseContent
        }

        print("✅ Successfully received response from Llama API")
        return firstChoice.message.content
    }
}

enum LlamaServiceError: Error, CustomStringConvertible {
    case failedToGetAccessToken
    case apiError(statusCode: UInt, message: String)
    case noResponseContent

    var description: String {
        switch self {
        case .failedToGetAccessToken:
            return "Failed to get access token from gcloud"
        case .apiError(let statusCode, let message):
            return "API Error (\(statusCode)): \(message)"
        case .noResponseContent:
            return "No response content from API"
        }
    }
}
