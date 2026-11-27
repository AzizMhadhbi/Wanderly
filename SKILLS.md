# Installed skills

Skills are copied into `.opencode/skills/` and auto-discovered by OpenCode. They are
**instructions, not code** — they steer how the agent plans, implements and verifies
the Wanderly project. All upstream sources are MIT or similarly permissive.

| Skill | Source repo | Commit | Why it is here |
|---|---|---|---|
| `spec-driven-development` | addyosmani/agent-skills | `e997ac5` | Keep the spec authoritative over code |
| `planning-and-task-breakdown` | addyosmani/agent-skills | `e997ac5` | Ordered, implementable tasks |
| `incremental-implementation` | addyosmani/agent-skills | `e997ac5` | Thin verifiable slices, one commit each |
| `writing-plans` | obra/superpowers | `22f0b46` | Durable plan files |
| `executing-plans` | obra/superpowers | `22f0b46` | Inline plan execution |
| `test-driven-development` | addyosmani/agent-skills | `e997ac5` | Red-green-refactor for logic and models |
| `verification-before-completion` | obra/superpowers | `22f0b46` | Evidence before claiming "done" |
| `code-review-and-quality` | addyosmani/agent-skills | `e997ac5` | Review gate before each commit |
| `systematic-debugging` | obra/superpowers | `22f0b46` | Root cause before fixes |
| `source-driven-development` | addyosmani/agent-skills | `e997ac5` | Verify Flutter APIs against official docs |
| `context-engineering` | addyosmani/agent-skills | `e997ac5` | Keep sessions coherent across compaction |
| `documentation-and-adrs` | addyosmani/agent-skills | `e997ac5` | Record architecture decisions |
| `frontend-design` | anthropics/skills | `e4bb5d9` | Distinctive aesthetic direction for the UI |
| `ui-ux-pro-max` | nextlevelbuilder/ui-ux-pro-max-skill | `3442615` | Mobile UI/UX guidelines and patterns |
| `design-system` | nextlevelbuilder/ui-ux-pro-max-skill | `3442615` | Three-layer token architecture |

Deliberately **not** installed: `ui-styling` (Tailwind/shadcn — irrelevant to Flutter),
`analytics`, `cro`, `customer-research`, `api-and-interface-design`,
`security-and-hardening`, `subagent-driven-development`.

## Refresh a skill

The upstream clones remain in the original toolchain workspace. Re-copy a directory
containing `SKILL.md` into `.opencode/skills/<id>` and update the commit in the table.

## Add another

1. Clone the upstream repo.
2. Copy the skill directory (the one containing `SKILL.md`) into `.opencode/skills/<id>`.
3. Add a row to the table above.
