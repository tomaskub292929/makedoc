# MakeDoc (makedoc.page24.app) 전체 기능 분석 및 클론 스펙

> 원본 사이트의 모든 메뉴, 페이지, 기능을 분석하여 새 사이트에 100% 반영하기 위한 상세 명세서

---

## 1. 사이트 개요

| 항목 | 내용 |
|------|------|
| **사이트명** | 메이크닥 (MakeDoc) |
| **URL** | https://makedoc.page24.app |
| **사업 내용** | 해외 의대 신·편입학 전문 컨설팅 |
| **플랫폼** | page24.app (Nuxt.js 기반 SaaS 웹사이트 빌더) |
| **호스팅** | Naver Cloud Platform (글로벌 엣지 CDN) |
| **보안** | Google reCAPTCHA v3 |
| **테마** | 다크/라이트 모드 지원 |

---

## 2. 전체 메뉴 구조 (Sitemap)

```
makedoc.page24.app
│
├── [GNB] 공통 네비게이션 바
│   ├── 로고 (홈 링크)
│   ├── 메인 메뉴 (7개 항목)
│   └── 모바일 햄버거 메뉴
│
├── 1. About MakeDoc ─────── /blank/10?mcode=10
│   └── 서브페이지 ────────── /blank/1010?mcode=1010
│       └── 회사 소개, 비전, 미션, 대표 인사말
│
├── 2. Medical Schools ───── /blank/11?mcode=11
│   └── 서브페이지 ────────── /blank/1110?mcode=1110
│       └── 제휴 의대 목록, 각 대학 소개, 커리큘럼
│
├── 3. News ──────────────── /blank/12?mcode=12
│   └── 네이버 블로그 연동 ── /naverblog/1210?mcode=1210
│       └── 블로그 포스트 자동 피드, 썸네일+제목+날짜
│
├── 4. MAKEDOC Building ──── /blank/13?mcode=13
│   └── 서브페이지 ────────── /blank/1310?mcode=1310
│       └── 건물/시설 사진, 층별 안내, 시설 소개
│
├── 5. 예약상담 ─────────── /form/1410?mcode=1410
│   └── 서브페이지 ────────── /blank/1410?mcode=1410
│       └── 상담 예약 폼 (이름, 연락처, 문의내용 등)
│
├── 6. 합격후기 ─────────── /board/1510?mcode=1510
│   └── 서브페이지 ────────── /blank/1510?mcode=1510
│       └── 게시판 (합격 후기 글 목록, 상세보기, 작성)
│
├── 7. 오시는길 ─────────── /blank/16?mcode=16
│   └── 서브페이지 ────────── /blank/1610?mcode=1610
│       └── 지도 임베드, 주소, 교통편 안내
│
├── [Footer] 공통 하단 영역
│   ├── 회사 정보 (상호, 대표, 사업자번호)
│   ├── 연락처 (전화, 이메일, 주소)
│   ├── 소셜 링크
│   └── 저작권 표시
│
└── [Popup] 팝업 배너 (선택적)
    └── 공지사항, 이벤트 안내 등
```

---

## 3. URL 라우팅 시스템

### 3.1 라우트 패턴

| 패턴 | 페이지 타입 | 설명 |
|------|-----------|------|
| `/blank/{pageId}?mcode={menuCode}` | 정적 콘텐츠 | 자유 레이아웃 페이지 |
| `/form/{pageId}?mcode={menuCode}` | 입력 폼 | 데이터 수집 페이지 |
| `/board/{pageId}?mcode={menuCode}` | 게시판 | 사용자 게시글 목록/상세 |
| `/naverblog/{pageId}?mcode={menuCode}` | 블로그 연동 | 네이버 블로그 피드 |

### 3.2 mcode 체계

```
1차 메뉴 코드: 10, 11, 12, 13, 14, 15, 16
2차 메뉴 코드: 1010, 1110, 1210, 1310, 1410, 1510, 1610

규칙: 서브페이지 mcode = 부모 mcode × 100 + 부모 mcode의 10의 자리 × 10
예: 부모 10 → 서브 1010
    부모 11 → 서브 1110
```

### 3.3 클론 구현 시 라우팅 설계

```javascript
// Nuxt.js / Next.js 라우팅
/pages/
├── blank/
│   └── [id].vue          // 정적 콘텐츠 페이지
├── form/
│   └── [id].vue          // 폼 페이지
├── board/
│   └── [id].vue          // 게시판 목록
│   └── [id]/[postId].vue // 게시판 상세
├── naverblog/
│   └── [id].vue          // 네이버 블로그 연동
└── index.vue             // 홈페이지 (= /blank/10)
```

---

## 4. 페이지 타입별 상세 기능

### 4.1 Blank 페이지 (정적 콘텐츠)

**사용 페이지**: About MakeDoc, Medical Schools, MAKEDOC Building, 오시는길

