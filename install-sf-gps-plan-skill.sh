#!/usr/bin/env bash
# install-sf-gps-plan-skill.sh — Installs the sf-gps-plan skill into the current SFDX project
# Usage: curl -sL <url> | bash   OR   bash install-sf-gps-plan-skill.sh
#
# Creates:
#   .agents/skills/sf-gps-plan/SKILL.md
#   .agents/skills/sf-gps-plan/references/completeness-checklist.md
#   .agents/skills/sf-gps-plan/references/plan-template.md

set -euo pipefail

SKILL_DIR=".agents/skills/sf-gps-plan"
REF_DIR="${SKILL_DIR}/references"

# Verify we're in a project root (look for sfdx-project.json or .agents/)
if [[ ! -f "sfdx-project.json" && ! -d ".agents" && ! -d ".claude" ]]; then
  echo "⚠️  No sfdx-project.json, .agents/, or .claude/ found in current directory."
  echo "   Run this from your project root, or pass --force to install anyway."
  [[ "${1:-}" == "--force" ]] || exit 1
fi

mkdir -p "${REF_DIR}"

# ─── SKILL.md ───────────────────────────────────────────────────────────────────
cat > "${SKILL_DIR}/SKILL.md" << 'SKILL_EOF'
---
name: sf-gps-plan
description: >
  Salesforce project planning skill that wraps customer requirements with a
  completeness framework. Ensures plans cover every metadata category including
  Tabs, Lightning Apps, and project scaffolding — blind spots that AI models
  consistently miss. Use before any sf-metadata/sf-flow/sf-deploy work.
license: MIT
metadata:
  version: "1.0.0"
  author: "Gnanasekaran Thoppae"
  scoring: "100 points across 10 categories (scoring system by Jag Valaiyapathy / sf-skills initiative)"
---

# sf-gps-plan: Salesforce Project Planning

Expert Salesforce solution architect that transforms customer requirements into complete, actionable implementation plans. This skill augments the user's prompt with a mandatory completeness framework so no metadata category is missed.

## Why This Skill Exists

AI models consistently miss the same Salesforce project elements when planning:

| Blind Spot | Impact | How Often Missed |
|---|---|---|
| **Custom Tabs** | Objects invisible in App Launcher | 4/4 models |
| **Lightning App** | No app grouping tabs together | 4/4 models |
| **Photo/asset URLs** | Gallery components render blank | 4/4 models |
| **.gitignore** | Credentials and build artifacts committed | 4/4 models |
| **Permission Set assignment** | Fields invisible after deploy | 3/4 models |
| **Screen Flow detail** | Screens undefined, unimplementable | 3/4 models |
| **Field types** | Ambiguous schema, wrong types chosen at build time | 2/4 models |
| **Deploy commands** | Plan can't be executed | 2/4 models |

This skill ensures every plan addresses these items explicitly.

## Core Responsibilities

1. **Requirements Analysis**: Parse customer brief into Salesforce solution components
2. **Completeness Enforcement**: Check plan against mandatory checklist — flag omissions
3. **Skills Mapping**: Map each deliverable to the correct sf-skill
4. **Deploy Sequencing**: Produce correct, copy-paste deployment order
5. **Scoring**: Rate plan completeness (0-100 points)

## Document Map

| Need | Document | Description |
|------|----------|-------------|
| **Completeness checklist** | [references/completeness-checklist.md](references/completeness-checklist.md) | Mandatory items every plan must address |
| **Plan template** | [references/plan-template.md](references/plan-template.md) | Output structure for generated plans |

---

## CRITICAL: This Skill Goes First

```
sf-gps-plan → sf-metadata → sf-flow → sf-deploy → sf-data
  ^
  YOU ARE HERE — planning layer, before any metadata generation
```

sf-gps-plan produces the blueprint. The other skills execute it.

---

## Workflow

### Phase 1: Ingest Requirements

Accept the customer brief. This can be:
- A customer email or message
- A list of requirements
- A verbal description
- An existing spec document

Extract and organize:
- **Who**: Customer name, role, organization
- **What**: Business processes to support
- **Scale**: Record volumes, user counts
- **Wow factor**: Any UI or automation requirements called out
- **Target org**: Alias for all `sf` commands

### Phase 2: Solution Mapping

Map each customer requirement to Salesforce solution components:

