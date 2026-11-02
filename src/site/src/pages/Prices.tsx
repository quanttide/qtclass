import { PRICES_TRACKS } from '../models/learning'

// 价格页：只保留三种服务模式（询价口径不标价格），明细内容不在此页展示
function Prices() {
  return (
    <main>
      <section className="courseSection" aria-labelledby="prices-title">
        <div className="sectionHead">
          <div>
            <p>Prices</p>
            <h2 id="prices-title">价格</h2>
          </div>
          <p className="sectionDesc">定价跟付费对象与商业模式走，不跟课程走。</p>
        </div>

        <div className="learnGrid">
          {PRICES_TRACKS.map((track) => (
            <div key={track.key} className="learnCard">
              <div className="courseTop">
                <h3>{track.label}</h3>
              </div>
              <p className="summary">{track.summary}</p>
              <p className="audience">{track.action}</p>
            </div>
          ))}
        </div>
      </section>
    </main>
  )
}

export default Prices
