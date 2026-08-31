import { BrowserRouter, Routes, Route, NavLink } from 'react-router-dom'
import Home from './pages/Home'
import Learn from './pages/Learn'
import ItemDetail from './pages/learning/ItemDetail'
import ProductionInternship from './pages/ProductionInternship'
import ProductionInternshipCourse from './pages/courses/ProductionInternshipCourse'
import './App.css'

function App() {
  return (
    <BrowserRouter>
      <div className="app">
        <nav className="site-nav">
          <div className="nav-inner">
            <a className="site-brand" href="/">量潮课堂</a>
            <div className="site-links">
              <NavLink to="/" end className={({ isActive }) => (isActive ? 'active' : '')}>
                课程体系
              </NavLink>
              <NavLink to="/courses/production-internship" className={({ isActive }) => (isActive ? 'active' : '')}>
                生产实习
              </NavLink>
              <NavLink to="/learn" className={({ isActive }) => (isActive ? 'active' : '')}>
                学习
              </NavLink>
            </div>
          </div>
        </nav>

        <header className="hero">
          <h1>量潮课堂</h1>
          <p>课程体系展示 · 学习资料区框架</p>
        </header>

        <div className="content">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/learn" element={<Learn />} />
            <Route path="/learn/:type/:slug" element={<ItemDetail />} />
            <Route path="/courses/production-internship" element={<ProductionInternship />} />
            <Route path="/courses/production-internship/lessons/:lessonSlug" element={<ProductionInternshipCourse />} />
          </Routes>
        </div>
      </div>
    </BrowserRouter>
  )
}

export default App
