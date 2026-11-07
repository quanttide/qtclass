// 价格三档：定价跟付费对象与商业模式走，不跟课程走。G/B 档为询价入口不标价格，C 档明细暂不展示
const PRICES_TRACKS = [
  {
    key: 'g',
    label: 'G 端 · 校企合作',
    summary: '为高校定制完整课程方案——课程体系、讲义实验、授课与考核，教学与教研按合同合作。',
    action: '经量潮课堂联系洽谈',
  },
  {
    key: 'b',
    label: 'B 端 · 企业培训与人才交付',
    summary: '以真实业务任务为教材的团队培训，人才交付附任务轨迹与淘汰赛结果。',
    action: '报价洽谈',
  },
  {
    key: 'c',
    label: 'C 端 · 个人学习',
    summary: '课时包与一对一咨询，群内提问免费；完成任务可得代金券。',
    action: '明细见下方列表',
  },
] as const

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
