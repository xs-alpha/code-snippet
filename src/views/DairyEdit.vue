<template>
  <div>
    <Header></Header>
    <div class="edit-content">
      <el-form
          :model="ruleForm"
          :rules="rules"
          ref="ruleForm"
          label-width="100px"
          class="demo-ruleForm"
      >
        <el-form-item label="发表 年" prop="description">
          <el-input v-model="ruleForm.year" placeholder="默认发表当前年  不用填写"></el-input>
        </el-form-item>

        <el-form-item label="发表时间" prop="description">
          <el-input v-model="ruleForm.postTime" placeholder="默认不用填写"></el-input>
        </el-form-item>
        <el-form-item label="标题" prop="title">
          <el-input type="textarea" v-model="ruleForm.title" placeholder="请填写标题哦"></el-input>
        </el-form-item>
        <el-form-item label="隐私" prop="hideDiary">
          <!--          <el-input  v-model="ruleForm.hideDiary" placeholder="请填写标题哦"></el-input>-->
          <el-switch
              v-model="ruleForm.hide"
              :active-value=1
              :inactive-value=0
              active-text="仅自己可见"
              inactive-text="所有人可见"
              active-color="#13ce66"
              inactive-color="#999"
              @change="change($event,ruleForm.hide)">
          </el-switch>

        </el-form-item>
        <el-form-item label="内容" prop="content">
          <mavon-editor v-model="ruleForm.dairyContent"></mavon-editor>
        </el-form-item>


        <el-form-item>
          <el-button type="primary" @click="submitForm('ruleForm')">提交</el-button>
          <el-button @click="resetForm('ruleForm')">重置</el-button>
        </el-form-item>
      </el-form>
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
      ruleForm: {
        year: "",
        postTime: "",
        hide: 1,
        dairyContent: "",
        title: "",
        author: this.$store.getters.getUserInfo.username
      },
      timer: null,// 初始定时器变量名为null
      rules: {
        title: [
          {required: false, message: "日志标题", trigger: "blur"},
          {min: 2, max: 25, message: "长度在 2 到 25 个字符", trigger: "blur"}
        ],
        description: [
          {required: false, message: "默认不用输入", trigger: "blur"}
        ],
        dairyContent: [{required: true, trigger: "blur"}]
      }
    };
  },
  methods: {
    change(data, row) {
      console.log(data);
      console.log(row);
    },
    autoSave() {
      if (this.timer) {
        clearInterval(this.timer);
      }
      this.timer = setInterval(() => {
        console.log("suto save enter")

        if (this.ruleForm.title.length != 0) {
          const _this = this;
          this.$axios
              .post("/postDairy", this.ruleForm, {
                headers: {
                  Authorization: localStorage.getItem("token")
                }
              })
              .then(res => {
                console.log("suto save going")
                // this.$message({
                //   type: "info",
                //   message: '自动保存成功！'
                // });
              });
        } else {
          console.log("error submit!!");
          return false;
        }
      }, 10000);

    },
    submitForm(formName) {
      this.$refs[formName].validate(valid => {
        if (valid) {
          const _this = this;
          this.$axios
              .post("/postDairy", this.ruleForm, {
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
                    _this.$router.push("/myBlog");
                  }
                });
              });
        } else {
          console.log("error submit!!");
          return false;
        }
      });
    },
    resetForm(formName) {
      this.$refs[formName].resetFields();
    }
  },
  created() {
    let blogId = this.$route.params.blogId
    if (blogId) {
      this.$axios.get("/dairyDetail/" + blogId).then(res => {
        let blog = res.data.data
        this.ruleForm.id = blog.id
        this.ruleForm.year = blog.year
        this.ruleForm.title = blog.title
        this.ruleForm.postTime = blog.postTime
        this.ruleForm.dairyContent = blog.dairyContent
        this.ruleForm.hide = blog.hide
      })
    }
    this.autoSave()
  },

  beforeDestroy() {
    clearInterval(this.timer);
    this.timer = null // 这里最好清除一下，回归默认值
    // 众所周知，定时器返回一个随机整数，用于表示定时器的编号，后面通过名字可以取消这个定时器的执行。
    console.log("this.timer", this.timer);
  }
};
</script>

<style scoped>
.edit-content {
  text-align: center;
  clear: both;
}

.v-note-wrapper ::v-deep {
  min-height: 40rem;
}
</style>