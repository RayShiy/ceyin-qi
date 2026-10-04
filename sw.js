/* 音高检测与对比器 · Service Worker（离线优先 / PWA）
 * 策略：缓存优先（Cache First）→ 首访后所有资源本地直取，秒开、断网可用。
 * 更新：后台静默拉取新版并写入缓存，下次打开即为新版。
 */
const VERSION = 'pitch-v7';
const CACHE = VERSION;
const ASSETS = [
  './',
  './index.html',
  './diagnose.html',
  './404.html',
  './manifest.webmanifest',
  './icons/icon-192.png',
  './icons/icon-512.png'
];

// 安装：全量预缓存（任一失败不阻塞）
self.addEventListener('install', (e) => {
  self.skipWaiting();
  e.waitUntil(
    caches.open(CACHE).then((c) =>
      Promise.all(ASSETS.map((u) => c.add(u).catch(() => null)))
    )
  );
});

// 激活：清理旧版本缓存并立即接管
self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

// 请求：缓存优先，命中即返回；未命中回退网络并写入缓存；网络失败回退首页
self.addEventListener('fetch', (e) => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return; // 仅接管同源

  e.respondWith(
    caches.match(req, { ignoreSearch: true }).then((cached) => {
      if (cached) {
        // 后台静默更新（stale-while-revalidate）
        fetch(req).then((res) => {
          if (res && res.ok) caches.open(CACHE).then((c) => c.put(req, res.clone())).catch(() => {});
        }).catch(() => {});
        return cached;
      }
      return fetch(req).then((res) => {
        if (res && res.ok) {
          const copy = res.clone();
          caches.open(CACHE).then((c) => { try { c.put(req, copy); } catch (err) {} });
        }
        return res;
      }).catch(() =>
        (req.mode === 'navigate' || (req.headers.get('accept') || '').includes('text/html'))
          ? caches.match('./index.html')
          : Response.error()
      );
    })
  );
});
