const tablet = document.getElementById('tablet');
const list = document.getElementById('incident-list');
document.getElementById('close').onclick = () => fetch(`https://${GetParentResourceName()}/close`, { method: 'POST', body: '{}' });

window.addEventListener('message', (e) => {
  const d = e.data;
  if (d.action === 'openTablet') {
    tablet.classList.remove('hidden');
    renderIncidents(d.list || []);
  } else if (d.action === 'close') tablet.classList.add('hidden');
  else if (d.action === 'incidents') renderIncidents(d.list || []);
  else if (d.action === 'taxiJob') showTaxiJob(d.job);
});

function renderIncidents(items) {
  list.innerHTML = items.map(i => `<div class="incident" data-id="${i.id}">
    <strong>${i.title}</strong><br><small>${i.type}</small>
  </div>`).join('');
  list.querySelectorAll('.incident').forEach(el => {
    el.onclick = () => {
      const inc = items.find(x => x.id == el.dataset.id);
      if (inc) fetch(`https://${GetParentResourceName()}/setGPS`, {
        method: 'POST', body: JSON.stringify({ coords: inc.coords })
      });
    };
  });
}

function showTaxiJob(job) {
  const panel = document.getElementById('taxi-panel');
  panel.classList.remove('hidden');
  document.getElementById('taxi-jobs').innerHTML = job ? `
    <div class="taxi-job"><b>${job.customer}</b><br>${job.distance}m
    <button onclick="acceptTaxi(${job.id})">Accept</button>
    <button onclick="declineTaxi(${job.id})">Decline</button></div>` : '';
}

function acceptTaxi(id) { fetch(`https://${GetParentResourceName()}/acceptTaxi`, { method:'POST', body: JSON.stringify({ id }) }); }
function declineTaxi(id) { fetch(`https://${GetParentResourceName()}/acceptTaxi`, { method:'POST', body: JSON.stringify({ id, decline: true }) }); }
