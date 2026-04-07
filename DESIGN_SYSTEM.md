# MakeDoc Design System

4색 팔레트 기반, shadcn/ui 스타일 디자인 시스템.

## Color Palette — 4 Colors

| Swatch | Hex | Name | Role |
|--------|-----|------|------|
| Light Blue | `#92B9BD` | Primary | 카드 넘버, 프로세스 카드 1, 링 포커스 |
| Celadon | `#A8D4AD` | Secondary | 프로세스 카드 2, Subscribe 버튼, 호버 강조 |
| Lime Cream | `#F2F79E` | Lime | 프로세스 카드 3, 배지 배경 |
| Canary Yellow | `#E8EC67` | Accent | CTA 버튼, 프로세스 카드 4, 네비 버튼 |

## shadcn Token Mapping

```
background:          #FAFBF9   (살짝 웜 화이트)
foreground:          #1C3336   (primary에서 파생된 다크 틸)
card:                #FFFFFF
card-foreground:     #1C3336
muted:               #F0F4F4   (아주 연한 틸 틴트)
muted-foreground:    #6B8B8F   (중간 틸 그레이)
primary:             #92B9BD
primary-hover:       #7DA5A9
primary-dark:        #2C4A4E   (히어로 오버레이, 푸터, CTA 다크 섹션)
primary-foreground:  #1C3336
secondary:           #A8D4AD
secondary-hover:     #8FC496
secondary-foreground:#1E3322
accent:              #E8EC67
accent-hover:        #D4D855
accent-foreground:   #2E3010
border:              #D5E2E3
ring:                #92B9BD
```

## Typography

- **Font stack**: `"Noto Sans KR"`, `Montserrat`, system sans-serif
- **Headings font**: `Montserrat` → `"Noto Sans KR"` fallback
- **H1**: 56px / 800 weight / 1.15 line-height
- **H2**: 40px / 700 weight / 1.25 line-height
- **Body**: 14-16px / 400 weight / 1.7 line-height
- **Label**: 11px / 700 weight / uppercase / tracking 3px

## Component Patterns

### Buttons (shadcn style)
- **Primary CTA**: `bg-accent text-accent-foreground rounded-lg shadow-sm`
- **Ghost**: `bg-white/10 backdrop-blur border border-white/20 rounded-lg`
- **Outline**: `border border-border rounded-lg hover:bg-muted`
- 패딩: `px-8 py-3.5` / 폰트: `text-sm font-semibold`

### Cards
- `bg-white rounded-xl border border-border p-7`
- 호버: `-translate-y-1 shadow-lg border-{color}/40`
- 넘버: `text-[36px] font-extrabold text-{color}/25`

### Process Cards
- 4색 각각 배경색: primary → secondary → lime → accent
- 텍스트: `{color}-foreground` (다크톤)
- `rounded-xl p-6 min-h-[220px]`

### Navbar
- `bg-white/80 backdrop-blur-md border-b border-border`
- Nav hover: `bg-muted rounded-md` (shadcn 스타일)

### Sections
- 교대 배경: `bg-white` ↔ `bg-muted (#F0F4F4)`
- 다크 섹션: `bg-primary-dark (#2C4A4E)`
- 섹션 패딩: `py-20 md:py-28`

## Design Principles

1. **절제된 색상 사용**: 4색만으로 모든 UI 구성. 추가 색상 금지.
2. **뉴트럴 기반**: 대부분의 UI는 white/muted 뉴트럴. 색상은 포인트로만.
3. **명확한 전경/배경 대비**: 밝은 배경에 다크 텍스트, 다크 배경에 밝은 텍스트.
4. **미묘한 보더**: `border-border` 1px로 카드 구분. 그림자는 호버에서만.
5. **backdrop-blur**: 네비바, 고스트 버튼에 글래스모피즘 적용.
