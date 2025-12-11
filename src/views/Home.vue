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
    <div class="notice-card" data-test-id="home-notice">
      <p class="headline">✨ Fresh update just landed!</p>
      <p class="body">
        We’re polishing the timeline experience—keep an eye out for smoother
        interactions and new touches as you scroll.
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
      color: #000;
      cursor: pointer;
    }
    img {
      cursor: pointer;
    }
  }

  .notice-card {
    margin: 0 1rem 1rem;
    padding: 0.85rem 1rem;
    border-radius: 12px;
    background: linear-gradient(135deg, #e8f5fe, #eef6ff);
    border: 1px solid rgba(29, 155, 240, 0.3);
    box-shadow: 0 6px 18px rgba(0, 0, 0, 0.06);
    .headline {
      font-weight: 800;
      font-size: 16px;
      color: #0f1419;
      margin-bottom: 0.2rem;
    }
    .body {
      font-size: 14px;
      color: #4b5563;
      line-height: 1.4;
      margin: 0;
    }
  }
}
</style>
