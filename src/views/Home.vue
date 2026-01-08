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

    <div class="software-grid">
      <div class="software-card" v-for="(software, index) in softwareList" :key="index">
        <h4>{{ software.icon }} {{ software.name }}</h4>
        <p>{{ software.description }}</p>
      </div>
    </div>

    <ZoneTweet />
    <Tweet v-for="n in 25" :key="'tweet-' + n" />
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
        { id: 1, name: "Frontend Mastery", icon: "✨", color: "#42b883", description: "Crafting pixel-perfect interfaces." },
        { id: 2, name: "AI & Neural Labs", icon: "🧠", color: "#3776ab", description: "Deep learning models." },
        { id: 3, name: "Mobile Innovations", icon: "🚀", color: "#02559B", description: "High-speed mobile apps." },
        { id: 4, name: "Cloud & DevOps", icon: "☁️", color: "#FF9900", description: "Automating deployments." },
        { id: 5, name: "Cyber Security", icon: "🛡️", color: "#E34F26", description: "Protecting data integrity." },
        { id: 6, name: "Backend Engines", icon: "⚙️", color: "#8892BF", description: "Powerful API development." },
        { id: 7, name: "E-Commerce Solutions", icon: "🛒", color: "#9b59b6", description: "Seamless shopping." },
        { id: 8, name: "Database Architect", icon: "🗄️", color: "#00758f", description: "Optimized indexing." },
        { id: 9, name: "UI/UX Design Lab", icon: "🎨", color: "#f24e1e", description: "Interactive prototypes." },
        { id: 10, name: "Blockchain Systems", icon: "⛓️", color: "#34495e", description: "Decentralized apps." }
      ]
    };
  }
};
</script>

<style scoped lang="scss">
.home {
  border: 1px solid rgba(0, 0, 0, 0.08);

  .title {
    display: flex;
    justify-content: space-between;
    padding: 1rem;
    h3 { font-weight: 900; font-size: 23px; color: #1d9bf0; cursor: pointer; }
    img { cursor: pointer; }
  }

  .greeting {
    padding: 1rem;
    text-align: center;
    h2 { font-weight: 900; font-size: 32px; color: #ff6b9d; margin: 0; text-transform: lowercase; }
  }

  .notice-card {
    margin: 0 1rem 1rem;
    padding: 0.85rem 1rem;
    border-radius: 12px;
    background: linear-gradient(135deg, #ff6b9d, #c44569, #f8b500);
    box-shadow: 0 6px 18px rgba(255, 107, 157, 0.3);
    color: white;
    .headline { font-weight: 800; margin-bottom: 0.2rem; }
    .body { font-size: 14px; line-height: 1.4; margin: 0; }
  }

  .software-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 1rem;
    margin: 1rem;

    .software-card {
      background: linear-gradient(135deg, #89f7fe, #66a6ff);
      padding: 1rem;
      border-radius: 12px;
      color: #fff;
      transition: transform 0.3s ease;

      h4 { margin: 0 0 0.5rem 0; font-size: 18px; font-weight: 900; }
      p { margin: 0; font-size: 14px; }
      &:hover { transform: translateY(-5px); }
    }
  }
}
</style>
