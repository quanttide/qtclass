import { useLocation, useNavigate } from 'react-router-dom'
import { ROUTE_PATHS, isTabPath } from '../routes'

// 顶部 AppBar（微信式）：页签根页居中标题；压入页（详情/反馈）左侧返回——
// 有历史可退则弹栈，深链直达则回实践
function AppBar() {
  const { pathname } = useLocation()
  const navigate = useNavigate()
  const onTab = isTabPath(pathname)

  const goBack = () => {
    if ((window.history.state?.idx ?? 0) > 0) {
      navigate(-1)
    } else {
      navigate(ROUTE_PATHS.practice)
    }
  }

  return (
    <header className="appBar">
      {onTab ? (
        <span className="appBarSlot" aria-hidden="true" />
      ) : (
        <button type="button" className="appBarBack" aria-label="返回" onClick={goBack}>
          <svg viewBox="0 0 24 24" width="22" height="22" aria-hidden="true">
            <path
              d="M15 5l-7 7 7 7"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.8"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
        </button>
      )}
      <h1 className="appBarTitle">量潮课堂</h1>
      <span className="appBarSlot" aria-hidden="true" />
    </header>
  )
}

export default AppBar