| Customer Ask | Solution Component | Skill |
|---|---|---|
| "Track [entity]" | Custom Object + Fields | sf-metadata |
| "Manage [related entity]" | Custom Object + Lookup/MD relationship | sf-metadata |
| "Process [workflow]" | Screen Flow or Record-Triggered Flow | sf-flow |
| "Automate [action]" | Record-Triggered Flow | sf-flow |
| "Online gallery/portal" | LWC + Apex Controller | sf-lwc, sf-apex |
| "Reports/dashboards" | Report Types + Reports | sf-metadata |

### Phase 3: Completeness Check

**Run through the mandatory checklist** (see `references/completeness-checklist.md`). For EVERY item, the plan must either:
- **Include it** with specifics, OR
- **Explicitly exclude it** with a reason (e.g., "No LWC needed — standard UI sufficient")

Items that are silently omitted fail the completeness check.

### Phase 4: Generate Plan

Produce the plan using the template in `references/plan-template.md`. The plan must include:

1. **Data Model** — Every object, every field with type and picklist values
2. **Relationships** — Lookup vs. Master-Detail with rationale
3. **UI Scaffolding** — Tabs, Lightning App, Page Layouts
4. **Security** — Permission Set with CRUD + FLS + Tab visibility
5. **Automation** — Flows with trigger conditions, entry criteria, actions
6. **Apex** — Controllers, test classes, coverage targets
7. **LWC** — Components, wire/imperative, targets
8. **Demo Data** — Record counts per status, realistic values, asset URLs
9. **Deploy Order** — Numbered phases with exact `sf` CLI commands
10. **Project Setup** — .gitignore, sfdx-project.json validation

### Phase 5: Score

Score the plan against the 100-point rubric and report gaps.

---

## Scoring Rubric (100 points)

| Category | Max | What It Measures |
|---|---|---|
| **Data Model** | 15 | Objects, fields with explicit types, picklist values, correct relationship types |
| **UI Scaffolding** | 10 | Custom Tabs for every object, Lightning App, Page Layouts or FlexiPages |
| **Security** | 10 | Permission Set with CRUD + FLS + Tab visibility, perm set assignment command |
| **Automation** | 15 | Flows with trigger type, entry conditions, decision logic, actions |
| **Apex & Tests** | 10 | Controller methods, test class, coverage target (95%+), WITH SECURITY_ENFORCED |
| **LWC** | 10 | Component spec, targets, wire/imperative, accessibility |
| **Demo Data** | 10 | Record counts per status, realistic names, asset URLs for photo fields |
| **Deploy Order** | 10 | Numbered phases, exact CLI commands, --dry-run first, correct dependency order |
| **Project Setup** | 5 | .gitignore, sfdx-project.json, API version |
| **Actionability** | 5 | Can an SE execute this plan without asking clarifying questions? |

### Score Interpretation

| Score | Meaning |
|---|---|
| **90-100** | Production-ready plan. Hand to an SE or AI agent and go. |
| **75-89** | Strong plan. Fill noted gaps before executing. |
| **50-74** | Incomplete. Multiple categories missing or underspecified. |
| **Below 50** | Restart. More a sketch than a plan. |

---

## Cross-Skill Integration

| Skill | How sf-gps-plan Integrates |
|---|---|
| sf-metadata | Plan specifies objects, fields, tabs, apps, perm sets for sf-metadata to generate |
| sf-flow | Plan specifies flow type, trigger, conditions, screens for sf-flow to build |
| sf-apex | Plan specifies controller methods, test class, coverage target |
| sf-lwc | Plan specifies component, targets, data source, UI pattern |
| sf-deploy | Plan produces the exact deploy command sequence |
| sf-data | Plan specifies record counts, distributions, realistic sample values |
| sf-testing | Plan specifies test scenarios and acceptance criteria |

---

## Anti-Patterns

| Anti-Pattern | Why It Fails | What To Do Instead |
|---|---|---|
| "Plan to write a plan" | Deliverable is a spec doc, not actionable metadata guidance | Produce the implementation plan directly |
| Fields without types | "species, breed, age" — is age a Number or Text? | Always specify: `Age_Years__c (Number 3,0)` |
| "Deploy metadata" | Which metadata? In what order? | Numbered phases with `sf project deploy start --source-dir` |
| Lookup for child-owns-parent | Medical records should cascade-delete with their animal | Use Master-Detail when child has no meaning without parent |
| "Create test class" | What methods? What coverage? | Specify methods, assert patterns, 95%+ target |
| Roll-up on Lookup | Standard roll-up summaries require Master-Detail | Use Flow-based roll-up or DLRS for Lookup relationships |
SKILL_EOF

