# WebSocket Example

This is a simple WebSocket example with a server and client implementation.

## Prerequisites

- Node.js installed
- npm (comes with Node.js)

## Setup

Make sure you have installed the required dependencies:

```bash
npm install ws
```

## Running the Example

1. Start the WebSocket server:

```bash
node server.js
```

You should see "WebSocket server started on port 8080" in the console.

2. Open the client.html file in a web browser.
   - You can do this by double-clicking the file or opening it from your browser's File menu.
   - Alternatively, you can serve it with a simple HTTP server if needed.

3. Using the client:
   - Click "Connect" to establish a WebSocket connection
   - Type a message in the input field and click "Send" (or press Enter)
   - The server will echo back the message
   - Click "Disconnect" to close the connection

## How It Works

- The server (server.js) creates a WebSocket server that listens on port 8080
- When a client connects, the server sends a welcome message
- For any message received from a client, the server echoes it back
- The client (client.html) provides a UI to connect, send messages, and disconnect
- Messages are displayed in the message area with different styles based on their type (sent, received, system) 