```
[기능 목록]
┌─────────────────────────────────────────────────────────┐
│  1. 자유 레이아웃 구성                                     │
│     - 위젯/컴포넌트를 드래그 앤 드롭으로 배치                │
│     - 섹션 단위 구성 (배경색, 배경이미지 설정 가능)           │
│     - 반응형: 데스크톱/모바일 각각 최적화                    │
│                                                          │
│  2. 사용 가능한 위젯 (35종)                                │
│     ┌────────────────────────────────────────┐           │
│     │ [텍스트 계열]                            │           │
│     │  • 텍스트 (단일)                         │           │
│     │  • 텍스트 그룹 (여러 텍스트 모음)          │           │
│     │  • 텍스트 배너 (강조 영역)                │           │
│     │  • 구분선                                │           │
│     │  • 공백 (여백 조절)                       │           │
│     ├────────────────────────────────────────┤           │
│     │ [이미지 계열]                            │           │
│     │  • 이미지 (단일)                         │           │
│     │  • 이미지 그룹 (그리드 배치)              │           │
│     │  • 이미지 + 텍스트 (결합 레이아웃)         │           │
│     │  • 이미지 슬라이더 (캐러셀)               │           │
│     │  • 이미지 스크롤 (가로 스크롤)            │           │
│     │  • 이미지 버튼 그룹 (클릭 가능)           │           │
│     ├────────────────────────────────────────┤           │
│     │ [슬라이더/카드 계열]                      │           │
│     │  • 카드 슬라이더                         │           │
│     │  • 썸네일 게시물 (게시판 연동)             │           │
│     │  • 웹진형 게시물                         │           │
│     │  • 카드형 게시물                         │           │
│     ├────────────────────────────────────────┤           │
│     │ [미디어/외부 콘텐츠]                      │           │
│     │  • YouTube 영상 임베드                   │           │
│     │  • 네이버 블로그 위젯                    │           │
│     │  • 네이버 플레이스 메뉴                  │           │
│     │  • 페이지 미리보기 (링크 프리뷰)          │           │
│     │  • 아이프레임 (외부 페이지 삽입)           │           │
│     ├────────────────────────────────────────┤           │
│     │ [비즈니스/정보]                          │           │
│     │  • 로고 클라우드 (파트너/제휴 로고)       │           │
│     │  • 카드형 멤버 소개 (팀 프로필)           │           │
│     │  • FAQ (아코디언 형태)                   │           │
│     │  • 지도/오시는길 (네이버/구글 지도)       │           │
│     │  • 상품 안내 (가격표/서비스 소개)         │           │
│     │  • 타임라인 (연표/역사)                  │           │
│     ├────────────────────────────────────────┤           │
│     │ [고급]                                  │           │
│     │  • HTML 코드 작성 (커스텀 HTML/CSS/JS)   │           │
│     │  • 코드 블럭 (syntax highlighting)      │           │
│     │  • 텍스트 버튼 그룹 (CTA 버튼 모음)      │           │
│     └────────────────────────────────────────┘           │
│                                                          │
│  3. 섹션 설정                                             │
│     - 배경: 단색 / 이미지 / 그라디언트                      │
│     - 여백: 상하 패딩 조절                                 │
│     - 가로폭: 전체 너비 / 콘텐츠 너비                       │
│     - 정렬: 좌측 / 중앙 / 우측                             │
└─────────────────────────────────────────────────────────┘
```

**클론 구현 데이터 모델**:

```typescript
interface BlankPage {
  id: number;
  mcode: number;
  title: string;
  sections: Section[];
  seo: SEOConfig;
  isPublished: boolean;
}

interface Section {
  id: string;
  order: number;
  background: {
    type: 'color' | 'image' | 'gradient';
    value: string;
  };
  padding: { top: number; bottom: number };
  width: 'full' | 'contained';
  widgets: Widget[];
}

interface Widget {
  id: string;
  type: WidgetType;     // 'text' | 'image' | 'slider' | 'youtube' | 'faq' | 'map' | ...
  order: number;
  props: Record<string, any>;  // 위젯별 고유 속성
}

type WidgetType =
  | 'text' | 'text-group' | 'text-banner'
  | 'divider' | 'spacer'
  | 'image' | 'image-group' | 'image-text' | 'image-slider' | 'image-scroll' | 'image-button-group'
  | 'card-slider' | 'thumbnail-post' | 'webzine-post' | 'card-post'
  | 'youtube' | 'naver-blog' | 'naver-place-menu' | 'page-preview' | 'iframe'
  | 'logo-cloud' | 'member-card' | 'faq' | 'map' | 'pricing' | 'timeline'
  | 'html-code' | 'code-block' | 'button-group';
```

---

### 4.2 Form 페이지 (입력 폼)

**사용 페이지**: 예약상담

```
[기능 목록]
┌─────────────────────────────────────────────────────────┐
│  1. 폼 구성 요소                                         │
│     ┌────────────────────────────────────────┐           │
│     │ [입력 필드 타입]                         │           │
│     │  • 텍스트 입력 (한 줄)                   │           │
│     │  • 텍스트 영역 (여러 줄)                 │           │
│     │  • 이메일 입력                          │           │
│     │  • 전화번호 입력                         │           │
│     │  • 드롭다운 선택                         │           │
│     │  • 라디오 버튼 (단일 선택)               │           │
│     │  • 체크박스 (다중 선택)                  │           │
│     │  • 날짜 선택                            │           │
│     │  • 파일 첨부                            │           │
│     ├────────────────────────────────────────┤           │
│     │ [폼 설정]                               │           │
│     │  • 필수/선택 필드 지정                   │           │
│     │  • 입력 유효성 검사 (형식, 길이 등)       │           │
│     │  • 플레이스홀더 텍스트 설정               │           │
│     │  • 개인정보 수집 동의 체크박스            │           │
│     │  • reCAPTCHA 봇 방지                    │           │
│     └────────────────────────────────────────┘           │
│                                                          │
│  2. 제출 처리                                             │
│     • 제출 완료 메시지 표시                               │
│     • 관리자 이메일/알림 발송                              │
│     • 제출 데이터 관리자 대시보드에 저장                     │
│     • 중복 제출 방지                                      │
│                                                          │
│  3. 데이터 관리 (관리자)                                  │
│     • 제출된 데이터 목록 조회                              │
│     • 개별 응답 상세 보기                                  │
│     • CSV/Excel 내보내기                                  │
│     • 응답 삭제                                           │
│     • 작성자 + 관리자만 데이터 열람 가능 (보안)              │
└─────────────────────────────────────────────────────────┘
```

**클론 구현 데이터 모델**:

