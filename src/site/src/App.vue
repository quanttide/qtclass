<script setup>
const learnUrl = 'https://studio.class.quanttide.com'

const courses = [
  {
    name: '知识工作',
    level: '入门',
    audience: '新同学、实习生、业务协作成员',
    summary: '建立文档、信息收集、结构化表达和复盘的基本工作习惯。',
    modules: ['文档即资产', '信息收集与整理', '知识输出'],
  },
  {
    name: '氛围编程',
    level: '进阶',
    audience: '需要用 AI 提升研发和自动化效率的成员',
    summary: '从开发环境搭建到 API Key、编辑器 Agent 配置，完成可运行的 AI 编程闭环。',
    modules: ['开发环境搭建', '工具配置', '任务拆解'],
  },
  {
    name: '大数据导论',
    level: '进阶',
    audience: '数据岗位入门、业务分析协作成员',
    summary: '理解数据采集、治理、分析和应用的基本链路。',
    modules: ['数据资产', '分析流程', '业务指标'],
  },
  {
    name: '数据工程',
    level: '高阶',
    audience: '数据工程、平台建设和交付实施成员',
    summary: '面向真实项目的数据建模、管道、质量和交付规范。',
    modules: ['数据建模', '工程管道', '质量与运维'],
  },
  {
    name: '生产实习',
    level: '实训',
    audience: '公司内部培训、实训基地学员',
    summary: '以微型创业和真实交付为牵引，完成学习、Demo、进度和立项闭环。',
    modules: ['理解业务', '识别机会', '验证 Demo', '提交立项'],
  },
]

const resourceGroups = [
  '量潮是谁',
  '业务与市场',
  '方法论',
  '方案与实施',
  '复盘与展示',
]
</script>

<template>
  <main>
    <section class="hero">
      <img src="/images/course-hero.png" alt="量潮课堂课程体系" />
      <div class="heroOverlay">
        <nav>
          <span class="brand">量潮课堂</span>
          <a :href="learnUrl">进入学员端</a>
        </nav>
        <div class="heroText">
          <p>class.quanttide.com</p>
          <h1>量潮课堂</h1>
          <span>课程体系展示 · 学习资料区框架</span>
        </div>
      </div>
    </section>

    <section class="courseSection" aria-labelledby="courses-title">
      <div class="sectionHead">
        <div>
          <p>Courses</p>
          <h2 id="courses-title">五门课</h2>
        </div>
        <a class="primaryLink" :href="learnUrl">去学习</a>
      </div>

      <div class="courseGrid">
        <article v-for="course in courses" :key="course.name" class="courseCard">
          <div class="courseTop">
            <h3>{{ course.name }}</h3>
            <span>{{ course.level }}</span>
          </div>
          <p class="audience">{{ course.audience }}</p>
          <p class="summary">{{ course.summary }}</p>
          <div class="moduleList">
            <span v-for="module in course.modules" :key="module">{{ module }}</span>
          </div>
        </article>
      </div>
    </section>

    <section class="resources" aria-labelledby="resources-title">
      <div class="sectionHead">
        <div>
          <p>Materials</p>
          <h2 id="resources-title">学习资料区</h2>
        </div>
        <span class="status">待周会确认</span>
      </div>
      <div class="resourceGrid">
        <article v-for="group in resourceGroups" :key="group">
          <h3>{{ group }}</h3>
          <p>内容待周会确认</p>
        </article>
      </div>
    </section>
  </main>
</template>
