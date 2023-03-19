<template>
  <div>
    <!--    https://blog.csdn.net/zujiasheng/article/details/125262567?spm=1001.2101.3001.6650.10&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-10-125262567-blog-126259601.pc_relevant_recovery_v2&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-10-125262567-blog-126259601.pc_relevant_recovery_v2&utm_relevant_index=15-->
    <Header></Header>

    <!--    <el-calendar class="task-calendar" v-model="value">-->
    <!--      <div class="calendar-inner"-->
    <!--          slot="dateCell"-->
    <!--          slot-scope="{ data }"-->
    <!--          @click="viewDayWork(data)"-->
    <!--      >-->
    <!--        <p>-->
    <!--          &lt;!&ndash;          {{ data.day.split("-").slice(1).join().replace(",", "-") }}&ndash;&gt;-->
    <!--          &lt;!&ndash;          {{ data.day }}&ndash;&gt;-->
    <!--          {{ data.day.split("-").slice(2).join() }}-->
    <!--        </p>-->
    <!--      </div>-->
    <!--    </el-calendar>-->
    <div class="yiyan">
      <el-card class="box-card yiyancard" shadow="hover">
        <div class="yiyandiv">
          {{ yiyan }}
        </div>
      </el-card>
    </div>

    <Calendar
        v-on:choseDay="clickDay"
        v-on:changeMonth="changeDate"
        v-on:isToday="clickToday"
        :markDate=arr
    ></Calendar>

    <div class="edit-content" v-loading="loading">
      <div v-for="task in tasks">
        <el-card class="box-card" style="background-color:  rgb(217, 236, 255);color: rgb(225, 243, 216); ">
          <div slot="header" class="clearfix">

            <router-link class="link" :to="{name:'GetMyTask',params:{taskId:task.taskId}}">{{ task.timeShow }}的任务
            </router-link>

            <el-link type="info" style="float: right;color: #b3c0d1; font-size: 0.7rem"
                     @click="deleteTask(task.taskId)">删除
            </el-link>
          </div>
        </el-card>
      </div>

      <el-divider v-if="! isTasksNull && ! isPeroidTasksNull"></el-divider>

    </div>
    <div class="edit-content" v-loading="loading">
      <div v-for="task in peroidTasks">
        <el-card class="box-card" style="background-color: #00ffc9;color: #ff5722; ">
          <div class=" text item">

            <router-link class="link" :to="{name:'GetMyPeroidTask',params:{taskId:task.taskId}}">{{ task.timeShow }}
            </router-link>

            <el-link type="info" style="float: right;color: #b3c0d1; font-size: 0.7rem"
                     @click="deletePeroidTask(task.taskId)">删除
            </el-link>
          </div>
        </el-card>
      </div>
    </div>


    <Footer></Footer>
  </div>
</template>

<script>
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import Calendar from 'vue-calendar-component';