# ─── completeness-checklist.md ──────────────────────────────────────────────────
cat > "${REF_DIR}/completeness-checklist.md" << 'CHECK_EOF'
<!-- Parent: sf-gps-plan/SKILL.md -->
# Salesforce Project Completeness Checklist

Every plan generated by sf-gps-plan MUST address each item below. If intentionally excluded, state why.

---

## 1. Data Model

- [ ] **Custom Objects** listed with labels, plural labels, and Name field type (Text vs. Auto Number)
- [ ] **Fields** with explicit types: Text, Number(precision,scale), Currency, Date, Picklist (with values), Multi-Select Picklist, Checkbox, URL, Email, Phone, Long Text Area, Formula
- [ ] **Relationships** specified as Lookup or Master-Detail with rationale
  - Master-Detail when: child has no meaning without parent, need cascade delete, need roll-up summaries
  - Lookup when: child can exist independently, relationship is optional
- [ ] **Picklist values** listed inline (not "a picklist of statuses" — list the actual values)
- [ ] **Name field strategy** — Will the Name field be meaningful (e.g., "Bella") or Auto Number (e.g., "AN-0001")? Auto Number breaks gallery displays.
- [ ] **Roll-up summaries** — Only on Master-Detail. If you need a count/sum on a Lookup, specify Flow-based roll-up or DLRS.

## 2. UI Scaffolding

- [ ] **Custom Tab** for each custom object (`tabs/Object_Name__c.tab-meta.xml`)
  - Specify tab icon (e.g., `Custom20` for animals, `Custom15` for homes)
- [ ] **Lightning App** grouping all tabs (`applications/App_Name.app-meta.xml`)
  - Include standard tabs (Home, Reports) alongside custom tabs
- [ ] **Page Layouts** or **Lightning Record Pages** (FlexiPages) if non-default layout needed
- [ ] **List Views** for each object (at minimum: "All [Objects]", filtered views by status)

## 3. Security

- [ ] **Permission Set** with:
  - Object CRUD (Create, Read, Update, Delete) for each custom object
  - Field-Level Security (Read, Edit) for every custom field
  - Tab visibility (Available, Visible) for each custom tab
- [ ] **Permission Set assignment command**: `sf org assign permset --name [Name] --target-org [alias]`
- [ ] Permission Set deployed and assigned BEFORE attempting to view records

## 4. Automation

- [ ] **Flow type** specified: Record-Triggered, Screen, Autolaunched, Scheduled, Platform Event-Triggered
- [ ] **Trigger conditions** for Record-Triggered flows:
  - Object
  - When: Create, Update, Create or Update, Delete
  - Entry condition formula (e.g., `Status__c = 'Approved' AND PRIORVALUE(Status__c) != 'Approved'`)
  - Run: Before Save or After Save (with rationale)
- [ ] **Screen Flow detail** for Screen Flows:
  - Number of screens
  - What each screen collects
  - Record queries (Get Records) — what object, what filters
  - Record creation — what object, what field mappings
- [ ] **Actions** after trigger/screen: Create Record, Update Record, Send Email, Post to Chatter

## 5. Apex

- [ ] **Controller class** with method signatures
  - `@AuraEnabled(cacheable=true)` for read methods
  - `@AuraEnabled` for DML methods
  - `WITH SECURITY_ENFORCED` in all SOQL queries
- [ ] **Test class** with:
  - Method list (test each controller method + bulk + negative)
  - Coverage target: 95%+ (state this explicitly)
  - Test data setup via `@TestSetup`
- [ ] **Sharing model** awareness: `with sharing` on controllers

## 6. LWC

- [ ] **Component name** and directory: `force-app/main/default/lwc/componentName/`
- [ ] **Targets** in `.js-meta.xml`: `lightning__AppPage`, `lightning__RecordPage`, `lightning__HomePage`, `lightning__Tab`
- [ ] **Data source**: Wire service (`@wire`) vs. imperative (`import method from '@salesforce/apex/...'`)
- [ ] **SLDS styling** referenced (grid, cards, modals)
- [ ] **Accessibility**: `aria-label`, keyboard navigation, screen reader support

