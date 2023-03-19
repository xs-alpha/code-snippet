<template>

  <div class="m-content">
    <div class="nav-left" v-if="this.deviceType==='pc'">
      <a href="http://diary.devilwst.top">
        <el-image style="width: 8rem; height: 4rem; margin-top: 1.3rem" :src="url" lazy>
        </el-image>
      </a>
    </div>
    <div class="nav-left" v-if="this.deviceType==='mobile'">
      <a href="http://diary.devilwst.top">
        <el-image style="width: 7rem; height: 3.5rem; margin-top: 1.7rem" :src="url" lazy>
        </el-image>
      </a>
    </div>
    <div v-if="this.deviceType==='pc'" class="nav-right">
      <span v-show="!isLogin"><el-link type="primary" href="/login">登录</el-link></span>
      <span v-show="isLogin"><el-link type="primary"><el-popover
          placement="bottom"
          width="40"
          trigger="click"
      >
					<el-avatar :size="50" :src="user.avatar"></el-avatar>
					<el-button slot="reference">{{ user.username }}</el-button>
				</el-popover></el-link> </span>
      &nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;&nbsp;
      <span v-show="!isLogin"><el-link type="primary" href="/register">注册</el-link></span>
      <span v-show="isLogin"><el-link type="danger" @click="logout">退出</el-link></span>
    </div>

    <div v-if="this.deviceType==='mobile'" class="nav-right">
      <el-select class="select-item-mob" reserve-keyword ref="selected" v-model="selectLoginData"
                 placeholder="选项" @change="handleLogin" style="width: 4rem">
        <el-option v-show="isLogin" label="author" value="avatar">{{ user.username }}</el-option>
        <el-option v-show="!isLogin" label="login" value="login"><span v-show="!isLogin"><el-link type="primary"
                                                                                                  href="/login">登录</el-link></span>
        </el-option>
        <el-option v-show="!isLogin" label="register" value="register" style="width: 6rem"><span
            v-show="!isLogin"><el-link type="primary" href="/register">注册</el-link></span></el-option>
        <el-option v-if="isLogin" label="logout" value="logout"><span v-show="isLogin"><el-link type="danger"
                                                                                                @click="logout">退出</el-link></span>
        </el-option>
      </el-select>
    </div>

    <div v-if="this.deviceType==='mobile'" class="nav-right">
      <el-select class="select-item-mob" reserve-keyword ref="selected" v-model="selectLoginData"
                 placeholder="选项" @change="handleLogin" style="width: 4rem">
        <el-option v-show="isLogin" label="author" value="avatar">{{ user.username }}</el-option>
        <el-option v-show="!isLogin" label="login" value="login"><span v-show="!isLogin"><el-link type="primary"
                                                                                                  href="/login">登录</el-link></span>
        </el-option>
        <el-option v-show="!isLogin" label="register" value="register" style="width: 6rem"><span
            v-show="!isLogin"><el-link type="primary" href="/register">注册</el-link></span></el-option>
        <el-option v-if="isLogin" label="logout" value="logout"><span v-show="isLogin"><el-link type="danger"
                                                                                                @click="logout">退出</el-link></span>
        </el-option>
        <el-option label="fenge" value="fenge">======</el-option>
        <el-option label="查看广场" value="mainPage"> 查看广场</el-option>
        <el-option label="查看主页" value="myBlog"> 查看主页</el-option>
        <el-option label="查看日志" value="diary"> 查看日志</el-option>
        <el-option v-if="isLogin" label="发表日志" value="diaryPost">发表日志</el-option>
        <el-option label="查看文章" value="article" style="width: 6rem"> 查看列表</el-option>
        <el-option v-if="isLogin" label="发表文章" value="articlePost">发表文章</el-option>

      </el-select>
    </div>

    <el-menu
        :default-active="activeIndex2"
        class="el-menu-demo"
        mode="horizontal"
        @select="handleSelect"
        text-color="#333"
        active-text-color="blue">
      <el-submenu index="1">
        <template slot="title">广场</template>
        <el-menu-item index="mainPage">文章广场</el-menu-item>
        <el-menu-item index="squaredDairyList">日志广场</el-menu-item>
        <el-menu-item index="chat">chatgpt</el-menu-item>
      </el-submenu>
      <el-submenu index="2">
        <template slot="title">我的</template>
        <el-menu-item v-if="isLogin" index="chatgpt">chatgpt</el-menu-item>
        <el-menu-item v-if="isLogin" index="myBlog">我的主页</el-menu-item>
        <el-menu-item v-if="isLogin" disabled label="=====" value="divide">====</el-menu-item>
        <el-menu-item v-if="isLogin" index="postTask">发布任务</el-menu-item>
        <el-menu-item v-if="isLogin" index="getTask">查看任务</el-menu-item>
        <el-menu-item v-if="isLogin" disabled index="===" label="=====" value="divide">====</el-menu-item>
        <el-menu-item v-if="isLogin" index="diary">查看日志</el-menu-item>
        <el-menu-item v-if="isLogin" index="diaryPost">发表日志</el-menu-item>
        <el-menu-item v-if="isLogin" disabled label="=====" value="divide">====</el-menu-item>
        <el-menu-item index="article">查看列表</el-menu-item>
        <el-menu-item v-if="isLogin" index="articlePost">发表文章</el-menu-item>
        <el-menu-item v-if="isLogin" disabled label="=====" value="divide">====</el-menu-item>
        <el-menu-item v-if="isLogin" index="MyEssay">我的随笔</el-menu-item>
        <el-menu-item v-if="isLogin" index="EssayPost">发表随笔</el-menu-item>
      </el-submenu>
      <el-menu-item index="3">
        <el-link type="warning" href="/timeLine">时间线</el-link>
      </el-menu-item>
      <!--        <el-input-->
      <!--            class="searchContent"-->
      <!--            type="text"-->
      <!--            prefix-icon="el-icon-search"-->
      <!--            v-model="searchContent"-->
      <!--            placeholder="请输入"-->
      <!--            style="width: 270px; cursor: pointer"-->
      <!--            @keyup.enter.native="getPage"-->
      <!--        ></el-input>-->
    </el-menu>
    <FloatBall v-if="isLogin&&this.deviceType==='pc'"></FloatBall>
    <!-- 相对于窗口底部偏移 -->

  </div>

