# MongoDB Full Database Export to JSON (TLS + Client Certificate)

This guide explains how to export a full MongoDB database (`rwaprod`) to **readable JSON files** for each collection on a TLS-enabled MongoDB server with client certificate authentication.

---

## Prerequisites

- MongoDB database running with TLS/SSL enabled
- Client certificate (`toucanint-full.pem`) and CA certificate (`ca.crt`)
- MongoDB user with sufficient privileges (e.g., `superAdmin`)
- `mongosh` installed (version 2.3.0 or higher)

> Note: System-installed `mongodump` and `mongoexport` on Ubuntu/Debian may **not support TLS certificates**, which is why `mongosh` is used.

---

## Steps to Prepare the Environment

### 1. Upgrade MongoDB Tools (Optional)

Initially, system tools lacked full TLS support:

```bash
sudo apt-get update
sudo apt-get install -y mongodb-database-tools
