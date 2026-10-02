import { expect, test } from 'claude-code/testing'

const SURFACES = ['terminal', 'desktop'] as const

const texts = (node: unknown): string[] => {
  if (typeof node === 'string') return [node]
  if (typeof node !== 'object' || node === null) return []
  const children = (node as { children?: unknown[] }).children ?? []
  return children.flatMap(texts)
}

test('every restyled site draws a tree both surfaces accept', async ($, on) => {
  on('ui.render', () => ({ type: 'engine', ref: 0 }))

  for (const surface of SURFACES) {
    const prompt = await $.ui.mount({
      plugin: 'midnight-sun', surface, component: 'UserMessage',
      props: { text: 'restyle it like midnight sun', origin: { kind: 'composer' }, isExpanded: false },
    })
    expect(texts(await prompt.drawn()).join('')).toContain('☀ restyle it like midnight sun')

    const reply = await $.ui.mount({
      plugin: 'midnight-sun', surface, component: 'AssistantMessage',
      props: { text: 'Done. **It works.**', isFirstOfReply: true },
    })
    expect(texts(await reply.drawn()).join('')).toContain('✦')

    const tool = await $.ui.mount({
      plugin: 'midnight-sun', surface, component: 'ToolUse',
      props: { tool_use_id: `t-${surface}`, tool: 'Bash', input: { command: 'ls -la\n  ~/Projects' }, isRunning: false, isErrored: false, isInterrupted: false },
    })
    expect(texts(await tool.drawn()).join('')).toBe('◆ Bash  ls -la ~/Projects')
  }

  const done = await $.ui.mount({
    plugin: 'midnight-sun', surface: 'terminal', component: 'TurnDuration',
    props: { word: 'Baked', durationMs: 64000 },
  })
  expect(texts(await done.drawn()).join('')).toMatch(/^✧ \w+ for 1m 4s$/)

  const notice = await $.ui.mount({
    plugin: 'midnight-sun', surface: 'terminal', component: 'InfoNotice',
    props: { text: 'Using Opus', command: '/model' },
  })
  expect(texts(await notice.drawn()).join('')).toBe('Using Opus /model')
})

test('a group unfolded inline keeps the engine row for its calls', async ($, on) => {
  on('ui.render', () => ({ type: 'engine', ref: 0 }))
  const call = { tool_use_id: 'g1', tool: 'Read', input: { file_path: '/tmp/x' }, isRunning: false, isErrored: false }
  await $.ui.mount({
    plugin: 'midnight-sun', surface: 'terminal', component: 'ToolGroup',
    props: { calls: [call], isActive: false, isExpanded: true },
  })
  const row = await $.ui.mount({
    plugin: 'midnight-sun', surface: 'terminal', component: 'ToolUse',
    props: { ...call, isInterrupted: false, output: { file: {} } },
  })
  expect((await row.drawn()).type).toBe('engine')
})
