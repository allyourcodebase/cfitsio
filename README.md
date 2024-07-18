# cfitsio

[![CI][ci-shd]][ci-url]
[![LC][lc-shd]][lc-url]

## Zig build of [CFITSIO library](https://github.com/HEASARC/cfitsio).

### :rocket: Usage

- Add `cfitsio` dependency to `build.zig.zon`.

```sh
zig fetch --save https://github.com/allyourcodebase/cfitsio/archive/<git_tag_or_commit_hash>.tar.gz
```

- Use `cfitsio` dependency in `build.zig`.

```zig
const cfitsio_dep = b.dependency("cfitsio", .{
    .target = target,
    .optimize = optimize,
});
const cfitsio_mod = cfitsio_dep.module("cfitsio");
<compile>.root_module.addImport("cfitsio", cfitsio_mod);
```

<!-- MARKDOWN LINKS -->

[ci-shd]: https://img.shields.io/github/actions/workflow/status/allyourcodebase/cfitsio/ci.yaml?branch=main&style=for-the-badge&logo=github&label=CI&labelColor=black
[ci-url]: https://github.com/allyourcodebase/cfitsio/blob/main/.github/workflows/ci.yaml
[lc-shd]: https://img.shields.io/github/license/allyourcodebase/cfitsio.svg?style=for-the-badge&labelColor=black
[lc-url]: https://github.com/allyourcodebase/cfitsio/blob/main/LICENSE
