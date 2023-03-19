<template>
  <div>
    <Header></Header>
    <div v-if="this.deviceType==='pc'" class="yiyan">
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
    </div>
    <div class="block-essay">
      <div>
        <div
            v-for="(blog,index) in blogContents"
            :key="index"
        >
          <el-card id="el-card-id">
            <div class="outer-top" v-if="blog.isTop===1"
                 style="width: 3.6rem;height: 1.7rem;color: white;background-color: #ffbf00; z-index: 999;padding-top: 0;padding-left: 0;margin-top: 0;margin-left: 0;position: absolute;float: left">
              <span class="inner-top" style="text-align: center">置顶</span>
            </div>
            <el-row :gutter="20">
              <el-col :span="6">
                <div class="grid-content bg-purple">
                  <el-image
                      style="width: 230px; height: 230px"
                      :src="blog.detailImg"
                      :fit="fit"></el-image>
                </div>
              </el-col>
              <el-col :span="18">
                <div class="grid-content bg-purple">
                  <h2>
                    <router-link class="link" :to="{name:'EssayDetail',params:{blogId:blog.id}}">{{
                        blog.title
                      }}
                    </router-link>
                  </h2>
                  <div class="new-meta-box">
                    <div class="new-meta-item">
                      <i class="el-icon-user-solid" aria-hidden="true"></i>
                      <router-link class="link" :to="{name:'User',params:{username:blog.author}}">{{
                          blog.author
                        }}
                      </router-link>


                    </div>
                    <div class="new-meta-item ">
                      <i class="el-icon-s-order" aria-hidden="true"></i>
                      <p>{{ blog.gmtCreate }}</p>
                    </div>
                    <div class="new-meta-item hide-p">
                      <i class="el-icon-view" aria-hidden="true"></i>
                      <p>{{ blog.isBlogHide }}</p>
                    </div>
                  </div>
                  <div class="desc">
                    <!--                    <p>简介：{{ blog.description }}</p>-->
                    <router-link class="link" :to="{name:'EssayDetail',params:{blogId:blog.id}}" style="color: #666"><i
                        class="el-icon-collection-tag"></i>简介：{{ blog.description }}
                    </router-link>
                  </div>
                </div>
              </el-col>
            </el-row>
            <div class="essay-image">

            </div>


          </el-card>
        </div>
      </div>
      <div style="margin-top: 2rem"></div>
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
      url: "http://blog.devilwst.top/wp-content/uploads/2021/11/thumbnail_t01d710d82aeaf81332-360x240.jpg",
      fit: "fill",
      deviceType: '',
      searchContent: '',
      // detailImg:"",
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
      _this.$axios.post("/myEssays?currentPage=" + currentPage, data, {
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
  margin-top: 0.25rem;
  font-weight: bold;
}

.outer-top {
  border-radius: 6px;
}

.essay-image {
  margin-left: 0px;
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
  /*padding-top: 2px;*/
  padding-bottom: 2px;
  display: flex;
  align-items: center;
  flex-wrap: wrap;
}

.new-meta-box p {
  float: right;
  height: 1px;
  line-height: 0px;
  display: block;
  width: 95px;
}

.new-meta-item {
  height: 10px;
  width: 115px;
  float: left;
}

.hide-p {
  margin-left: 1rem;
}

.new-meta-item i {
  margin-top: 5px;
  padding-top: 2px;
}

.desc {
  display: block;
  margin-top: 30px;
  font-size: medium;
  color: #666;
}

.el-row ::v-deep {
  margin-bottom: 0;
}
</style>