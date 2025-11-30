const CACHE_NAME = 'manpro-pwa-cache-v1';

// Core files and key assets to make the app shell and images available offline.
const OFFLINE_URLS = [
  'index.html',
  'manifest.json',
  'favicon.png',
  'flutter_bootstrap.js',
  'flutter.js',
  'main.dart.js',
  'canvaskit/canvaskit.js',
  'canvaskit/canvaskit.wasm',
  'assets/AssetManifest.json',
  'assets/AssetManifest.bin',
  'assets/AssetManifest.bin.json',
  'assets/FontManifest.json',
  'assets/NOTICES',
  'icons/Icon-192.png',
  'icons/Icon-512.png',
  'icons/Icon-maskable-192.png',
  'icons/Icon-maskable-512.png',
  'assets/assets/images/background.jpg',
  'assets/assets/images/event1.jpg',
  'assets/assets/images/event2.jpg',
  'assets/assets/images/event3.jpg',
  'assets/assets/icons/garis tiga.jpg',
  'assets/assets/icons/garis%20tiga.jpg'
];

self.addEventListener('install', (event) => {
  self.skipWaiting();
  event.waitUntil((async () => {
    const cache = await caches.open(CACHE_NAME);
    for (const url of OFFLINE_URLS) {
      try {
        await cache.add(url);
      } catch (error) {
        // Ignore individual failures so one missing file doesn't block install.
      }
    }
  })());
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys
          .filter((key) => key !== CACHE_NAME)
          .map((key) => caches.delete(key))
      )
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const { request } = event;

  if (request.method !== 'GET') {
    return;
  }

  const url = new URL(request.url);

  // Only handle same-origin requests.
  if (url.origin !== self.location.origin) {
    return;
  }

  const isHtmlNavigation =
    request.mode === 'navigate' ||
    (request.headers.get('accept') || '').includes('text/html');

  const isAssetRequest = url.pathname.includes('/assets/');
  const isImageRequest = /\.(png|jpg|jpeg|gif|webp|svg)$/i.test(url.pathname);

  if (isHtmlNavigation) {
    event.respondWith(handleNavigation(request));
    return;
  }

  if (isAssetRequest || isImageRequest) {
    event.respondWith(cacheFirst(request));
    return;
  }

  event.respondWith(staleWhileRevalidate(request));
});

async function handleNavigation(request) {
  const cache = await caches.open(CACHE_NAME);
  const cached =
    (await cache.match(request)) ||
    (await cache.match('index.html')) ||
    (await cache.match('/'));

  try {
    const networkResponse = await fetch(request);
    cache.put(request, networkResponse.clone());
    return networkResponse;
  } catch (error) {
    if (cached) {
      return cached;
    }
    return new Response('Offline', { status: 503, statusText: 'Offline' });
  }
}

async function cacheFirst(request) {
  const cache = await caches.open(CACHE_NAME);
  const cached = await cache.match(request);
  if (cached) {
    return cached;
  }
  try {
    const response = await fetch(request);
    cache.put(request, response.clone());
    return response;
  } catch (error) {
    return cached || new Response('Offline', { status: 503, statusText: 'Offline' });
  }
}

async function staleWhileRevalidate(request) {
  const cache = await caches.open(CACHE_NAME);
  const cached = await cache.match(request);

  const networkPromise = fetch(request)
    .then((response) => {
      cache.put(request, response.clone());
      return response;
    })
    .catch(() => undefined);

  if (cached) {
    return cached;
  }

  const networkResponse = await networkPromise;
  if (networkResponse) {
    return networkResponse;
  }

  return new Response('Offline', { status: 503, statusText: 'Offline' });
}
