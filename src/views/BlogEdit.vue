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
        <el-form-item label="标题" prop="title">
          <el-input v-model="ruleForm.title" placeholder="请填写标题哦"></el-input>
        </el-form-item>

        <el-form-item label="简介" prop="description">
          <el-input type="textarea" v-model="ruleForm.description" placeholder="请填写简介"></el-input>
        </el-form-item>

        <el-form-item label="简介" prop="description">
          <el-switch
              v-model="ruleForm.hide"
              :active-value=1
              :inactive-value=0
              active-text="仅自己可见"
              inactive-text="所有人可见"
              active-color="#13ce66"
              inactive-color="#999">
          </el-switch>
          <span style="padding-left: 6rem">       </span>
          <el-switch
              v-model="ruleForm.isTop"
              :active-value=1
              :inactive-value=0
              active-text="设为置顶"
              inactive-text="不置顶"
              active-color="#13ce66"
              inactive-color="#999">
          </el-switch>
          <div v-if="ruleForm.isTop===1" style="margin-top: 1rem">
            <span style="margin-right: 1rem;margin-top: 1rem">权重: </span>
            <el-input-number v-if="ruleForm.isTop===1" v-model="ruleForm.weight" @change="handleChange" :min="1"
                             :max="100" label="描述文字">权重
            </el-input-number>
          </div>
        </el-form-item>

        <el-form-item label="内容" prop="content">
          <!--          <mavon-editor v-model="ruleForm.content"></mavon-editor>-->
          <MonacoEditor class="my-editor"
                        height="600"
                        language="typescript"
                        :code="code"
                        :editorOptions="options"
                        @mounted="onMounted"
                        @codeChange="onCodeChange"
          >
          </MonacoEditor>
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
// import MonacoEditor from '@/components/MonacoEditor.vue'
import MonacoEditor from 'vue-monaco-editor'

export default {
  components: {Header, Footer, MonacoEditor},
  data() {
    return {
      code: '// Type away! \n',
      options: {
        selectOnLineNumbers: false
      },
      ruleForm: {
        title: "",
        description: "",
        hide: 1,
        isTop: 0,
        weight: 1,
        content: "",
        author: this.$store.getters.getUserInfo.username
      },
      nums: 0,
      timer: null,// 初始定时器变量名为null
      rules: {
        title: [
          {required: true, message: "请输入文章标题", trigger: "blur"},
          {min: 3, max: 25, message: "长度在 3 到 25 个字符", trigger: "blur"}
        ],
        description: [
          {required: true, message: "请输入摘要（简介）", trigger: "blur"}
        ],
        content: [{required: true, trigger: "blur"}]
      }
    };
  },

  methods: {
    onMounted(editor) {
      this.editor = editor;
    },
    onCodeChange(editor) {
      console.log(editor.getValue());
    },
    handleChange(value) {
      console.log(value);
    },
    autoSave() {
      if (this.timer) {
        clearInterval(this.timer);
      }
      this.timer = setInterval(() => {
        console.log("suto save enter")
        // this.ruleForm.title.length!=0&&this.ruleForm.description.length!=0
        if (this.ruleForm.id != undefined) {
          const _this = this;
          this.$axios
              .post("/blog/edit", this.ruleForm, {
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
          if (this.ruleForm.isTop === 0) {
            this.ruleForm.weight = 0
          }
          const _this = this;
          this.$axios
              .post("/blog/edit", this.ruleForm, {
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
  watch: {
    selectedMode: function (val) {
      this.cmOptions.mode = val
    },
  },
  created() {
    let blogId = this.$route.params.blogId
    if (blogId) {
      this.$axios.get("/blog/" + blogId).then(res => {
        let blog = res.data.data
        this.ruleForm.id = blog.id
        this.ruleForm.title = blog.title
        this.ruleForm.description = blog.description
        this.ruleForm.hide = blog.hide
        this.ruleForm.isTop = blog.isTop
        this.ruleForm.weight = blog.weight
        this.ruleForm.content = blog.content
        this.code = blog.content
        console.log("content:code: ", this.ruleForm.content)
      })
    }

    this.autoSave()

  },

  beforeDestroy() {
    clearInterval(this.timer);
    this.timer = null // 这里最好清除一下，回归默认值
    // 众所周知，定时器返回一个随机整数，用于表示定时器的编号，后面通过名字可以取消这个定时器的执行。
    console.log("this.timer", this.timer);
  },
  mounted() {
    // 初始化编辑器
    this.editor = monaco.editor.create(this.$refs.editorContainer, {
      value: 'initial code',
      language: 'javascript'
    });

    let blogId = this.$route.params.blogId
    if (blogId) {
      this.$axios.get("/blog/" + blogId).then(res => {
        let blog = res.data.data
        this.ruleForm.id = blog.id
        this.ruleForm.title = blog.title
        this.ruleForm.description = blog.description
        this.ruleForm.hide = blog.hide
        this.ruleForm.isTop = blog.isTop
        this.ruleForm.weight = blog.weight
        this.ruleForm.content = blog.content
        // this.ruleForm.code= blog.content
        console.log("content:code: ", this.ruleForm.content)
      })
      this.editor.trigger('', 'editor.action.format')
    }
  },

};
</script>

<style scoped>
.edit-content {
  /*text-align: center;*/
  clear: both;
  margin: 60px auto;
  width: 70%;
}

.v-note-wrapper ::v-deep {
  min-height: 40rem;
}

.el-form-item__content {
  display: flex;
  justify-content: center;
}

.my-editor {
  text-align: inherit;
}
</style>