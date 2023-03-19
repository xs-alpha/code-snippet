<template>
  <div>
    <Header></Header>

    <ul class="timeline-wrapper" v-loading="loading">
      <li class="timeline-item" v-for="t in dairyContents" :key="t.id">
        <div class="timeline-box">
          <div class="out-circle">
            <div class="in-circle"></div>
          </div>
          <div class="long-line"></div>
        </div>

        <!--      TODO: 日志数据超长问题-->
        <div class="timeline-content">
          <div class="timeline-date">
            <router-link class="link" :to="{name:'DairyDetail',params:{blogId:t.id}}">{{ t.postTime }}</router-link>
            - {{ t.year }}
          </div>
          <div class="timeline-title">
            <router-link class="link" :to="{name:'DairyDetail',params:{blogId:t.id}}">{{ t.title }}</router-link>
          </div>
          <div class="timeline-desc">{{ t.dairyDesc }}</div>
        </div>
      </li>
    </ul>

    <!--分页-->
    <el-pagination class="pager" background layout="prev, pager, next"
                   :current-page="currentPage"
                   :page-size="pageSize"
                   :total="total"
                   @current-change="getPage">
    </el-pagination>

    <Footer/>
  </div>
</template>

<script type="text/babel">
import Vue from 'vue';
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import MardownIt from "markdown-it";

export default {
  components: {Header, Footer},
  data() {
    return {
      dairyContents: {},
      currentPage: 1,
      total: 0,
      loading: false,
      dairyDesc: "",
      pageSize: 20,
      avatar: require("@/asserts/img/default_user.jpg"),
    };
  },

  methods: {
    getPage(currentPage) {
      this.loading = true
      const _this = this;
      _this.$axios.post("/dairyList?currentPage=" + currentPage, null, {
        headers: {
          Authorization: localStorage.getItem("token")
        }
      }).then(res => {
        _this.dairyContents = res.data.data.records;
        _this.currentPage = res.data.data.current;
        _this.total = res.data.data.total;
        _this.pageSize = res.data.data.size;
        // let MardownIt = require("markdown-it");
        // let md = new MardownIt();
        //
        // let result = md.render(res.data.data.records);
        //
        // _this.dairyContents = result;
      }).finally(() => {
        this.loading = false;
      });
    }
  },
  created() {
    this.getPage(1);
  }
}
</script>

<style scoped>
ul.timeline-wrapper {
  list-style: none;
  margin: 0;
  padding: 0;
}

.pager {
  margin: 0 auto;
  text-align: center;
}

/* 时间线 */
.timeline-item {
  position: relative;
}

.timeline-item .timeline-box {
  text-align: center;
  position: absolute;
}

.timeline-item .timeline-box .out-circle {
  width: 16px;
  height: 16px;
  background: rgba(14, 116, 218, 0.1);
  box-shadow: 0px 4px 12px 0px rgba(0, 0, 0, 0.1);
  /*opacity: 0.1;*/
  border-radius: 50%;
  display: flex;
  align-items: center;
}

.timeline-item .timeline-box .out-circle .in-circle {
  width: 8px;
  height: 8px;
  margin: 0 auto;
  background: rgb(14, 116, 218);
  border-radius: 50%;
  box-shadow: 0px 4px 12px 0px rgba(0, 0, 0, 0.1);
}

.timeline-item .timeline-box .long-line {
  width: 2px;
  height: 162px;
  background: rgb(14, 116, 218);
  box-shadow: 0px 4px 12px 0px rgba(0, 0, 0, 0.1);
  opacity: 0.1;
  margin-left: 5px;
}

.timeline-item .timeline-content {
  box-sizing: border-box;
  margin-left: 20px;
  height: 106px;
  width: 100%;
  padding: 0 0 0 20px;
  text-align: left;
  margin-bottom: 30px;
}

.timeline-item .timeline-content .timeline-title {
  font-size: 14px;
  word-break: break-all;
  margin-bottom: 16px;
  color: #333;
  font-weight: 500;
  /*display: inline;*/
}

.timeline-item .timeline-content .timeline-date {
  font-size: 16px;
  color: #333;
  font-weight: 500;
  margin-bottom: 16px;
}

.timeline-item .timeline-content .timeline-desc {
  font-size: 14px;
  width: 100%;
  color: #999999;
}

.timeline-item:last-of-type .timeline-content {
  margin-bottom: 0;
}

.link {
  color: skyblue;
  text-decoration: none;
}
</style>
