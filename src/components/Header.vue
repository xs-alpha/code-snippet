<template>
  <div class="nav-wrapper">
    <nav class="nav">
      <ul class="header-link">
        <li v-for="(item, index) in menuItems" :key="index" :class="{ active: item.active }">
          <router-link :to="item.link">{{ item.text }}</router-link>
        </li>
      </ul>
    </nav>
  </div>
</template>

<script>
export default {
  data() {
    return {
      menuItems: [
        {text: '首页', link: '/', active: true},
        {text: '发布', link: '/blog/add', active: false},
        {text: '分类', link: '/services', active: false},
        {text: '关于我们', link: '/about', active: false},
        {text: '联系我们', link: '/contact', active: false},
      ],
    };
  },
};
</script>

<style scoped>
body {
  margin: 0;
  padding: 0;
}

nav {
  padding-top: 0;
  background-color: #333;
  height: 50px;
  display: flex;
  justify-content: center;
}

ul {
  list-style: none;
  display: flex;
  align-items: center;
  margin: 0;
  padding: 0;
}

li {
  margin-right: 20px;
}

li:last-child {
  margin-right: 0;
}

a {
  color: #fff;
  text-decoration: none;
  font-weight: bold;
  padding: 0 10px;
  line-height: 50px;
  display: block;
  transition: background-color 0.3s ease;
}

/*a:hover {*/
/*  background-color: #555;*/
/*}*/
li:hover {
  background-color: #555;
}

li.active a {
  background-color: #555;
}

.nav-wrapper {
  position: fixed;
  top: 0;
  width: 100%;
  z-index: 999;
}
</style>
