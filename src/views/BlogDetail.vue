<template>
  <div>
    <Header></Header>
    <div class="content">
      <h1>{{ blog.title }}</h1>
      <div class="new-meta-box">
        <div class="new-meta-item">
          <i class="el-icon-user-solid" aria-hidden="true"></i>
          <h5>{{ blog.author }}</h5>
        </div>
        <div class="new-meta-item date">
          <i class="el-icon-s-order" aria-hidden="true"></i>
          <a class="notlink">

            <p>{{ blog.commitTime }}</p>
          </a>
        </div>

        <div class="new-meta-item date">
          <i class="el-icon-view" aria-hidden="true"></i>
          <a class="notlink">

            <p>{{ blog.isBlogHide }}</p>
          </a>
        </div>
        <div class="new-meta-item date">
          <i class="el-icon-bangzhu" aria-hidden="true"></i>
          <a class="notlink">

            <p>{{ blog.codeLanguage }}</p>
          </a>
        </div>
      </div>

      <div class="new-meta-box meta-box-remark">
        <div class="new-meta-item date">
          <i class="el-icon-s-claim" aria-hidden="true"></i>
          <a class="notlink">

            <p>{{ blog.remark }}</p>
          </a>
        </div>
      </div>
      <br />
      <div class="new-meta-box meta-box-desc">
        <div class="new-meta-item date">
          <i class="el-icon-s-ticket" aria-hidden="true"></i>
          <a class="notlink">

            <p>{{ blog.description }}</p>
          </a>
        </div>
      </div>

      <el-button-group class="button group-button">
        <el-button type="primary" icon="el-icon-edit" @click="toEdit">编辑</el-button>
        <el-button type="danger" icon="el-icon-delete" @click="toDelete">删除</el-button>
      </el-button-group>

      <el-divider>
        <i class="el-icon-reading"></i>
      </el-divider>
      <div class="markdown-body" v-html="blog.content"></div>
    </div>
    <Footer></Footer>
  </div>
</template>

<script>
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import "github-markdown-css";

export default {
  components: {Header, Footer},
  data() {
    return {
      blog: {
        id: "",
        title: "",
        content: "",
        gmtStatus: null,
        author: "",
        userId: "",
        avatar: "https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png"
      },
      ownBlog: true   // TODO:改false
    };
  },
  methods: {
    toEdit() {
      // TODO:测试后要!=
      if (this.$store.getters.getUserInfo.id != this.blog.userId) {
        this.$message({
          type: "error",
          message: "对不起！你并非博文发布者无法编辑修改！"
        });
      } else {
        this.$router.push({name: "BlogEdit", params: {blogId: this.blog.id}});
        console.log("essay:")
        // this.$router.push({ name: "EssayEdit", params: { blogId: this.blog.id } });
      }
    },
    toDelete() {
      this.$confirm("是否删除该博文？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      })
          .then(() => {
            if (this.$store.getters.getUserInfo.id != this.blog.userId) {
              this.$message({
                type: "error",
                message: "删除失败！对不起，你并非博文作者无权限删除!"
              });
            } else {
              this.$axios
                  .get("/blog/delete/" + this.blog.id, {
                    headers: {
                      Authorization: localStorage.getItem("token")
                    }
                  })
                  .then(res => {
                    this.$router.push({name: "Blog"});
                  });
              this.$message({
                type: "success",
                message: "删除成功!"
              });
            }
          })
          .catch(() => {
            this.$message({
              type: "info",
              message: "已取消删除"
            });
          });
    }
  },
  created() {
    let blogId = this.$route.params.blogId;
    if (blogId) {
      this.$axios.get("/blog/" + blogId).then(res => {
        let blog = res.data.data;
        this.blog.id = blog.id;
        this.blog.title = blog.title;
        this.blog.userId = blog.userId;
        this.blog.gmtCreate = blog.gmtCreate;
        this.blog.author = blog.author;
        this.blog.isBlogHide = blog.isBlogHide;
        this.blog.codeLanguage = blog.codeLanguage;
        this.blog.remark= blog.remark;
        this.blog.commitTime= blog.commitTime;
        this.blog.description= blog.description;
        let content = blog.content;
        content = "```"+blog.codeLanguage+"\n"+content +"\n```"
        // 进行css渲染
        let MardownIt = require("markdown-it");
        let md = new MardownIt();

        let result = md.render(content);
        console.log("md_content:"+content)

        this.blog.content = result;
        // 判断是否为该作者，是才能编辑
        // TODO: 要解开注释
        // this.ownBlog = blog.userId === this.$store.getters.getUserInfo.id;

      });
    }
  }
};
</script>

<style scoped>
.button {
  padding-left: 200px;
}

.new-meta-item a {
  text-decoration: none;
  color: rgba(68, 68, 68, 0.65);
  padding-left: 0;
  padding-right: 4px;
}

.new-meta-box {
  padding-left: 400px;
  -webkit-transition: all 0.1s ease;
  font-size: 0.8125rem;
  padding-top: px;
  padding-bottom: 2px;
  display: flex;
  align-items: center;
  float: left;
  flex-wrap: wrap;
}

.new-meta-item {
  color: rgba(68, 68, 68, 0.65);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2px;
  margin: 0 8px 0 0;
  border-radius: 4px;
}

.content {
  /*margin-top: 60px;*/
  padding: 60px 15px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  width: 80%;
  margin: 60px auto;
  min-height: 700px;
}

.edit {
  color: skyblue;
  text-decoration: none;
}

.edit:hover {
  color: red;
  scale: 1;
}

h1 {
  padding: calc(var(--sp) / 2) 0 var(--sp);
  text-align: center;
  transition: color .6s;
  color: var(--t);
  margin: 2.75rem 0 1rem;
  font-family: Product Sans, Oswald, -apple-system, BlinkMacSystemFont, Segoe UI, Helvetica, Arial, sans-serif;
  font-weight: 600;
  line-height: 1.5;
}

.markdown-body {
  width: 70%;
  margin: 0 auto;
}
  .meta-box-remark{
    width: 100%;
  }
.meta-box-desc{
  width: 100%;
}
  .group-button{
      margin-right: 30px;
    padding-left: 80%;
  }
</style>