<template>
  <FloatingButtons main-style="position: fixed; right: 20px; bottom: 80px; width:50px" direction="up"
                   :buttons="buttons"/>
</template>

<script>
export default {
  name: 'FloatBall',
  data() {
    return {
      buttons: [
        {
          html: '<i class="el-icon-menu menu" style=" font-size: 44px;" title="主菜单"></i>'
        },
        {
          html: '<i class="el-icon-set-up" style=" font-size: 44px;" title="发布任务"></i>',
          click: () => this.$router.push("/myTask")
        },
        {
          html: '<i class="el-icon-s-operation" style=" font-size: 44px;" title="查看任务"></i>',
          click: () => this.$router.push("/taskList")
        },
        {
          html: '<i class="el-icon-edit" style=" font-size: 44px;" title="发表日志"></i>',
          click: () => this.$router.push("/dairyPost")
        },
        {
          html: '<i class="el-icon-edit-outline" style=" font-size: 44px;" title="发表文章"></i>',
          click: () => this.$router.push("/blog/add")
        },
        // {
        //   html: '<el-backtop target=".page-component__scroll .el-scrollbar__wrap"></el-backtop>',
        //   // click: () => this.$router.push("/blog/add")
        // }
      ],
    }

  }

};
</script>

<style>
.floating-buttons-go-up .button {
  background-color: #1b1f23;
  /*margin: 0 auto;*/
  text-align: center;
}
</style>