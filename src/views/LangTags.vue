<template>
  <div>
    <Header></Header>
    <el-row :gutter="20" class="container-tag">
      <el-col :span="5"><div class="grid-content bg-purple"></div></el-col>
      <el-col :span="14"><div class="grid-content bg-purple">

        <div v-for="o in 10" :key="o" class="text item">
          <el-card class="box-card" style="background-color: #88c2fa">
            <div slot="header" class="clearfix">
              <span><h2 style="text-align: center">java
<!--                          <router-link :to="/blog">java</router-link>-->
<!--                                <router-link class="link" :to="{name:'LangTags',params:{blogId:blog.id}}">{{o+'java'}}</router-link>-->
              </h2></span>
              <!--            <el-button style="float: right; padding: 3px 0" type="text">操作按钮</el-button>-->
            </div>
            <span style="font-size: xx-small">代码段数量：</span>
          </el-card>
        </div>


      </div></el-col>
      <el-col :span="5"><div class="grid-content bg-purple"></div></el-col>
    </el-row>
    <Footer></Footer>
  </div>

</template>

<script>
import Header from "@/components/Header";
import Footer from "@/components/Footer";

export default {
  components: {Header, Footer},
  data() {
    return {
      blogContents: {},
      currentPage: 1,
      drawer: false,
      message: "",
      total: 0,
      loading: false,
      pageSize: 5,
      deviceType: '',
      yiyan: "",
      avatar: require("@/asserts/img/default_user.jpg"),
    };
  },

  methods: {
    getPage(currentPage) {
      this.loading = true;
      const _this = this;
      _this.$axios.get("/blogs?currentPage=" + currentPage).then(res => {
        _this.blogContents = res.data.data.records;
        _this.currentPage = res.data.data.current;
        _this.total = res.data.data.total;
        _this.pageSize = res.data.data.size;
      }).catch(() => {
        console.log("请求发生错误")
        alert("请求发生错误，请看官稍后重试鸭")
      }).finally(() => {
        this.loading = false;
      });
    },
    getYiYan() {
      this.$axios.post("https://api.xygeng.cn/one").then(res => {
        this.loading = true;
        const data = res.data.data
        console.log("res:" + data.content)
        this.yiyan = data.content + "————" + data.origin
      }).catch(e => {
        console.log("error:" + e)
      }).finally(() => {
        this.loading = false;
      });
    },
    _isMobile() {
      let flag = navigator.userAgent.match(/(phone|pad|pod|iPhone|iPod|ios|iPad|Android|Mobile|BlackBerry|IEMobile|MQQBrowser|JUC|Fennec|wOSBrowser|BrowserNG|WebOS|Symbian|Windows Phone)/i)
      return flag;
    },
  },
  created() {
    this.getPage(1);

  },
  mounted() {
    if (this._isMobile()) {
      console.log("手机端")
      this.deviceType = 'mobile'
    } else {
      console.log("pc端")
      this.deviceType = 'pc'
    }
    this.getYiYan();
  }
};
</script>

<style scoped>
body {
  margin: 0;
  padding: 0;
}

.main-contain {
  margin-top: 10px;
  padding-bottom: 10px;
}

.each-card {
  height: 220px;
  margin-top: 20px;
}

.el-descriptions-item__container a {
  text-decoration: none;
  line-height: 20px;
}

.descriptions-wrapper .el-descriptions__title {
  color: #333;
  font-size: 16px;
  font-weight: bold;
}

.bolg-link:hover {
  /*background-color: ;*/
  text-decoration: none;
}

.code-title {
  font-weight: bold;
}

.first-blog {
  margin-top: 60px; /* 设置距离顶部的距离 */
}
  .container-tag{
    margin-top: 60px;
  }
.box-card{
  width: 10rem;
  height: 10rem;
  float: left;
  margin-left: 3rem;
}
</style>