import {
  ACCEPTANCES,
  REQUIREMENTS,
  type AcceptanceFilter,
  type RequirementFilter,
} from '../models/task'

interface FilterSheetProps {
  requirement: RequirementFilter
  acceptance: AcceptanceFilter
  onRequirement: (value: RequirementFilter) => void
  onAcceptance: (value: AcceptanceFilter) => void
  onClose: () => void
}

// 底部弹层筛选（微信式）：两组选项各带「全部」，点选即生效并收起
function FilterSheet({
  requirement,
  acceptance,
  onRequirement,
  onAcceptance,
  onClose,
}: FilterSheetProps) {
  return (
    <div className="sheetOverlay" onClick={onClose} role="presentation">
      <div
        className="sheet"
        role="dialog"
        aria-label="筛选"
        onClick={(event) => event.stopPropagation()}
      >
        <div className="sheetGroup">
          <p className="sheetGroupTitle">需求的精确程度</p>
          <div className="sheetOptions">
            <button
              type="button"
              className={`sheetOption${requirement === 'all' ? ' active' : ''}`}
              onClick={() => {
                onRequirement('all')
                onClose()
              }}
            >
              全部
            </button>
            {REQUIREMENTS.map((item) => (
              <button
                key={item.value}
                type="button"
                className={`sheetOption${requirement === item.value ? ' active' : ''}`}
                onClick={() => {
                  onRequirement(item.value)
                  onClose()
                }}
              >
                {item.label}
              </button>
            ))}
          </div>
        </div>
        <div className="sheetGroup">
          <p className="sheetGroupTitle">验收标准的开放程度</p>
          <div className="sheetOptions">
            <button
              type="button"
              className={`sheetOption${acceptance === 'all' ? ' active' : ''}`}
              onClick={() => {
                onAcceptance('all')
                onClose()
              }}
            >
              全部
            </button>
            {ACCEPTANCES.map((item) => (
              <button
                key={item.value}
                type="button"
                className={`sheetOption${acceptance === item.value ? ' active' : ''}`}
                onClick={() => {
                  onAcceptance(item.value)
                  onClose()
                }}
              >
                {item.label}
              </button>
            ))}
          </div>
        </div>
        <button type="button" className="sheetCancel" onClick={onClose}>
          取消
        </button>
      </div>
    </div>
  )
}

export default FilterSheet
