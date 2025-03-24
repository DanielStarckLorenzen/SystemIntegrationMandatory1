const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });

console.log('WebSocket server started on port 8080');

wss.on('connection', (ws) => {
  console.log('Client connected');
  
  ws.send('Welcome to the WebSocket server!');
  
  ws.on('message', (message) => {
    console.log(`Received message: ${message}`);
    
    ws.send(`Server received: ${message}`);
  });
  
  ws.on('close', () => {
    console.log('Client disconnected');
  });
}); 