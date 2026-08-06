window.addEventListener('message',e=>{
  if(e.data.action==='open'){
    document.getElementById('dealer').classList.remove('hidden');
    document.getElementById('list').innerHTML=(e.data.catalog||[]).map(c=>`
      <div class="car"><b>${c.label}</b> — $${c.price.toLocaleString()}
      <br>Top: ${c.topSpeed || 0}mph • Acc: ${c.acceleration || 0} • Handling: ${c.handling || 0}
      <br><button onclick="buy('${c.model}',${c.price},false)">Buy</button>
      <button onclick="buy('${c.model}',${c.price},true)">Finance</button>
      <button onclick="test('${c.model}')">Test Drive</button>
      <button onclick="tune('street')">Street Tune ($4,000)</button>
      <button onclick="tune('track')">Track Tune ($9,000)</button></div>`).join('');
  }
});
document.getElementById('close').onclick=()=>fetch(`https://${GetParentResourceName()}/close`,{method:'POST',body:'{}'});
function buy(m,p,f){fetch(`https://${GetParentResourceName()}/buy`,{method:'POST',body:JSON.stringify({model:m,price:p,finance:f})})}
function tune(pkg){fetch(`https://${GetParentResourceName()}/tune`,{method:'POST',body:JSON.stringify({package:pkg,plate:'CUSTOM'})})}
function test(m){fetch(`https://${GetParentResourceName()}/testDrive`,{method:'POST',body:JSON.stringify({model:m})})}
