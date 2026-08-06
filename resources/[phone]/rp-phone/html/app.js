const phone = document.getElementById('phone');
const appsEl = document.getElementById('apps');
const appView = document.getElementById('app-view');
const home = document.getElementById('home');
let playerData = {};

const appMeta = {
  messages:{ icon:'💬', name:'Messages' }, calls:{ icon:'📞', name:'Calls' },
  contacts:{ icon:'👤', name:'Contacts' }, camera:{ icon:'📷', name:'Camera' },
  gallery:{ icon:'🖼', name:'Gallery' }, settings:{ icon:'⚙', name:'Settings' },
  calculator:{ icon:'🔢', name:'Calc' }, maps:{ icon:'🗺', name:'Maps' },
  bank:{ icon:'🏦', name:'Bank' }, vehicles:{ icon:'🚗', name:'Vehicles' },
  inventory:{ icon:'🎒', name:'Inventory' }, marketplace:{ icon:'🛒', name:'Market' },
  business:{ icon:'🏢', name:'Business' }, contracts:{ icon:'🗂', name:'Contracts' },
  casino:{ icon:'🎰', name:'Casino' }, services:{ icon:'🛠', name:'Services' },
  blackmarket:{ icon:'🕶', name:'Black Market' }, chrome:{ icon:'🌐', name:'Chrome' },
  taktik:{ icon:'🎵', name:'TakTik' }, browser:{ icon:'🌐', name:'Browser' },
  darkweb:{ icon:'🕶', name:'Dark Web' },
};

document.getElementById('homeBtn').onclick = showHome;
document.getElementById('time').textContent = new Date().toLocaleTimeString([], {hour:'2-digit',minute:'2-digit'});

window.addEventListener('message', e => {
  const d = e.data;
  if (d.action === 'open') {
    phone.classList.remove('hidden');
    playerData = d.player || {};
    renderApps(d.apps || []);
    showHome();
  } else if (d.action === 'close') phone.classList.add('hidden');
  else if (d.action === 'newMessage') appendMessage(d.msg);
  else if (d.action === 'openApp') {
    openApp(d.app);
  }
});

function renderApps(list) {
  appsEl.innerHTML = list.map(id => {
    const m = appMeta[id] || { icon:'📱', name:id };
    return `<div class="app-icon" onclick="openApp('${id}')"><span>${m.icon}</span><small>${m.name}</small></div>`;
  }).join('');
}

function showHome() {
  home.classList.remove('hidden');
  appView.classList.add('hidden');
}

