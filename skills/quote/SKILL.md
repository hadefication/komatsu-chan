---
name: quote
description: Random motivational or sarcastic quote — because sometimes you need one at 2am. Use when the user says "quote", "inspire me", "motivate me", "give me a quote", or "/quote".
---

# Quote

Serve up a quote. Sometimes motivational, sometimes sarcastic, always timely.

## Usage

```
/quote [vibe]
```

- No args — random quote matching the current mood/personality
- `<vibe>` — request a specific vibe: `motivational`, `sarcastic`, `dev`, `stoic`, `chaotic`

## Vibes

| Vibe | Style |
|------|-------|
| `motivational` | Genuinely inspiring, no irony |
| `sarcastic` | Dry, witty, "motivational" in air quotes |
| `dev` | Programming humor and wisdom |
| `stoic` | Marcus Aurelius energy — calm, grounded |
| `chaotic` | Unhinged wisdom that somehow makes sense |

## Execution

### 1. Determine the vibe

- If a vibe was specified, use it
- If a mood is set (`~/.config/komatsu-chan/mood.txt`), match the mood:
  - hyped → motivational
  - chill → stoic
  - snarky → sarcastic
  - serious → stoic
  - chaotic → chaotic
  - mentor → motivational
  - speedrun → dev
- Otherwise, pick randomly based on personality settings

### 2. Generate the quote

Generate a quote that fits the vibe. Mix from these sources:

**Real quotes** (prefer these — attribute properly):
- Programming: Knuth, Dijkstra, Thompson, Pike, Torvalds, etc.
- Stoic: Marcus Aurelius, Seneca, Epictetus
- General: whatever fits

**Original komatsu-chan quotes** (for sarcastic/chaotic/dev vibes):
- Written in komatsu-chan's voice
- Tied to dev life
- e.g., "The best code is the code you didn't have to debug at 3am."

### 3. Present it

Format as a quote block:

```
  "The best error message is the one that never shows up."
  — Thomas Fuchs
```

For komatsu-chan originals:
```
  "Your code doesn't need more comments. It needs fewer decisions at 2am."
  — komatsu-chan
```

## Guidelines

- Keep it to one quote per invocation
- Don't over-explain or add commentary — let the quote land
- Make sure attributed quotes are real (don't fabricate attributions)
- For original quotes, they should be genuinely clever, not generic
- Match the energy of the session — if the user just fixed a brutal bug, maybe something triumphant; if they're starting fresh, something energizing
