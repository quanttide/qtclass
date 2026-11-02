import { BrowserRouter, Navigate, Routes, Route, Link } from 'react-router-dom'
import Today from './pages/Today'
import TaskDetail from './pages/TaskDetail'
import Feedback from './pages/Feedback'
import { ROUTE_PATHS } from './routes'
import './App.css'

// 路由表单独导出，便于测试
export function AppRoutes() {
  return (
    <Routes>
      <Route path={ROUTE_PATHS.today} element={<Today />} />
      <Route path={ROUTE_PATHS.taskItem} element={<TaskDetail />} />
      <Route path={ROUTE_PATHS.feedback} element={<Feedback />} />
      <Route path="*" element={<Navigate to={ROUTE_PATHS.today} replace />} />
    </Routes>
  )
}

// 外壳：只留品牌与反馈入口，无导航菜单、无配置
function App() {
  return (
    <BrowserRouter>
      <div className="liteApp">
        <header className="liteHeader">
          <Link to={ROUTE_PATHS.today} className="liteBrand">
            量潮课堂 Lite
          </Link>
          <Link to={ROUTE_PATHS.feedback} className="liteFeedbackLink">
            反馈
          </Link>
        </header>
        <main className="liteMain">
          <AppRoutes />
        </main>
      </div>
    </BrowserRouter>
  )
}

export default App
