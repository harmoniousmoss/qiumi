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

   Copy `.env.example` to `.env` and update with your Google Cloud credentials:
   ```bash
   cp .env.example .env
   ```

   Edit `.env` and set your values:
   ```
   PROJECT_ID=your-project-id
   REGION=us-east5
   ENDPOINT=us-east5-aiplatform.googleapis.com
   LLAMA_MODEL=meta/llama-4-maverick-17b-128e-instruct-maas
   ```

3. **Authenticate with Google Cloud**
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```

### Running the Application

```bash
swift run
```

The server will start on `http://127.0.0.1:8080`

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
curl -X POST http://127.0.0.1:8080/insights \
  -H "Content-Type: application/json" \
  -d '{"question": "What are the key investment opportunities between Indonesia and Australia?"}'
```

## Example Questions

- "How are Indonesia and Australia partnering in the mining industry sector?"
- "What are the main trade agreements between Indonesia and Australia?"
- "What investment opportunities exist in renewable energy between both countries?"
- "How do Indonesia and Australia collaborate on agricultural exports?"
- "What are the key strategic decisions affecting Indonesia-Australia economic relations?"

## Technologies

- [Swift](https://swift.org/) - Programming language
- [Hummingbird](https://github.com/hummingbird-project/hummingbird) - Web framework
- [Llama 4](https://cloud.google.com/vertex-ai) - AI model via Google Cloud Vertex AI
- [AsyncHTTPClient](https://github.com/swift-server/async-http-client) - HTTP client

## License

This project is built using the [Hummingbird](https://github.com/hummingbird-project/hummingbird) framework.
