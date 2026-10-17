
A reading tool for long text
----

Live Demo https://r.tiye.me/Memkits/lutea-reader/

Options:

- `mode`: `dev` / `release`
- `lang`: `en-US` / `zh-CN`
- `azure-key`: from Azure

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

Use paired Calcit/procs 0.30.1-alpha.4 (compiler prerelease) with `caps --ci --strict`,
`yarn install --immutable` and `caps deps.cirru verify --toolchain`. Canonical project
files are `calcit.cirru` and `deps.cirru`; retired `compact.cirru`
and `package.cirru` are not tracked. The unused Markdown import/module was removed; actual
paragraph/character rendering and Azure/native speech are retained. Component-only
Memof memoization uses the released Respo `memo-comp-by`/`render-with!` API instead.
Module versions are formal exact tags: Respo 0.16.122, UI 0.7.41, Reel 0.6.39,
js-ffi 0.2.3; no hash or alpha module dependencies.

Reel state now uses the actual `reel.typed/State<Enum,Store>` Struct, not the old
fake Map type alias. Reading content, the `lutea-reader` persistence key, legacy
Map/Struct save decoding, original speech configuration and production paths stay
unchanged. Store UI-state branches support real mixed cursor keys. Refresh an
already-open page after this type/runtime upgrade. This PR does not authorize
merging, releasing or deploying the application.

Run `calcit calcit.cirru --check-only --all-defs`, strict workflow verification and public
namespace checks, then `calcit calcit.cirru js` and `node --test tests/*.test.mjs`.
Storage regression tests cover legacy Map and typed Store decoding, invalid
external data rejection and the unchanged `lutea-reader` key. Native speech
uses browser fixtures; tests do not request Azure services or consume credits.

Build with a PR-specific `VITE_BASE_URL=https://cos-sh.tiye.me/Memkits/lutea-reader/pr/<number>/<run>/<attempt>/ yarn build`
with public upload verification handled by cos-upload-action's built-in verify
settings, without an extra CDN checker.
Shared fonts/logo, language/configuration keys and original server paths stay
unchanged. COS only uploads the generated frontend `dist` resources.

CI 使用正式 COS action v1.2.0 内置 HTML 同域脚本/样式引用检查及公开字节/SHA-256 校验，不保留重复 CDN 构建测试。全部八项真实阅读/持久化/语音适配测试、严格入口及五个业务 namespace 公开定义检查保留，语音测试不请求付费服务。PR 资源按 PR/run/attempt 隔离，同组串行保留等待队列，原生产及服务器路径不变。

部署采用正式 Action 标签；在构建后查询一次当前 main，过期生产构建同时跳过 COS 和 rsync。
任务限时 15 分钟、COS 上传限时 10 分钟，公开校验仍由 action 自身完成，不新增验证脚本。
本候选使用已发布的 0.30.1-alpha.4 配对，不宣称 0.30.1 稳定版已经发布；真实付费语音服务不在离线验收范围内。

`yarn dev` 编译一次再启动 Vite；需要实时编译时另开终端运行 `calcit calcit.cirru js -w`，不增加 concurrently。保留原八项业务测试，只把 Reel 和 Storage fixture 对齐实际新合同；不新增防御性测试、兼容预算或上传校验脚本。

### License

MIT
