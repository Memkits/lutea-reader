
A reading tool for long text
----

Live Demo https://r.tiye.me/Memkits/lutea-reader/

Options:

- `mode`: `dev` / `release`
- `lang`: `en-US` / `zh-CN`
- `azure-key`: from Azure

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

Use stable Calcit/procs 0.27.0 with `caps --ci --strict`,
`yarn install --immutable` and `caps verify --toolchain`. Canonical project
files are `calcit.cirru` and `deps.cirru`; retired `compact.cirru`
and `package.cirru` are not tracked. The unused Markdown import/module was removed; actual
paragraph/character rendering, Memof and Azure/native speech are retained.

Run `calcit calcit.cirru --check-only`, strict workflow verification and public
namespace checks, then `calcit calcit.cirru js` and `node --test tests/*.test.mjs`.
Storage regression tests cover legacy Map and typed Store decoding, invalid
external data rejection and the unchanged `lutea-reader` key. Native speech
uses browser fixtures; tests do not request Azure services or consume credits.

Build with `VITE_BASE_URL=https://cos-sh.tiye.me/Memkits/lutea-reader/pr/11/local/1/ yarn build`
with public upload verification handled by cos-upload-action's built-in verify
settings, without an extra CDN checker.
Shared fonts/logo, language/configuration keys and original server paths stay
unchanged. COS only uploads the generated frontend `dist` resources.

CI 使用正式 COS action v1.2.0 内置 HTML 同域脚本/样式引用检查及公开字节/SHA-256 校验，不保留重复 CDN 构建测试。全部八项真实阅读/持久化/语音适配测试、严格入口及五个业务 namespace 公开定义检查保留，语音测试不请求付费服务。PR 资源按 PR/run/attempt 隔离，同组串行保留等待队列，原生产及服务器路径不变。

部署采用正式 Action 标签；在构建后查询一次当前 main，过期生产构建同时跳过 COS 和 rsync。
任务限时 15 分钟、COS 上传限时 10 分钟，公开校验仍由 action 自身完成，不新增验证脚本。
此处是前端部署配置迁移，不代表 Calcit 0.28 已完成兼容验收。

`yarn dev` 编译一次再启动 Vite；需要实时编译时另开终端运行 `calcit calcit.cirru js -w`，不增加 concurrently。Calcit/procs 保持正式 0.27.0，仅在兼容正式模块存在时升级，不新增模块 hash 或机械降级 alpha。

### License

MIT
