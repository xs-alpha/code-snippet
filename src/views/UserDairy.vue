<template>
  <div>
    <Header></Header>
    <!-- <el-avatar :size="50" :src=""></el-avatar>
    <div>name</div> -->
    <el-table
        :data="tableData"
        style="width: 100%" border>
      <el-table-column
          label="日期"
          width="180">
        <template slot-scope="scope">
          <i class="el-icon-time"></i>
          <span style="margin-left: 10px">{{ scope.row.timeShow }}</span>
        </template>
      </el-table-column>
      <el-table-column
          label="日记"
          width="250">
        <template slot-scope="scope">
          <i class="el-icon-star-on"></i>
          <span style="margin-left: 10px">{{ scope.row.title }}</span>
        </template>
      </el-table-column>
      <el-table-column
          label="简介"
          width="260">
        <template slot-scope="scope">
          <i class="el-icon-s-order"></i>
          <span style="margin-left: 10px">{{ scope.row.dairyDesc }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button
              size="mini"
              @click="handleLook(scope.$index, scope.row)">查看
          </el-button>
          <el-button
              v-show="ownBlog"
              size="mini"
              type="primary"
              @click="handleEdit(scope.$index, scope.row)">编辑
          </el-button>
          <el-button
              v-show="ownBlog"
              size="mini"
              type="danger"
              @click.native.prevent="handleDelete(scope.$index, tableData)">删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <Footer/>
  </div>
</template>

<script>
import Header from "@/components/Header";
import Footer from "@/components/Footer";

export default {
  components: {Header, Footer},
  methods: {
    handleLook(row) {
      this.$router.push({name: "DairyDetail", params: {blogId: this.tableData[row].id}});
    },

    handleEdit(row) {

      this.$router.push({name: "DairyEdit", params: {blogId: this.tableData[row].id}});
    },
    handleDelete(index, rows) {
      this.$confirm("是否删除该日记？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      })
          .then(() => {
            this.$axios
                .get("/dairy/delete/" + this.tableData[index].id, {
                  headers: {
                    Authorization: localStorage.getItem("token")
                  }
                })
                .then(res => {
                  rows.splice(index, 1)
                });
            this.$message({
              type: "success",
              message: "删除成功!"
            });
          })
          .catch(() => {
            this.$message({
              type: "info",
              message: "已取消删除"
            });
          });
    }
  },
  data() {
    return {
      ownBlog: false,
      timeShow: '',
      tableData: [],
    }
  },
  created() {
    let username = this.$route.params.username;
    if (username) {
      this.$axios.get("/dairy/user/" + username).then(res => {
        let blogs = res.data.data;
        console.log(blogs)
        this.tableData = blogs;
        // 判断是否为该作者，是才能编辑
        this.ownBlog = blogs[0].userId === this.$store.getters.getUserInfo.id;
      });
    }
  },

}
</script>

<style>

</style>