
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
files are `calcit.cirru` and `deps.cirru`; CI rejects retired `compact.cirru`
and `package.cirru`. The unused Markdown import/module was removed; actual
paragraph/character rendering, Memof and Azure/native speech are retained.

Run `calcit calcit.cirru --check-only`, strict workflow verification and public
namespace checks, then `calcit calcit.cirru js` and `node --test tests/*.test.mjs`.
Storage regression tests cover legacy Map and typed Store decoding, invalid
external data rejection and the unchanged `lutea-reader` key. Native speech
uses browser fixtures; tests do not request Azure services or consume credits.

Build with `VITE_BASE_URL=https://cos-sh.tiye.me/Memkits/lutea-reader/pr/ yarn vite build`
and run `node tests/check-cdn-path.mjs` with the same base. This validates
local generated JS/CSS URLs; cos-upload-action verifies uploaded files publicly.
Shared fonts/logo, language/configuration keys and original server paths stay
unchanged. COS only uploads the generated frontend `dist` resources.

### License

MIT
