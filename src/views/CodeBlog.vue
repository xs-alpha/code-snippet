<template>
  <div>
    <Header></Header>
    <el-row :gutter="20" class="main-contain">
      <el-col :span="6">
        <div class="grid-content bg-purple"></div>
      </el-col>

      <el-row :gutter="12">
        <el-col :span="12">
          <div v-for="(blog,index) in blogContents"
               :key="index" :class="{ 'first-blog': index === 0 }">

            <el-card shadow="always" class="each-card">
              <!--            总是显示-->
              <el-col :span="24">
                <div class="grid-content bg-purple code-title">
                  <h3 style="margin-bottom: 10px">
                    <router-link class="link bolg-link" :to="{name:'BlogDetail',params:{blogId: blog.id}}">{{
                        blog.title
                      }}
                    </router-link>
                  </h3>
<!--                  <el-descriptions class="descriptions-wrapper"-->
<!--                                   :data="[{ label: '用户名', value: blog.author }, { label: '提交时间', value: blog.gmtCreate }, { label: '备注', value: blog.remark }, { label: '语言', value: blog.codeLanguage }, { label: '描述', value: blog.description }, { label: 'code', value: blog.content }]">-->
<!--                    <template v-slot:title="{ row }">-->
<!--                      <router-link class="link bolg-link" :to="{name:'BlogDetail',params:{blogId: blog.id}}">-->
<!--                        {{ blog.title }}-->
<!--                      </router-link>-->
<!--                    </template>-->
<!--                    <el-descriptions-item label="用户名" :column="4" label-class-name="my-label" content-class-name="my-content" >-->
<!--                      <router-link class="link" :to="{name:'User',params:{username:blog.author}}">{{ blog.author }}-->
<!--                      </router-link>-->
<!--                    </el-descriptions-item>-->
<!--                    <el-descriptions-item label="提交时间">{{ blog.gmtCreate }}</el-descriptions-item>-->
<!--                    <el-descriptions-item label="备注">{{ blog.remark }}</el-descriptions-item>-->
<!--                    <el-descriptions-item label="语言" :span="1">-->
<!--                      <el-tag size="small">{{ blog.codeLanguage }}</el-tag>-->
<!--                    </el-descriptions-item>-->
<!--                    <el-descriptions-item label="描述">{{ blog.description }}</el-descriptions-item>-->
<!--                    <el-descriptions-item label="code" :span="2">{{ blog.content }}</el-descriptions-item>-->
<!--                  </el-descriptions>-->
                    <div style="overflow:hidden; font-weight: normal">
                      <el-row :gutter="10">
                        <el-col :span="7"><div class="grid-content bg-purple">用户名:<router-link class="link" :to="{name:'User',params:{username:blog.author}}">{{ blog.author }}
                        </router-link>
                        </div></el-col>
                        <el-col :span="9"><div class="grid-content bg-purple-light">提交时间：{{ blog.commitTime }}</div></el-col>
                        <el-col :span="6"><div class="grid-content bg-purple-light">语言：<el-tag size="small">{{ blog.codeLanguage }}</el-tag></div></el-col>
                      </el-row>
                      <el-row>
                        <el-col :span="24"><div class="grid-content bg-purple">描述：{{ blog.description}}</div></el-col>
                      </el-row>
                      <el-row>
                        <el-col :span="24"><div class="grid-content bg-purple" style="font-weight: lighter;font-size: 13px">备注：{{ blog.remark }}</div></el-col>
                      </el-row>
                      <el-col :span="24">
                        <div class="grid-content bg-purple" style="float: left; white-space: nowrap;overflow:hidden;">
                          code：
                          <p style="display: inline;font-size: 12px;font-weight: lighter;font-family: 'JetBrains Mono ExtraLight'">{{ blog.content }}</p>
                        </div>
                      </el-col>
                    </div>
                </div>
              </el-col>
            </el-card>
          </div>
        </el-col>

      </el-row>


      <el-col :span="6">
        <div class="grid-content bg-purple"></div>
      </el-col>
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
      debugger
      this.codeLanguage = window.location.href.split("code/")[1].trimEnd();
      console.log("currentpage：", currentPage)
      _this.$axios.get("/blogtag/"+this.codeLanguage+"?currentPage=" + currentPage).then(res => {
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
  /*background-color: #96ceb4;*/
  /*background-image: linear-gradient(to right, #e6e6fa, #ffffff);*/
  background-image: linear-gradient(to right, #e6e6fa, #96ceb4);
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
.my-label {
  background: #E1F3D8;
}

.my-content {
  background: #FDE2E2;
}
  .el-row{
    margin-bottom:3px;
  }
.grid-content{
  min-height: 26px;
}
</style>
<!--contentStyle="background:#d8e484" labelStyle="background:#d8e484"-->