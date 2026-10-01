import assert from "node:assert/strict";
import { test } from "node:test";
import { registerHooks } from "node:module";
import * as c from "../js-out/calcit.core.mjs";
import { store, decode_store, Op } from "../js-out/app.schema.mjs";
import { updater } from "../js-out/app.updater.mjs";
import { reel } from "../js-out/reel.schema.mjs";
import { make_string } from "../js-out/respo.render.html.mjs";
const t = c.init_tags(["store", "base", "states", "data", "content", "rendered?", "hydrate-storage", "toggle-rendered", "editor"]);
const map = c._$n__$M_;
const read = (value, key) => c.option_$o_unwrap(c.get(value, t[key]));
const op = (key, ...args) => c._PCT__$o__$o_(Op, t[key], ...args);
const originalWindow = globalThis.window;
const originalDocument = globalThis.document;
const originalSdk = globalThis.SpeechSDK;
const info = console.info;
const mount = { fixture: "actual queried mount" };
const hooks = registerHooks({ resolve(specifier, context, nextResolve) {
  // Node needs extensions on the legacy CommonJS subpaths that Vite resolves.
  if (specifier === "virtual-dom/create-element") specifier += ".js";
  if (specifier === "microsoft-cognitiveservices-speech-sdk/distrib/browser/microsoft.cognitiveservices.speech.sdk.bundle") specifier += ".js";
  return nextResolve(specifier, context);
} });
let app, main;
try {
  // The real browser SDK assigns window.SpeechSDK; do not stub SDK exports.
  globalThis.window = globalThis;
  globalThis.document = {
    querySelector(selector) { assert.equal(selector, ".app"); return mount; },
    createElement() { return { getContext() { return { measureText(text) { return { width: text.length }; } }; } }; },
  };
  console.info = () => {}; // Published speech util logs its whole SDK namespace.
  app = await import("../js-out/app.comp.container.mjs");
  main = await import("../js-out/app.main.mjs");
  assert.equal(typeof globalThis.SpeechSDK.SpeechConfig.fromSubscription, "function");
} finally {
  hooks.deregister();
  console.info = info;
  if (originalWindow === undefined) delete globalThis.window; else globalThis.window = originalWindow;
  if (originalDocument === undefined) delete globalThis.document; else globalThis.document = originalDocument;
  if (originalSdk === undefined) delete globalThis.SpeechSDK; else globalThis.SpeechSDK = originalSdk;
}
test("actual initial Store renders without decoding a Struct as a Map", () => {
  const root = c.assoc(c.assoc(reel, t.base, store), t.store, store);
  assert.ok(make_string(app.comp_container(root)).includes("Toggle"));
  assert.equal(main.mount_target, mount);
});
test("whole-store states Enum preserves typed content and rendering flag", () => {
  const before = c.assoc(store, t.content, "Original content");
  const next = updater(before, op("states", c._$L_(t.editor), "UI data"), "fixture", 0);
  assert.ok(c.struct_$q_(next));
  assert.equal(read(next, "content"), "Original content");
  assert.equal(read(next, "rendered?"), false);
  assert.equal(read(read(read(next, "states"), "editor"), "data"), "UI data");
  assert.equal(c.option_$o_some_$q_(c.get(read(before, "states"), t.editor)), false);
});
test("nominal content/toggle Enums retain actual reading content", () => {
  const changed = updater(store, op("content", "First paragraph\n\nSecond paragraph"), "fixture", 0);
  const shown = updater(changed, op("toggle-rendered"), "fixture2", 0);
  assert.equal(read(shown, "rendered?"), true);
  const html = make_string(app.comp_container(c.assoc(reel, t.store, shown)));
  assert.ok(html.includes("Speech"));
  assert.equal(app.split_regex(read(shown, "content"), app.pattern_lines).toArray().length, 2);
});
test("legacy Maps and saved typed Stores validate once before hydration", () => {
  const legacy = map(t.states, map(), t.content, "Legacy text", t["rendered?"], true);
  for (const value of [legacy, decode_store(legacy), c.parse_cirru_edn(c.format_cirru_edn(decode_store(legacy)))]) {
    const decoded = decode_store(value);
    assert.ok(c.struct_$q_(decoded));
    const hydrated = updater(store, op("hydrate-storage", decoded), "fixture", 0);
    assert.equal(read(hydrated, "content"), "Legacy text");
    assert.equal(read(hydrated, "rendered?"), true);
  }
});
test("external invalid saved data is rejected instead of asserted valid", () => {
  assert.throws(() => decode_store(null));
  assert.throws(() => decode_store(map(t.content, 42, t["rendered?"], true, t.states, map())));
  assert.throws(() => decode_store(map(t.content, "text", t.states, map())));
});
test("actual main persistence uses the original key and a compatible Map round trip", () => {
  const prior = globalThis.localStorage;
  const priorWindow = globalThis.window;
  const writes = [];
  try {
    globalThis.localStorage = { setItem(key, value) { writes.push([key, value]); } };
    globalThis.window = { localStorage: globalThis.localStorage };
    main.dispatch_$x_(op("content", "Saved fixture"));
    main.persist_storage_$x_();
    assert.equal(writes.length, 1);
    assert.equal(writes[0][0], "lutea-reader");
    const saved = c.parse_cirru_edn(writes[0][1]);
    assert.ok(c.map_$q_(saved));
    assert.equal(read(decode_store(saved), "content"), "Saved fixture");
  } finally {
    if (prior === undefined) delete globalThis.localStorage; else globalThis.localStorage = prior;
    if (priorWindow === undefined) delete globalThis.window; else globalThis.window = priorWindow;
  }
});
test("actual native speech path preserves language, content and host methods", () => {
  const previous = globalThis.window;
  const utterance = globalThis.SpeechSynthesisUtterance;
  const azureKey = process.env["azure-key"];
  const calls = [];
  try {
    delete process.env["azure-key"];
    globalThis.window = { speechSynthesis: { cancel() { calls.push("cancel"); }, speak(msg) { calls.push(msg); } } };
    globalThis.SpeechSynthesisUtterance = class { constructor(text) { this.text = text; } };
    app.speak_text_$x_("Native fixture", "en-US");
    assert.equal(calls[0], "cancel");
    assert.equal(calls[1].text, "Native fixture");
    assert.equal(calls[1].lang, "en-US");
    assert.equal(calls[1].rate, 1.1);
  } finally {
    if (azureKey === undefined) delete process.env["azure-key"]; else process.env["azure-key"] = azureKey;
    if (previous === undefined) delete globalThis.window; else globalThis.window = previous;
    if (utterance === undefined) delete globalThis.SpeechSynthesisUtterance; else globalThis.SpeechSynthesisUtterance = utterance;
  }
});
test("actual Azure queue adapter forwards configured key/language without network requests", () => {
  const key = process.env["azure-key"];
  const sdk = globalThis.SpeechSDK;
  const calls = [];
  try {
    process.env["azure-key"] = "fixture-not-a-real-key";
    globalThis.SpeechSDK = {
      SpeechConfig: { fromSubscription(value, region) { calls.push([value, region]); return {}; } },
      AudioConfig: { fromDefaultSpeakerOutput() { return { fixture: "speaker" }; } },
      SpeechSynthesizer: class {
        constructor(config, audio) {
          assert.equal(config.speechSynthesisLanguage, "en-US");
          assert.equal(config.speechSynthesisVoiceName, "en-US-SaraNeural");
          assert.equal(audio.fixture, "speaker");
        }
        speakSsmlAsync(ssml, onResult) { calls.push(ssml); onResult({ fixture: "no network" }); }
      },
    };
    app.speak_text_$x_("Azure queue fixture", "en-US");
    assert.deepEqual(calls[0], ["fixture-not-a-real-key", "eastasia"]);
    assert.ok(calls[1].includes("Azure queue fixture"));
    assert.ok(calls[1].includes("en-US-SaraNeural"));
  } finally {
    if (key === undefined) delete process.env["azure-key"]; else process.env["azure-key"] = key;
    if (sdk === undefined) delete globalThis.SpeechSDK; else globalThis.SpeechSDK = sdk;
  }
});
