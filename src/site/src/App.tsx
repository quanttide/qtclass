import { BrowserRouter, Routes, Route } from 'react-router-dom'
import Home from './pages/Home'
import Learn from './pages/Learn'
import ItemDetail from './pages/learning/ItemDetail'
import Layout from './components/Layout'
import { ROUTE_PATHS } from './routes'
import './App.css'

// 路由表单独导出，便于在 MemoryRouter 下测试
export function AppRoutes() {
  return (
    <Routes>
      <Route path={ROUTE_PATHS.home} element={<Home />} />
      <Route path={ROUTE_PATHS.learn} element={<Learn />} />
      <Route path={ROUTE_PATHS.learnItem} element={<ItemDetail />} />
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