## 7. Demo Data

- [ ] **Record counts** per object
- [ ] **Status distributions** (e.g., "7 Available, 2 In Foster, 2 Adopted, 1 Medical Hold")
- [ ] **Realistic values** — real names, breeds, addresses (not "Test Record 1")
- [ ] **Photo/asset URLs** — if any field stores images, provide placeholder URLs (e.g., Unsplash, placeholder.com)
- [ ] **Relationship data** — records linked across objects (animals assigned to foster homes, applications linked to animals)
- [ ] **Data load order** — parent objects first (Foster_Home before Rescue_Animal)

## 8. Deploy Order

- [ ] **Numbered phases** with exact `sf` CLI commands
- [ ] **Dependency-correct order**:
  1. Objects + Fields (`force-app/main/default/objects`)
  2. Custom Tabs (`force-app/main/default/tabs`)
  3. Lightning App (`force-app/main/default/applications`)
  4. Permission Sets (`force-app/main/default/permissionsets`)
  5. Assign Permission Set (`sf org assign permset`)
  6. Apex Classes (`force-app/main/default/classes`)
  7. Flows as Draft (`force-app/main/default/flows`)
  8. LWC (`force-app/main/default/lwc`)
  9. Activate Flows
  10. Load Data
- [ ] **--dry-run** before each deploy phase
- [ ] **Target org** specified in every command: `--target-org [alias]`

## 9. Project Setup

- [ ] **.gitignore** with standard SFDX entries:
  ```
  # Salesforce
  .sfdx/
  .sf/
  .localdevserver/
  deploy-options.json

  # IDE
  .vscode/
  .idea/

  # OS
  .DS_Store
  Thumbs.db

  # Dependencies
  node_modules/
  ```
- [ ] **sfdx-project.json** validated with correct API version and package directories
- [ ] **API version** stated (e.g., `65.0`) and consistent across all metadata

## 10. Acceptance Criteria

- [ ] **Testable statements** — each criterion is pass/fail, not subjective
- [ ] **End-to-end scenario** — at least one full workflow test (e.g., "submit application → approve → verify animal status = Adopted")
- [ ] **Edge cases** — what happens with duplicate applications, inactive foster homes, zero-capacity scenarios
CHECK_EOF

# ─── plan-template.md ───────────────────────────────────────────────────────────
cat > "${REF_DIR}/plan-template.md" << 'TMPL_EOF'
<!-- Parent: sf-gps-plan/SKILL.md -->
# Salesforce Implementation Plan Template

Use this structure for every plan generated by sf-gps-plan. Every section is mandatory — if not applicable, state why.

---

