<template>
  <div>

    <Header></Header>
    <div class="edit-content">
      <!--      <h2>{{ this.timeShow }}</h2>-->
      <el-link type="info" href="/taskList"><h2>{{ this.timeShow }}</h2></el-link>
    </div>


    <el-row :gutter="20">
      <el-col :span="6">
        <div class="grid-content bg-purple"></div>
      </el-col>
      <el-col :span="12">
        <div class="grid-content bg-purple">

          <el-checkbox :indeterminate="isIndeterminate" v-model="checkAll" @change="handleCheckAllChange"
                       style="display: block">全选
          </el-checkbox>
          <div style="margin: 15px 0;"></div>
          <el-checkbox-group v-model="checkedCities" @change="handleCheckedCitiesChange" type="vertical" size="medium"
                             border="true">
            <!--        <el-checkbox v-for="city in cities" :label="city" :key="city">{{city}}</el-checkbox>-->
            <div v-for="city in cities" style="margin-top: 0.5rem">
              <el-checkbox :label="city" :key="city">{{ city }}</el-checkbox>
            </div>
          </el-checkbox-group>

        </div>
      </el-col>
      <el-col :span="6">
        <div class="grid-content bg-purple"></div>
      </el-col>
    </el-row>
    <div class="edit-content">
      <el-button class="task-button" type="primary" @click="submitTask">提交</el-button>

    </div>
    <!--      <el-checkbox-group v-model="checkedCities" @change="handleCheckedCitiesChange" type="vertical" size="medium" border="true">-->
    <!--&lt;!&ndash;        <el-checkbox v-for="city in cities" :label="city" :key="city">{{city}}</el-checkbox>&ndash;&gt;-->
    <!--        <div v-for="city in cities">-->
    <!--          <el-checkbox :label="city" :key="city" >{{city}}</el-checkbox>-->
    <!--        </div>-->
    <!--      </el-checkbox-group>-->
    <!--    </div>-->
    <Footer></Footer>
  </div>
</template>

<script>
import Header from "@/components/Header";
import Footer from "@/components/Footer";

const cityOptions = [];
export default {
  components: {Header, Footer},
  data() {
    return {
      checkAll: false,
      checkedCities: [],
      cityOptions: [],
      cities: [],
      selected: [],
      taskId: "",
      resData: "",
      timeShow: "",
      isIndeterminate: true
    };
  },
  methods: {
    handleCheckAllChange(val) {
      console.log(val + this.cityOptions)
      this.checkedCities = val ? this.cityOptions : [];
      this.isIndeterminate = false;
      this.selected = this.checkedCities;
    },
    handleCheckedCitiesChange(value) {
      let checkedCount = value.length;
      this.checkAll = checkedCount === this.cities.length;
      this.isIndeterminate = checkedCount > 0 && checkedCount < this.cities.length;
      console.log("value:" + value)
      this.selected = value;
    },
    submitTask() {
      const _this = this;
      if (this.taskId) {
        _this.$axios.post("/commitTask/" + this.taskId, this.selected,
            {
              headers: {
                Authorization: localStorage.getItem("token")
              }
            }
        ).then(res => {
          _this.blogContents = res.data.data.records;

          this.$alert("操作成功", "消息提示", {
            confirmButtonText: "确定",
            callback: action => {
              this.$message({
                type: "info",
                message: '操作成功！'
              });
              _this.$router.push("/taskList");
            }
          });
        });
      }

    }

  },
  created() {
    let blogId = this.$route.params.taskId
    // let blogId = "bc99c3fffd4c4cbb91fd823c7ec54a75"
    if (blogId) {
      this.$axios.get("/getTasks/" + blogId,
          {
            headers: {
              Authorization: localStorage.getItem("token")
            }
          }
      ).then(res => {
        const resData = res.data.data;
        console.log(resData)
        this.resData = resData;
        const arr = [];
        for (let i = 0; i < resData.length; i++) {
          arr.push(resData[i].task)
        }
        this.cityOptions = arr;
        this.cities = arr;

        for (let i = 0; i < resData.length; i++) {
          if (resData[i].state === 1) {
            this.checkedCities.push(resData[i].task)
          }
        }
        console.log("checked:" + this.checkedCities)
        this.selected = this.checkedCities
        this.taskId = blogId;
        if (this.cities.length > 0) {
          this.timeShow = resData[0].timeShow;
        }
      }).catch(err => {
        console.log("err:" + err)
      })
    }
  }
};
</script>

<style>
.edit-content {
  text-align: center;
  clear: both;
}

.task-button {
  margin-top: 3em;
}

.el-row {
  margin-bottom: 20px;

&
:last-child {
  margin-bottom: 0;
}

}
.el-col {
  border-radius: 4px;
}

.bg-purple-dark {
  /*background: #99a9bf;*/
}

.bg-purple {
  /*background: #d3dce6;*/
}

.bg-purple-light {
  /*background: #e5e9f2;*/
}

.grid-content {
  border-radius: 4px;
  min-height: 36px;
}

.row-bg {
  padding: 10px 0;
  /*background-color: #f9fafc;*/
}

.el-checkbox .el-checkbox__inner {
  width: 1.5rem;
  height: 1.5rem;
}

.el-checkbox .el-checkbox__label {
  font-size: 1.1rem;
}
</style>