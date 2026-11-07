import { Link } from 'react-router-dom'
import { ROUTE_PATHS } from '../routes'

// 我的：个人页骨架——登录与学习记录接通后开放。当前只留反馈入口，不放假数据
function Mine() {
  return (
    <main>
      <div className="mineCard">
        <p className="mineHint">个人页待接入——登录与学习记录接通后开放。</p>
        <Link to={ROUTE_PATHS.feedback} className="liteLink">
          反馈
        </Link>
      </div>
    </main>
  )
}

export default Mine
