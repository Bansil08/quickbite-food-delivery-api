require('dotenv').config();

const app = require('./app');
const { testConnection } = require('./config/db');

const PORT = parseInt(process.env.PORT, 10) || 3000;

const startServer = async () => {
  
  await testConnection();

  const server = app.listen(PORT, () => {
    console.log(`🚀  Quick-Bite API server started`);
    console.log(`    → Local:   http://localhost:${PORT}`);
    console.log(`    → Health:  http://localhost:${PORT}/health`);
    console.log(`    → Env:     ${process.env.NODE_ENV || 'development'}`);
  });

  const gracefulShutdown = (signal) => {
    console.log(`\n⚠️   Received ${signal}. Shutting down gracefully...`);
    server.close(() => {
      console.log('✅  HTTP server closed. Exiting process.');
      process.exit(0);
    });

    setTimeout(() => {
      console.error('❌  Forced shutdown after timeout.');
      process.exit(1);
    }, 10_000);
  };

  process.on('SIGTERM', () => gracefulShutdown('SIGTERM')); 
  process.on('SIGINT', () => gracefulShutdown('SIGINT'));   
};

startServer();
