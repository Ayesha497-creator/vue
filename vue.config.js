module.exports = {
  publicPath: process.env.NODE_ENV === 'production'
    ? '/vue/'   // yahan '/twitter-clone/' ki jagah '/vue/' rakho
    : '/',
  devServer: {
    host: '0.0.0.0',
    port: 8080,
    allowedHosts: 'all'
  }
};