```typescript
interface FormPage {
  id: number;
  mcode: number;
  title: string;
  description?: string;
  fields: FormField[];
  settings: FormSettings;
  submissions: FormSubmission[];
}

interface FormField {
  id: string;
  type: 'text' | 'textarea' | 'email' | 'phone' | 'select' | 'radio' | 'checkbox' | 'date' | 'file';
  label: string;
  placeholder?: string;
  required: boolean;
  options?: string[];         // select, radio, checkbox용
  validation?: {
    pattern?: string;         // 정규식
    minLength?: number;
    maxLength?: number;
    maxFileSize?: number;     // 파일 첨부 시
    allowedTypes?: string[];  // 파일 확장자 제한
  };
  order: number;
}

interface FormSettings {
  recaptchaEnabled: boolean;
  privacyConsentRequired: boolean;
  privacyConsentText: string;
  submitButtonText: string;
  successMessage: string;
  notifyEmail?: string;          // 관리자 알림 이메일
  preventDuplicateSubmit: boolean;
}

interface FormSubmission {
  id: string;
  formId: number;
  data: Record<string, any>;     // fieldId → value
  submittedAt: string;           // ISO 8601
  ipAddress: string;
  isRead: boolean;
}
```

**클론 구현 — 예약상담 폼 예시 필드**:

```
┌─────────────────────────────────────────┐
│  예약상담 신청                            │
│                                          │
│  이름 *           [________________]      │
│  연락처 *         [________________]      │
│  이메일            [________________]      │
│  희망 상담일시     [📅 날짜 선택    ]      │
│  관심 과정         [▼ 선택하세요    ]      │
│    ├── 몽골 의대 과정                     │
│    ├── 헝가리 의대 과정                    │
│    ├── 미국 의대 과정                     │
│    └── 기타                              │
│  문의 내용         [                ]      │
│                    [                ]      │
│                    [________________]      │
│                                          │
│  ☑ 개인정보 수집·이용에 동의합니다         │
│                                          │
│           [ 상담 신청하기 ]               │
│                                          │
│  🔒 reCAPTCHA로 보호됩니다               │
└─────────────────────────────────────────┘
```

---

### 4.3 Board 페이지 (게시판)

**사용 페이지**: 합격후기

```
[기능 목록]
┌─────────────────────────────────────────────────────────┐
│  1. 게시판 표시 형태 (3가지)                               │
│     ┌──────────────────────────────────────┐             │
│     │ A. 목록형 (List View)                  │             │
│     │    번호 │ 제목        │ 작성자 │ 날짜  │             │
│     │    ─────┼─────────────┼────────┼────── │             │
│     │    5    │ 합격했습니다!│ 김OO   │ 04.01 │             │
│     │    4    │ 후기 공유.. │ 이OO   │ 03.28 │             │
│     │    3    │ 감사합니다  │ 박OO   │ 03.15 │             │
│     ├──────────────────────────────────────┤             │
│     │ B. 갤러리형 (Gallery View)              │             │
│     │    ┌──────┐ ┌──────┐ ┌──────┐        │             │
│     │    │ 📷   │ │ 📷   │ │ 📷   │        │             │
│     │    │ 제목 │ │ 제목 │ │ 제목 │        │             │
│     │    │ 날짜 │ │ 날짜 │ │ 날짜 │        │             │
│     │    └──────┘ └──────┘ └──────┘        │             │
│     ├──────────────────────────────────────┤             │
│     │ C. 웹진형 (Webzine View)               │             │
│     │    ┌───────────────────────────────┐  │             │
│     │    │ 📷 이미지   │ 제목            │  │             │
│     │    │             │ 요약 텍스트...   │  │             │
│     │    │             │ 작성자 · 날짜   │  │             │
│     │    └───────────────────────────────┘  │             │
│     └──────────────────────────────────────┘             │
│                                                          │
│  2. 게시글 목록 기능                                       │
│     • 정렬: 최신순 / 인기순 / 제목순                        │
│     • 페이지네이션: 번호형 (1, 2, 3...) 또는 더보기 버튼     │
│     • 검색: 제목 / 내용 / 작성자 키워드 검색                 │
│     • 카테고리 필터 (관리자가 카테고리 설정 시)              │
│     • 글 작성 버튼 (권한 있는 사용자)                       │
│                                                          │
│  3. 게시글 상세 보기                                       │
│     • 제목, 작성자, 작성일시                                │
│     • 본문 (HTML 리치 텍스트)                              │
│     • 첨부 이미지/파일                                     │
│     • 조회수                                              │
│     • 이전글 / 다음글 네비게이션                             │
│     • 목록으로 돌아가기 버튼                                │
│                                                          │
│  4. 게시글 작성/수정                                       │
│     • 리치 텍스트 에디터 (WYSIWYG)                         │
│     • 이미지 업로드 (드래그 앤 드롭)                         │
│     • 파일 첨부                                           │
│     • 카테고리 선택                                        │
│     • 임시 저장                                           │
│     • 비밀글 설정                                          │
│                                                          │
│  5. 관리자 기능                                            │
│     • 게시글 승인/반려 (선택적 사전 검열)                    │
│     • 게시글 삭제 / 복구                                   │
│     • 공지사항 고정                                        │
│     • 금지어 자동 필터링                                    │
│     • 작성 권한 설정 (전체 / 회원만 / 관리자만)              │
│     • 열람 권한 설정                                       │
└─────────────────────────────────────────────────────────┘
```

**클론 구현 데이터 모델**:

```typescript
interface BoardPage {
  id: number;
  mcode: number;
  title: string;
  displayType: 'list' | 'gallery' | 'webzine';
  settings: BoardSettings;
  posts: BoardPost[];
}

interface BoardSettings {
  writePermission: 'all' | 'member' | 'admin';
  readPermission: 'all' | 'member' | 'admin';
  useCategory: boolean;
  categories?: string[];
  useComment: boolean;
  useSecret: boolean;                // 비밀글 기능
  useNotice: boolean;                // 공지 고정 기능
  postsPerPage: number;              // 페이지당 게시글 수 (기본 10)
  sortOrder: 'latest' | 'popular' | 'title';
  requireApproval: boolean;          // 관리자 승인 후 공개
  bannedWords: string[];             // 금지어 목록
}

interface BoardPost {
  id: string;
  boardId: number;
  category?: string;
  title: string;
  content: string;                   // HTML 리치 텍스트
  author: {
    id: string;
    name: string;
    isAdmin: boolean;
  };
  thumbnail?: string;               // 갤러리/웹진형 썸네일
  attachments: Attachment[];
  viewCount: number;
  isNotice: boolean;                 // 공지사항 여부
  isSecret: boolean;                 // 비밀글 여부
  status: 'draft' | 'pending' | 'published' | 'deleted';
  createdAt: string;
  updatedAt: string;
}

interface Attachment {
  id: string;
  fileName: string;
  fileUrl: string;
  fileSize: number;
  mimeType: string;
}
```

