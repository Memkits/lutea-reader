# Lutea Reader

长文本阅读工具：[Demo](https://r.tiye.me/Memkits/lutea-reader/)。支持 `mode`（dev/release）、`lang`（en-US/zh-CN）和原 `azure-key` 语音配置。

## 使用者需要注意

配对正式 **Calcit / @calcit/procs 0.40.0**、Caps 0.1.1、Node 24 和 Yarn 4.18.0。模块使用正式 Respo 0.19.5、Reel 0.11.0、UI 0.15.2、JS FFI 0.2.13，传递 Router 0.12.2。重新安装完整图、生成 JS、重启并刷新。

阅读分词、词级渐变和英文词间空格保持；连续空白按原合同在阅读视图显示为一个空格，编辑器原文不改写。公开 Store/Op、`lutea-reader` 存储键与旧 Map/Struct 恢复合同保持。先读取/解析/解码/hydrate，再渲染并注册退出和60秒保存；恢复失败中止启动、保留原文，不自动清除/回退/修复，见 [#13](https://github.com/Memkits/lutea-reader/issues/13)。

原语音配置和 Azure/native 适配逻辑保持，SDK与适配包版本不变。本轮只做离线语音夹具，不配置真实密钥、不点击 Speech、不请求真实语音服务；不要把离线回归等同付费服务验收。JS 引入的 `hud!` 页面成功/编译错误提示保留，不改为 raise。

## 本次迁移与风险

- 以 RespoEvent 读取编辑输入。渲染派发接收具名 `Op`，Reel 快捷键和面板共用独立的 `reel.typed/Control` 回调。两路在应用更新入口汇合为 union，历史记录存储业务 `Op`，状态路径使用 CoordKey union。
- 开发面板使用 Option 表达缺席，阅读区底部使用 40vh 的垂直间距。
- 配对 deps/runtime/lock，一小时 npm 包龄无例外，原 CI/测试/全部类型门禁、权限、正式 Action tags 与部署路径保持。不增加 checker、concurrently、预算或编译器 fix/proof 规则。

String/RegExp/语音适配仍保留4处既有显式 unsafe 边界，本轮未扩大或伪造为零；事件值仍检查为 String，⌘E 仍通过正式 KeyboardEventHost 适配，不放宽合同。

## 开发与验证

```sh
caps --ci --strict
yarn install --immutable
caps verify --toolchain
calcit calcit.cirru --check-only --all-defs
calcit calcit.cirru fix --workflow strict --verify
yarn build
node --test tests/*.test.mjs
```

候选通过221个全定义、完整 strict diagnostics=[]、原8项阅读/持久化/离线语音回归、canonical 和构建。原测试文件及全部断言保持；没有附带 native 测试，不把空集合计为通过。

全新回环来源实际验证了中英文/emoji两段文本、词间空格、连续空白不改写原文、Toggle、⌘E 和阅读状态/内容刷新恢复，浏览器 warn/error=[]。本轮不读取真实存档，不把历史坏存档/HUD注错验收记作重验；失败存档保护与原语音代码未改，不宣称真实语音已验收。构建保留原 SDK 造成的大 chunk 提示，不通过隐藏告警冒充优化。

`yarn dev` 编译一次再启动 Vite，监听另开终端运行 `calcit calcit.cirru js -w`。仅维护 calcit.cirru/deps.cirru，Snapshot 使用官方 CLI，不恢复 compact.cirru/package.cirru，不提交 js-out/dist。

## 前端部署

VITE_BASE_URL 指定资源 CDN。COS 只上传 dist/，cos-upload-action v1.2.0 自身验证 HTML 引用及公开资源字节/SHA-256；不增加上传校验脚本。原 PR/run/attempt 隔离前缀、过期 main 同时跳过 COS/rsync 的条件、任务/上传限时以及 `/web-assets/repo/Memkits/lutea-reader` 目的地保持。不改后端，不合并、不部署生产、不发布 Git/npm。

模板：[respo-calcit-workflow](https://github.com/calcit-lang/respo-calcit-workflow)。

## License

MIT
