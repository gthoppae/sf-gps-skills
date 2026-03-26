# sf-gps-plan

A Salesforce project planning skill for AI-assisted vibe coding demos. Ensures AI models don't miss common blind spots (Custom Tabs, Lightning Apps, Permission Set assignment, deploy order) when generating Salesforce implementation plans.

**Origin:** GPS OU, EMEA NGO team
**Author:** Gnanasekaran Thoppae
**Scoring system:** Jag Valaiyapathy / sf-skills initiative

## Install

From your SFDX project root:

```bash
bash install-sf-gps-plan-skill.sh
```

Or install remotely:

```bash
curl -sL <raw-url-to-script> | bash
```

### What it creates

```
.agents/skills/sf-gps-plan/
  SKILL.md                              # Skill definition + scoring rubric
  references/
    completeness-checklist.md           # 10-category mandatory checklist
    plan-template.md                    # Output structure for generated plans
```

## Prerequisites

- An SFDX project directory (has `sfdx-project.json`), or pass `--force` to install anywhere
- An AI coding assistant that reads `.agents/skills/` (Claude Code, Cursor, etc.)

## Usage

After installing, ask your AI assistant to plan a Salesforce project. It will automatically read the checklist and score the plan against a 100-point rubric across 10 categories:

| Category | Points |
|---|---|
| Data Model | 15 |
| Automation | 15 |
| UI Scaffolding | 10 |
| Security | 10 |
| Apex & Tests | 10 |
| LWC | 10 |
| Demo Data | 10 |
| Deploy Order | 10 |
| Project Setup | 5 |
| Actionability | 5 |

### Optional: wire it into your project config

Add to `CLAUDE.md` or `.cursorrules`:

```markdown
## Salesforce Project Planning
When creating a Salesforce implementation plan, always read
`.agents/skills/sf-gps-plan/references/completeness-checklist.md` first.
```

## Why this exists

AI models consistently miss the same things when planning Salesforce projects:

- Custom Tabs (4/4 models miss them)
- Lightning App grouping tabs (4/4)
- Photo/asset URLs for gallery components (4/4)
- .gitignore (4/4)
- Permission Set assignment commands (3/4)
- Screen Flow detail (3/4)

This skill injects a completeness framework so plans are actionable on first pass.
