import Hummingbird
import HTTPTypes

struct CORSMiddleware<Context: RequestContext>: RouterMiddleware {
    func handle(_ request: Request, context: Context, next: (Request, Context) async throws -> Response) async throws -> Response {
        var response = try await next(request, context)

        // Add CORS headers to all responses
        response.headers[.init("Access-Control-Allow-Origin")!] = "*"
        response.headers[.init("Access-Control-Allow-Methods")!] = "GET, POST, OPTIONS"
        response.headers[.init("Access-Control-Allow-Headers")!] = "Content-Type"
        response.headers[.init("Access-Control-Max-Age")!] = "86400"

        return response
    }
}
