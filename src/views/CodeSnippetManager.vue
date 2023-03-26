<template>
  <div class="snippet-manager">
    <div class="header">
      <h1>Code Snippet Manager</h1>
      <button @click="showAddModal">Add Snippet</button>
    </div>
    <div class="snippets">
      <div class="snippet" v-for="snippet in snippets" :key="snippet.id">
        <h2>{{ snippet.title }}</h2>
        <p>{{ snippet.description }}</p>
        <div class="actions">
          <button @click="showEditModal(snippet)">Edit</button>
          <button @click="deleteSnippet(snippet)">Delete</button>
        </div>
      </div>
    </div>
    <div class="modal" :class="{ 'is-active': showModal }">
      <div class="modal-background"></div>
      <div class="modal-content">
        <div class="modal-header">
          <h2>{{ modalTitle }}</h2>
          <button class="delete" aria-label="close" @click="showModal = false"></button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="saveSnippet">
            <label for="title">Title</label>
            <input type="text" id="title" v-model="snippet.title" required>
            <label for="description">Description</label>
            <textarea id="description" v-model="snippet.description"></textarea>
            <label for="code">Code</label>
            <textarea id="code" v-model="snippet.code"></textarea>
            <button type="submit">Save</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'CodeSnippetManager',
  data() {
    return {
      snippets: [
        {
          id: 1,
          title: 'test1',
          description: 'test test',
          code: 'func main(){}'
        },
        {
          id: 2,
          title: 'test2',
          description: 'test2 test2',
          code: 'public static void main(){}'
        },
      ],
      snippet: {
        id: null,
        title: '',
        description: '',
        code: ''
      },
      modalTitle: '',
      showModal: false
    }
  },
  methods: {
    loadSnippets() {
      axios.get('/api/snippets')
          .then(response => {
            this.snippets = response.data;
          });
    },
    saveSnippet() {
      if (this.snippet.id) {
        axios.put(`/api/snippets/${this.snippet.id}`, this.snippet)
            .then(response => {
              this.showModal = false;
              this.loadSnippets();
            });
      } else {
        axios.post('/api/snippets', this.snippet)
            .then(response => {
              this.showModal = false;
              this.loadSnippets();
            });
      }
    },
    deleteSnippet(snippet) {
      axios.delete(`/api/snippets/${snippet.id}`)
          .then(response => {
            this.loadSnippets();
          });
    },
    showAddModal() {
      this.modalTitle = 'Add Snippet';
      this.snippet = {
        id: null,
        title: '',
        description: '',
        code: ''
      };
      this.showModal = true;
    },
    showEditModal(snippet) {
      this.modalTitle = 'Edit Snippet';
      this.snippet = Object.assign({}, snippet);
      this.showModal = true;
    }
  },
  mounted() {
    this.loadSnippets();
  }
}
</script>

<style>
/* 省略样式 */
body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #F8F8F8;
}

.container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  margin-top: 50px;
}

.card {
  background-color: white;
  box-shadow: 0px 2px 10px 0px rgba(0, 0, 0, 0.1);
  width: 500px;
  padding: 20px;
  border-radius: 5px;
}

h1 {
  font-size: 24px;
  font-weight: bold;
  margin: 0 0 20px 0;
  text-align: center;
}

.form-group {
  margin-bottom: 20px;
}

label {
  font-weight: bold;
  display: block;
  margin-bottom: 5px;
}

input[type=text] {
  border: none;
  border-bottom: 1px solid gray;
  width: 100%;
  height: 30px;
  font-size: 16px;
  padding: 0 10px;
  box-sizing: border-box;
}

textarea {
  border: none;
  border-bottom: 1px solid gray;
  width: 100%;
  height: 100px;
  font-size: 16px;
  padding: 10px;
  box-sizing: border-box;
  resize: none;
}

button {
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 5px;
  padding: 10px 20px;
  font-size: 16px;
  cursor: pointer;
}

button:hover {
  background-color: #3e8e41;
}

.code-snippet-list {
  margin-top: 20px;
}

.code-snippet {
  background-color: #f2f2f2;
  border: 1px solid #e6e6e6;
  padding: 10px;
  border-radius: 5px;
  margin-bottom: 10px;
}

.code-snippet pre {
  font-size: 14px;
  white-space: pre-wrap;
  word-wrap: break-word;
}

.code-snippet__header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 5px;
}

.code-snippet__title {
  font-weight: bold;
  font-size: 16px;
  /*margin-right: 10px;*/
}

.code-snippet__actions {
  display: flex;
  justify-content: flex-end;
}

.code-snippet__delete-button {
  background-color: #ff5c5c;
  /*margin-left: 10px;*/
}

.code-snippet__delete-button:hover {
  background-color: #ff4444;
}


</style>