</template>

<script>
import FloatBall from "./FloatBall";
import Aside from "../views/aside";

export default {
  components: {Aside, FloatBall},
  data() {
    return {
      selectDairyData: '',
      selectArticleData: '',
      selectLoginData: '',
      drawer: false,
      selectSquareData: '',
      activeIndex: '1',
      activeIndex2: '1',
      deviceType: '',
      user: {
        username: "请先登录",
        avatar: require("@/asserts/img/default_user.jpg"),
      },
      isLogin: false,
      // url: "https://cdn.jsdelivr.net/gh/HimitZH/CDN/images/HCODE.png"
      url: "http://blog.devilwst.top/wp-content/uploads/2021/12/cropped-logo.png"
    };
  },

  methods: {
    handleSelect(key, keyPath) {
      if (key === 'EssayPost') {
        console.log("squaredDairyList")
        this.$router.push("/essay/add");
      }
      if (key === 'MyEssay') {
        console.log("squaredDairyList")
        this.$router.push("/MyEssay");
      }
      if (key === 'squaredDairyList') {
        console.log("squaredDairyList")
        this.$router.push("/dairy");
      }
      if (key === 'chat') {
        console.log("chat")
        //TODO:url
        // console.log("url:","http://localhost:5173/"+localStorage.getItem("token"))
        window.open("http://ct.devilwst.top/?p=" + localStorage.getItem("token"))
        // window.open("http://localhost:5173/?p="+localStorage.getItem("token"))
      }
      if (key === 'chatgpt') {
        console.log("chat")
        //TODO:url
        // console.log("url:","http://localhost:5173/"+localStorage.getItem("token"))
        window.open("http://ct.devilwst.top/?p=" + localStorage.getItem("token"))
        // window.open("http://localhost:5173/?p="+localStorage.getItem("token"))
      }
      if (key === 'mainPage') {
        console.log("mainPage")
        this.$router.push("/blog");
      }
      console.log(key, " keyPath:", keyPath);
      if (key === 'postTask') {
        console.log("postTask")
        this.$router.push("/myTask");
      }
      if (key === 'getTask') {
        console.log("getTask")
        this.$router.push("/taskList");
      }
      if (key === 'myBlog') {
        console.log("myBlog")
        this.$router.push("/myBlog");
      }
      if (key === 'mainPage') {
        console.log("mainPage")
        this.$router.push("/blog");
      }
      if (key === 'diary') {
        console.log("diary")
        this.toDairy();
      }
      if (key === 'diaryPost') {
        console.log("dairyPost");
        this.$router.push("/dairyPost");
      }
      if (key === 'article') {
        console.log("select article")
        this.toUser();
      }
      if (key === 'articlePost') {
        console.log("article post");
        this.$router.push("/blog/add");
      }
    },
    logout() {
      const _this = this
      _this.$axios.get("/logout", {
        headers: {
          "Authorization": localStorage.getItem("token")
        }
      }).then(res => {
        _this.$store.commit("rmUserInfo")
        _this.$router.push('/login')
      })
    },
    toUser() {
      this.$router.push({path: '/user/' + this.user.username})
    },
    toDairy() {
      this.$router.push({path: '/dairy/' + this.user.username})
    },
    handleSquareChange() {
      if (this.selectSquareData === 'squaredDairyList') {
        console.log("squaredDairyList")
        this.$router.push("/dairy");
      }
      if (this.selectSquareData === 'mainPage') {
        console.log("mainPage")
        this.$router.push("/blog");
      }
    },
    handleDairyChange() {
      if (this.selectDairyData === 'postTask') {
        console.log("postTask")
        this.$router.push("/myTask");
      }
      if (this.selectDairyData === 'getTask') {
        console.log("getTask")
        this.$router.push("/taskList");
      }
      if (this.selectDairyData === 'myBlog') {
        console.log("myBlog")
        this.$router.push("/myBlog");
      }
      if (this.selectDairyData === 'mainPage') {
        console.log("mainPage")
        this.$router.push("/blog");
      }
      if (this.selectDairyData === 'diary') {
        console.log("diary")
        this.toDairy();
      }
      if (this.selectDairyData === 'diaryPost') {
        console.log("dairyPost");
        this.$router.push("/dairyPost");
      }
      if (this.selectDairyData === 'article') {
        console.log("select article")
        this.toUser();
      }
      if (this.selectDairyData === 'articlePost') {
        console.log("article post");
        this.$router.push("/blog/add");
      }
    },
    handleArticleChange() {
      if (this.selectArticleData === 'article') {
        console.log("select article")
        this.toUser();
      } else {
        console.log("article post");
        this.$router.push("/blog/add");
      }
    },

    handleLogin() {
      if (this.selectLoginData === 'myBlog') {
        console.log("myBlog")
        this.$router.push("/myBlog");
      }
      if (this.selectLoginData === 'avatar') {
        console.log("avatar")
      }
      if (this.selectLoginData === 'login') {
        console.log("login")
        this.$router.push("/login");
      }
      if (this.selectLoginData === 'logout') {
        console.log("logout");
        this.$router.push("/logout");
      }
      if (this.selectLoginData === 'register') {
        console.log("select article")
        this.$router.push("/register");
      }
      if (this.selectLoginData === 'mainPage') {
        console.log("select")
        this.$router.push("/blog");
      }
      if (this.selectLoginData === 'diary') {
        console.log("select")
        this.toDairy();
      }
      if (this.selectLoginData === 'diaryPost') {
        console.log("dairyPost");
        this.$router.push("/dairyPost");
      }
      if (this.selectLoginData === 'article') {
        console.log("select article")
        this.toUser();
      }
      if (this.selectLoginData === 'articlePost') {
        console.log("article post");
        this.$router.push("/blog/add");
      }
    },
    _isMobile() {
      let flag = navigator.userAgent.match(/(phone|pad|pod|iPhone|iPod|ios|iPad|Android|Mobile|BlackBerry|IEMobile|MQQBrowser|JUC|Fennec|wOSBrowser|BrowserNG|WebOS|Symbian|Windows Phone)/i)
      return flag;
    },

  },
  created() {
    if (this.$store.getters.getUserInfo.username) {
      this.user.username = this.$store.getters.getUserInfo.username
      this.user.avatar = this.$store.getters.getUserInfo.avatar
      this.isLogin = true
    }
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

<style>
.m-content {
  max-width: 1060px;
  height: 100px;
  margin: 0 auto;
}

.m-action {
  margin: 10px 0;
}

.nav-left {
  float: left;
}

.nav-right {
  float: right;
  height: 80px;
  padding-top: 37px;
  font-size: 14px;
  color: #909399;
}

.block {
  text-align: center;
}

.el-popover {
  text-align: center !important;
}

.el-menu-demo {
  padding-right: 2%;
  height: 80px;
  padding-top: 20px;
  background-color: rgba(0, 0, 0, 0);
  float: right;
}

/* 点击出来的下划线进行隐藏 */
.el-menu-item.is-active {
  border-bottom: none !important;
  color: rgba(0, 0, 0, 0);
}

/* 整体的下划线进行隐藏 */
.el-menu.el-menu--horizontal {
  border-bottom: none !important;
}

/* 导航栏的间距等样式 */
.el-menu-item {
  padding: 0 5rem;
  width: 8rem;
  z-index: 9999;
}

/* 点击出来的下划线动效残留进行隐藏 */
.el-menu--horizontal > .el-menu-item {
  border-bottom: none;
  padding-left: 8rem;
  padding-right: 8rem;
}

.el-menu--horizontal > .el-submenu {
  border-bottom: none;
  padding-left: 8rem;
}

/* 点击以后的背景色进行隐藏 */
.el-menu--horizontal > .el-menu-item:not(.is-disabled):focus,
.el-menu--horizontal > .el-menu-item:not(.is-disabled):hover,
.el-menu--horizontal > .el-submenu .el-submenu__title:hover {
  background-color: rgba(0, 0, 0, 0);
}

/*去除边框*/
.el-select .el-input__inner {
  border: transparent;
  padding-left: 0;
  padding-right: 0;
}

.el-select .el-input .el-input__suffix {
  /*display: none;*/
  /*width: 0.3rem;*/
}

.select-item {
  padding-right: 0;
  height: 8rem;
}

.el-menu-demo-mob {
  padding: 1.4rem 1rem;

}

.el-menu--horizontal .el-menu--popup {
  min-width: 6%;
  margin-left: 8rem;
}

el-menu--horizontal .el-menu--popup {
  /*position: absolute !important;*/
  /*left: 0px !important;*/
  /*border: 1px solid #010f13;*/
}

.el-menu-demo el-submenu {
  padding-left: 8rem !important;
}

/*.wh_content_item ::v-deep .wh_isMark[data-v-2ebcbc83] {*/
/*  background: #57c14a !important;*/
/*}*/
</style>