---

### 4.4 Naver Blog 페이지 (블로그 연동)

**사용 페이지**: News

```
[기능 목록]
┌─────────────────────────────────────────────────────────┐
│  1. 네이버 블로그 피드 자동 수집                            │
│     • 등록된 네이버 블로그 ID의 최신 포스트 자동 가져오기     │
│     • RSS 또는 네이버 Open API를 통한 데이터 수집           │
│     • 주기적 갱신 (캐싱 + 자동 업데이트)                    │
│                                                          │
│  2. 표시 정보                                             │
│     ┌──────────────────────────────────────┐             │
│     │ ┌──────┐                              │             │
│     │ │ 📷   │  포스트 제목                  │             │
│     │ │ 썸네일│  요약 텍스트 (2-3줄)...       │             │
│     │ │      │  2026.04.01                  │             │
│     │ └──────┘                              │             │
│     │ ───────────────────────────────────── │             │
│     │ ┌──────┐                              │             │
│     │ │ 📷   │  다음 포스트 제목             │             │
│     │ │ 썸네일│  요약 텍스트...               │             │
│     │ └──────┘                              │             │
│     └──────────────────────────────────────┘             │
│                                                          │
│  3. 클릭 동작                                             │
│     • 포스트 클릭 → 원본 네이버 블로그 글로 새 탭 이동       │
│     • 또는 사이트 내 iframe으로 블로그 글 표시              │
│                                                          │
│  4. 페이지네이션                                          │
│     • 더보기 버튼 또는 무한 스크롤                          │
│     • 한 번에 표시되는 포스트 수 설정 가능                   │
│                                                          │
│  5. 관리자 설정                                            │
│     • 네이버 블로그 ID 등록                                │
│     • 표시할 포스트 수 설정                                │
│     • 갱신 주기 설정                                       │
│     • 특정 카테고리만 필터링 (선택)                          │
└─────────────────────────────────────────────────────────┘
```

**클론 구현 데이터 모델**:

```typescript
interface NaverBlogPage {
  id: number;
  mcode: number;
  title: string;
  settings: NaverBlogSettings;
  cachedPosts: NaverBlogPost[];
}

interface NaverBlogSettings {
  blogId: string;                    // 네이버 블로그 ID
  postsPerPage: number;              // 한 번에 표시할 수
  category?: string;                 // 특정 카테고리 필터
  refreshInterval: number;           // 갱신 주기 (분)
  openInNewTab: boolean;             // 새 탭에서 원본 열기
}

interface NaverBlogPost {
  title: string;
  summary: string;
  thumbnail?: string;
  link: string;                      // 원본 블로그 URL
  publishedAt: string;
  cachedAt: string;
}
```

---

## 5. 공통 UI 컴포넌트

### 5.1 GNB (Global Navigation Bar)

```
[데스크톱]
┌──────────────────────────────────────────────────────────┐
│  [Logo]  About  Medical  News  Building  상담  후기  길   │
└──────────────────────────────────────────────────────────┘

[모바일]
┌──────────────────────┐
│  [Logo]        [☰]   │
└──────────────────────┘
      ↓ 햄버거 클릭 시
┌──────────────────────┐
│  About MakeDoc    ✕  │
│  Medical Schools     │
│  News                │
│  MAKEDOC Building    │
│  예약상담             │
│  합격후기             │
│  오시는길             │
└──────────────────────┘

[기능]
• 현재 페이지 활성 메뉴 하이라이트
• 스크롤 시 고정(sticky) 또는 배경색 전환
• 드롭다운 서브메뉴 (2단계 지원)
• 로고 클릭 → 홈으로 이동
• 모바일: 오프캔버스 슬라이드 메뉴 + 오버레이
```

### 5.2 Footer

```
┌──────────────────────────────────────────────────────────┐
│  [Logo]                                                   │
│                                                           │
│  상호: 메이크닥  │  대표: OOO  │  사업자등록번호: 000-00-00000│
│  주소: 서울특별시 ~~~                                      │
│  전화: 02-0000-0000  │  이메일: info@makedoc.co.kr         │
│                                                           │
│  [Facebook] [Instagram] [YouTube] [Blog]                  │
│                                                           │
│  © 2026 MakeDoc. All rights reserved.                     │
│  개인정보처리방침  │  이용약관                                │
└──────────────────────────────────────────────────────────┘
```

### 5.3 팝업 배너

```
[기능]
• 사이트 접속 시 자동 표시
• 이미지 또는 HTML 콘텐츠
• 닫기 버튼 (X)
• "오늘 하루 보지 않기" 체크박스 (쿠키/로컬스토리지 저장)
• 표시 기간 설정 (시작일 ~ 종료일)
• 복수 팝업 지원 (순서 지정)
• 링크 연결 (클릭 시 특정 페이지로 이동)

[관리자 설정]
• 팝업 이미지 업로드
• 표시 위치 (중앙 / 좌하단 / 우하단)
• 표시 조건 (전체 / 비로그인 / 첫 방문 등)
• 활성/비활성 토글
```

---

## 6. 관리자 대시보드 기능

### 6.1 홈페이지 관리

