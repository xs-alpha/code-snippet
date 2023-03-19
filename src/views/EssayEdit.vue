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

        <el-form-item label="设置" prop="description">
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

        <el-form-item label="图片">
          <!--          <el-upload-->
          <!--              class="upload-demo"-->
          <!--              drag-->
          <!--              action="http://127.0.0.1:8083/fileUpload"-->
          <!--              multiple>-->
          <!--            <i class="el-icon-upload"></i>-->
          <!--            <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>-->
          <!--            <div class="el-upload__tip" slot="tip">只能上传jpg/png文件，且不超过500kb</div>-->
          <!--          </el-upload>-->
          <el-dialog title="上传" :visible.sync="dialogOfUpload" width="35%" style="text-align: center;">
            <el-upload class="upload-demo" action="/upload"
                       :drag="true"
                       :multiple="false"
                       :headers="headers"
                       :auto-upload="false"
                       :before-upload="beforeUpload"
                       :file-list="fileList"
                       accept=".jpg,.jpeg,.png,.gif,.bmp,.JPG,.JPEG,.GIF,.BMP"
                       :on-change="handleChangeFile">
              <i class="el-icon-upload"></i>
              <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
              <div class="el-upload__tip" slot="tip">上传图片格式文件</div>
            </el-upload>
            <div slot="footer" class="dialog-footer">
              <el-button @click="dialogOfUpload = false">取 消</el-button>
              <el-button type="primary" @click="confirmUpload()">上 传</el-button>
            </div>
          </el-dialog>
          <div>
            <el-image
                style="width: 300px; height: 300px"
                :src="url"
                accept=".jpg,.png,.gif,.ico,.webp,.jiff"
                :fit="fits"></el-image>
            <div slot="tip" class="el-upload__tip">只能上传图片文件，且不超过5MB</div>
          </div>

          <el-button type="primary" @click="dialogOfUpload = true">上 传 图片</el-button>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <mavon-editor v-model="ruleForm.content"></mavon-editor>
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
        title: "",
        hide: 1,
        isTop: 0,
        weight: 1,
        detailImg: "",
        content: "",
        essayUrl: "",
        author: this.$store.getters.getUserInfo.username
      },
      timer: null,// 初始定时器变量名为null
      dialogOfUpload: false,
      essayUrlTemp: "",
      fileList: [],
      headers: {
        'Content-Type': 'multipart/form-data'
      },
      url: "",
      fits: "full",
      nums: 0,
      rules: {
        title: [
          {required: true, message: "请输入文章标题", trigger: "blur"},
          {min: 3, max: 25, message: "长度在 3 到 25 个字符", trigger: "blur"}
        ],
        content: [{required: true, trigger: "blur"}]
      }
    };
  },
  methods: {
    beforeUpload(file) {
      const isLt2M = file.size / 1024 / 1024 < 5;
      if (!isLt2M) {
        this.$message.error('上传头像图片大小不能超过 5MB!');
      }
      return isLt2M;
    },
    handleChangeFile(file, fileList) { //文件数量改变
      console.log("file:", file, "fileList", fileList)
      this.fileList = fileList;
    },

    confirmUpload() { //确认上传
      const param = new FormData();
      this.fileList.forEach(
          (val, index) => {
            console.log("index:", index)
            param.append("file", val.raw);
          }
      );
      console.log(param)
      this.$axios.post("/upload", param).then(res => {

        this.getImg(res.data.data)

        console.log("img data:", res.data.data)
        this.dialogOfUpload = false
        this.essayUrlTemp = res.data.data
        // 清空列表
        this.fileList = []
      }).catch(e => {
        this.$message({
          type: "error",
          message: '上传失败，请检查网络或图片是否太大！'
        });
      });
      this.$message({
        message: "上传成功！",
        duration: 1000
      });

    },

    getImg(name) {
      this.$axios
          .get("/download?name=" + name, {
            headers: {
              Authorization: localStorage.getItem("token")
            }
          })
          .then((resp) => {
            let img = resp.data.data;
            console.log("getimg:new-image-data:", img.toString().substring(0, 50))
            let suffix = resp.data.msg;
            console.log("getimg:image-suffix:", suffix)
            this.url = this.dealBase64Url(suffix) + img
            this.ruleForm.detailImg = this.url
            // console.log(this.url.substring(0, 50), "    suffix:", suffix)
          });
    },
    dealBase64Url(suffix) {
      // data:image/gif;base64,base64 编码的 gif 图片数据
      // data:image/png;base64,base64 编码的 png 图片数据
      // data:image/jpeg;base64,base64 编码的 jpeg 图片数据
      // data:image/x-icon;base64,base64 编码的 icon 图片数据
      if (suffix === "jpg" || suffix === "jpeg") {
        return 'data:image/jpeg;base64,';
      }
      if (suffix === "png") {
        return 'data:image/png;base64,';
      }
      if (suffix === "gif") {
        return 'data:image/gif;base64,';
      }
      if (suffix === "icon" || suffix === "x-icon") {
        return 'data:image/x-icon;base64,';
      }
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
        console.log("id:", this.ruleForm.id)
        if (this.ruleForm.id != undefined) {
          const _this = this;
          this.$axios
              .post("/essay/edit", this.ruleForm, {
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
          if (this.essayUrlTemp != "") {
            this.ruleForm.essayUrl = this.essayUrlTemp
          }
          console.log(this.essayUrlTemp)
          const _this = this;
          this.$axios
              .post("/essay/edit", this.ruleForm, {
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
                    _this.$router.push("/MyEssay");
                  }
                });
              }).catch(e => {
            this.$message({
              type: "error",
              message: '上传失败，请检查网络或图片是否太大！'
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
      this.$axios.get("/essay/" + blogId).then(res => {
        let blog = res.data.data
        this.ruleForm.id = blog.id
        this.ruleForm.title = blog.title
        this.ruleForm.description = blog.description
        this.ruleForm.hide = blog.hide
        this.ruleForm.isTop = blog.isTop
        this.ruleForm.weight = blog.weight
        this.ruleForm.content = blog.content
        this.ruleForm.essayUrl = blog.essayUrl
        this.getImg(this.ruleForm.essayUrl)
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