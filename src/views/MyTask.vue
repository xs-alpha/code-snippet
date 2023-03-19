<template>
  <div>
    <Header></Header>

    <el-form :model="dynamicValidateForm" ref="dynamicValidateForm" label-width="100px" class="demo-dynamic">

      <el-form-item class="each-task"
                    v-for="(task, index) in dynamicValidateForm.tasks"
                    :label="'我的任务' + index"
                    :key="task.key"
                    :prop="'tasks.' + index + '.value'"
                    :rules="{
      required: true, message: '任务不能为空', trigger: 'blur'
    }"
      >
        <el-row :gutter="10" style="margin-bottom: 5px">
          <el-col :span="17">
            <div class="grid-content bg-purple">
              <el-input v-model="task.value"></el-input>
            </div>
          </el-col>
          <el-col :span="3">
            <div class="grid-content bg-purple">
              <el-button class="delete-btn" @click.prevent="removetask(task)">删除</el-button>
            </div>
          </el-col>
        </el-row>

        <!--        <el-input v-model="task.value" style="width: 40rem"></el-input>-->
        <!--        <el-button class="delete-btn" @click.prevent="removetask(task)" style="float: right">删除</el-button>-->
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="submitForm('dynamicValidateForm')">提交</el-button>
        <el-button @click="addtask">新增任务</el-button>
        <el-button @click="resetForm('dynamicValidateForm')">重置</el-button>
        <el-divider direction="vertical" style="padding-left:  5rem"></el-divider>
        <el-button type="success" icon="el-icon-check" circle title="提交为周计划"
                   @click="submitWeekProxy('dynamicValidateForm')"></el-button>
        <el-button type="info" icon="el-icon-check" circle title="提交为月计划"
                   @click="submitMonthProxy('dynamicValidateForm')"></el-button>
      </el-form-item>
    </el-form>

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
      dynamicValidateForm: {
        tasks: [{
          value: ''
        }],
        email: ''
      }
    };

  },
  methods: {
    submitWeekProxy(formName) {
      this.submitTaskFunc(formName, "week")
    },
    submitMonthProxy(formName) {
      this.submitTaskFunc(formName, "month");
    },
    submitTaskFunc(formName, taskName) {
      if (window.confirm("确认提交吗，提交后不可修改哦")) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            var retTasks = [];
            for (var i = 0; i < this.dynamicValidateForm.tasks.length; i++) {
              retTasks.push(this.dynamicValidateForm.tasks[i].value)
            }
            const _this = this;
            this.$axios
                .post("/peroidState/" + taskName, retTasks, {
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
          } else {
            console.log("error submit!!");
            return false;
          }

        });
      }
    },
    submitForm(formName) {
      if (window.confirm("确认提交吗，提交后不可修改哦")) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            var retTasks = [];
            for (var i = 0; i < this.dynamicValidateForm.tasks.length; i++) {
              retTasks.push(this.dynamicValidateForm.tasks[i].value)
            }
            const _this = this;
            this.$axios
                .post("/tasks", retTasks, {
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
          } else {
            console.log("error submit!!");
            return false;
          }

        });
      }

    },
    resetForm(formName) {
      this.$refs[formName].resetFields();
    },
    removetask(item) {
      if (window.confirm("确认删除当前任务吗")) {
        var index = this.dynamicValidateForm.tasks.indexOf(item)
        if (index !== -1) {
          this.dynamicValidateForm.tasks.splice(index, 1)
        }
      } else {
        console.log("cancel")
      }

    },
    addtask() {
      this.dynamicValidateForm.tasks.push({
        value: '',
        key: Date.now()
      });
    }
  },

};
</script>
<style scoped>

.edit-content {
  text-align: center;
  clear: both;
}

.el-divider--vertical {
  height: 1.5rem;
  margin: 0 22px;
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
  background: #99a9bf;
}

.bg-purple {
  /*background: #d3dce6;*/
}

.bg-purple-light {
  background: #e5e9f2;
}

.grid-content {
  border-radius: 4px;
  min-height: 36px;
}

.row-bg {
  padding: 10px 0;
  background-color: #f9fafc;
}
</style>