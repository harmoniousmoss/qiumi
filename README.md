# Quimi

**Indonesia-Australia Economic Explorer**

Quimi delivers preliminary insights into the Indonesia-Australia economic landscape—covering policy, investment, and strategic decisions.

## About

Quimi is a web application built with Swift and Hummingbird that leverages Llama 4 AI to provide intelligent insights and analysis on the economic relationship between Indonesia and Australia.

## Features

- AI-powered insights using Llama 4 (Meta)
- Real-time analysis of Indonesia-Australia economic partnerships
- Industry sector collaboration insights
- Investment and policy analysis
- RESTful API endpoints

## Getting Started

### Prerequisites
- Swift 6.2 or later
- macOS 14 or later
- Google Cloud account with Llama 4 API access
- gcloud CLI installed and authenticated

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/harmoniousmoss/qiumi.git
   cd qiumi
   ```

2. **Configure environment variables**

   Create a `.env` file in the project root:
   ```bash
   touch .env
   ```

   Add your Google Cloud configuration to `.env`:
   ```bash
   PROJECT_ID=
   REGION=
   ENDPOINT=
   LLAMA_MODEL=
   ```

   Refer to [Google Cloud Vertex AI Llama documentation](https://cloud.google.com/vertex-ai) for the appropriate values for your setup.

   > **Note:** The `.env` file is gitignored and will not be committed to the repository.

3. **Authenticate with Google Cloud**

   Make sure you have gcloud CLI installed and authenticated:
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```

   The application will automatically use your gcloud credentials to access the Llama 4 API.

### Running the Application

Build and run the application:
```bash
swift build
swift run
```

The server will start on `http://127.0.0.1:8080`

You should see:
```
2025-11-06T16:52:02+0700 info Hummingbird: [HummingbirdCore] Server started and listening on 127.0.0.1:8080
```

## API Usage

### Get Economic Insights

**Endpoint:** `POST /insights`

**Request Body:**
```json
{
  "question": "How are Indonesia and Australia partnering in the mining industry sector?"
}
```

**Response:**
```json
{
  "answer": "Indonesia and Australia have established significant partnerships in the mining sector..."
}
```

**Example using curl:**
```bash
curl -X POST http://127.0.0.1:8080/insights -H "Content-Type: application/json" -d '{"question": "What are the key investment opportunities between Indonesia and Australia?"}'
```

> **Important:** Make sure the entire command is on one line, or if using line breaks with `\`, ensure there are no line breaks inside the JSON string value.

## Example Questions

- "How are Indonesia and Australia partnering in the mining industry sector?"
- "What are the main trade agreements between Indonesia and Australia?"
- "What investment opportunities exist in renewable energy between both countries?"
- "How do Indonesia and Australia collaborate on agricultural exports?"
- "What are the key strategic decisions affecting Indonesia-Australia economic relations?"

## Architecture

- **Configuration**: Environment variable loader for secure credential management
- **LlamaService**: HTTP client wrapper for Google Cloud Vertex AI Llama 4 API
- **API Endpoints**: RESTful endpoints with comprehensive error handling
- **Logging**: Detailed request/response logging for debugging

## Technologies

- [Swift](https://swift.org/) - Programming language
- [Hummingbird](https://github.com/hummingbird-project/hummingbird) - Web framework
- [Llama 4](https://cloud.google.com/vertex-ai) - AI model via Google Cloud Vertex AI
- [AsyncHTTPClient](https://github.com/swift-server/async-http-client) - HTTP client

## Security

- The `.env` file containing sensitive credentials is excluded from version control
- All API requests use OAuth 2.0 tokens via Google Cloud CLI
- Environment variables are loaded at runtime from `.env` file

## Contributing

When contributing, ensure:
1. Never commit the `.env` file
2. Update `.env.example` with any new configuration variables (without values)
3. Test API endpoints thoroughly before submitting changes

## License

This project is built using the [Hummingbird](https://github.com/hummingbird-project/hummingbird) framework.
