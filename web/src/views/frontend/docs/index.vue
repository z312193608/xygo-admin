<!-- +----------------------------------------------------------------------
  | XYGo Admin [ Vue3 + GoFrame 企业级中后台管理系统 ]
  +----------------------------------------------------------------------
  | Copyright (c) 2026 大连星韵网络科技有限公司 All rights reserved.
  +----------------------------------------------------------------------
  | Licensed ( https://opensource.org/licenses/MIT )
  +----------------------------------------------------------------------
  | Author: 喜羊羊 <751300685@qq.com>
  +---------------------------------------------------------------------- -->
<template>
  <main class="docs-page px-4 pb-4 pt-4">
    <div class="max-w-[1600px] mx-auto flex gap-4 lg:gap-6 items-start">
      <!-- Left sidebar -->
      <aside class="hidden lg:flex flex-col w-56 flex-shrink-0 sticky top-[88px] self-start max-h-[calc(100vh-100px)] overflow-y-auto sidebar-scroll">
        <div class="bg-white/60 backdrop-blur-lg rounded-[24px] shadow-clay-card border border-[#d1d9e6]/40 p-4">
          <!-- Search trigger -->
          <div class="mb-4">
            <button
              class="w-full h-9 flex items-center gap-2 px-3 rounded-lg bg-[#f0f3f8] shadow-clay-pressed text-xs font-medium text-clay-muted hover:bg-white hover:shadow-clay-card transition-all"
              @click="openSearch"
            >
              <ArtSvgIcon icon="ri:search-line" class="text-sm" />
              <span class="flex-1 text-left">搜索文档...</span>
              <kbd class="hidden sm:inline-flex items-center gap-0.5 px-1.5 py-0.5 rounded bg-white/80 border border-[#d1d9e6]/50 text-[10px] font-bold text-clay-muted shadow-sm">
                Ctrl K
              </kbd>
            </button>
          </div>

          <!-- Doc category tree：一级无子分类也可点；挂在任意层级的文章都能打开 -->
          <div v-for="group in categories" :key="group.id" class="mb-4 last:mb-0">
            <template v-if="(group.children || []).length">
              <h3 class="text-[10px] font-black text-clay-muted uppercase tracking-[0.1em] mb-2 px-2">{{ group.title }}</h3>
              <ul v-if="getDocsByCategory(group.id).length" class="space-y-0.5 mb-1">
                <li v-for="doc in getDocsByCategory(group.id)" :key="'gdoc-' + doc.id">
                  <a
                    href="#"
                    class="flex items-center gap-2 px-3 py-1.5 rounded-lg font-bold text-xs transition-all duration-300"
                    :class="docLinkClass(doc)"
                    @click.prevent="openDoc(doc)"
                  >
                    <ArtSvgIcon icon="ri:article-line" class="text-sm" />
                    <span class="truncate">{{ doc.title }}</span>
                  </a>
                </li>
              </ul>
              <ul class="space-y-0.5">
                <li v-for="child in group.children" :key="child.id">
                  <a
                    href="#"
                    class="flex items-center gap-2 px-3 py-2 rounded-lg font-bold text-xs transition-all duration-300"
                    :class="getCategoryClass(child)"
                    @click.prevent="toggleCategory(child)"
                  >
                    <ArtSvgIcon :icon="child.icon || 'ri:folder-line'" class="text-sm" />
                    <span class="truncate">{{ child.title }}</span>
                  </a>
                  <ul v-if="expandedCategoryId === child.id && getDocsByCategory(child.id).length > 1" class="ml-4 mt-0.5 space-y-0.5">
                    <li v-for="doc in getDocsByCategory(child.id)" :key="'doc-' + doc.id">
                      <a
                        href="#"
                        class="flex items-center gap-2 px-3 py-1.5 rounded-lg font-bold text-xs transition-all duration-300"
                        :class="docLinkClass(doc)"
                        @click.prevent="openDoc(doc)"
                      >
                        <ArtSvgIcon icon="ri:article-line" class="text-sm" />
                        <span class="truncate">{{ doc.title }}</span>
                      </a>
                    </li>
                  </ul>
                </li>
              </ul>
            </template>
            <template v-else>
              <a
                href="#"
                class="flex items-center gap-2 px-3 py-2 rounded-lg font-bold text-xs transition-all duration-300"
                :class="getCategoryClass(group)"
                @click.prevent="toggleCategory(group)"
              >
                <ArtSvgIcon :icon="group.icon || 'ri:folder-line'" class="text-sm" />
                <span class="truncate">{{ group.title }}</span>
              </a>
              <ul v-if="expandedCategoryId === group.id && getDocsByCategory(group.id).length > 1" class="ml-4 mt-0.5 space-y-0.5">
                <li v-for="doc in getDocsByCategory(group.id)" :key="'doc-' + doc.id">
                  <a
                    href="#"
                    class="flex items-center gap-2 px-3 py-1.5 rounded-lg font-bold text-xs transition-all duration-300"
                    :class="docLinkClass(doc)"
                    @click.prevent="openDoc(doc)"
                  >
                    <ArtSvgIcon icon="ri:article-line" class="text-sm" />
                    <span class="truncate">{{ doc.title }}</span>
                  </a>
                </li>
              </ul>
            </template>
          </div>

          <div v-if="loadingCategories" class="text-center py-8 text-clay-muted text-xs">加载中...</div>
          <div v-if="!loadingCategories && categories.length === 0" class="text-center py-8 text-clay-muted text-xs">暂无文档分类</div>
        </div>
      </aside>

      <!-- Main content area -->
      <article class="flex-1 min-w-0">
        <div v-if="loadingDoc" class="bg-white/60 backdrop-blur-lg rounded-[24px] shadow-clay-card border border-[#d1d9e6]/40 p-10 text-center">
          <div class="inline-flex items-center gap-2 text-clay-muted text-sm font-bold">
            <ArtSvgIcon icon="ri:loader-4-line" class="text-lg animate-spin" />
            加载中...
          </div>
        </div>

        <div v-else-if="!currentDoc" class="bg-white/60 backdrop-blur-lg rounded-[24px] shadow-clay-card border border-[#d1d9e6]/40 p-16 text-center">
          <ArtSvgIcon icon="ri:file-text-line" class="text-5xl text-clay-muted mb-4 mx-auto" />
          <p class="text-clay-muted text-sm font-bold">请从左侧选择一篇文档</p>
        </div>

        <div v-else class="bg-white/60 backdrop-blur-lg rounded-[24px] shadow-clay-card border border-[#d1d9e6]/40 p-8 lg:p-10">
          <header class="mb-8 pb-6 border-b border-[#d1d9e6]/40">
            <h1 class="font-heading font-black text-2xl lg:text-3xl text-clay-foreground mb-3 leading-tight">{{ currentDoc.title }}</h1>
            <div class="flex flex-wrap items-center gap-4 text-xs font-bold text-clay-muted">
              <span v-if="currentDoc.author" class="flex items-center gap-1">
                <ArtSvgIcon icon="ri:user-3-line" class="text-sm" />
                {{ currentDoc.author }}
              </span>
              <span v-if="currentDoc.updatedAt" class="flex items-center gap-1">
                <ArtSvgIcon icon="ri:time-line" class="text-sm" />
                {{ formatTimestamp(currentDoc.updatedAt, 'date') }}
              </span>
              <span v-if="currentDoc.views" class="flex items-center gap-1">
                <ArtSvgIcon icon="ri:eye-line" class="text-sm" />
                {{ currentDoc.views }} 次阅读
              </span>
            </div>
            <p v-if="currentDoc.summary" class="mt-4 text-sm text-clay-muted leading-relaxed">{{ currentDoc.summary }}</p>
          </header>

          <div class="doc-markdown-body">
            <MdPreview
              :model-value="currentDoc.content || ''"
              :editor-id="previewId"
              preview-theme="github"
              code-theme="atom"
              :noMermaid="true"
              :noKatex="true"
            />
          </div>
        </div>
      </article>

      <!-- Right TOC sidebar -->
      <aside v-if="currentDoc" class="hidden xl:flex flex-col w-48 flex-shrink-0 sticky top-[88px] self-start max-h-[calc(100vh-100px)] overflow-y-auto sidebar-scroll">
        <div class="bg-white/60 backdrop-blur-lg rounded-[24px] shadow-clay-card border border-[#d1d9e6]/40 p-4">
          <h4 class="text-[10px] font-black text-clay-muted uppercase tracking-[0.1em] mb-3 px-2">本章目录</h4>
          <MdCatalog
            :key="activeDocSlug"
            :editor-id="previewId"
            :scroll-element="scrollElement"
            class="doc-toc"
          />
        </div>
      </aside>
    </div>

    <!-- ==================== 全局搜索弹窗 ==================== -->
    <Teleport to="body">
      <Transition name="search-fade">
        <div v-if="searchVisible" class="search-overlay" @mousedown.self="closeSearch">
          <div class="search-dialog">
            <!-- 搜索输入 -->
            <div class="search-header">
              <ArtSvgIcon icon="ri:search-line" class="text-lg text-clay-muted flex-shrink-0" />
              <input
                ref="searchInputRef"
                v-model="searchKeyword"
                type="text"
                placeholder="搜索文档标题和内容..."
                class="flex-1 bg-transparent outline-none text-sm text-clay-foreground font-medium placeholder:text-clay-muted"
                @keydown.down.prevent="moveActive(1)"
                @keydown.up.prevent="moveActive(-1)"
                @keydown.enter.prevent="selectActive"
                @keydown.esc.prevent="closeSearch"
              />
              <kbd class="px-1.5 py-0.5 rounded bg-[#f0f3f8] border border-[#d1d9e6]/50 text-[10px] font-bold text-clay-muted">ESC</kbd>
            </div>

            <!-- 搜索结果 -->
            <div class="search-body" ref="searchBodyRef">
              <div v-if="!searchKeyword.trim()" class="search-tip">
                <ArtSvgIcon icon="ri:lightbulb-line" class="text-2xl text-clay-muted mb-2" />
                <p class="text-xs text-clay-muted">输入关键词搜索文档标题和内容</p>
              </div>

              <div v-else-if="searchLoading" class="search-tip">
                <ArtSvgIcon icon="ri:loader-4-line" class="text-2xl text-clay-muted animate-spin mb-2" />
                <p class="text-xs text-clay-muted">搜索中...</p>
              </div>

              <div v-else-if="searchResults.length === 0" class="search-tip">
                <ArtSvgIcon icon="ri:file-search-line" class="text-2xl text-clay-muted mb-2" />
                <p class="text-xs text-clay-muted">未找到「{{ searchKeyword.trim() }}」相关文档</p>
              </div>

              <ul v-else class="search-results">
                <li
                  v-for="(item, idx) in searchResults"
                  :key="item.id"
                  :class="{ 'is-active': activeIndex === idx }"
                  class="search-result-item"
                  @mouseenter="activeIndex = idx"
                  @click="selectResult(item)"
                >
                  <ArtSvgIcon icon="ri:hashtag" class="text-sm text-blue-400 flex-shrink-0 mt-0.5" />
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-bold text-clay-foreground truncate" v-html="highlightKeyword(item.title)"></p>
                    <p class="text-[11px] text-clay-muted mt-0.5 truncate">
                      {{ item.categoryName }}
                      <span v-if="item.matchType === 'content'" class="ml-1 text-blue-400">· 内容匹配</span>
                    </p>
                  </div>
                  <ArtSvgIcon icon="ri:arrow-right-s-line" class="text-sm text-clay-muted flex-shrink-0" />
                </li>
              </ul>
            </div>

            <!-- 底部提示 -->
            <div class="search-footer">
              <span class="flex items-center gap-1 text-[10px] text-clay-muted">
                <kbd class="search-kbd">↑</kbd>
                <kbd class="search-kbd">↓</kbd>
                导航
              </span>
              <span class="flex items-center gap-1 text-[10px] text-clay-muted">
                <kbd class="search-kbd">↵</kbd>
                选择
              </span>
              <span class="flex items-center gap-1 text-[10px] text-clay-muted">
                <kbd class="search-kbd">esc</kbd>
                关闭
              </span>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>
  </main>
</template>

<script setup lang="ts">
import { ref, watch, nextTick, onMounted, onUnmounted } from 'vue'
import { MdPreview, MdCatalog } from 'md-editor-v3'
import 'md-editor-v3/lib/preview.css'
import { fetchDocCategoryTree, fetchDocListByCategory, fetchDocDetailBySlug, fetchDocSearch } from '@/api/frontend/doc'
import { formatTimestamp } from '@/utils/time'

defineOptions({ name: 'FrontendDocs' })

const previewId = 'doc-preview'
const scrollElement = document.documentElement

// --- state ---
const categories = ref<any[]>([])
const docsByCategory = ref<Record<number, any[]>>({})
const loadingCategories = ref(false)
const loadingDoc = ref(false)
const activeDocId = ref<number>()
const activeDocSlug = ref('')
const currentDoc = ref<any>(null)
const expandedCategoryId = ref<number>()

// --- 搜索弹窗 ---
const searchVisible = ref(false)
const searchKeyword = ref('')
const searchResults = ref<any[]>([])
const searchLoading = ref(false)
const activeIndex = ref(0)
const searchInputRef = ref<HTMLInputElement>()
const searchBodyRef = ref<HTMLDivElement>()
let searchTimer: ReturnType<typeof setTimeout> | null = null

function openSearch() {
  searchVisible.value = true
  searchKeyword.value = ''
  searchResults.value = []
  activeIndex.value = 0
  nextTick(() => searchInputRef.value?.focus())
}

function closeSearch() {
  searchVisible.value = false
  searchKeyword.value = ''
}

function moveActive(delta: number) {
  if (searchResults.value.length === 0) return
  activeIndex.value = (activeIndex.value + delta + searchResults.value.length) % searchResults.value.length
  nextTick(() => {
    const el = searchBodyRef.value?.querySelector('.is-active') as HTMLElement
    el?.scrollIntoView({ block: 'nearest' })
  })
}

function selectActive() {
  const item = searchResults.value[activeIndex.value]
  if (item) selectResult(item)
}

function selectResult(item: any) {
  closeSearch()
  loadDoc(item.slug)
}

function highlightKeyword(text: string): string {
  const kw = searchKeyword.value.trim()
  if (!kw) return text
  const escaped = kw.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
  return text.replace(new RegExp(`(${escaped})`, 'gi'), '<mark class="search-highlight">$1</mark>')
}

watch(searchKeyword, (kw) => {
  if (searchTimer) clearTimeout(searchTimer)
  const trimmed = kw.trim()
  if (!trimmed) {
    searchResults.value = []
    searchLoading.value = false
    activeIndex.value = 0
    return
  }
  searchLoading.value = true
  searchTimer = setTimeout(async () => {
    try {
      searchResults.value = await fetchDocSearch(trimmed)
      activeIndex.value = 0
    } catch (e) {
      console.error('搜索失败', e)
      searchResults.value = []
    } finally {
      searchLoading.value = false
    }
  }, 300)
})

function handleGlobalKeydown(e: KeyboardEvent) {
  if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
    e.preventDefault()
    searchVisible.value ? closeSearch() : openSearch()
  }
}