function openApp(id) {
  home.classList.add('hidden');
  appView.classList.remove('hidden');
  const templates = {
    messages: `<h3>Messages</h3><div id="msg-list"></div>
      <input id="recv" placeholder="Number"/><textarea id="msg" placeholder="Message"></textarea>
      <button onclick="sendMsg()">Send</button>`,
    bank: `<h3>Bank</h3><div class="card">Balance: $${(playerData.bank||0).toLocaleString()}</div>
      <button onclick="appAction('bank')">Open Bank Menu</button>
      <input id="tid" placeholder="Player ID"/><input id="amt" type="number" placeholder="Amount"/>
      <button onclick="transfer()">Transfer</button>`,
    taktik: `<h3>TakTik</h3><button onclick="loadTakTik('feed')">Feed</button>
      <button onclick="loadTakTik('trending')">Trending</button><div id="taktik-feed"></div>`,
    inventory: `<h3>Inventory</h3>
      <div class="card" id="inventory-summary">Loading inventory...</div>
      <div id="inventory-list"></div>`,
    chrome: `<h3>Chrome</h3><input id="url" placeholder="https://..." value="https://www.google.com"/>
      <button onclick="browse()">Go</button><div id="browser-frame" class="card">Enter URL above</div>`,
    browser: `<h3>Browser</h3><input id="url" placeholder="https://..." value="https://losantos.gov"/>
      <button onclick="browse()">Go</button><div id="browser-frame" class="card">Enter URL above</div>`,
    blackmarket: `<h3>Black Market</h3><div id="blackmarket-screen"></div>
      <div class="card">Buy rare illegal gear and forged access items using cash.</div>
      <button onclick="buyBlackMarket('bank_card', 8000)">Bank Card $8,000</button>
      <button onclick="buyBlackMarket('hacking_device', 12000)">Hacking Device $12,000</button>
      <button onclick="buyBlackMarket('weapon_parts', 7000)">Weapon Parts $7,000</button>
      <button onclick="buyBlackMarket('stolen_watch', 3500)">Stolen Watch $3,500</button>
      <button onclick="buyBlackMarket('fake_id', 2500)">Fake ID $2,500</button>`,
    services: `<h3>Services</h3>
      <button onclick="appAction('services:bounty')">Open Bounty Board</button>
      <button onclick="appAction('services:drug')">Open Drug Lab</button>
      <p class="card">Access both illegal service menus from one app.</p>`,
    business: `<h3>Business</h3>
      <button onclick="appAction('business')">Open Business Menu</button>
      <p class="card">Manage your businesses from one place.</p>`,
    contracts: `<h3>Contracts</h3>
      <button onclick="appAction('contracts')">Open Contract Board</button>
      <p class="card">Accept new work through your phone.</p>`,
    casino: `<h3>Casino</h3>
      <button onclick="appAction('casino')">Open Casino Menu</button>
      <p class="card">Place bets using the phone table.</p>`,
    darkweb: `<h3>Dark Web</h3><div class="card">Requires Dark Browser ($5000)</div>
      <button onclick="buyItem('lockpick',450)">ATM Lockpick $450</button>
      <button onclick="buyItem('thermite',1200)">Thermite $1200</button>
      <button onclick="buyItem('usb_hack',2800)">USB Hack $2800</button>
      <button onclick="buyItem('fake_id',2500)">Fake ID $2500</button>`,
    marketplace: `<h3>Marketplace</h3>
      <button onclick="appAction('marketplace')">Open Marketplace</button>
      <p class="card">Browse listings via in-city terminals or create from inventory.</p>`,
    vehicles: `<h3>My Vehicles</h3><p class="card">Lock, unlock, locate via garage app — synced with rp-vehicles.</p>`,
    blackmarket: `<h3>Black Market</h3><div class="card">Buy illegal gear, fake documents, and rare access items.</div>
      <button onclick="buyBlackMarket('bank_card', 8000)">Bank Card $8,000</button>
      <button onclick="buyBlackMarket('hacking_device', 12000)">Hacking Device $12,000</button>
      <button onclick="buyBlackMarket('weapon_parts', 7000)">Weapon Parts $7,000</button>
      <button onclick="buyBlackMarket('stolen_watch', 3500)">Stolen Watch $3,500</button>
      <button onclick="buyBlackMarket('fake_id', 2500)">Fake ID $2,500</button>`,
    maps: `<h3>Maps</h3><p class="card">Set GPS waypoints from dispatch and phone.</p>`,
    calculator: `<h3>Calculator</h3><input id="calc"/><div id="calc-out" class="card"></div>`,
    settings: `<h3>Settings</h3>
      <div class="card">
        <label>Theme</label>
        <select id="setting-theme">
          <option value="light">Light</option>
          <option value="dark">Dark</option>
        </select>
        <label>Phone Key</label>
        <input id="setting-phone-key" maxlength="1" type="text" placeholder="P" />
        <label>Inventory Key</label>
        <input id="setting-inv-key" maxlength="1" type="text" placeholder="I" />
        <label>Ringtone</label>
        <select id="setting-ringtone">
          <option value="classic">Classic</option>
          <option value="beep">Beep</option>
          <option value="pop">Pop</option>
          <option value="retro">Retro</option>
        </select>
        <label>Notification Volume</label>
        <input id="setting-volume" type="range" min="0" max="1" step="0.05" />
        <label><input id="setting-vibrate" type="checkbox" /> Enable Vibration</label>
        <button onclick="saveSettings()">Save Settings</button>
        <button onclick="resetSettings()">Reset Defaults</button>
        <div id="settings-status" class="card"></div>
      </div>`,
  };
  appView.innerHTML = templates[id] || `<h3>${id}</h3><p class="card">App loaded.</p>`;
  if (id === 'messages') loadMessages();
  if (id === 'inventory') loadInventory();
  if (id === 'blackmarket') renderBlackMarket();
  if (id === 'settings') loadSettings();
}

function loadMessages() {
  fetch(`https://${GetParentResourceName()}/getMessages`, { method:'POST', body:'{}' })
    .then(r=>r.json()).then(msgs => {
      document.getElementById('msg-list').innerHTML = (msgs||[]).map(m =>
        `<div class="card"><b>${m.sender}</b>: ${m.message}</div>`).join('');
    });
}

function sendMsg() {
  fetch(`https://${GetParentResourceName()}/sendMessage`, {
    method:'POST', body: JSON.stringify({ receiver: document.getElementById('recv').value, message: document.getElementById('msg').value })
  });
}

function transfer() {
  fetch(`https://${GetParentResourceName()}/bankTransfer`, {
    method:'POST', body: JSON.stringify({ targetId: document.getElementById('tid').value, amount: +document.getElementById('amt').value })
  });
}

function loadTakTik(tab) {
  fetch(`https://${GetParentResourceName()}/getTakTik`, { method:'POST', body: JSON.stringify({ tab }) })
    .then(r=>r.json()).then(posts => {
      document.getElementById('taktik-feed').innerHTML = (posts||[]).map(p =>
        `<div class="card"><b>@${p.username}</b><br>${p.caption||''}<br>❤ ${p.likes}
        <button onclick="like(${p.id})">Like</button></div>`).join('');
    });
}

