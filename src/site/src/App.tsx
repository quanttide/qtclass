import { BrowserRouter, Routes, Route } from 'react-router-dom'
import Home from './pages/Home'
import Course from './pages/Course'
import Prices from './pages/Prices'
import ItemDetail from './pages/learning/ItemDetail'
import Layout from './components/Layout'
import { ROUTE_PATHS } from './routes'
import './App.css'

// 路由表单独导出，便于在 MemoryRouter 下测试
export function AppRoutes() {
  return (
    <Routes>
      <Route path={ROUTE_PATHS.home} element={<Home />} />
      <Route path={ROUTE_PATHS.course} element={<Course />} />
      <Route path={ROUTE_PATHS.prices} element={<Prices />} />
      <Route path={ROUTE_PATHS.scheduleItem} element={<ItemDetail />} />
    </Routes>
  )
}

function App() {
  return (
    <BrowserRouter>
      <Layout>
        <AppRoutes />
      </Layout>
    </BrowserRouter>
  )
}

export default App