onMounted(() => document.addEventListener('keydown', handleGlobalKeydown))
onUnmounted(() => {
  document.removeEventListener('keydown', handleGlobalKeydown)
  if (searchTimer) clearTimeout(searchTimer)
})

// --- 分类导航 ---
function collectCategoryIds(tree: any[]): number[] {
  const ids: number[] = []
  const walk = (nodes: any[]) => {
    for (const node of nodes || []) {
      if (node?.id) ids.push(node.id)
      if (node.children?.length) walk(node.children)
    }
  }
  walk(tree)
  return ids
}

function getDocsByCategory(categoryId: number) {
  return docsByCategory.value[categoryId] || []
}

function docLinkClass(doc: any) {
  return activeDocSlug.value === doc.slug
    ? 'bg-gradient-to-br from-blue-400 to-blue-600 text-white shadow-clay-btn'
    : 'text-clay-foreground hover:bg-white hover:shadow-clay-card'
}

function getCategoryClass(child: any) {
  const docs = getDocsByCategory(child.id)
  const isSingle = docs.length <= 1
  const isActive = expandedCategoryId.value === child.id

  if (isSingle && isActive && docs[0]?.slug && activeDocSlug.value === docs[0].slug) {
    return 'bg-gradient-to-br from-blue-400 to-blue-600 text-white shadow-clay-btn'
  }
  if (isActive) return 'bg-blue-50 text-blue-600'
  return 'text-clay-foreground hover:bg-white hover:shadow-clay-card'
}

