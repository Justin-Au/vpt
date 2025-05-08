# 🏐 Volleyball Player Tracker App — Specification

## 📘 Overview

A multi-tenant web app to track volleyball team and player performance over time. Users can log detailed match events, manage team structures, and export data for analysis. A mobile app may be added later.

---

## 📂 Table of Contents

1. [User Roles](#user-roles)
2. [Entities & Relationships](#entities--relationships)
3. [Functional Requirements](#functional-requirements)
4. [Data Model Overview](#data-model-overview)
5. [Technical Architecture](#technical-architecture)
6. [Authentication & Authorization](#authentication--authorization)
7. [Data Handling](#data-handling)
8. [Export & Backup](#export--backup)
9. [Error Handling](#error-handling)
10. [Testing Plan](#testing-plan)

---

## 👥 User Roles

- **Coach**: Full edit access to players, matches, lineups, and roles.
- **Player**: View-only access.
- **Analyst**: Edit match lineups and matches + can record match events.
- **Owner**: Own a team with full access.
- A user may have **multiple roles**.

---

## 🧩 Entities & Relationships

- **User**

  - Owns or belongs to a **Team**

- **Team**

  - Contains **Sub-teams** (e.g., age/gender divisions)
  - Has multiple **Seasons**

- **Season**

  - Has multiple **Matches**

- **Match**

  - Includes **Lineups**, **Events**, **Scores**, **Substitutions**

- **Player**
  - Belongs to one Team
  - Can be moved across sub-teams
  - Has individual performance records per match

---

## ✅ Functional Requirements

### Team & User Management

- Users register with **email/password**
- Users can:
  - **Create a new team** (become owner)
  - **Invite others** (via email or link) to join a team
  - Assign/edit roles during or after invitation
  - Accept/reject team invitations

### Player Management

Each Player has:

- `name`, `nickname`, `dob`, `jersey_number`, `height`, `position`, `handedness` `(L/R)`, `active`, `notes`
- Editable by Coaches and Analysts

### Match Tracking

**Match metadata:**

- `date`, `opponent_name`, `location`, `match_type`, `final_score`, `set_scores`

**Team Event-level tracking:**

- **Attacks**: pass origin → setter location + quality → attacker → outcome + ball landing location
- **Serves**: player → origin/destination → outcome
- **Defenses**: blockers → location → outcome of opponent attack

**Opponent Event-level tracking:**

- **Attacks**: pass origin → setter location + quality → attacker → outcome + ball landing location
- **Serves**: player → origin/destination → outcome
- **Defenses**: blockers → location → outcome of opponent attack

**Lineup Input:**

- Starting lineup with positions
- Substitutes and timing
- Rotations
- Libero assignment

### Data Export

- CSV Export:
  - By match
  - By season
  - Full team histor

---

## 🧱 Data Model Overview (Simplified)

```prisma
model User {
  id           String   @id @default(uuid())
  email        String   @unique
  passwordHash String
  roles        Role[]
  teamId       String?
  team         Team?    @relation(fields: [teamId], references: [id])
}

model Team {
  id         String   @id @default(uuid())
  name       String
  ownerId    String
  subTeams   SubTeam[]
  players    Player[]
  seasons    Season[]
}

model SubTeam {
  id       String   @id @default(uuid())
  name     String
  teamId   String
  players  Player[]
}

model Player {
  id           String   @id @default(uuid())
  name         String
  nickname     String?
  dateOfBirth  DateTime
  jerseyNumber Int
  height       Float
  position     String
  handedness   String
  active       Boolean
  notes        String?
  teamId       String
  subTeamId    String?
}

model Season {
  id      String   @id @default(uuid())
  name    String
  teamId  String
  matches Match[]
}

model Match {
  id         String   @id @default(uuid())
  seasonId   String
  opponent   String
  location   String
  date       DateTime
  matchType  String
  setScores  Json
  finalScore String
  events     MatchEvent[]
}

model MatchEvent {
  id       String   @id @default(uuid())
  matchId  String
  type     String   // "attack", "serve", "defense"
  data     Json     // dynamic based on type
}
```