const cityOptions = [];
export default {
  components: {Header, Footer, Calendar},
  data() {
    return {
      loading: false,
      peroidTasks: [],
      isTasksNull: false,
      isPeroidTasksNull: false,
      tasks: [],
      // arr:[{date:'2022/12/1',className:"mark1"}, {date:'2022/12/13',className:"mark2"}],
      arr: [],
      yiyan: "",
      value: new Date(),
      curTime: '',
    };
  },
  methods: {
    getYiYanDate() {
      this.$axios.post("https://api.xygeng.cn/day").then(res => {
        const data = res.data.data
        console.log(data.festival.length === 0 ? data.festival.join(", ") : "")
        const festival = data.festival.length === 0 ? "" : data.festival.join(", ") + "，阳历";
        this.yiyan = "今天是" + festival + this.formatToday(new Date()) + "， " + "阴历" + data.lunar.date
      }).catch(e => {
        console.log("error:" + e)
      });
    },
    clickDay(data) {
      data = this.changeFormat(data);


      // getSpecTasks
      this.getCurrentDayTask(data)
      let dateStr = this.formatDate(new Date());
      // getDateList
      this.getCurrentDayPeroidTask(data)
      console.log("click:" + data); //选中某天
    },
    setCurTime(data) {
      if (this.curTime === '' || data.includes(this.curTime) != -1) {
        this.curTime = data.split("-").slice(0, 2).join("-")
        this.getTaskedDate(data)
        console.log("this.curTime", this.curTime)
      }
    },
    changeDate(data) {
      data = this.changeFormat(data);
      this.setCurTime(data)
      console.log("change month:" + data); //左右点击切换月份
    },
    clickToday(data) {
      data = this.changeFormat(data);
      console.log("click today:" + data); // 跳到了本月
    },
    viewDayWork(val) {
      console.log("val:" + val.day)
      console.log("date：" + this.value)
      this.getCurrentDayTask(val.day);
    },
    deletePeroidTask(val) {
      const _this = this;
      this.$axios
          .get("/deletePeroidTask/" + val, {
            headers: {
              Authorization: localStorage.getItem("token")
            }
          })
          .then(res => {
            this.$alert("操作成功", "消息提示", {
              confirmButtonText: "确定",
              callback: action => {
                this.$message({
                  type: "info",
                  message: '操作成功！已返回首页！'
                });
                _this.$router.push("/taskList");
              }
            });
          });
    },
    deleteTask(val) {
      const _this = this;
      this.$axios
          .get("/deleteTask/" + val, {
            headers: {
              Authorization: localStorage.getItem("token")
            }
          })
          .then(res => {
            this.$alert("操作成功", "消息提示", {
              confirmButtonText: "确定",
              callback: action => {
                this.$message({
                  type: "info",
                  message: '操作成功！已返回首页！'
                });
                _this.$router.push("/taskList");
              }
            });
          });
    },
    getCurrentDayTask(val) {
      this.loading = true
      let _this = this
      this.$axios.get("/getSpecTasks?taskDate=" + val,
          {
            headers: {
              Authorization: localStorage.getItem("token")
            }
          }
      ).then(res => {
        console.log("初始化成功")
        console.log("初始化成功1", res.data.data)
        _this.tasks = res.data.data
        this.isTasksNull = _this.tasks.length === 0 ? true : false
      }).catch(err => {
        console.log("err:" + err)
      }).finally(() => {
        this.loading = false
      })
    },
    getCurrentDayPeroidTask(val) {
      this.loading = true
      let _this = this
      this.$axios.get("/getSpecPeroidTasks?taskDate=" + val,
          {
            headers: {
              Authorization: localStorage.getItem("token")
            }
          }
      ).then(res => {
        console.log("初始化成功")
        console.log("初始化成功1", res.data.data)
        _this.peroidTasks = res.data.data
        this.isPeroidTasksNull = _this.peroidTasks.length === 0 ? true : false
      }).catch(err => {
        console.log("err:" + err)
      }).finally(() => {
        this.loading = false
      })
    },
    toDetailTask() {
      this.$router.push({path: '/dairy/' + this.user.username})
    },
    //格式化时间
    formatDate(dat) {
      //获取年月日，时间
      var year = dat.getFullYear();
      var mon = (dat.getMonth() + 1) < 10 ? "0" + (dat.getMonth() + 1) : dat.getMonth() + 1;
      var data = dat.getDate() < 10 ? "0" + (dat.getDate()) : dat.getDate();
      return year + "-" + mon + "-" + data;
    },
    formatToday(dat) {
      //获取年月日，时间
      var year = dat.getFullYear();
      var mon = (dat.getMonth() + 1) < 10 ? "0" + (dat.getMonth() + 1) : dat.getMonth() + 1;
      var data = dat.getDate() < 10 ? "0" + (dat.getDate()) : dat.getDate();
      return year + "年" + mon + "月" + data + "日";
    },
    changeFormat(date) {
      let split = date.split("/");
      let join = split.join("-");
      return join;
    },
    getTaskedDate(val) {
      this.$axios.get("/getDateList?taskDate=" + val,
          {
            headers: {
              Authorization: localStorage.getItem("token")
            }
          }
      ).then(res => {
        console.log("初始化getTaskedDate成功")
        let temp = res.data.data
        let filter = temp.filter(item => this.changeFormat(item) != this.formatDate(new Date()));
        console.log("arr:" + temp)
        console.log("arr:" + filter)
        this.arr = filter
      }).catch(err =>
          console.log("err:" + err)
      )
    },
    // }

  },
  created() {
    let dateStr = this.formatDate(new Date());
    console.log("created:" + dateStr)
    this.getCurrentDayTask(dateStr)
    this.getCurrentDayPeroidTask(dateStr)
    this.getTaskedDate(dateStr)
    this.getYiYanDate();
  },


}
</script>

<style>
.edit-content {
  text-align: center;
  clear: both;
  margin: 0 auto;
}

.link {
  color: #409EFF;
}

.edit-content .el-divider--horizontal {
  width: 36%;
  margin: 24px auto;
}

.task-calendar {
  width: 35rem;
  /*height: 30rem;*/
  margin: 0 auto 10px;
}

.yiyandiv {
  text-align: center;
  color: #2196f3;
}

.yiyandiv {
  /*-webkit-mask-image:-webkit-gradient(linear, 0 0, 0 bottom, from(blue), to(rgba(210, 1, 160, 0.9)));*/
  background-image: -webkit-linear-gradient(bottom, #2d38ff, #ff73a5);
  /*background-image:-webkit-linear-gradient(bottom,red,#fd8403,yellow);*/
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.text {
  font-size: 14px;
}

.item {
  margin-bottom: 18px;
}

.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}

.clearfix:after {
  clear: both
}

.box-card {
  width: 480px;
}

.link {
  /*color: skyblue;*/
  text-decoration: none;
}

.link:hover {
  color: #ff5722;
}

.box-card {
  margin: 2rem auto;
}


.wh_content_item .wh_chose_day[data-v-2ebcbc83] {
  background-color: green;
}

.wh_content_item > .wh_isMark[data-v-2ebcbc83] {
  background: #ffef004a;
}
</style>
