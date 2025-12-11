module.exports = {
  publicPath: process.env.NODE_ENV === 'production'
    ? '/vue/'   // yahan '/twitter-clone/' ki jagah '/vue/' rakho
    : '/',
};