```
┌─────────────────────────────────────────────────────────┐
│  [관리자 대시보드]                                         │
│                                                          │
│  📊 홈페이지 현황                                         │
│     ├── 홈페이지 목록 조회                                 │
│     ├── 홈페이지 설정 (기본 정보, 로고, 파비콘)             │
│     ├── 공동 편집자 초대/관리                              │
│     ├── 홈페이지 선물하기 (이전)                           │
│     └── 홈페이지 삭제                                     │
│                                                          │
│  📝 콘텐츠 관리                                           │
│     ├── 페이지 편집기 (드래그 앤 드롭)                      │
│     ├── 메뉴 관리 (추가, 수정, 삭제, 순서 변경)             │
│     ├── 게시물 통합 관리 (모든 게시판 글)                    │
│     └── 삭제된 게시물 관리 (복구 가능)                      │
│                                                          │
│  👤 회원 관리                                             │
│     ├── 가입 회원 목록                                     │
│     ├── 회원 정보 조회                                     │
│     └── 회원 삭제/차단                                     │
│                                                          │
│  📈 분석 (Analytics)                                      │
│     ├── 페이지뷰 (PV) 통계                                │
│     │    └── 일별/주별/월별 차트                            │
│     ├── 순방문자 (UV) 통계                                │
│     │    └── 일별/주별/월별 차트                            │
│     └── 외부 분석 연동                                     │
│          ├── 네이버 서치 어드바이저                          │
│          ├── 네이버 애널리틱스                              │
│          └── 구글 애널리틱스 (GA4)                          │
│                                                          │
│  ⚙️ 설정                                                 │
│     ├── 금지어 관리                                        │
│     ├── 관리자 프로필 설정                                  │
│     ├── 도메인 포워딩 (커스텀 도메인 연결)                   │
│     └── SEO 설정 (메타 태그, OG 태그)                      │
│                                                          │
│  💳 구독/결제                                             │
│     ├── 현재 구독 플랜 확인                                 │
│     ├── 플랜 변경 (Lite / Core / Pro)                      │
│     └── 결제 내역 조회                                     │
└─────────────────────────────────────────────────────────┘
```

### 6.2 페이지 편집기 (에디터)

```
[편집 모드 UI]

┌─────────────────────────────────────────────────────────┐
│  [← 뒤로]  페이지 이름  [미리보기 👁]  [저장 💾]  [발행 🚀]│
├─────────────┬───────────────────────────────────────────┤
│  위젯 패널   │                                          │
│  ──────────  │       편집 캔버스                         │
│  텍스트      │                                          │
│  이미지      │    ┌──────────────────────────────┐      │
│  슬라이더    │    │     섹션 1                     │      │
│  YouTube     │    │     [위젯 A] [위젯 B]          │      │
│  FAQ         │    │     [+ 위젯 추가]              │      │
│  지도        │    └──────────────────────────────┘      │
│  게시물      │    ┌──────────────────────────────┐      │
│  HTML 코드   │    │     섹션 2                     │      │
│  ...         │    │     [위젯 C]                   │      │
│              │    │     [+ 위젯 추가]              │      │
│              │    └──────────────────────────────┘      │
│              │                                          │
│              │    [+ 섹션 추가]                          │
├─────────────┴───────────────────────────────────────────┤
│  속성 패널 (위젯 선택 시 우측 또는 하단에 표시)              │
│  ├── 텍스트: 글꼴, 크기, 색상, 정렬, 간격                  │
│  ├── 이미지: 소스, 대체 텍스트, 링크, 크기, 정렬            │
│  ├── 섹션: 배경, 여백, 가로폭                              │
│  └── 공통: 여백, 표시/숨김, 모바일 설정                     │
└─────────────────────────────────────────────────────────┘
```

---

## 7. 각 메뉴 페이지별 콘텐츠 상세

### 7.1 About MakeDoc (`/blank/10`)

```
[구현해야 할 콘텐츠 구조]

섹션 1: 히어로 배너
  • 풀와이드 배경 이미지
  • 오버레이 텍스트: "해외 의대 전문 컨설팅, 메이크닥"
  • 서브 텍스트: 비전/미션 한 줄 요약

섹션 2: 회사 소개
  • 이미지 + 텍스트 레이아웃 (2 컬럼)
  • 설립 배경, 핵심 가치, 차별화 포인트
  • 주요 수치 (합격률, 상담 건수, 제휴 학교 수 등)

섹션 3: 대표 인사말
  • 대표 사진 + 인사말 텍스트
  • 서명 이미지 (선택)

섹션 4: 연혁 (타임라인)
  • 주요 이정표 시간순 배치
  • 연도, 이벤트 제목, 설명

섹션 5: 파트너/제휴
  • 로고 클라우드 위젯
  • 제휴 대학, 기관 로고 나열
```

### 7.2 Medical Schools (`/blank/11`)

```
[구현해야 할 콘텐츠 구조]

섹션 1: 섹션 배너
  • "Medical Schools" 타이틀
  • 부제: 제휴 의과대학 소개

섹션 2: 의대 카드 그리드
  • 각 의대별 카드:
    ┌─────────────────────────┐
    │  [대학 이미지/로고]       │
    │  대학명                  │
    │  국가 / 도시             │
    │  과정: 6년 / English Track│
    │  인증: ECFMG, ASIIN 등  │
    │  [자세히 보기 →]         │
    └─────────────────────────┘

섹션 3: 각 대학 상세 (서브페이지 또는 아코디언)
  • 대학 개요
  • 커리큘럼 (학년별)
  • 입학 조건
  • 학비 정보
  • 졸업 후 진로 (면허 취득 경로)
  • 캠퍼스 사진 갤러리

섹션 4: 비교표
  • 대학 간 비교 (학비, 기간, 인증, 언어 등)
  • 테이블 위젯
```

### 7.3 News (`/naverblog/1210`)

```
[구현해야 할 콘텐츠 구조]

• 네이버 블로그 연동 피드
• 각 포스트: 썸네일 + 제목 + 요약 + 날짜
• 클릭 시 원본 블로그로 이동
• 페이지네이션 또는 무한 스크롤
• 관리자가 블로그 ID만 등록하면 자동 갱신
```

### 7.4 MAKEDOC Building (`/blank/13`)

