window.addEventListener('message', (e) => {
  const d = e.data;
  if (d.action !== 'update') return;
  document.getElementById('health').style.width = Math.max(0, d.health) + '%';
  document.getElementById('armor').style.width = Math.max(0, d.armor) + '%';
  document.getElementById('hunger').style.width = Math.max(0, d.hunger) + '%';
  document.getElementById('thirst').style.width = Math.max(0, d.thirst) + '%';
  document.getElementById('stress').style.width = Math.max(0, d.stress) + '%';
  document.getElementById('cash').textContent = '$' + (d.cash || 0).toLocaleString();
  document.getElementById('bank').textContent = '$' + (d.bank || 0).toLocaleString();
  document.getElementById('compass').textContent = d.compass || 'N';
  document.getElementById('street').textContent = d.street || '—';
  const fuelWrap = document.getElementById('fuel-wrap');
  const speedWrap = document.getElementById('speed-wrap');
  const seatbelt = document.getElementById('seatbelt');
  if (d.inVehicle) {
    fuelWrap.classList.remove('hidden');
    speedWrap.classList.remove('hidden');
    document.getElementById('fuel').textContent = Math.round(d.fuel);
    document.getElementById('speed').textContent = d.speed;
    seatbelt.classList.toggle('hidden', !d.seatbelt);
  } else {
    fuelWrap.classList.add('hidden');
    speedWrap.classList.add('hidden');
    seatbelt.classList.add('hidden');
  }
  document.getElementById('talking').classList.toggle('hidden', !d.talking);
});
