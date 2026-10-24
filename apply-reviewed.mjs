import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {readFileSync,writeFileSync,mkdirSync} from 'node:fs';
assert.equal(process.env.GITHUB_ACTIONS,'true');assert.equal(process.platform,'linux');
assert.equal(execFileSync('calcit',['-v'],{encoding:'utf8'}).trim(),'0.30.1');
const run=(...a)=>execFileSync('calcit',['calcit.cirru',...a],{encoding:'utf8',maxBuffer:48e6,stdio:['ignore','pipe','pipe']});
const blob=()=>execFileSync('git',['hash-object','calcit.cirru'],{encoding:'utf8'}).trim();
assert.equal(blob(),'51ec49600f3ceb1959a25d6b1d9bdad9fb9d14fe');
const norm=v=>Array.isArray(v)?v.map(norm):v&&typeof v==='object'?Object.fromEntries(Object.entries(v).map(([k,x])=>[k,k==='__edn_set'?x.map(norm).sort((a,b)=>JSON.stringify(a).localeCompare(JSON.stringify(b))):norm(x)])):v;
const q=(...a)=>norm(JSON.parse(run('query',...a,'--format','json')).data);
const input=JSON.parse(readFileSync('reviewed.json','utf8'));
const before={config:norm(input.config.data),namespaces:input.namespaces.map(x=>norm(x.data)),defs:input.definitions.map(x=>norm(x.data))};
assert.equal(before.defs.length,34);assert.equal(before.defs.reduce((n,d)=>n+d.tests.length+d.examples.length,0),0);
assert.deepEqual(q('config'),before.config);assert.deepEqual(q('ns').namespaces.map(n=>q('ns',n)),before.namespaces);
for(const d of before.defs)assert.deepEqual(q('def',d.id),d);
const expected=structuredClone(before),ops=[],sites=[],counts={merge:0,unwrapOr:0,unwrap:0,len:0,css:0,dom:0,watcher:0,host:0,eventSchema:0,mapGuard:0,keyboardBody:0,keyboardCall:0,keyboardSchema:0,imports:0};
const show=(id,path)=>JSON.parse(run('tree','show',id,'--path','@'+path.join('.'),'--format','json')).tree;
const replace=(id,path,value)=>ops.push(['tree','replace',id,'--path','@'+path.join('.'),'--input-format','json-ast','--code',JSON.stringify(value)]);
const map=['::',"'Map","'Tag","'Dynamic"],dispatch=['::',"'Fn",['{}',[':rest',"'Dynamic"],[':return',"'Unit"],[':args',['[]',"'Dynamic"]]]];
const domHint=['hint-fn',['{}',[':return',"'Unit"],[':args',['[]',map,dispatch]]]];
const state=['::',"'reel.typed/State","'Enum","'app.schema/Store"];
const watchHint=['hint-fn',['{}',[':return',"'Unit"],[':args',['[]',state,state]]]];
const hostHint=['hint-fn',['{}',[':return',"'Unit"],[':args',['[]',"'js-ffi.browser/EventHost"]]]];
const lengths=new Set([':font-size',':max-width',':border-top-width',':border-bottom-width',':right',':bottom',':top']),keywords=new Set([':display',':position']);
function insertHint(id,path,x,hint){assert.equal(x[0],'fn');assert.notEqual(x[2]?.[0],'hint-fn');const p=[...path,2];ops.push(['tree','insert',id,'--path','@'+p.join('.'),'--at','before','--input-format','json-ast','--code',JSON.stringify(hint)]);x.splice(2,0,structuredClone(hint));sites.push({id,path:p,inserted:hint});}
function walk(x,path,id){
  if(!Array.isArray(x)||['quote','quasiquote','comment',';','defmacro'].includes(x[0]))return x;
  const original=structuredClone(x);
  if(['merge','option:unwrap-or','option:unwrap','count'].includes(x[0])){
    assert.deepEqual(show(id,path),original);const old=x[0];if(old==='count'){assert.equal(id,'app.comp.container/comp-word-ui');assert.equal(x[1],'word');}
    const next={merge:'.merge','option:unwrap-or':'.unwrap-or','option:unwrap':'.unwrap',count:'.len'}[old];replace(id,[...path,0],next);x[0]=next;counts[{merge:'merge','option:unwrap-or':'unwrapOr','option:unwrap':'unwrap',count:'len'}[old]]++;sites.push({id,path,original,replacement:next});
  }
  if(x[0]==='{}')for(let j=1;j<x.length;j++){
    const pair=x[j];if(!Array.isArray(pair)||pair.length!==2)continue;const [k,v]=pair;let next;
    if(typeof v==='string'&&/^\d+$/.test(v)&&lengths.has(k))next='|'+v+'px';else if(typeof v==='string'&&v.startsWith(':')&&keywords.has(k))next='|'+v.slice(1);else if(k===':z-index'&&v==='101')next='|101';
    if(next!==undefined){assert.ok(id.startsWith('app.comp.container/'));const p=[...path,j,1];assert.equal(show(id,p),v);replace(id,p,next);pair[1]=next;counts.css++;sites.push({id,path:p,before:v,after:next});}
  }
  if(x[0]==='toggle-shortcut?'){
    assert.equal(id,'app.main/main!');assert.deepEqual(x,['toggle-shortcut?','event']);assert.deepEqual(show(id,path),original);replace(id,[...path,1],['keyboard-event-host','event']);x[1]=['keyboard-event-host','event'];counts.keyboardCall++;
  }
  const needsDOM=id.startsWith('app.comp.container/')&&x[0]==='fn'&&JSON.stringify(x[1])===JSON.stringify(['e','d!']);
  x=x.map((v,i)=>walk(v,[...path,i],id));
  if(needsDOM){assert.deepEqual(show(id,path),original);assert.ok(['d!','speak-text!'].includes(original[2][0]));assert.equal(original.length,3);insertHint(id,path,x,domHint);counts.dom++;}
  if(x[0]==='add-watch!'){
    assert.equal(x[1],'*reel');assert.equal(x[2],':changes');assert.deepEqual(show(id,[...path,3]),original[3]);insertHint(id,[...path,3],x[3],watchHint);counts.watcher++;
  }else if(x[0]==='add-event-listener!'){
    assert.equal(id,'app.main/main!');assert.ok(['|beforeunload','|keydown'].includes(x[1]));assert.deepEqual(show(id,[...path,2]),original[2]);insertHint(id,[...path,2],x[2],hostHint);counts.host++;
  }
  return x;
}
for(const d of expected.defs)d.code=walk(d.code,[],d.id);
const schema=(d)=>ops.push(['edit','schema',d.id,'--input-format','json-ast','--code',JSON.stringify(['::',"'Fn",['{}',...d.schema.slice(1).filter(x=>x[0]!==':kind')]])]);
const reader=expected.defs.find(d=>d.id==='app.comp.container/event-value');
const readerArgs=reader.schema.find(x=>Array.isArray(x)&&x[0]===':args')[1];assert.deepEqual(readerArgs,['[]',"'Dynamic"]);readerArgs[1]=structuredClone(map);schema(reader);counts.eventSchema++;
assert.deepEqual(show(reader.id,[3,1,1,1]),['decode-map-as','event',map]);replace(reader.id,[3,1,1,1],'event');reader.code[3][1][1][1]='event';counts.mapGuard++;
const keyboard=expected.defs.find(d=>d.id==='app.main/toggle-shortcut?');
assert.deepEqual(show(keyboard.id,[3]),['let',[['keyboard',['unsafe-coerce','event','js-ffi.browser/KeyboardEventHost']]],['and',['=','|e',['keyboard',':key']],['keyboard',':meta-key?']]]);
keyboard.code[3]=['and',['=','|e',['event',':key']],['event',':meta-key?']];replace(keyboard.id,[3],keyboard.code[3]);counts.keyboardBody++;
const keyboardArgs=keyboard.schema.find(x=>Array.isArray(x)&&x[0]===':args')[1];assert.deepEqual(keyboardArgs,['[]',"'js-ffi.browser/EventHost"]);keyboardArgs[1]="'js-ffi.browser/KeyboardEventHost";schema(keyboard);counts.keyboardSchema++;
const ns=expected.namespaces.find(n=>n.namespace==='app.main'),require=ns.ns_code[2],browser=require.find(x=>Array.isArray(x)&&x[0]==='js-ffi.browser');assert.equal(browser[1],':refer');assert.ok(!browser[2].includes('keyboard-event-host'));browser[2].push('keyboard-event-host');
ops.push(['edit','imports','app.main','--input-format','json-ast','--code',JSON.stringify(['[]',...require.slice(1)])]);counts.imports++;
assert.deepEqual(counts,{merge:4,unwrapOr:2,unwrap:1,len:1,css:14,dom:3,watcher:2,host:2,eventSchema:1,mapGuard:1,keyboardBody:1,keyboardCall:1,keyboardSchema:1,imports:1});assert.equal(ops.length,35);
for(const d of before.defs)if(![reader.id,keyboard.id].includes(d.id))assert.deepEqual(expected.defs.find(x=>x.id===d.id).schema,d.schema);
for(const id of ['app.comp.container/RegexHost','app.comp.container/StringHost','app.comp.container/make-regex','app.comp.container/pattern-lines','app.comp.container/pattern-spaces','app.comp.container/split-regex','app.comp.container/speak-text!','app.schema/decode-store','app.schema/Store','app.schema/Op','app.schema/store','app.main/*reel','app.main/dispatch!','app.main/mount-target','app.main/persist-storage!','app.main/render-app!','app.updater/updater'])assert.deepEqual(expected.defs.find(d=>d.id===id),before.defs.find(d=>d.id===id));
const main=expected.defs.find(d=>d.id==='app.main/main!');assert.equal(main.code[5][0],'match');assert.equal(main.code[6][0],'render-app!');assert.equal(main.code[9][0],'add-event-listener!');assert.equal(main.code[10][0],'set-interval!');
const reload=expected.defs.find(d=>d.id==='app.main/reload!'),oldReload=before.defs.find(d=>d.id===reload.id);assert.deepEqual(reload.code[3][2][5],oldReload.code[3][2][5]);assert.deepEqual(reload.code[3][3],oldReload.code[3][3]);
mkdirSync('acceptance',{recursive:true});for(const [name,value]of Object.entries({before,expected,sites,operations:ops}))writeFileSync('acceptance/'+name+'.json',JSON.stringify(value,null,2));
const txn=['edit','transaction','--file','acceptance/operations.json','--format','json'],preview=JSON.parse(run(...txn,'--dry-run'));assert.ok(preview.scoped_revision);writeFileSync('acceptance/preview.json',JSON.stringify(preview,null,2));writeFileSync('acceptance/applied.json',run(...txn,'--expect-revision',preview.scoped_revision));
const after={config:q('config'),namespaces:q('ns').namespaces.map(n=>q('ns',n)),defs:expected.defs.map(d=>q('def',d.id))};assert.deepEqual(after,expected);
writeFileSync('acceptance/after.json',JSON.stringify(after,null,2));writeFileSync('acceptance/snapshot-after-blob.txt',blob());
writeFileSync('acceptance/summary.json',JSON.stringify({definitions:34,tests:0,examples:0,operations:35,counts,unsafeBefore:5,unsafeAfter:4,preserved:'Original8Nodeassertions;metadata/config/all schemas except event-value Map/keyboard predicate KeyboardEventHost,oneexistingimportextended. HUD/restorefirst/Store/Op/wire/language/SDK/regexsplit/paragraphspaces/tokenjoin/gradient equations unchanged. KeyboardopaqueEventHost checkedonce atkeydownboundarythenpuretypedpredicate;readerduplicateMapguardremoved,Stringguardkept. No helpers/casts/budgets/tests/frameworks/compiler rules.'},null,2));
