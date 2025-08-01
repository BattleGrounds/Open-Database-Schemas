# 📦 Modular Database Schemas — Best-Practice SQL for Real Systems

This repository contains production-level **SQL schemas** designed with best practices in mind: modularity, normalization (up to **5NF/6NF**), reusability, and scalability.  
You can freely **use, adapt, learn from, or improve** these schemas for your own systems.

> ✅ Suitable for learning, prototyping, production, and architectural inspiration.

---

## 🧱 What’s Inside?

Each schema represents a **domain-specific module** with clean separation of concerns and reusable components. Examples:

- `users`, `permissions`, `version` — core modules
- `courses`, `skills`, `tasks`, `quizzes` — learning management system (LMS)
- `student_profile`, `learning_style`, `feature_store` — adaptive learning & analytics
- `content_unit`, `unit_dependencies` — microlearning (5NF)
- `student_activity_log`, `grades_audit` — behavioral tracking & audit (6NF)
- `translation_dictionary`, `translation_synsets` — multilingual & semantic modeling

All schemas follow **strict normalization**, sensible default values, proper constraints, and are written for **MariaDB / MySQL 8+**.

---

## 🌟 Why This Exists?

I’m building this as a long-term open resource for:
- Developers designing real-world relational systems
- Students learning clean database architecture
- Engineers exploring **modular and versioned schema design**
- Teams building **GraphQL/REST APIs** over relational storage

You can explore, fork, clone, or extend any schema in this repository.  
**Pull requests and feedback are welcome.**

---

## 🛠 Technologies

- SQL (MySQL / MariaDB)
- UTF8MB4 with UCA collation
- ColumnStore-compatible fact tables
- Compatible with GraphQL-style queries

---

## 🔄 Versioning & Modularity (planned)

Soon each schema group will have:
- Package metadata (name, version, description)
- Dependencies and compatibility notes
- Migration versioning via DDL diffs

Think: **SPM/NPM for SQL schema design**.

---

## 🤝 Contributing

Contributions are welcome!  
If you have a suggestion for improvement — open an issue or submit a PR.  
Let’s build **database architecture as code** — clean, modular, and composable.

---

## 📚 License

MIT License — free for personal or commercial use. Attribution appreciated.

---

## 📬 Author

Developed and maintained by [@Roman](https://github.com/yourusername)  
I’m a student and database enthusiast who believes that **schema design is software architecture**.

---
