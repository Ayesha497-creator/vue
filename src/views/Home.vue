<script>
import ZoneTweet from "@/components/ZoneTweet";
import Tweet from "@/components/Tweet";

export default {
  name: "Home",
  components: {
    ZoneTweet,
    Tweet,
  },
};
</script>

<template>
  <div id="home-page" class="home">
    <div class="title">
      <h3>Home</h3>
      <img src="@/assets/img/starsicon.png" alt="" class="icon" />
    </div>
    <div class="greeting">
      <h2>hi ayesha</h2>
    </div>
    <div class="notice-card" data-test-id="home-notice">
      <p class="headline">🎨 Colorful Update!</p>
      <p class="body">
        Welcome to the new vibrant design! Enjoy the fresh colors and improved
        user experience.
      </p>
    </div>
    <ZoneTweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
    <Tweet />
  </div>
</template>

<style scoped lang="scss">
.home {
  // max-width: 600px;
  // min-width: 598px;
  border: 1px solid rgba(0, 0, 0, 0.08);

  .title {
    display: flex;
    justify-content: space-between;
    padding: 1rem;
    h3 {
      font-weight: 900;
      font-size: 23px;
      line-height: 22.27px;
      color: #1d9bf0;
      cursor: pointer;
    }
    img {
      cursor: pointer;
    }
  }

  .greeting {
    padding: 1rem;
    text-align: center;
    h2 {
      font-weight: 900;
      font-size: 32px;
      color: #ff6b9d;
      margin: 0;
      text-transform: lowercase;
    }
  }

  .notice-card {
    margin: 0 1rem 1rem;
    padding: 0.85rem 1rem;
    border-radius: 12px;
    background: linear-gradient(135deg, #ff6b9d, #c44569, #f8b500);
    border: 2px solid rgba(255, 107, 157, 0.5);
    box-shadow: 0 6px 18px rgba(255, 107, 157, 0.3);
    .headline {
      font-weight: 800;
      font-size: 16px;
      color: #ffffff;
      margin-bottom: 0.2rem;
    }
    .body {
      font-size: 14px;
      color: #fff8e1;
      line-height: 1.4;
      margin: 0;
    }
  }
}
</style>

