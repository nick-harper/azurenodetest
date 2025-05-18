const express = require('express');
const app = express();
const port = 3000;

// Sample quotes
const quotes = [
  "Deploy like nobody's watching.",
  "Keep calm and automate everything.",
  "Ship it!",
  "Logs or it didn't happen.",
  "Your pipeline is your superpower."
];

// Root route
app.get('/', (req, res) => {
  res.send(`
    <h1 style="font-family:sans-serif;">🚀 DevOps Lab</h1>
    <p>Hello World from Node.js!</p>
    <p>Try: <a href="/status">/status</a>, <a href="/quote">/quote</a></p>
  `);
});

// Health check route
app.get('/status', (req, res) => {
  res.json({
    status: "ok",
    time: new Date().toISOString(),
    version: "1.0.0"
  });
});

// Random quote route
app.get('/quote', (req, res) => {
  const random = quotes[Math.floor(Math.random() * quotes.length)];
  res.json({ quote: random });
});

// Start server
app.listen(port, '0.0.0.0', () => {
  console.log(`\x1b[36mApp running on http://localhost:${port}\x1b[0m`);
});
