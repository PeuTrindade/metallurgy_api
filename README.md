# ⚙️ Metallurgy API

A **Ruby on Rails 7 REST API** designed to manage metallurgical production workflows. The system enables companies to track parts, define process flows and steps, register inspections, and automatically generate AI-powered technical reports using OpenAI's GPT-3.5.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Data Model](#data-model)
- [API Endpoints](#api-endpoints)
  - [Authentication](#authentication)
  - [User Profile](#user-profile)
  - [Flows](#flows)
  - [Steps Flow (Templates)](#steps-flow-templates)
  - [Parts](#parts)
  - [Steps](#steps)
  - [Inspections](#inspections)
  - [Comments](#comments)
  - [Suggestions](#suggestions)
  - [Reports](#reports)
- [Authentication & Authorization](#authentication--authorization)
- [AI Report Generation](#ai-report-generation)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Environment Variables](#environment-variables)
  - [Database Setup](#database-setup)
  - [Running the Server](#running-the-server)
- [Contributing](#contributing)

---

## Overview

The Metallurgy API is built for metallurgy companies that need to:

- Define **production flows** with reusable step templates
- Register and track **parts** (metallic pieces) through each stage of processing
- Log **start/end dates**, descriptions, and images per step
- Perform and record **final inspections**
- Add **comments and suggestions** to each part
- Generate structured, **AI-written technical reports** (in Portuguese) that include an introduction, process specifications, and a final inspection narrative

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Ruby 3.3.0 |
| Framework | Rails 7.1.3 (API mode) |
| Database | MySQL 2 (via `mysql2` gem) |
| Authentication | JWT (`jwt` gem) + BCrypt (`bcrypt`) |
| HTTP Client | HTTParty |
| AI Integration | OpenAI GPT-3.5-turbo |
| File Uploads | Active Storage |
| CORS | `rack-cors` |
| Web Server | Puma |
| Environment | `dotenv-rails` |

---

## Features

- **JWT Authentication** — register, login, and token validation with 24-hour expiry
- **Production Flows** — define named workflows that act as templates for parts processing
- **Step Templates (StepsFlow)** — pre-define the steps that will be automatically assigned to any new part created under a flow
- **Parts Management** — register parts with name, tag, hiring company, description, and images; steps, inspection, comment, and suggestion records are auto-created on part creation
- **Step Tracking** — update each step's start/end dates, description, and images as work progresses
- **Final Inspections** — record the final quality inspection for each part
- **Comments & Suggestions** — annotate parts with additional notes or improvement suggestions
- **AI Report Generation** — produce professional, formal technical reports with three sections: introduction, process specifications, and final inspection narrative
- **Image Support** — Active Storage integration for attaching images to parts and steps

---

## Data Model

```
User
 ├── has_many :flows
 ├── has_many :steps
 ├── has_many :parts
 ├── has_many :steps_flows
 ├── has_many :inspections
 ├── has_many :comments
 └── has_many :suggestions

Flow
 ├── belongs_to :user
 ├── has_many :steps_flows   (template steps)
 └── has_many :parts

Part
 ├── belongs_to :user
 ├── belongs_to :flow
 ├── has_many :steps
 ├── has_one :inspection
 ├── has_one :comment
 └── has_one :suggestion

Step
 ├── belongs_to :user
 ├── belongs_to :flow
 └── belongs_to :part (optional)

StepsFlow  (template step — belongs to a flow, not a part)
 ├── belongs_to :user
 └── belongs_to :flow

Inspection / Comment / Suggestion
 ├── belongs_to :user
 ├── belongs_to :flow
 └── belongs_to :part
```

> **Important:** When a Part is created, the API automatically creates its associated Inspection, Comment, and Suggestion records and replicates all StepsFlow templates of the parent Flow as concrete Step records for that Part.

---

## API Endpoints

> All protected routes require the `Authorization: Bearer <token>` header.

### Authentication

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|---|
| `POST` | `/register` | ❌ | Create a new user account |
| `POST` | `/login` | ❌ | Authenticate and receive a JWT token |
| `POST` | `/me` | ❌ | Validate a JWT token and return the user data |

**POST /register — Request Body**
```json
{
  "email": "user@company.com",
  "fullName": "John Doe",
  "cnpj": 12345678000190,
  "password": "yourpassword"
}
```

**POST /login — Request Body**
```json
{
  "email": "user@company.com",
  "password": "yourpassword"
}
```

**POST /me — Request Body**
```json
{
  "token": "your.jwt.token"
}
```

---

### User Profile

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|---|
| `PUT` | `/profile` | ✅ | Update user profile fields |

**PUT /profile — Permitted Fields:** `fullName`, `image`, `cityId`, `stateId`, `address`, `zipcode`

---

### Flows

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|---|
| `GET` | `/flows` | ✅ | List all flows for the current user |
| `GET` | `/flow/:id` | ✅ | Get a specific flow (includes its step templates) |
| `POST` | `/flow` | ✅ | Create a new flow |
| `PUT` | `/flow/:id` | ✅ | Update a flow |
| `DELETE` | `/flow/:id` | ✅ | Delete a flow |

**POST /flow — Request Body**
```json
{
  "flow": {
    "name": "Steel Pipe Finishing",
    "description": "Full finishing process for steel pipes"
  }
}
```

---

### Steps Flow (Templates)

Template steps that are automatically replicated to new parts created under the same flow.

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|---|
| `GET` | `/steps_flow` | ✅ | List all step templates for the current user |
| `GET` | `/steps_flow/:id` | ✅ | Get a specific step template |
| `GET` | `/steps_flow/flow/:flow_id` | ✅ | List step templates for a given flow |
| `POST` | `/steps_flow` | ✅ | Create a step template |
| `PUT` | `/steps_flow/:id` | ✅ | Update a step template |
| `DELETE` | `/steps_flow/:id` | ✅ | Delete a step template |

**POST /steps_flow — Request Body**
```json
{
  "steps_flow": {
    "name": "Surface Cleaning",
    "flow_id": 1
  }
}
```

---

### Parts

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|---|
| `GET` | `/parts` | ✅ | List all parts for the current user |
| `GET` | `/part/:id` | ✅ | Get a part with steps, inspection, comment, and suggestion |
| `GET` | `/parts/flow/:flow_id` | ✅ | List all parts under a specific flow |
| `POST` | `/part` | ✅ | Create a part (auto-creates steps, inspection, comment, suggestion) |
| `PUT` | `/part/:id` | ✅ | Update a part |
| `DELETE` | `/part/:id` | ✅ | Delete a part |

**POST /part — Request Body**
```json
{
  "part": {
    "name": "Shaft Coupling",
    "tag": "SC-001",
    "hiringCompany": "Acme Steel",
    "description": "Carbon steel shaft coupling for industrial pump",
    "flow_id": 1,
    "images": ["<file>"]
  }
}
```

---

### Steps

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|---|
| `GET` | `/steps` | ✅ | List all steps for the current user |
| `GET` | `/step/:id` | ✅ | Get a specific step |
| `GET` | `/steps/flow/:flow_id` | ✅ | List steps by flow |
| `GET` | `/steps/part/:part_id` | ✅ | List steps by part |
| `POST` | `/step` | ✅ | Create a step manually |
| `PUT` | `/step/:id` | ✅ | Update a step (e.g., add dates, description, image) |
| `DELETE` | `/step/:id` | ✅ | Delete a step |

**PUT /step/:id — Request Body**
```json
{
  "step": {
    "startDate": "2025-01-10T08:00:00",
    "finishDate": "2025-01-12T17:00:00",
    "description": "Surface cleaned using sandblasting method.",
    "image": "<file>"
  }
}
```

---

### Inspections

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|---|
| `GET` | `/inspection/:id` | ✅ | Get a specific inspection |
| `POST` | `/inspection` | ✅ | Create an inspection manually |
| `PUT` | `/inspection/:id` | ✅ | Update an inspection |
| `DELETE` | `/inspection/:id` | ✅ | Delete an inspection |

**PUT /inspection/:id — Request Body**
```json
{
  "inspection": {
    "description": "Final inspection completed. No cracks detected under ultrasonic testing.",
    "image": "<file>"
  }
}
```

---

### Comments

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|---|
| `GET` | `/comment/:id` | ✅ | Get a specific comment |
| `POST` | `/comment` | ✅ | Create a comment |
| `PUT` | `/comment/:id` | ✅ | Update a comment |
| `DELETE` | `/comment/:id` | ✅ | Delete a comment |

---

### Suggestions

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|---|
| `GET` | `/suggestion/:id` | ✅ | Get a specific suggestion |
| `POST` | `/suggestion` | ✅ | Create a suggestion |
| `PUT` | `/suggestion/:id` | ✅ | Update a suggestion |
| `DELETE` | `/suggestion/:id` | ✅ | Delete a suggestion |

---

### Reports

| Method | Endpoint | Auth Required | Description |
|--------|----------|:---:|---|
| `POST` | `/report/:id` | ✅ | Generate an AI-powered technical report for a part |

The report is generated asynchronously using parallel HTTP requests (via Ruby threads) to fetch part and step data, then calls OpenAI GPT-3.5-turbo to produce three text sections.

**POST /report/:id — Response**
```json
{
  "intro": "...",
  "specifications": "...",
  "inspection": "...",
  "comments": "...",
  "suggestions": "..."
}
```

---

## Authentication & Authorization

- Passwords are hashed using **BCrypt** (`has_secure_password`)
- On login/register, a **JWT token** is issued with a **24-hour expiry**, signed with `HS256` using the application's `secret_key_base`
- All protected routes use a `before_action :authorize_request` filter that decodes the token from the `Authorization: Bearer <token>` header
- Resources (parts, steps, flows, etc.) are always scoped to `current_user`, ensuring users can only access their own data

---

## AI Report Generation

The `ReportsController` orchestrates AI report generation by:

1. Fetching the **part data** and its **steps** in parallel using Ruby threads and HTTParty (calling the API itself internally via `ENV['API_BASE_URL']`)
2. Sending three separate prompts to **OpenAI GPT-3.5-turbo** via the `OpenAIService`:
   - **Introduction** — a formal, technical paragraph (500+ words) contextualizing the part and the service performed
   - **Specifications** — a detailed breakdown of each process step (4000+ words)
   - **Final Inspection** — a narrative describing the final quality inspection (500+ words)

Reports are generated in **Brazilian Portuguese** using formal technical language.

---

## Getting Started

### Prerequisites

- Ruby `3.3.0`
- Rails `7.1.3`
- MySQL (running locally or remotely)
- Bundler gem
- An [OpenAI API key](https://platform.openai.com/api-keys)

### Installation

```bash
# Clone the repository
git clone https://github.com/PeuTrindade/metallurgy_api.git
cd metallurgy_api

# Install dependencies
bundle install
```

### Environment Variables

Create a `.env` file at the root of the project with the following variables:

```env
# OpenAI
OPENAI_API_KEY=sk-your-openai-key-here

# Internal API base URL (used by the report generator to call itself)
API_BASE_URL=http://localhost:3000

# Database (optional if using the defaults in database.yml)
DATABASE_PASSWORD=your_db_password
```

### Database Setup

Update `config/database.yml` with your MySQL credentials if needed, then run:

```bash
# Create databases
rails db:create

# Run migrations
rails db:migrate
```

### Running the Server

```bash
rails server
```

The API will be available at `http://localhost:3000`.

---

## Contributing

1. Fork this repository
2. Create your feature branch: `git checkout -b feature/my-new-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/my-new-feature`
5. Open a Pull Request

---

> Built with ❤️ using Ruby on Rails. Designed for metallurgy professionals who need structured, traceable, and AI-enhanced production documentation.
