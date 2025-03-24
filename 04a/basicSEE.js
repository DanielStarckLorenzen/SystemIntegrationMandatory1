const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors());

app.get("/events", (req, res) => {
    res.setHeader("Content-Type", "text/event-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.setHeader("Connection", "keep-alive");

    const sendEvent = () => {
        res.write(`data: ${JSON.stringify({ message: "Hello from SSE!" })}\n\n`);
    };

    sendEvent();
    const interval = setInterval(sendEvent, 5000);

    req.on("close", () => {
        clearInterval(interval);
    });
});

app.listen(3000, () => console.log("SSE server running on port 3000"));