import type { MemberMenuItem } from '@/api/frontend/member/user'

export function normalizeSitePath(pathOrName: string, name: string): string {
  const raw = (pathOrName || '').trim() || (name || '').trim()
  if (!raw) return '/'
  if (/^https?:\/\//i.test(raw) || raw.startsWith('//')) return raw
  return raw.startsWith('/') ? raw : `/${raw}`
}

export function memberMenuHref(m: MemberMenuItem): { url: string; isExternal: boolean } {
  if (m.menuType === 'iframe') {
    const u = (m.url || '').trim()
    return { url: u || '#', isExternal: true }
  }
  const isLink = m.menuType === 'link'
  const rawLink = (m.url || '').trim()
  if (isLink) {
    if (/^https?:\/\//i.test(rawLink) || rawLink.startsWith('//')) {
      return { url: rawLink, isExternal: true }
    }
    const url = normalizeSitePath(rawLink, m.name)
    return { url, isExternal: false }
  }
  const url = normalizeSitePath(m.path, m.name)
  return { url, isExternal: false }
}
