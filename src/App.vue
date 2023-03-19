<!--<template>-->
<!--  <div>-->
<!--    <h1>My Code Snippets</h1>-->
<!--    <div class="snippet-manager">-->
<!--      &lt;!&ndash; 管理列表 &ndash;&gt;-->
<!--      <div class="snippet-list">-->
<!--        <div v-for="(snippet, index) in snippets" :key="snippet.id" class="snippet">-->
<!--          <div class="snippet-title">-->
<!--            <span class="title">{{ snippet.title }}</span>-->
<!--            <div class="controls">-->
<!--              &lt;!&ndash; 编辑按钮 &ndash;&gt;-->
<!--              <button class="edit-button" @click="editSnippet(index)">编辑</button>-->
<!--              &lt;!&ndash; 删除按钮 &ndash;&gt;-->
<!--              <button class="delete-button" @click="deleteSnippet(index)">删除</button>-->
<!--            </div>-->
<!--          </div>-->
<!--          &lt;!&ndash; 代码片段 &ndash;&gt;-->
<!--          <pre class="snippet-code">{{ snippet.code }}</pre>-->
<!--        </div>-->
<!--      </div>-->

<!--      &lt;!&ndash; 添加按钮 &ndash;&gt;-->
<!--      <button class="add-button" @click="addSnippet">添加代码片段</button>-->

<!--      &lt;!&ndash; 编辑模态框 &ndash;&gt;-->
<!--      <div v-if="editingIndex !== null" class="edit-modal">-->
<!--        <div class="edit-header">-->
<!--          <span class="title">编辑代码片段</span>-->
<!--          <button class="close-button" @click="closeEditModal">关闭</button>-->
<!--        </div>-->
<!--        <div class="edit-body">-->
<!--          <div class="edit-field">-->
<!--            <label for="title">标题：</label>-->
<!--            <input type="text" id="title" v-model="editingSnippet.title" />-->
<!--          </div>-->
<!--          <div class="edit-field">-->
<!--            <label for="code">代码：</label>-->
<!--            <textarea id="code" v-model="editingSnippet.code"></textarea>-->
<!--          </div>-->
<!--        </div>-->
<!--        <div class="edit-footer">-->
<!--          <button class="save-button" @click="saveSnippet">保存</button>-->
<!--        </div>-->
<!--      </div>-->
<!--    </div>-->
<!--  </div>-->
<!--</template>-->

<!--<script>-->
<!--import CodeSnippetManager from 'views/CodeSnippetManager';-->
<!--export default {-->
<!--  data() {-->
<!--    return {-->
<!--      snippets: ["hello world","hello world"], // 代码片段列表-->
<!--      editingIndex: null, // 当前编辑的代码片段索引-->
<!--      editingSnippet: { // 当前编辑的代码片段-->
<!--        title: '',-->
<!--        code: '',-->
<!--      },-->
<!--    }-->
<!--  },-->

<!--  methods: {-->
<!--    // 添加代码片段-->
<!--    addSnippet() {-->
<!--      this.editingSnippet = {-->
<!--        title: '',-->
<!--        code: '',-->
<!--      }-->
<!--      this.editingIndex = null-->
<!--    },-->

<!--    // 编辑代码片段-->
<!--    editSnippet(index) {-->
<!--      this.editingSnippet = { ...this.snippets[index] }-->
<!--      this.editingIndex = index-->
<!--    },-->

<!--    // 删除代码片段-->
<!--    deleteSnippet(index) {-->
<!--      this.snippets.splice(index, 1)-->
<!--    },-->

<!--    // 关闭编辑模态框-->
<!--    closeEditModal() {-->
<!--      this.editingSnippet = {-->
<!--        title: '',-->
<!--        code: '',-->
<!--      }-->
<!--      this.editingIndex = null-->
<!--    },-->

<!--    // 保存代码片段-->
<!--    saveSnippet() {-->
<!--      if (this.editingIndex === null) {-->
<!--        // 添加代码片段-->
<!--        this.snippets.push({-->
<!--          id: Date.now(),-->
<!--          title: this.editingSnippet.title,-->
<!--          code: this.editingSnippet.code,-->
<!--        })-->
<!--      } else {-->
<!--        // 更新代码片段-->
<!--        this.snippets.splice(this.editingIndex, 1, {-->
<!--          ...this.snippets[this.editingIndex],-->
<!--          title: this.editingSnippet.title,-->
<!--          code: this.editingSnippet.code,-->
<!--        })-->
<!--      }-->
<!--      this.closeEditModal()-->
<!--    },-->
<!--  },-->
<!--}-->
<!--</script>-->
<template>
  <div>
    <!--    <CodeSnippetManager></CodeSnippetManager>-->
    <router-view></router-view>
  </div>
</template>

<script>
// import CodeSnippetManager from './views/CodeSnippetManager.vue';

export default {
  components: {
    // CodeSnippetManager
  }
};
</script>
<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
</style>