```
[구현해야 할 콘텐츠 구조]

섹션 1: 건물 외관 사진
  • 이미지 슬라이더 (외부/내부 사진)

섹션 2: 층별 안내
  • 각 층별 용도 설명
  • 이미지 + 텍스트 (교대 배치)

섹션 3: 시설 소개
  • 이미지 갤러리 (강의실, 상담실, 라운지 등)
  • 카드형 시설 소개

섹션 4: 360도 뷰 / 가상 투어 (선택)
  • iframe 임베드 또는 이미지 슬라이더
```

### 7.5 예약상담 (`/form/1410`)

```
[구현해야 할 콘텐츠 구조]

섹션 1: 안내 텍스트
  • "무료 상담 예약"
  • 상담 안내 문구, 운영 시간

섹션 2: 예약 폼
  • (4.2 Form 페이지 참조)
  • 필드: 이름, 연락처, 이메일, 관심 과정, 희망 일시, 문의 내용
  • 개인정보 동의 체크
  • 제출 버튼

섹션 3: 기타 연락 방법
  • 전화번호
  • 카카오톡 상담 링크
  • 이메일 주소
```

### 7.6 합격후기 (`/board/1510`)

```
[구현해야 할 콘텐츠 구조]

• 게시판 (4.3 Board 페이지 참조)
• 표시 형태: 목록형 또는 웹진형
• 합격생 후기 게시글
• 각 글: 제목 / 작성자 / 날짜 / 조회수
• 상세 페이지: 본문 + 사진 + 첨부파일
• 검색 기능
```

### 7.7 오시는길 (`/blank/16`)

```
[구현해야 할 콘텐츠 구조]

섹션 1: 지도
  • 네이버 지도 또는 구글 지도 임베드
  • 마커 핀 (사무실 위치)
  • 줌 레벨 설정

섹션 2: 주소 및 연락처
  • 도로명 주소
  • 지번 주소
  • 전화번호
  • 이메일

섹션 3: 교통편 안내
  • 지하철: 노선, 역명, 출구 번호, 도보 시간
  • 버스: 정류장명, 버스 번호
  • 자가용: 주차 안내
```

---

## 8. 기술 스택 및 인프라

### 8.1 프론트엔드

```
[원본 기술 스택]
• Framework:     Nuxt.js (Vue.js SSR/SPA)
• 상태 관리:      로컬스토리지 + Nuxt 스토어
• 스타일링:       CSS (nuxt-color-mode 다크/라이트)
• 캐러셀:         자체 구현 또는 라이브러리 (Swiper 등)
• 에디터:         WYSIWYG 리치 텍스트 에디터
• 봇 방지:        Google reCAPTCHA v3
• CDN:           Naver Cloud Platform 글로벌 엣지

[클론 권장 기술 스택]
• Framework:     Next.js 14+ (App Router) 또는 Nuxt 3
• 스타일링:       Tailwind CSS + CSS Variables (design-system.md 토큰)
• 상태 관리:      Zustand 또는 Pinia
• 캐러셀:         Swiper.js v11
• 에디터:         Tiptap 또는 Plate (리치 텍스트)
• 폼:            React Hook Form + Zod 유효성 검사
• 지도:           @vis.gl/react-google-maps 또는 네이버 Maps API
• 봇 방지:        Google reCAPTCHA v3
• 아이콘:         Lucide Icons 또는 Font Awesome
```

### 8.2 백엔드 API

```
[필요한 API 엔드포인트]

# 페이지 관리
GET    /api/pages                      # 전체 페이지 목록
GET    /api/pages/:id                  # 페이지 상세 (위젯 포함)
POST   /api/pages                      # 페이지 생성
PUT    /api/pages/:id                  # 페이지 수정
DELETE /api/pages/:id                  # 페이지 삭제

# 메뉴 관리
GET    /api/menus                      # 메뉴 트리 조회
PUT    /api/menus                      # 메뉴 구조 업데이트
PUT    /api/menus/:id/order            # 메뉴 순서 변경

# 게시판
GET    /api/boards/:boardId/posts      # 게시글 목록 (페이지네이션, 검색, 정렬)
GET    /api/boards/:boardId/posts/:id  # 게시글 상세
POST   /api/boards/:boardId/posts      # 게시글 작성
PUT    /api/boards/:boardId/posts/:id  # 게시글 수정
DELETE /api/boards/:boardId/posts/:id  # 게시글 삭제 (소프트 삭제)
PATCH  /api/boards/:boardId/posts/:id/restore  # 삭제된 게시글 복구

# 폼 제출
GET    /api/forms/:formId/submissions  # 제출 데이터 목록
POST   /api/forms/:formId/submit       # 폼 제출
GET    /api/forms/:formId/submissions/:id  # 제출 상세
DELETE /api/forms/:formId/submissions/:id  # 제출 삭제
GET    /api/forms/:formId/export       # CSV/Excel 내보내기

# 네이버 블로그 연동
GET    /api/naver-blog/:blogId/posts   # 블로그 포스트 피드 (캐싱)
PUT    /api/naver-blog/settings        # 블로그 연동 설정

# 파일 업로드
POST   /api/upload                     # 이미지/파일 업로드
DELETE /api/upload/:fileId             # 파일 삭제

# 회원 관리
GET    /api/members                    # 회원 목록
GET    /api/members/:id               # 회원 상세
DELETE /api/members/:id               # 회원 삭제/차단

# 분석
GET    /api/analytics/pageviews        # PV 통계 (기간별)
GET    /api/analytics/visitors         # UV 통계 (기간별)

# 설정
GET    /api/settings                   # 사이트 설정 조회
PUT    /api/settings                   # 사이트 설정 업데이트
PUT    /api/settings/seo               # SEO 설정
PUT    /api/settings/domain            # 도메인 설정
PUT    /api/settings/banned-words      # 금지어 설정

# 인증
POST   /api/auth/login                 # 로그인
POST   /api/auth/register             # 회원가입
POST   /api/auth/logout               # 로그아웃
GET    /api/auth/me                   # 현재 사용자 정보

# 팝업 배너
GET    /api/popups                    # 활성 팝업 목록
POST   /api/popups                    # 팝업 생성
PUT    /api/popups/:id                # 팝업 수정
DELETE /api/popups/:id                # 팝업 삭제
```

