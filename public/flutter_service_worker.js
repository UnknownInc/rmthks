'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/index.html": "1e2980ef09118f24384a7ecf23427758",
"/main.dart.js": "a94eee84741ec92db7d0c7db3ac89eeb",
"/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/manifest.json": "6fa600aacec255f6c1f3f2661697f8ec",
"/assets/LICENSE": "2ba06e68fbaf980fdcf64d5fa09d7fe0",
"/assets/AssetManifest.json": "b2bfc800a2bd301d92e3d778793391ed",
"/assets/FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/assets/images/loading.gif": "d71d8ccb7264fb1ca4a4ec9a871849d1",
"/assets/assets/images/children_line.png": "e09551737ab45cc64081212892e744a9",
"/assets/assets/images/logo1.jpg": "8d6eb72db9e222c97f2cec8399eb066c",
"/assets/assets/images/logo2.jpg": "050b3edd98b670dda8898e8c0b230c79",
"/assets/assets/images/red_ribbon.png": "c7b7740e0115639dbf582bf1ad80ce94",
"/assets/assets/images/fidget-spinner-loading.gif": "9b54dbe80bed2ddbb8788c3f421b0973",
"/assets/assets/images/red_ribbon.svg": "1bddffde206cb82eb6ff32718ffe6fc5",
"/assets/assets/images/bgdoodles.jpeg": "fd2a09ac520c8c69b340cdee01a6048c"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
