'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "473ed1a4ec18f12ea8566caef972d903",
"assets/AssetManifest.bin.json": "c7e6ddfa93382fd7f2e7b31d46a11957",
"assets/AssetManifest.json": "d22c451537028340057872a094ac466f",
"assets/assets/fonts/MAIAN.TTF": "0141df8c3436a6c3eb8be69855e1ec0d",
"assets/assets/images/1200-L-f1-le-verdict-implacable-des-essais-2026-bahren-deux-curies-en-patrons.jpg": "24b2e75b87ee0a19ec201eeb77a31634",
"assets/assets/images/2025racingbullslialaw01right.avif": "d27cad57ad594a97df098eb90881a6e7",
"assets/assets/images/albon.png": "19d9837f96f410865468b56d60d4f03f",
"assets/assets/images/albon_full.png": "d1f107393e8a83dc69e0b13c1ac7a798",
"assets/assets/images/alpine_logo.png": "7c7216d40bec3ef150332270b4e2c83d",
"assets/assets/images/alp_car.png": "238a57cd3f6821af6729cd92d184d038",
"assets/assets/images/antonelli.png": "723221750e6f38bb279c6dbc2094efbb",
"assets/assets/images/antonelli_full.png": "ab89e6631f6510849cd1205fd3b2430b",
"assets/assets/images/aston-martin.png": "bf0184796db453e8b9797ade69006a9c",
"assets/assets/images/aston_logo.png": "d7416fda318479752ac97fc2389ba5c4",
"assets/assets/images/ast_car.png": "0c04084184ea8e599c84359fb0fd9778",
"assets/assets/images/audi_logo.png": "e4948f8b7212078b0537bbe61f665faf",
"assets/assets/images/aud_car.png": "14580a01e25fdcf4751781a4f64d2bad",
"assets/assets/images/Bahrein.jpg": "c43f029b0198d07255a9d25479564a59",
"assets/assets/images/bearman.png": "2abf18ae686f67bc92e22f69c4803079",
"assets/assets/images/bearman_full.png": "7c5c84a01bfa78d2b3f5b3aef622c5f2",
"assets/assets/images/bortoleto.png": "051357b97edb7c06538e27878443a8af",
"assets/assets/images/bortoleto_full.png": "3245c256091349f44fddfa44f8456061",
"assets/assets/images/bottas.png": "398cc35e03ac6dfa965facaff4d3cd9f",
"assets/assets/images/bottas_full.png": "97684676707ac2bef7497c454c339779",
"assets/assets/images/cadillac_logo.png": "cc89f3718929f470fd2d753ba217918f",
"assets/assets/images/cad_car.png": "e4c735a8a2b10be2bf2298e026a29976",
"assets/assets/images/carlos-sainz-williams.png": "a6c3e83a7c431216f8566530844ddb60",
"assets/assets/images/carlos-sainz.png": "57a30c1b8f3f43dddbc34c17f8fbfec5",
"assets/assets/images/charles.png": "37f351e5b085fe5bdadf1fe1c6bf2fe3",
"assets/assets/images/charles16.png": "0ebd8674359c710f363a5d2b2d68d07d",
"assets/assets/images/circuits/bakou.png": "71e185177bb32139dcd6678b2278d433",
"assets/assets/images/circuits/barcelone.jpg": "5b0c188da42d19d036192d4d840a3243",
"assets/assets/images/circuits/canada.png": "0d31f88d32fc1857b05e6adaf68bef9c",
"assets/assets/images/circuits/hongrie.png": "fe56e4573ce4e53e96ffd2497bab1f39",
"assets/assets/images/circuits/imola.png": "8fab46a23138ed6d801e3aef48e06a79",
"assets/assets/images/circuits/melbourne.png": "99783c1c352a4cf772ac5dc16ea7ed29",
"assets/assets/images/circuits/monaco.png": "ee438d520ae19d749238f6364bfdff87",
"assets/assets/images/circuits/singapour.png": "16409bf05303ce07ee5093905a5ebacd",
"assets/assets/images/circuits/spa.png": "c10b9a748ebd269e5717002e8fa3be66",
"assets/assets/images/default_avatar.png": "3700770c0fa284b878ef34704e445f4b",
"assets/assets/images/essaie.jpg": "116610900651f85cf563ff4513e4c8ed",
"assets/assets/images/f1_line.jpg": "36c04cf328276591705d13a8dbe6994f",
"assets/assets/images/fernando.png": "f11d488efbf9cd0ae278cafcdd649c81",
"assets/assets/images/fernando_full.png": "a0822f770130cd6d28c683e267fc0822",
"assets/assets/images/franco.png": "67fa8f28f056183cdde2ea63aeb9ad9b",
"assets/assets/images/franco_full.png": "092ccae4bd16dbcbcf552663849de943",
"assets/assets/images/gasly.png": "dce90bf71e949cf355f80376e4b92cf5",
"assets/assets/images/gasly_full.png": "7c72048cdc8d35654d56a7840b864986",
"assets/assets/images/haas_logo.png": "3754437082dfe3622b5ea1021c147f6e",
"assets/assets/images/haa_car.png": "bb4b8e3cb156887192f0c99a1ba65383",
"assets/assets/images/hamilton.png": "cb1ca417eefe5a6c17d7e6e74a4d424f",
"assets/assets/images/hamilton_full.png": "bfba75a1e7b8134cc85836e393688a82",
"assets/assets/images/hulkenberg.png": "aa3c282d06daedda5c1cc7495cbbb7da",
"assets/assets/images/hulkenberg_full.png": "1c33325c8dda05390068edc95b0bc725",
"assets/assets/images/isack-hadjar-red-bull-racing-3.png": "8e9f205ff69283323aca80976ff89d77",
"assets/assets/images/isack-hadjar.png": "95b547f92e0511cbdeb70a26b1001705",
"assets/assets/images/IsackHadjar.png": "715790131a88ddfba9cf32fac5b42a9b",
"assets/assets/images/lance.png": "76541b8b8a77d5c9c0f9bfb51bd35a49",
"assets/assets/images/lance_full.png": "8f8100ac6834c1a1d238f69ce31013f8",
"assets/assets/images/lando-norris-mclaren-3.jpg": "5a16242130479a164835d8c3985d7530",
"assets/assets/images/lando.png": "ce60aa596117f91c87a156015d31542a",
"assets/assets/images/lawson.png": "41edd61247c26b451c3a8f44e05b7264",
"assets/assets/images/lawson_full.png": "56c98349618f398b41c45f04db9e4c02",
"assets/assets/images/leclerc_verstappen.jpg": "81f820d09603dc2bf2dfd6eb8c9b3894",
"assets/assets/images/lindblad.png": "3035a890f9fac3f14659b60edc8d6df9",
"assets/assets/images/lindblad_full.png": "be831341934e60f203bc2dff1de768c0",
"assets/assets/images/ln1.png": "03e59884f36a9f2fd4d1d63f16d8685d",
"assets/assets/images/logo_mercedes.avif": "2076dc46fd121c66561765ddc1023718",
"assets/assets/images/max-verstappen.png": "24e88444dce3ce2bead9154347cb6455",
"assets/assets/images/max.png": "4495fa926d63d9ef045900de4080fa7c",
"assets/assets/images/mcl_car.png": "418b5a99ab5e15a503951e5fb84f6d23",
"assets/assets/images/mcl_logo.png": "33a3513f37ba28606743382cfff9b1fd",
"assets/assets/images/mer_car.png": "fb8f68f64d3c73989ec2c2e3d52a8289",
"assets/assets/images/mer_logo.png": "6229883ed0599a3e85c201ff01f4da6b",
"assets/assets/images/ocon.png": "a1074276c48def5ed7dd55432ddf6cae",
"assets/assets/images/ocon_full.png": "f8acaedd26ef71bb39523346276c9b84",
"assets/assets/images/op81.png": "21fc1e52c6b3cd752fbcd1b69fd6a92e",
"assets/assets/images/perez.png": "2cc693e69446c984bb4e54a116e0d6ab",
"assets/assets/images/perez_full.png": "3fc4c36895ed25b750e9f246de7bbb23",
"assets/assets/images/piastri.png": "04085cac5930b24d92e6feb235a0eb31",
"assets/assets/images/pneu/hard.png": "707a5378bf262eecda3a1fbd74234c53",
"assets/assets/images/pneu/medium.png": "a95572694dc33c55f8e1eab014ce8e2d",
"assets/assets/images/pneu/soft.png": "211d0a2b1a60c435ae720ca86cb0f8c8",
"assets/assets/images/rb_car.png": "16fdf9191760c958f4c02eccd935491d",
"assets/assets/images/rb_logo.png": "758969395aced02f29105a9f4392fe85",
"assets/assets/images/russell.png": "663655da74e32d366695cc12d9e747df",
"assets/assets/images/russell_full.png": "2b2d12a419e6b4ce72956efe46f27ba9",
"assets/assets/images/ryo-hirakawa-alpine.png": "114bd25bcf19cdf779916eac2e6fb6d1",
"assets/assets/images/sainz.png": "51ad59abd47094da2900723e034d55f0",
"assets/assets/images/sainz_full.png": "3c0aa3d194026d688a4acc6f40056a8a",
"assets/assets/images/sf-26.jpg": "e8940f86157c70d1123136a4bb1e1251",
"assets/assets/images/sf.jpg": "cfcb4714ab9b5826676b9ca5346c3547",
"assets/assets/images/sf_logo.png": "b8147df80d33011881fc0bd5c8b3b3a6",
"assets/assets/images/tracks/abu-dhabi.jpg": "04935cb3757dcbdb481d9ac7d71d55f7",
"assets/assets/images/tracks/austin.jpg": "9ab51ac202fd3da49adadaf13cf5979a",
"assets/assets/images/tracks/bakou.jpg": "300ed323eb3d027535ce3acd2385e16d",
"assets/assets/images/tracks/barcelone.jpg": "504ec640426ea7ed33bc39f864f40040",
"assets/assets/images/tracks/brazil.jpg": "1e89622a27237cd1669885288e87bcd8",
"assets/assets/images/tracks/budapest.jpg": "4947c8bfb8b934b9c4374f0576ac8a76",
"assets/assets/images/tracks/doha.jpg": "3ca4c0f81b986142d19a0e72fbe958a5",
"assets/assets/images/tracks/imola.jpg": "58e43ca860a38bcef0bfbb16eb8ab668",
"assets/assets/images/tracks/jeddah.jpg": "21c59e9a682d21fc948a7e6576aab525",
"assets/assets/images/tracks/las-vegas.jpg": "0f520de00facad06c781d3e83d25e949",
"assets/assets/images/tracks/madrid.png": "a72f0a118c8e8ed5f946d8143cbd64b4",
"assets/assets/images/tracks/manama.jpg": "188a5eefbebe4abd00e14500a428a853",
"assets/assets/images/tracks/melbourne.jpg": "89af7a02152713b9ddd50319c65496ec",
"assets/assets/images/tracks/mexico.jpg": "c21f306261fed089b66c63698ddd0ce4",
"assets/assets/images/tracks/miami.jpg": "3511cb0ecaee9d345fb0f9bffd6fb270",
"assets/assets/images/tracks/monaco.png": "5d1b2f4b894787431fd303383e4e301f",
"assets/assets/images/tracks/montreal.jpg": "93d769d3c2959457e07e2552fa959580",
"assets/assets/images/tracks/monza.jpg": "b2d2a57f59e8e541a3b9ae0ac742e79a",
"assets/assets/images/tracks/shanghai.jpg": "d15e479dd951aed9d017a0fb72e2c4e8",
"assets/assets/images/tracks/silverstone.jpg": "5f997a7343acbad98990e3ac0c19802c",
"assets/assets/images/tracks/singapour.jpg": "0c34ca3304178266b6afad38b6a7b6d9",
"assets/assets/images/tracks/spa.jpg": "ed8f5bde88c76087a3ffeaa1dc350aca",
"assets/assets/images/tracks/spielberg.jpg": "0ca5501d9494e538bad71f15867cdfc2",
"assets/assets/images/tracks/suzuka.jpg": "82e914aa09cdf96bd1cfe7f163c969fb",
"assets/assets/images/tracks/zandvoort.jpg": "e4051d91b52234c3b9a5a9590d2999dc",
"assets/assets/images/vcab_logo.png": "aec44a32f82696839baddcc7f2fc0d8c",
"assets/assets/images/vca_car.png": "69dc42efa8b1b68f28fe7ae62314924f",
"assets/assets/images/wdc.jpeg": "ebb70a42c3f6667faaaf41b8b6db27c4",
"assets/assets/images/welcome.jpg": "568a3dd74d17074d24524336dfc90232",
"assets/assets/images/williams_logo.png": "1ce9f1d200fd57a203598f6d3a60ef8e",
"assets/assets/images/wil_car.png": "a9cc6b879586c4bc562c64e7e6aceb4c",
"assets/assets/splash.png": "9c81f33ab7e7a8367dce27cc149521bf",
"assets/FontManifest.json": "e7fb809b73474655740af06ee5639bf5",
"assets/fonts/MaterialIcons-Regular.otf": "eff184b85c943ec34927a907da8d1fa7",
"assets/NOTICES": "2a56f5faf08943ffd2ff8d5b51cf0f40",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "aa170ac713aeb15cb558bd9a84fb1fdb",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b2703f18eee8303425a5342dba6958db",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "5b8d20acec3e57711717f61417c1be44",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "b96059fd29d1a765623dc192048828b3",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "8535b8244cf967d22a6d6074f6be0186",
"/": "8535b8244cf967d22a6d6074f6be0186",
"main.dart.js": "f97ba946ff7e5f6f449d2f279ad39ea5",
"manifest.json": "c2e16857d9b5276557090c21a1a02cf0",
"splash/img/dark-1x.png": "23cf2c2f433be3c479243a7089f48922",
"splash/img/dark-2x.png": "a8b49e2358635ef6fd54c8fb648a90d7",
"splash/img/dark-3x.png": "7e714f5205813b44cd8d66f0661b0867",
"splash/img/dark-4x.png": "615a04c674ff8dfc396ee3e6a4e91e3b",
"splash/img/light-1x.png": "23cf2c2f433be3c479243a7089f48922",
"splash/img/light-2x.png": "a8b49e2358635ef6fd54c8fb648a90d7",
"splash/img/light-3x.png": "7e714f5205813b44cd8d66f0661b0867",
"splash/img/light-4x.png": "615a04c674ff8dfc396ee3e6a4e91e3b",
"version.json": "2dc9684a02a426e47ca7e38bc4be5532"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