### 8.3 데이터베이스 스키마 (핵심 테이블)

```sql
-- 사이트 설정
CREATE TABLE site_settings (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  site_name     VARCHAR(100) NOT NULL,
  logo_url      TEXT,
  favicon_url   TEXT,
  description   TEXT,
  contact_phone VARCHAR(20),
  contact_email VARCHAR(100),
  address       TEXT,
  social_links  JSONB DEFAULT '{}',
  seo_config    JSONB DEFAULT '{}',
  theme_mode    VARCHAR(10) DEFAULT 'light',
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 메뉴
CREATE TABLE menus (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id     UUID REFERENCES menus(id),
  title         VARCHAR(100) NOT NULL,
  mcode         INTEGER UNIQUE NOT NULL,
  page_type     VARCHAR(20) NOT NULL,  -- 'blank', 'form', 'board', 'naverblog', 'link', 'iframe', 'calendar'
  page_id       INTEGER,
  url           TEXT,                   -- 외부 링크용
  sort_order    INTEGER DEFAULT 0,
  is_visible    BOOLEAN DEFAULT true,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 페이지 (blank 타입)
CREATE TABLE pages (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mcode         INTEGER NOT NULL,
  title         VARCHAR(200) NOT NULL,
  sections      JSONB DEFAULT '[]',     -- 섹션 + 위젯 구조 전체
  seo_title     VARCHAR(200),
  seo_desc      VARCHAR(300),
  og_image      TEXT,
  is_published  BOOLEAN DEFAULT false,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 게시판 설정
CREATE TABLE boards (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mcode         INTEGER NOT NULL,
  title         VARCHAR(100) NOT NULL,
  display_type  VARCHAR(20) DEFAULT 'list',  -- 'list', 'gallery', 'webzine'
  settings      JSONB DEFAULT '{}',
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 게시글
CREATE TABLE board_posts (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  board_id      UUID REFERENCES boards(id) ON DELETE CASCADE,
  category      VARCHAR(50),
  title         VARCHAR(300) NOT NULL,
  content       TEXT NOT NULL,
  author_id     UUID REFERENCES users(id),
  author_name   VARCHAR(50) NOT NULL,
  thumbnail     TEXT,
  view_count    INTEGER DEFAULT 0,
  is_notice     BOOLEAN DEFAULT false,
  is_secret     BOOLEAN DEFAULT false,
  status        VARCHAR(20) DEFAULT 'published',
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW(),
  deleted_at    TIMESTAMPTZ
);

-- 첨부파일
CREATE TABLE attachments (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id       UUID REFERENCES board_posts(id) ON DELETE CASCADE,
  file_name     VARCHAR(200) NOT NULL,
  file_url      TEXT NOT NULL,
  file_size     INTEGER NOT NULL,
  mime_type     VARCHAR(100) NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 폼 설정
CREATE TABLE forms (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mcode         INTEGER NOT NULL,
  title         VARCHAR(100) NOT NULL,
  description   TEXT,
  fields        JSONB DEFAULT '[]',      -- 폼 필드 정의
  settings      JSONB DEFAULT '{}',      -- 폼 설정 (reCAPTCHA, 알림 등)
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 폼 제출 데이터
CREATE TABLE form_submissions (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  form_id       UUID REFERENCES forms(id) ON DELETE CASCADE,
  data          JSONB NOT NULL,
  ip_address    INET,
  is_read       BOOLEAN DEFAULT false,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 네이버 블로그 연동
CREATE TABLE naver_blog_configs (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mcode         INTEGER NOT NULL,
  blog_id       VARCHAR(50) NOT NULL,
  posts_per_page INTEGER DEFAULT 10,
  category      VARCHAR(100),
  refresh_interval INTEGER DEFAULT 60,  -- 분
  open_in_new_tab BOOLEAN DEFAULT true,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 네이버 블로그 캐시
CREATE TABLE naver_blog_cache (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  config_id     UUID REFERENCES naver_blog_configs(id),
  title         VARCHAR(300) NOT NULL,
  summary       TEXT,
  thumbnail     TEXT,
  link          TEXT NOT NULL,
  published_at  TIMESTAMPTZ,
  cached_at     TIMESTAMPTZ DEFAULT NOW()
);

-- 사용자
CREATE TABLE users (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email         VARCHAR(200) UNIQUE NOT NULL,
  password_hash VARCHAR(200) NOT NULL,
  name          VARCHAR(50) NOT NULL,
  phone         VARCHAR(20),
  role          VARCHAR(20) DEFAULT 'member',  -- 'admin', 'editor', 'member'
  is_active     BOOLEAN DEFAULT true,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 팝업 배너
CREATE TABLE popups (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         VARCHAR(100) NOT NULL,
  content_type  VARCHAR(20) DEFAULT 'image',  -- 'image', 'html'
  content       TEXT NOT NULL,
  link_url      TEXT,
  position      VARCHAR(20) DEFAULT 'center',
  start_date    TIMESTAMPTZ,
  end_date      TIMESTAMPTZ,
  is_active     BOOLEAN DEFAULT true,
  sort_order    INTEGER DEFAULT 0,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 방문 통계
CREATE TABLE analytics (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  page_path     TEXT NOT NULL,
  visitor_id    VARCHAR(100),               -- 쿠키 기반 고유 ID
  ip_address    INET,
  user_agent    TEXT,
  referer       TEXT,
  visited_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 금지어
CREATE TABLE banned_words (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word          VARCHAR(100) NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 9. 다크/라이트 모드 시스템

```
[구현 사항]
• 3가지 모드: light / dark / system (OS 설정 따르기)
• 로컬스토리지 키: 'color-mode' 또는 'nuxt-color-mode'
• HTML data 속성: <html data-color-mode="dark">
• CSS 변수로 전환:

