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

    <!-- Software Grid Start -->
    <div class="software-grid">
      <div class="software-card" v-for="(software, index) in softwareList" :key="index">
        <h4>{{ software.name }}</h4>
        <p>{{ software.description }}</p>
      </div>
    </div>
    <!-- Software Grid End -->

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

<script>
import ZoneTweet from "@/components/ZoneTweet";
import Tweet from "@/components/Tweet";

export default {
  name: "Home",
  components: {
    ZoneTweet,
    Tweet,
  },
  data() {
    return {
      softwareList: [
        { name: "🌐 Web Development", description: "Vue, React, Angular - Build stunning web apps." },
        { name: "🤖 AI & Machine Learning", description: "Python, TensorFlow, PyTorch - Create intelligent systems." },
        { name: "📱 Mobile Apps", description: "React Native, Flutter - Build cross-platform mobile apps." },
        { name: "⚡ Productivity Tools", description: "VS Code, Git, GitHub - Enhance your workflow." },
      ],
    };
  },
};
</script>

<style scoped lang="scss">
.home {
  border: 1px solid rgba(0, 0, 0, 0.08);

  .title {
    display: flex;
    justify-content: space-between;
    padding: 1rem;
    h3 {
      font-weight: 900;
      font-size: 23px;
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

  /* Software Grid Styles */
  .software-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 1rem;
    margin: 1rem;

    .software-card {
      background: linear-gradient(135deg, #89f7fe, #66a6ff);
      padding: 1rem;
      border-radius: 12px;
      box-shadow: 0 6px 15px rgba(102, 166, 255, 0.3);
      color: #fff;
      transition: transform 0.3s ease, box-shadow 0.3s ease;

      h4 {
        margin: 0 0 0.5rem 0;
        font-size: 18px;
        font-weight: 900;
      }

      p {
        margin: 0;
        font-size: 14px;
      }

      &:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 25px rgba(102, 166, 255, 0.5);
      }
    }
  }
}
</style>
