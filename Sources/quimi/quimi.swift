import Hummingbird

@main
struct QuimiApp {
    static func main() async throws {
        let router = Router()

        // Add a route for the root path
        router.get("/") { request, context in
            return "Welcome to Quimi - Indonesia-Australia Economic Explorer"
        }

        let app = Application(
            router: router,
            configuration: .init(address: .hostname("127.0.0.1", port: 8080))
        )

        try await app.runService()
    }
}
