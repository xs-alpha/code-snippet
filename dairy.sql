create table dairy
(
    `id`            int          not null auto_increment,
    `dairy_content` longtext comment '日记内容',
    `user_id`       bigint       not null default 0 comment 'userId',
    `author`        varchar(100) not null default '匿名' comment '作者',
    `year`          varchar(20)  not null default '' comment '年 字符串',
    `title`         varchar(20)  not null default '' comment '标题',
    `post_time`     varchar(20)  not null default '' comment '发表时间',
    `create_time`   timestamp(3) not null default current_timestamp(3) comment '创建时间',
    `update_time`   timestamp(3)          default current_timestamp(3) on update current_timestamp (3) comment '更新时间',
    primary key (`id`)
)engine=innodb auto_increment=1 default charset=utf8mb4 comment='日志';

create table user_code
(
    `id`          int          not null auto_increment,
    `user_id`     bigint(40) not null default 0 comment 'userId',
    `username`    varchar(100) not null default '匿名' comment '作者',
    `code`        varchar(50)  not null default '' comment '注册码',
    `create_time` timestamp(3) not null default current_timestamp(3) comment '创建时间',
    `update_time` timestamp(3)          default current_timestamp(3) on update current_timestamp (3) comment '更新时间',
    primary key (`id`)
)engine=innodb auto_increment=1 default charset=utf8mb4 comment='用户注册码对应表';


DROP TABLE IF EXISTS `m_blog`;

CREATE TABLE `m_blog`
(
    `id`           bigint(20) NOT NULL AUTO_INCREMENT,
    `user_id`      bigint(20) NOT NULL,
    `title`        varchar(255) NOT NULL,
    `description`  varchar(255) NOT NULL,
    `content`      longtext,
    `gmt_create`   datetime     NOT NULL,
    `gmt_modified` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `status`       tinyint(4) DEFAULT NULL,
    `deleted`      int(11) DEFAULT '0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `m_user`;

CREATE TABLE `m_user`
(
    `id`         bigint(20) NOT NULL comment 'user_id',
    `username`   varchar(64)  DEFAULT NULL,
    `avatar`     varchar(255) DEFAULT NULL,
    `email`      varchar(64)  DEFAULT NULL,
    `password`   varchar(64)  DEFAULT NULL,
    `status`     int(5) NOT NULL,
    `created`    datetime     DEFAULT NULL,
    `last_login` datetime     DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY          `UK_USERNAME` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

insert into `m_user`(`id`, `username`, `avatar`, `email`, `password`, `status`, `created`, `last_login`)
values (1, 'admin', 'https://cdn.jsdelivr.net/gh/HimitZH/CDN/images/HCODE.png', 'admin@qq.com',
        '96e79218965eb72c92a549dd5a330112', 0, '2020-07-19 22:00:00', NULL);


create table my_task
(
    `task_id`     int          not null auto_increment,
    `user_id`     bigint       not null comment '用户id',
    `author`      varchar(64)  not null default '匿名' comment '用户',
    `task_state`  int          not null default 0 comment '任务状态 0：未完成   1：已完成',
    `note`        varchar(64)           default '' comment '任务完成或未完成注释',
    `create_time` timestamp(3) not null default current_timestamp(3) comment '创建时间',
    `update_time` timestamp(3)          default current_timestamp(3) on update current_timestamp (3) comment '更新时间',
) <el-row :gutter="12" >
        <el-col :span="12">
          <div v-for="(blog,index) in blogContents"
               :key="index">
          <el-card shadow="always" class="each-card">
            <el-col :span="24">
              <div class="grid-content bg-purple">
                <el-descriptions :data="[{ label: blog.title }]">
                  <template v-slot:title="{ row }">
                    <router-link class="link bolg-link" :to="{name:'BlogDetail',params:{blogId:row.id}}">{{ row.label }}</router-link>
                  </template>
                  <el-descriptions-item label="用户名" :column="4"><router-link class="link" :to="{name:'User',params:{username:blog.author}}">{{ blog.author }}
                  </router-link></el-descriptions-item>
                  <el-descriptions-item label="提交时间">{{blog.gmtCreate}}</el-descriptions-item>
                  <el-descriptions-item label="备注">{{blog.remark}}</el-descriptions-item>
                  <el-descriptions-item label="语言" :span="1">
                    <el-tag size="small">{{blog.codeLanguage}}</el-tag>
                  </el-descriptions-item>
                  <el-descriptions-item label="描述">{{blog.description}}</el-descriptions-item>
                  <el-descriptions-item label="code" :span="2">{{blog.content}}</el-descriptions-item>
                </el-descriptions>
              </div>
            </el-col>
          </el-card>
          </div>
        </el-col>
      </el-row>>