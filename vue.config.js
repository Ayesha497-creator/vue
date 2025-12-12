module.exports = {
  publicPath: process.env.NODE_ENV === 'production'
    ? '/vue/test/'
    : '/',
  devServer: {
    host: '0.0.0.0',
    port: 8080
  }
};
