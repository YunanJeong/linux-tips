# 프로젝트 컨텍스트 가이드 (GEMINI.md)

이 파일은 AI 에이전트가 이 프로젝트의 최상위 법전으로 참조합니다.

## 1. 기술 스택
- Language: TypeScript (Strict Mode)
- Framework: React 18, TailwindCSS
- State Management: Zustand
- Testing: Vitest

## 2. 프로젝트 구조
- `src/components`: UI 컴포넌트 (PascalCase)
- `src/hooks`: 커스텀 훅 및 비즈니스 로직
- `src/lib`: 유틸리티 및 외부 API 연동 (`fetcher` 필수 사용)
- `src/store`: Zustand 상태 정의

## 3. 보안 가이드라인
- 절대 코드에 API Key나 비밀번호를 하드코딩하지 마십시오.
- 모든 API 호출은 `@/lib/api`의 `fetcher`를 경유해야 합니다.

## 4. 코딩 가이드라인 (Definition of Done)
- Naming: 변수/함수는 camelCase, 컴포넌트는 PascalCase를 사용합니다.
- Testing: 모든 비즈니스 로직은 `vitest`로 작성된 테스트가 동반되어야 합니다.
- Clean Code: 함수는 20라인을 넘지 않도록 작게 쪼개는 것을 선호합니다.
- Verification: 모든 변경 사항은 `npm run lint` 및 `npm test`를 통과해야 완료로 간주합니다.
