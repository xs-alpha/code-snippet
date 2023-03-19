import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '@/views/Login.vue'
import Blog from '@/views/Blog.vue'
import BlogDetail from '@/views/BlogDetail.vue'
import BlogEdit from '@/views/BlogEdit.vue'
import Register from '@/views/register.vue'
import User from '@/views/User.vue'
import DairyEdit from "@/views/DairyEdit";
import Dairy from "@/views/Dairy";
import UserDairy from "@/views/UserDairy";
import DairyDetail from "@/views/DairyDetail";
import TimeLine from "@/views/TimeLine";
import ReSet from "@/views/ReSet";
import MyBlog from "@/views/MyBlog";
import MyTask from "@/views/MyTask";
import GetMyTask from "@/views/GetMyTask";
import TaskList from "@/views/TaskList";
import GetMyPeroidTask from "@/views/GetMyPeroidTask";
import MyEssay from "../views/MyEssay";
import EssayDetail from "@/views/EssayDetail";
import EssayEdit from "@/views/EssayEdit";

Vue.use(VueRouter)

const routes = [
    {
        path: '/',
        name: 'Index',
        redirect: {name: "Blog"}
    },
    {
        path: '/blog',
        name: 'Blog',
        component: Blog
    },
    {
        path: '/myTask',
        name: 'MyTask',
        component: MyTask
    },
    {
        path: '/myPeroidTask/:taskId',
        name: 'GetMyPeroidTask',
        component: GetMyPeroidTask
    },
    {
        path: '/taskList',
        name: 'TaskList',
        component: TaskList
    },
    {
        path: '/myTask/:taskId',
        name: 'GetMyTask',
        component: GetMyTask
    },
    {
        path: '/deleteTask/:taskId',
        name: 'DeleteTask',
        component: TaskList
    },
    {
        path: '/myBlog',
        name: 'MyBlog',
        component: MyBlog
    },
    {
        path: '/MyEssay',
        name: 'MyEssay',
        component: MyEssay
    },
    {
        path: '/dairy',
        name: 'Dairy',
        component: Dairy
    },
    {
        path: '/register',
        name: 'Register',
        component: Register
    },
    {
        path: '/reSet',
        name: 'ReSet',
        component: ReSet
    },
    {
        path: '/login',
        name: 'Login',
        component: Login
    },
    {
        path: '/blog/add',
        name: 'BlogEdit',
        component: BlogEdit,
        meta: {
            requireAuth: true
        }
    },
    {
        path: '/essay/add',
        name: 'EssayEdit',
        component: EssayEdit,
        meta: {
            requireAuth: true
        }
    },
    {
        path: '/dairyPost',
        name: 'DairyEdit',
        component: DairyEdit,
        meta: {
            requireAuth: true
        }
    },
    {
        path: '/blog/:blogId',
        name: 'BlogDetail',
        component: BlogDetail
    },
    {
        path: '/essay/:blogId',
        name: 'EssayDetail',
        component: EssayDetail
    },
    {
        path: '/dairyDetail/:blogId',
        name: 'DairyDetail',
        component: DairyDetail
    },
    {
        path: '/user/:username',
        name: 'User',
        component: User
    },
    {
        path: '/dairy/:username',
        name: 'UserDairy',
        component: UserDairy
    },
    {
        path: '/blog/:blogId/edit',
        name: 'BlogEdit',
        component: BlogEdit,
        meta: {
            requireAuth: true
        }
    },
    {
        // TODO:测试后要删除这个
        path: '/essay/:blogId/edit',
        name: 'EssayEdit',
        component: EssayEdit,
        meta: {
            requireAuth: true
        }
    },
    {
        path: '/timeLine',
        name: 'TimeLine',
        component: TimeLine,
        meta: {
            requireAuth: true
        }
    },
]

const router = new VueRouter({
    mode: 'history',
    base: process.env.BASE_URL,
    routes
})

export default router
