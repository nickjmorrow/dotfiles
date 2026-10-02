import type { Register } from 'claude-code'

// Colours from dotfiles/themes/midnight-sun/palette.json.
const NAVY700 = '#22304f'
const TEXT = '#e3e8f2'
const BRIGHT = '#f4f6fb'
const DIM = '#9aa8c2'
const FAINT = '#6b7a96'
const SUN = '#ffcc33'
const VIOLET = '#c792ea'
const RED = '#ff6b6b'

const WORDS = ['Basking', 'Glowing', 'Shimmering', 'Radiating', 'Gleaming', 'Sunning', 'Dawning', 'Kindling', 'Beaming', 'Daydreaming', 'Lingering', 'Brightening']
const PAST = ['Shone', 'Glowed', 'Beamed', 'Basked', 'Gleamed', 'Radiated']

const pick = (list: string[], seed: string) => {
  let hash = 0
  for (const ch of seed) hash = (hash * 31 + ch.charCodeAt(0)) >>> 0
  return list[hash % list.length]
}

const duration = (ms: number) => {
  const s = Math.max(1, Math.round(ms / 1000))
  return s < 60 ? `${s}s` : `${Math.floor(s / 60)}m ${s % 60}s`
}

// The one-line summary a tool row shows after the tool's name.
const argOf = (tool: string, input: unknown) => {
  if (typeof input !== 'object' || input === null) return ''
  const i = input as Record<string, unknown>
  const keys = ['command', 'file_path', 'pattern', 'url', 'query', 'description', 'skill', 'prompt', 'path']
  const key = keys.find(k => typeof i[k] === 'string') ?? Object.keys(i).find(k => typeof i[k] === 'string')
  const value = key ? String(i[key]) : ''
  return (tool === 'Read' || tool === 'Edit' || tool === 'Write' ? value.replace(/^\/Users\/[^/]+/, '~') : value)
    .replace(/\s+/g, ' ')
    .trim()
}

const clip = (text: string, width: number) => (text.length > width ? `${text.slice(0, Math.max(0, width - 1))}…` : text)

export const register: Register = on => {
  // Calls in an unfolded group draw their output inline; those keep the engine's row.
  const unfolded = new Set<string>()

  on('ui.render', { component: 'UserMessage' }, ($, e, next) => {
    if ((e.surface !== 'terminal' && e.surface !== 'desktop') || e.props.origin.kind !== 'composer') return next(e)
    const { Box, Text } = $.ui.resolve(e)

    return (
      <Box flexDirection="row" marginTop={1} backgroundColor={NAVY700} paddingRight={1}>
        <Text color={SUN} backgroundColor={NAVY700} bold>
          {'☀ '}
        </Text>
        <Box flexGrow={1} flexShrink={1}>
          <Text color={BRIGHT} backgroundColor={NAVY700}>
            {e.props.text}
          </Text>
        </Box>
      </Box>
    )
  })

  on('ui.render', { component: 'AssistantMessage' }, ($, e, next) => {
    if (e.surface !== 'terminal' && e.surface !== 'desktop') return next(e)
    const { Box, Text, Markdown } = $.ui.resolve(e)

    return (
      <Box flexDirection="row" marginTop={1}>
        <Box width={2} flexShrink={0}>
          <Text color={SUN}>{e.props.isFirstOfReply ? '✦' : ' '}</Text>
        </Box>
        <Box flexGrow={1} flexShrink={1} flexDirection="column">
          <Markdown text={e.props.text} />
        </Box>
      </Box>
    )
  })

  on('ui.render', { component: 'ToolGroup' }, async ($, e, next) => {
    if (e.props.isExpanded) for (const call of e.props.calls) if (call.tool_use_id) unfolded.add(call.tool_use_id)
    if (e.props.isExpanded || e.surface !== 'terminal') return next(e)
    const { Box, Text } = $.ui.resolve(e)
    const isErrored = e.props.calls.some(call => call.isErrored)

    // The engine's line keeps its own blank bullet column; the mark is laid over it.
    return (
      <Box flexDirection="column">
        {await next(e)}
        <Box position="absolute" bottom={0} left={0}>
          <Text color={isErrored ? RED : e.props.isActive ? SUN : VIOLET}>{e.props.isActive ? '◇' : '◆'}</Text>
        </Box>
      </Box>
    )
  })

  on('ui.render', { component: 'ToolUse' }, ($, e, next) => {
    if ((e.surface !== 'terminal' && e.surface !== 'desktop') || unfolded.has(e.props.tool_use_id)) return next(e)
    const { Box, Text } = $.ui.resolve(e)
    const { tool, isRunning, isErrored, isInterrupted } = e.props
    const glyph = isRunning ? '◇' : '◆'
    const mark = isErrored ? RED : isRunning ? SUN : VIOLET
    const columns = e.viewport?.columns ?? 100
    const arg = clip(argOf(tool, e.props.input), columns - tool.length - 8)
    const parts = [
      <Text color={mark}>{`${glyph} `}</Text>,
      <Text color={isErrored ? RED : VIOLET} bold>
        {tool}
      </Text>,
    ]
    if (arg) parts.push(<Text color={DIM}>{`  ${arg}`}</Text>)
    if (isInterrupted) parts.push(<Text color={FAINT}>{'  · interrupted'}</Text>)

    return (
      <Box flexDirection="row" marginTop={1}>
        {parts}
      </Box>
    )
  })

  on('ui.render', { component: 'Spinner' }, ($, e, next) =>
    e.surface === 'terminal' ? next({ ...e, props: { ...e.props, word: pick(WORDS, e.props.word) } }) : next(e),
  )

  on('ui.render', { component: 'TurnDuration' }, ($, e, next) => {
    if (e.surface !== 'terminal') return next(e)
    const { Box, Text } = $.ui.resolve(e)

    return (
      <Box marginTop={1}>
        <Text color={FAINT}>
          {'✧ '}
          {`${pick(PAST, `${e.props.word}${e.props.durationMs}`)} for ${duration(e.props.durationMs)}`}
        </Text>
      </Box>
    )
  })

  on('ui.render', { component: 'InfoNotice' }, ($, e, next) => {
    if (e.surface !== 'terminal') return next(e)
    const { Box, Text } = $.ui.resolve(e)
    const parts = [<Text color={FAINT}>{e.props.text}</Text>]
    if (e.props.command) parts.push(<Text color={SUN}>{` ${e.props.command}`}</Text>)

    return <Box flexDirection="row">{parts}</Box>
  })
}