:root[data-color-mode="light"] {
  --bg-primary:    #FFFFFF;
  --bg-secondary:  #F5F7FA;
  --text-primary:  #1A1A2E;
  --text-secondary:#4A4A68;
  --border:        #E0E0E8;
}

:root[data-color-mode="dark"] {
  --bg-primary:    #1A1A2E;
  --bg-secondary:  #252540;
  --text-primary:  #E8E8F0;
  --text-secondary:#A0A0B8;
  --border:        #3A3A50;
}

[초기 로드 로직 — 깜빡임 방지]
<script>
  (function() {
    var saved = localStorage.getItem('color-mode');
    if (saved) {
      document.documentElement.setAttribute('data-color-mode', saved);
    } else if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
      document.documentElement.setAttribute('data-color-mode', 'dark');
    }
  })();
</script>
```

---

## 10. SEO 및 외부 서비스 연동

```
[SEO 설정]
• 페이지별 meta title, description, og:image 설정
• sitemap.xml 자동 생성
• robots.txt 설정
• 구조화 데이터 (JSON-LD) — Organization, LocalBusiness

[검색엔진 연동]
• 네이버 서치 어드바이저: 사이트 소유 확인 메타 태그
• 구글 서치 콘솔: 사이트 소유 확인 메타 태그

[분석 도구 연동]
• 네이버 애널리틱스: 추적 스크립트 삽입
• 구글 애널리틱스 (GA4): gtag.js 삽입
  - 설정 항목: Measurement ID (G-XXXXXXXXXX)

[채팅 연동]
• 채널톡 (Channel.io): 플러그인 키 입력 → 자동 삽입
• 카카오톡 상담: 플러스친구 링크

[reCAPTCHA]
• Google reCAPTCHA v3
• 사이트 키 + 시크릿 키 설정
• 폼 제출 시 자동 검증
```

---

## 11. 클론 구현 체크리스트

```
[Phase 1 — 핵심 구조]
☐ 프로젝트 초기화 (Next.js / Nuxt 3)
☐ 라우팅 시스템 (/blank, /form, /board, /naverblog)
☐ GNB 네비게이션 (데스크톱 + 모바일)
☐ 푸터 컴포넌트
☐ 다크/라이트 모드 전환
☐ 반응형 레이아웃 (4단계 브레이크포인트)
☐ design-system.md 토큰 적용

[Phase 2 — 콘텐츠 페이지]
☐ Blank 페이지 렌더러 (섹션 + 위젯 시스템)
☐ 35종 위젯 컴포넌트 구현
  ☐ 텍스트 계열 (5종)
  ☐ 이미지 계열 (6종)
  ☐ 슬라이더/카드 계열 (4종)
  ☐ 미디어/외부 (5종)
  ☐ 비즈니스/정보 (6종)
  ☐ 고급 (4종)
  ☐ 네비게이션 (2종: 공통 영역, 섹션)
☐ 섹션 설정 (배경, 여백, 너비)

[Phase 3 — 폼 시스템]
☐ 폼 빌더 (관리자용)
☐ 폼 렌더러 (방문자용)
☐ 9가지 필드 타입 구현
☐ 유효성 검사
☐ reCAPTCHA 연동
☐ 제출 데이터 저장 + 관리자 조회
☐ CSV/Excel 내보내기

[Phase 4 — 게시판 시스템]
☐ 게시판 3가지 뷰 (목록/갤러리/웹진)
☐ 게시글 CRUD
☐ 리치 텍스트 에디터
☐ 이미지/파일 업로드
☐ 페이지네이션 + 검색
☐ 공지 고정, 비밀글
☐ 금지어 필터링
☐ 삭제/복구

[Phase 5 — 네이버 블로그 연동]
☐ 블로그 ID로 포스트 크롤링/API 호출
☐ 캐싱 시스템 (자동 갱신)
☐ 피드 목록 UI (썸네일 + 제목 + 요약 + 날짜)
☐ 원본 링크 연결

[Phase 6 — 관리자 대시보드]
☐ 로그인/인증 시스템
☐ 사이트 설정 관리
☐ 메뉴 관리 (드래그 앤 드롭 순서 변경)
☐ 페이지 편집기 (드래그 앤 드롭 위젯 배치)
☐ 게시물 통합 관리
☐ 회원 관리
☐ 분석 대시보드 (PV/UV 차트)
☐ 팝업 배너 관리

[Phase 7 — SEO 및 연동]
☐ 메타 태그 / OG 태그 설정
☐ sitemap.xml 자동 생성
☐ 네이버 서치 어드바이저 / 구글 서치 콘솔 연동
☐ GA4 / 네이버 애널리틱스 연동
☐ 채널톡 연동
☐ 커스텀 도메인 연결

[Phase 8 — 메이크닥 고유 콘텐츠]
☐ About MakeDoc 페이지 콘텐츠
☐ Medical Schools 페이지 (의대 카드 그리드)
☐ MAKEDOC Building 페이지 (시설 갤러리)
☐ 예약상담 폼 (필드 구성)
☐ 합격후기 게시판 (초기 데이터)
☐ 오시는길 (지도 + 교통편)
☐ News 네이버 블로그 연동
```

---

## 12. 참고: 메이크닥 서비스 컨텍스트

```
[사업 정보]
• 사업명:    메이크닥 (MakeDoc)
• 사업 분야: 해외 의대 신·편입학 전문 컨설팅
• 대상 고객: 해외 의대 진학 희망 학생/학부모
• 주요 서비스:
  - 해외 의대 입학 컨설팅
  - 파운데이션 과정 안내
  - 의대 본과 입학 지원
  - 면허 취득 가이드
  - 예약 상담

[핵심 페이지 목적]
• About:        신뢰 구축 (회사 소개, 실적)
• Medical:      정보 제공 (제휴 의대 상세)
• News:         최신성 유지 (블로그 자동 연동)
• Building:     신뢰 구축 (실체 있는 사무실)
• 예약상담:     전환 유도 (리드 수집)
• 합격후기:     사회적 증명 (실제 합격 사례)
• 오시는길:     접근성 (오프라인 방문 유도)
```
