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
    { 
      id: 1,
      name: "Frontend Mastery", 
      icon: "✨",
      color: "#42b883", // Vue Green
      techStack: ["Vue.js", "React", "Tailwind"],
      description: "Crafting pixel-perfect, responsive interfaces that users love to interact with.",
      status: "High Performance"
    },
    { 
      id: 2,
      name: "AI & Neural Labs", 
      icon: "🧠",
      color: "#3776ab", // Python Blue
      techStack: ["Python", "PyTorch", "OpenAI"],
      description: "Implementing deep learning models and automated intelligence for complex problem solving.",
      status: "Cutting Edge"
    },
    { 
      id: 3,
      name: "Mobile Innovations", 
      icon: "🚀",
      color: "#02559B", // Flutter Blue
      techStack: ["Flutter", "React Native", "Swift"],
      description: "High-speed native and cross-platform mobile apps with seamless animations.",
      status: "Multi-Platform"
    },
    { 
      id: 4,
      name: "Cloud & DevOps", 
      icon: "☁️",
      color: "#FF9900", // AWS Orange
      techStack: ["Docker", "Jenkins", "AWS"],
      description: "Automating deployments and scaling infrastructure with 99.9% uptime guarantee.",
      status: "Rock Solid"
    },
    { 
      id: 5,
      name: "Cyber Security", 
      icon: "🛡️",
      color: "#E34F26", // Security Red
      techStack: ["Kali", "OAuth", "PenTesting"],
      description: "Protecting data integrity and ensuring secure communication across all digital assets.",
      status: "Highly Secure"
    },
    { 
      id: 6,
      name: "Backend Engines", 
      icon: "⚙️",
      color: "#8892BF", // PHP/Laravel Purple
      techStack: ["Laravel", "Node.js", "Go"],
      description: "Powerful API development and database management for high-traffic applications.",
      status: "Ultra Scalable"
    },
    { 
      id: 7,
      name: "E-Commerce Solutions", 
      icon: "🛒",
      color: "#9b59b6", // Amethyst Purple
      techStack: ["Shopify", "WooCommerce", "Stripe"],
      description: "Building seamless shopping experiences with secure payment gateways and inventory tracking.",
      status: "Sales Optimized"
    },
    { 
      id: 8,
      name: "Database Architect", 
      icon: "🗄️",
      color: "#00758f", // MySQL Blue
      techStack: ["PostgreSQL", "MongoDB", "Redis"],
      description: "Designing high-availability data structures and optimized query indexing for speed.",
      status: "Data Driven"
    },
    { 
      id: 9,
      name: "UI/UX Design Lab", 
      icon: "🎨",
      color: "#f24e1e", // Figma Orange
      techStack: ["Figma", "Adobe XD", "Protopie"],
      description: "Creating user-centric wireframes and interactive prototypes that bridge beauty and function.",
      status: "User Centric"
    },
    { 
      id: 10,
      name: "Blockchain Systems", 
      icon: "⛓️",
      color: "#34495e", // Ethereum Gray
      techStack: ["Solidity", "Web3.js", "Smart Contracts"],
      description: "Developing decentralized applications and secure ledger systems for the digital economy.",
      status: "Decentralized"
    }
  ],
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
