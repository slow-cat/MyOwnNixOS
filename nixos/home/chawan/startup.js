async () => {
      const MENU_HEIGHT = 15
      const keys = [
        "Up", "Down", "[A", "[B", "[C", "[D",
        "ESC", "C-p", "C-n", "RET", "LF", "C-g"
      ]
      const old = Object.fromEntries(keys.map(k => [k, config.line[k]]))

      const commands = Object.keys(cmd)
        .filter(k => typeof cmd[k] === "function")

      let matches = []
      let selected = 0
      let offset = 0
      let escTimer = null

      function SmithWatermanScore(text, query) {
        if (!query)
          return 0

        text = text.toLowerCase()
        query = query.toLowerCase()

        const MATCH = 2
        const MISMATCH = -1
        const GAP = -1

        const prev = new Int16Array(text.length + 1)
        const curr = new Int16Array(text.length + 1)

        let best = 0

        for (let i = 1; i <= query.length; i++) {
          curr.fill(0)

          for (let j = 1; j <= text.length; j++) {
            const score = query[i - 1] === text[j - 1]
              ? MATCH
              : MISMATCH

            curr[j] = Math.max(
              0,
              prev[j - 1] + score,
              prev[j] + GAP,
              curr[j - 1] + GAP
            )

            if (curr[j] > best)
              best = curr[j]
          }

          prev.set(curr)
        }

        return best || null
      }

      function draw() {
        if (!matches.length) {
          pager.menu = null
          return
        }

        if (selected < offset)
          offset = selected
        else if (selected >= offset + MENU_HEIGHT)
          offset = selected - MENU_HEIGHT + 1

        const visible = matches.slice(offset, offset + MENU_HEIGHT)
        const width = Math.max(20, pager.bufWidth - 6)

        pager.menu = new Select(
          visible.map(x => ("cmd." + x.name).padEnd(width - 2, " ")),
          selected - offset,
          2,
          Math.max(pager.bufHeight - visible.length - 3, 0),
          pager.bufWidth,
          pager.bufHeight,
          () => {}
        )
      }

      function move(n) {
        const next = selected + n

        if (next < 0 || next >= matches.length)
          return

        selected = next
        draw()
      }

      function refresh() {
        const q = line?.text ?? ""

        matches = commands
          .map(name => ({
            name,
            score: SmithWatermanScore(name, q)
          }))
          .filter(x => x.score !== null)
          .sort((a, b) =>
            b.score - a.score ||
            a.name.length - b.name.length ||
            a.name.localeCompare(b.name)
          )

        selected = 0
        offset = 0
        draw()
      }

      function clearEsc() {
        if (escTimer !== null)
          clearTimeout(escTimer)

        escTimer = null
      }

      function csi(fn) {
        return () => {
          if (escTimer === null)
            return

          clearEsc()
          fn()
        }
      }

      try {
        config.line["ESC"] = () => {
          clearEsc()

          escTimer = setTimeout(() => {
            escTimer = null
            pager.menu = null
            line.cancel()
          }, 50)
        }

        config.line["[A"] = csi(() => move(-1))
        config.line["[B"] = csi(() => move(1))
        config.line["[C"] = csi(() => line.forward())
        config.line["[D"] = csi(() => line.backward())

        config.line["C-p"] = () =>
          pager.menu && move(-1)

        config.line["C-n"] = () =>
          pager.menu && move(1)

        config.line["RET"] = () => {
          if (!pager.menu || !matches.length)
            return line.submit()

          const item = matches[selected]

          line.cancel()
          pager.menu = null

          Promise.resolve()
            .then(() => cmd[item.name]())
        }

        config.line["LF"] = config.line["RET"]

        config.line["C-g"] = () => {
          pager.menu = null
          return line.cancel()
        }

        refresh()

        await pager.setLineEdit(
          "command",
          "cmd: ",
          { update: refresh }
        )
      } finally {
        clearEsc()
        pager.menu = null

        for (const k of keys)
          config.line[k] = old[k]
      }
    }
