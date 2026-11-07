import { BrowserRouter, Navigate, Routes, Route } from 'react-router-dom'
import AppBar from './components/AppBar'
import TabBar from './components/TabBar'
import Practice from './pages/Practice'
import Theory from './pages/Theory'
import Mine from './pages/Mine'
import TaskDetail from './pages/TaskDetail'
import Feedback from './pages/Feedback'
import { ROUTE_PATHS } from './routes'
import './App.css'

// 路由表单独导出，便于测试
export function AppRoutes() {
  return (
    <Routes>
      <Route path={ROUTE_PATHS.practice} element={<Practice />} />
      <Route path={ROUTE_PATHS.theory} element={<Theory />} />
      <Route path={ROUTE_PATHS.mine} element={<Mine />} />
      <Route path={ROUTE_PATHS.taskItem} element={<TaskDetail />} />
      <Route path={ROUTE_PATHS.feedback} element={<Feedback />} />
      <Route path="*" element={<Navigate to={ROUTE_PATHS.practice} replace />} />
    </Routes>
  )
}

// 外壳：微信式顶栏 + 页签根页底部导航；任务详情与反馈为压入页
function App() {
  return (
    <BrowserRouter>
      <div className="liteApp">
        <AppBar />
        <main className="liteMain">
          <AppRoutes />
        </main>
        <TabBar />
      </div>
    </BrowserRouter>
  )
}

export default App
