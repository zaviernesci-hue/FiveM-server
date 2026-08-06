window.addEventListener('message',e=>{
  if(e.data.action!=='open')return;
  document.getElementById('market').classList.remove('hidden');
  document.getElementById('items').innerHTML=(e.data.listings||[]).map(l=>`
    <div class="item"><b>${l.title}</b> — $${l.price}
    <br>${l.description||''}
    <button onclick="buy(${l.id})">Buy Now</button>
    ${l.listing_type==='auction'?`<button onclick="bid(${l.id})">Bid</button>`:''}</div>`).join('');
});
function buy(id){fetch(`https://${GetParentResourceName()}/buy`,{method:'POST',body:JSON.stringify({id})})}
function bid(id){const a=prompt('Bid amount');if(a)fetch(`https://${GetParentResourceName()}/bid`,{method:'POST',body:JSON.stringify({id,amount:+a})})}
document.addEventListener('keydown',e=>{if(e.key==='Escape')fetch(`https://${GetParentResourceName()}/close`,{method:'POST',body:'{}'})})