function openDoc(doc: any) {
  if (!doc?.slug) return
  loadDoc(doc.slug)
}

function toggleCategory(child: any) {
  const docs = docsByCategory.value[child.id] || []
  if (docs.length <= 1) {
    expandedCategoryId.value = child.id
    if (docs[0]?.slug) openDoc(docs[0])
    return
  }
  if (expandedCategoryId.value === child.id) {
    expandedCategoryId.value = undefined
    return
  }
  expandedCategoryId.value = child.id
}

async function loadDoc(slug: string) {
  if (!slug) return
  if (activeDocSlug.value === slug && currentDoc.value) return
  activeDocSlug.value = slug
  loadingDoc.value = true
  try {
    const detail = await fetchDocDetailBySlug(slug)
    currentDoc.value = detail
    activeDocId.value = detail?.id
    window.scrollTo({ top: 0, behavior: 'smooth' })
  } catch (e) {
    console.error('加载文档失败', e)
    currentDoc.value = null
  } finally {
    loadingDoc.value = false
  }
}

async function loadCategories() {
  loadingCategories.value = true
  try {
    const tree = await fetchDocCategoryTree()
    categories.value = tree
    const categoryIds = collectCategoryIds(tree)
    const results = await Promise.all(categoryIds.map((id: number) => fetchDocListByCategory(id)))
    categoryIds.forEach((id: number, idx: number) => {
      docsByCategory.value[id] = results[idx] || []
    })
    for (const id of categoryIds) {
      const docs = docsByCategory.value[id] || []
      if (docs[0]?.slug) {
        expandedCategoryId.value = id
        openDoc(docs[0])
        return
      }
    }
  } catch (e) {
    console.error('加载分类失败', e)
  } finally {
    loadingCategories.value = false
  }
}

