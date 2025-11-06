import Hummingbird
import AsyncHTTPClient
import Foundation

@main
struct QiumiApp {
    static func main() async throws {
        // Load configuration
        let config = try Configuration.load()

        // Create HTTP client
        let httpClient = HTTPClient(eventLoopGroupProvider: .singleton)

        // Create Llama service
        let llamaService = LlamaService(configuration: config, httpClient: httpClient)

        let router = Router()

        // Add a route for the root path
        router.get("/") { request, context in
            return "Welcome to Qiumi - Indonesia-Australia Economic Explorer"
        }

        // Add insights endpoint
        router.post("/insights") { request, context -> Response in
            struct InsightRequest: Decodable {
                let question: String
            }

            struct InsightResponse: Encodable {
                let answer: String
            }

            do {
                print("📨 Received request at /insights")
                let insightRequest = try await request.decode(as: InsightRequest.self, context: context)
                print("❓ Question: \(insightRequest.question)")

                let answer = try await llamaService.sendPrompt(prompt: insightRequest.question)

                let response = InsightResponse(answer: answer)
                let responseData = try JSONEncoder().encode(response)

                var headers: HTTPFields = [:]
                headers[.contentType] = "application/json"

                return Response(
                    status: .ok,
                    headers: headers,
                    body: .init(byteBuffer: ByteBuffer(data: responseData))
                )
            } catch let error as LlamaServiceError {
                print("❌ Llama Service Error: \(error.description)")
                let errorResponse = ["error": error.description]
                let errorData = try! JSONEncoder().encode(errorResponse)

                var headers: HTTPFields = [:]
                headers[.contentType] = "application/json"

                return Response(
                    status: .internalServerError,
                    headers: headers,
                    body: .init(byteBuffer: ByteBuffer(data: errorData))
                )
            } catch {
                print("❌ Unexpected Error: \(error)")
                let errorResponse = ["error": error.localizedDescription]
                let errorData = try! JSONEncoder().encode(errorResponse)

                var headers: HTTPFields = [:]
                headers[.contentType] = "application/json"

                return Response(
                    status: .internalServerError,
                    headers: headers,
                    body: .init(byteBuffer: ByteBuffer(data: errorData))
                )
            }
        }

        let app = Application(
            router: router,
            configuration: .init(address: .hostname("127.0.0.1", port: 8080))
        )

        // Run the service and shutdown HTTP client when done
        do {
            try await app.runService()
        } catch {
            throw error
        }

        try await httpClient.shutdown()
    }
}
