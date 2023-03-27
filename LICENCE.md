# The MIT License (MIT)

Copyright © 2021–2023 Kinetic Commerce

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the \"Software\"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Notes

This repository includes instructions to build a Docker container that
explicitly incorporates:

- [Alpine Linux][]: GNU GPL v2
- [sqitch][]: [MIT][sqitch-mit]
- [pgTAP][]: [Modified MIT][pgtap-mit]
- [TAP::Parser::SourceHandler::pgTAP][theory/tap-parser-sourcehandler-pgtap]:
  [Perl][pgtap-perl]
- [nano][]: GNU GPL v3
- [jq][]: [Modified MIT + CC BY 3.0][jq-mit]

This Docker container was developed in part from examples provided by:

- [docker-sqitch] ([MIT][docker-sqitch-mit])
- [theory/tap-parser-sourcehandler-pgtap]: [Perl][pgtap-perl]
- [LREN-CHUV/docker-pgtap]: [Apache 2.0][docker-pgtap-apache]
- [disaykin/pgtap-docker-image]: [BSD 3-Clause][pgtap-docker-image-bsd]

The scripts were developed based on scripts in the above repositories but have
since diverged extensively. For build performance purposes, version-specific
copies of the [pgTAP][] code are kept in `opt/pgtap` and are covered under the
original [pgTAP licence][pgtap-mit].

[disaykin/pgtap-docker-image]: https://github.com/disaykin/pgtap-docker-image
[docker-sqitch-mit]: https://github.com/sqitchers/docker-sqitch/blob/main/LICENSE.md
[docker-sqitch]: https://github.com/sqitchers/docker-sqitch
[lren-chuv/docker-pgtap]: https://github.com/LREN-CHUV/docker-pgtap
[pgtap]: https://pgtap.org
[pgtap-mit]: https://github.com/theory/pgtap#copyright-and-license
[pgtap-perl]: https://github.com/theory/tap-parser-sourcehandler-pgtap/tree/v3.35#copyright-and-licence
[sqitch]: https://sqitch.org
[sqitch-mit]: https://github.com/sqitchers/sqitch/blob/develop/LICENSE.md
[theory/tap-parser-sourcehandler-pgtap]: https://github.com/theory/tap-parser-sourcehandler-pgtap
[alpine linux]: https://alpinelinux.org:
[nano]: https://www.nano-editor.org
[docker-pgtap-apache]: https://github.com/LREN-CHUV/docker-pgtap/blob/master/LICENSE
[pgtap-docker-image-bsd]: https://github.com/disaykin/pgtap-docker-image/blob/master/LICENSE
[jq-mit]: https://github.com/stedolan/jq/blob/master/COPYING