```markdown
# [Project Name] — Salesforce Implementation Plan

**Customer:** [Name, Role, Organization]
**Target org:** `[alias]` ([username])
**API Version:** [e.g., 65.0]
**Date:** [YYYY-MM-DD]
**Scale:** [record volumes, user counts]

---

## 1. Requirements Summary

| Customer Ask | Solution Component | Skill |
|---|---|---|
| [requirement] | [object/flow/lwc] | [sf-skill] |

---

## 2. Data Model

### [Object_Name__c]

| Field API Name | Type | Details |
|---|---|---|
| Name | Text / AutoNumber | [format if AutoNumber] |
| Field_1__c | Picklist | Values: Val1, Val2, Val3 |
| Field_2__c | Currency(16,2) | |
| Field_3__c | Lookup(Other_Object__c) | [rationale] |

### Relationships

| Child | Parent | Type | Rationale |
|---|---|---|---|
| [child] | [parent] | Master-Detail / Lookup | [why] |

---

## 3. UI Scaffolding

### Custom Tabs

| Object | Tab File | Icon |
|---|---|---|
| [Object__c] | `tabs/[Object__c].tab-meta.xml` | Custom[N] |

### Lightning App

| App Name | File | Tabs Included |
|---|---|---|
| [App] | `applications/[App].app-meta.xml` | Home, [tabs], Reports |

### List Views

| Object | View Name | Filter |
|---|---|---|
| [Object__c] | [View] | [filter or none] |

---

## 4. Security

### Permission Set: [Name]

**File:** `permissionsets/[Name].permissionset-meta.xml`

| Object | Create | Read | Update | Delete |
|---|---|---|---|---|
| [Object__c] | Yes | Yes | Yes | Yes |

**FLS:** All custom fields → Read + Edit
**Tab Visibility:** All custom tabs → Available, DefaultOn

**Assignment:**
```bash
sf org assign permset --name [Name] --target-org [alias]
```

---

## 5. Automation

### Record-Triggered Flow: [API_Name]

| Property | Value |
|---|---|
| Type | Record-Triggered |
| Object | [Object__c] |
| Trigger | After Update |
| Entry Condition | [formula] |
| Action | [description] |

### Screen Flow: [API_Name]

| Screen | Purpose | Elements |
|---|---|---|
| Screen 1 | [purpose] | [inputs] |
| Screen 2 | [purpose] | [Get Records + choice] |
| Screen 3 | [purpose] | [summary + Create Record] |

---

## 6. Apex

### [Controller].cls

| Method | Signature | Description |
|---|---|---|
| [method] | `@AuraEnabled(cacheable=true) static [return] [name]([params])` | [description] |

### [Controller]Test.cls

| Test Method | Scenario | Coverage Target |
|---|---|---|
| [method] | [scenario] | 95%+ |

---

## 7. LWC

### [componentName]

**Directory:** `force-app/main/default/lwc/[componentName]/`

| File | Purpose |
|---|---|
| [component].html | [layout] |
| [component].js | [data + handlers] |
| [component].css | [styles] |
| [component].js-meta.xml | Targets: [targets] |

---

## 8. Demo Data

### Record Counts

| Object | Total | Distribution |
|---|---|---|
| [Object__c] | [N] | [per-status breakdown] |

### Sample Records

| Name | [Key Fields] | Photo_URL__c |
|---|---|---|
| [realistic name] | [values] | [placeholder URL] |

### Data Load Order
1. [Parent objects first]
2. [Then children]

---

## 9. Deploy Order

```bash
# Phase 1: Objects + Fields
sf project deploy start --dry-run --source-dir force-app/main/default/objects --target-org [alias]
sf project deploy start --source-dir force-app/main/default/objects --target-org [alias]

# Phase 2: Tabs
sf project deploy start --source-dir force-app/main/default/tabs --target-org [alias]

# Phase 3: Lightning App
sf project deploy start --source-dir force-app/main/default/applications --target-org [alias]

# Phase 4: Permission Set + Assign
sf project deploy start --source-dir force-app/main/default/permissionsets --target-org [alias]
sf org assign permset --name [PermSetName] --target-org [alias]

# Phase 5: Apex
sf project deploy start --source-dir force-app/main/default/classes --target-org [alias] --test-level RunLocalTests

# Phase 6: Flows
sf project deploy start --source-dir force-app/main/default/flows --target-org [alias]

# Phase 7: LWC
sf project deploy start --source-dir force-app/main/default/lwc --target-org [alias]

# Phase 8: Data
sf apex run --file scripts/seed-data.apex --target-org [alias]
```

---

## 10. Project Setup

### .gitignore
```
.sfdx/
.sf/
.localdevserver/
deploy-options.json
.vscode/
.idea/
.DS_Store
Thumbs.db
node_modules/
```

### API Version
All metadata files use API version `[XX.0]`.

---

## 11. Acceptance Criteria

| # | Criterion | How to Verify |
|---|---|---|
| 1 | [testable statement] | [verification steps] |

---

## Plan Score: [XX] / 100

| Category | Score | Notes |
|---|---|---|
| Data Model | /15 | |
| UI Scaffolding | /10 | |
| Security | /10 | |
| Automation | /15 | |
| Apex & Tests | /10 | |
| LWC | /10 | |
| Demo Data | /10 | |
| Deploy Order | /10 | |
| Project Setup | /5 | |
| Actionability | /5 | |
```
TMPL_EOF

echo ""
echo "✅ sf-gps-plan skill installed:"
echo "   ${SKILL_DIR}/SKILL.md"
echo "   ${REF_DIR}/completeness-checklist.md"
echo "   ${REF_DIR}/plan-template.md"
echo ""
echo "Usage: Ask your AI assistant to plan a Salesforce project."
echo "       It will read the checklist and template automatically."
echo ""
echo "Optional: Add this to your CLAUDE.md or .cursorrules:"
echo '  ## Salesforce Project Planning'
echo '  When creating a Salesforce implementation plan, always read'
echo '  `.agents/skills/sf-gps-plan/references/completeness-checklist.md` first.'
