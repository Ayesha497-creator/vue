module.exports = {
  // Vue CLI automatically loads .env files based on mode
  // Use VUE_APP_BASE_URL from .env.[mode] files
  publicPath: process.env.VUE_APP_BASE_URL || '/',
  devServer: {
    host: '0.0.0.0',
    port: 8080
  }
};