function loadInventory() {
  fetch(`https://${GetParentResourceName()}/getInventory`, { method:'POST', body: '{}' })
    .then(r => r.json()).then(data => {
      const summary = document.getElementById('inventory-summary');
      const list = document.getElementById('inventory-list');
      if (!summary || !list) return;
      summary.innerHTML = `Slots: ${data.usedSlots}/${data.maxSlots}`;
      list.innerHTML = (data.items || []).map(item =>
        `<div class="card"><b>${item.label}</b> x${item.amount}<br>Slot: ${item.slot || '-'}<br>Item: ${item.name}</div>`
      ).join('') || '<div class="card">Inventory is empty.</div>';
    });
}

function renderBlackMarket() {
  const screen = document.getElementById('blackmarket-screen');
  if (!screen) return;
  screen.innerHTML = `<div class="card">The black market sells rare gear, fake docs and access items. Cash only.</div>`;
}

function loadSettings() {
  const saved = JSON.parse(localStorage.getItem('rpPhoneSettings') || '{}');
  const settings = {
    theme: saved.theme || 'light',
    phoneKey: saved.phoneKey || 'P',
    inventoryKey: saved.inventoryKey || 'I',
    ringtone: saved.ringtone || 'classic',
    volume: saved.volume ?? 0.8,
    vibrate: saved.vibrate ?? true,
  };
  document.getElementById('setting-theme').value = settings.theme;
  document.getElementById('setting-phone-key').value = settings.phoneKey;
  document.getElementById('setting-inv-key').value = settings.inventoryKey;
  document.getElementById('setting-ringtone').value = settings.ringtone;
  document.getElementById('setting-volume').value = settings.volume;
  document.getElementById('setting-vibrate').checked = settings.vibrate;
  applyTheme(settings.theme);
}

function saveSettings() {
  const settings = {
    theme: document.getElementById('setting-theme').value,
    phoneKey: document.getElementById('setting-phone-key').value.toUpperCase() || 'P',
    inventoryKey: document.getElementById('setting-inv-key').value.toUpperCase() || 'I',
    ringtone: document.getElementById('setting-ringtone').value,
    volume: Number(document.getElementById('setting-volume').value),
    vibrate: document.getElementById('setting-vibrate').checked,
  };
  localStorage.setItem('rpPhoneSettings', JSON.stringify(settings));
  fetch(`https://${GetParentResourceName()}/saveSettings`, { method:'POST', body: JSON.stringify(settings) });
  const status = document.getElementById('settings-status');
  if (status) status.innerText = 'Settings saved!';
  applyTheme(settings.theme);
  if (settings.vibrate && navigator.vibrate) navigator.vibrate(40);
  playTone(settings.ringtone, settings.volume);
}

function resetSettings() {
  localStorage.removeItem('rpPhoneSettings');
  loadSettings();
  saveSettings();
}

function applyTheme(theme) {
  document.body.classList.toggle('dark', theme === 'dark');
}

function playTone(name, volume) {
  try {
    const AudioContext = window.AudioContext || window.webkitAudioContext;
    const context = new AudioContext();
    const oscillator = context.createOscillator();
    const gain = context.createGain();
    oscillator.connect(gain);
    gain.connect(context.destination);
    gain.gain.value = volume;
    if (name === 'beep') {
      oscillator.type = 'square';
      oscillator.frequency.value = 880;
    } else if (name === 'pop') {
      oscillator.type = 'triangle';
      oscillator.frequency.value = 660;
    } else if (name === 'retro') {
      oscillator.type = 'sawtooth';
      oscillator.frequency.value = 520;
    } else {
      oscillator.type = 'sine';
      oscillator.frequency.value = 440;
    }
    oscillator.start();
    oscillator.stop(context.currentTime + 0.18);
    gain.gain.setTargetAtTime(0, context.currentTime + 0.12, 0.03);
  } catch (error) {
    console.warn('Phone sound preview unavailable.', error);
  }
}

function like(id) { fetch(`https://${GetParentResourceName()}/likePost`, { method:'POST', body: JSON.stringify({ id }) }); }
function browse() {
  const url = document.getElementById('url').value;
  document.getElementById('browser-frame').innerHTML = `Navigating to ${url}...`;
  fetch(`https://${GetParentResourceName()}/openBrowser`, { method:'POST', body: JSON.stringify({ url }) });
}
function buyItem(item, price) {
  fetch(`https://${GetParentResourceName()}/buyDarkWeb`, { method:'POST', body: JSON.stringify({ item, price }) });
}
function buyBlackMarket(item, price) {
  fetch(`https://${GetParentResourceName()}/buyBlackMarket`, { method:'POST', body: JSON.stringify({ item, price }) });
}

function appAction(action) {
  fetch(`https://${GetParentResourceName()}/appAction`, { method:'POST', body: JSON.stringify({ action }) });
}

document.addEventListener('keydown', e => {
  if (e.key === 'Escape') fetch(`https://${GetParentResourceName()}/close`, { method:'POST', body:'{}' });
});