onMounted(() => {
  loadCategories()
})
</script>

<style lang="scss" scoped>
.text-clay-foreground { color: #32325d; }
.text-clay-muted { color: #8898aa; }
.font-heading { font-family: 'Nunito', 'PingFang SC', sans-serif; }

.shadow-clay-card {
  box-shadow: 16px 16px 32px rgba(165, 175, 190, 0.3), -10px -10px 24px rgba(255, 255, 255, 0.9),
    inset 6px 6px 12px rgba(90, 141, 238, 0.03), inset -6px -6px 12px rgba(255, 255, 255, 1);
}
.shadow-clay-btn {
  box-shadow: 12px 12px 24px rgba(90, 141, 238, 0.3), -8px -8px 16px rgba(255, 255, 255, 0.4),
    inset 4px 4px 8px rgba(255, 255, 255, 0.4), inset -4px -4px 8px rgba(0, 0, 0, 0.05);
}
.shadow-clay-pressed {
  box-shadow: inset 10px 10px 20px #e0e5ec, inset -10px -10px 20px #ffffff;
}

.sidebar-scroll {
  scrollbar-width: thin;
  scrollbar-color: transparent transparent;
  transition: scrollbar-color 0.3s;

  &:hover { scrollbar-color: rgba(165, 175, 190, 0.35) transparent; }
  &::-webkit-scrollbar { width: 4px; }
  &::-webkit-scrollbar-track { background: transparent; }
  &::-webkit-scrollbar-thumb {
    background: transparent;
    border-radius: 99px;
  }
  &:hover::-webkit-scrollbar-thumb { background: rgba(165, 175, 190, 0.4); }
  &::-webkit-scrollbar-thumb:hover { background: rgba(130, 145, 165, 0.5); }
}

/* ===== Markdown 内容样式 ===== */
.doc-markdown-body {
  max-width: 100%;
  overflow: hidden;
  word-break: break-word;

  :deep(.md-editor) { background: transparent; }
  :deep(.md-editor-preview-wrapper) { padding: 0; max-width: 100%; overflow: hidden; }
  :deep(.md-editor-preview) {
    font-size: 15px;
    line-height: 1.8;
    color: #32325d;
    max-width: 100%;
    overflow-wrap: break-word;
    word-break: break-word;

    h1, h2, h3, h4, h5, h6 {
      font-family: 'Nunito', 'PingFang SC', sans-serif;
      font-weight: 800;
      color: #32325d;
      margin-top: 1.5em;
      margin-bottom: 0.5em;
    }
    h1 { font-size: 1.75em; }
    h2 { font-size: 1.4em; padding-bottom: 0.3em; border-bottom: 2px solid #eef2f7; }
    h3 { font-size: 1.15em; }
    p { max-width: 75ch; }
    ul, ol { max-width: 75ch; }
    a { color: #5a8dee; text-decoration: none; &:hover { text-decoration: underline; } }
    code:not([class*="language-"]) {
      background: #f0f3f8;
      padding: 2px 6px;
      border-radius: 6px;
      font-size: 0.9em;
      color: #e74c3c;
    }
    pre { border-radius: 12px; overflow-x: auto; max-width: 100%; }
    blockquote {
      border-left: 4px solid #5a8dee;
      background: #f8faff;
      padding: 12px 16px;
      border-radius: 0 12px 12px 0;
      color: #8898aa;
      max-width: 75ch;
    }
    table {
      border-collapse: collapse;
      width: 100%;
      max-width: 100%;
      overflow-x: auto;
      display: block;
      th, td { border: 1px solid #eef2f7; padding: 8px 12px; }
      th { background: #f8faff; font-weight: 700; }
    }
    img { border-radius: 12px; max-width: 100%; }
  }
}

/* ===== TOC 样式 ===== */
.doc-toc {
  :deep(.md-editor-catalog-link) {
    font-size: 12px;
    font-weight: 600;
    color: #8898aa;
    padding: 4px 8px;
    border-radius: 8px;
    transition: all 0.2s;
    border-left: 2px solid transparent;
    &:hover { color: #5a8dee; background: rgba(90, 141, 238, 0.05); }
    &.md-editor-catalog-active {
      color: #5a8dee;
      background: rgba(90, 141, 238, 0.08);
      border-left-color: #5a8dee;
    }
  }
}

/* ===== 搜索弹窗 ===== */
.search-overlay {
  position: fixed;
  inset: 0;
  z-index: 9999;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding-top: 12vh;
  background: rgba(50, 50, 93, 0.35);
  backdrop-filter: blur(4px);
}

.search-dialog {
  width: 100%;
  max-width: 620px;
  margin: 0 16px;
  background: white;
  border-radius: 20px;
  box-shadow:
    0 25px 60px rgba(50, 50, 93, 0.25),
    0 10px 20px rgba(0, 0, 0, 0.1),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.search-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  border-bottom: 1px solid #eef2f7;
}

.search-body {
  max-height: 420px;
  overflow-y: auto;
  scrollbar-width: thin;
  scrollbar-color: rgba(165, 175, 190, 0.3) transparent;
}

.search-tip {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 48px 20px;
}

.search-results {
  padding: 8px;
  list-style: none;
  margin: 0;
}

.search-result-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 10px 14px;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.15s;

  &:hover, &.is-active {
    background: #f0f4ff;
  }

  &.is-active {
    box-shadow: inset 0 0 0 1.5px rgba(90, 141, 238, 0.3);
  }
}

.search-footer {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 10px 20px;
  border-top: 1px solid #eef2f7;
  background: #fafbfd;
}

.search-kbd {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 20px;
  height: 18px;
  padding: 0 4px;
  border-radius: 4px;
  background: white;
  border: 1px solid #d1d9e6;
  font-size: 10px;
  font-weight: 700;
  color: #8898aa;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.06);
}

:deep(.search-highlight) {
  background: rgba(90, 141, 238, 0.15);
  color: #3b6cdb;
  padding: 1px 2px;
  border-radius: 3px;
  font-weight: 800;
}

/* ===== 搜索弹窗动画 ===== */
.search-fade-enter-active {
  transition: opacity 0.2s ease;
  .search-dialog { transition: transform 0.2s ease, opacity 0.2s ease; }
}
.search-fade-leave-active {
  transition: opacity 0.15s ease;
  .search-dialog { transition: transform 0.15s ease, opacity 0.15s ease; }
}
.search-fade-enter-from {
  opacity: 0;
  .search-dialog { transform: scale(0.96) translateY(-8px); opacity: 0; }
}
.search-fade-leave-to {
  opacity: 0;
  .search-dialog { transform: scale(0.96) translateY(-8px); opacity: 0; }
}
</style>
