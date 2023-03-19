<template>
  <div>
    <Header></Header>
    <div v-if="this.deviceType==='pc'" class="yiyan">
      <!--      <el-card class="box-card yiyancard" shadow="hover" style="height: 50px">-->
      <!--        <div >搜索</div>-->
      <div class="search" style="margin: 2rem auto;width: 470px;z-index: -100">
        <el-input
            class="searchContent"
            type="text"
            prefix-icon="el-icon-search"
            v-model="searchContent"
            placeholder="搜索文章：请输入"
            style="width: 470px; cursor: pointer"
            @keyup.enter.native="getPage"
        ></el-input>
      </div>
      <!--      </el-card>-->
    </div>
    <div class="block">
      <el-timeline>
        <el-timeline-item
            placement="top"
            v-for="(blog,index) in blogContents"
            :key="index"
        >
          <el-card id="el-card-id">
            <div class="outer-top" v-if="blog.isTop===1"
                 style="width: 4rem;height: 2rem;color: white;background-color: #ffa600; z-index: 999;padding-top: 0;padding-left: 0;margin-top: 0;margin-left: 0;position: absolute;float: left">
              <span class="inner-top">置顶</span></div>
            <h2>
              <router-link class="link" :to="{name:'BlogDetail',params:{blogId:blog.id}}">{{ blog.title }}</router-link>
            </h2>
            <div class="new-meta-box">
              <div class="new-meta-item">
                <i class="el-icon-user-solid" aria-hidden="true"></i>


                <router-link class="link" :to="{name:'User',params:{username:blog.author}}">{{ blog.author }}
                </router-link>
              </div>
              <div class="new-meta-item date">
                <i class="el-icon-s-order" aria-hidden="true"></i>
                <a class="notlink">

                  <p>{{ blog.gmtCreate }}</p>
                </a>
              </div>
              <div class="new-meta-item date">
                <i class="el-icon-view" aria-hidden="true"></i>
                <a class="notlink">

                  <p>{{ blog.isBlogHide }}</p>
                </a>
              </div>
            </div>
            <div class="fenge">
              <el-divider></el-divider>
            </div>
            <blockquote>
              <p><i class="el-icon-collection-tag"></i>简介：{{ blog.description }}</p>
            </blockquote>
          </el-card>
        </el-timeline-item>
      </el-timeline>
      <!--分页-->
      <el-pagination class="pager" background layout="prev, pager, next"
                     :current-page="currentPage"
                     :page-size="pageSize"
                     :total="total"
                     @current-change="getPage">
      </el-pagination>
    </div>
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
      total: 0,
      deviceType: '',
      searchContent: '',
      pageSize: 5,
      avatar: require("@/asserts/img/default_user.jpg"),
    };
  },

  methods: {
    getPage(currentPage) {
      if (currentPage.code != null) {
        currentPage = 1
      }
      const _this = this;
      const data = {
        searchContent: this.searchContent
      }
      _this.$axios.post("/myblogs?currentPage=" + currentPage, data, {
            headers: {
              Authorization: localStorage.getItem("token")
            },
          }
      ).then(res => {
        _this.blogContents = res.data.data.records;
        _this.currentPage = res.data.data.current;
        _this.total = res.data.data.total;
        _this.pageSize = res.data.data.size;
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
  }
};
</script>

<style scoped>
.fenge .el-divider {
  margin: 2px 0 !important;
}

#el-card-id {
  width: 100%;
}

.new-meta-item a {
  text-decoration: none;
  color: rgba(68, 68, 68, 0.65);
  padding-left: 0;
  padding-right: 4px;
}

.new-meta-box {
  -webkit-transition: all 0.1s ease;
  font-size: 0.8125rem;
  padding-top: px;
  padding-bottom: 2px;
  display: flex;
  align-items: center;
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

blockquote {
  margin-left: 2px;
  text-align: left;
  font-size: 0.9375rem;
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
  position: relative;
  width: 95%;
  padding: 0.7em 1.2em;
  background: #e8f4fd;
  border-left: 4px solid #2196f3;
  border-radius: 4px;
}

.pager {
  margin: 0 auto;
  text-align: center;
}

.link {
  color: skyblue;
  text-decoration: none;
}

.link:hover {
  color: #ff5722;
}

.el-card .inner-top {
  line-height: 1rem;
  display: block;
  margin-top: 0.4rem;
  font-weight: bold;
}

.outer-top {
  border-radius: 6px;
}
</style>