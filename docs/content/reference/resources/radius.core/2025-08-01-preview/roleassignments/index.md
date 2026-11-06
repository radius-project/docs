---
type: docs
title: "Radius.Core/roleAssignments@2025-08-01-preview"
linkTitle: "RoleAssignments"
---

{{< schemaExample >}}

## Description

An ARM-style extension assignment whose ID ends with /providers/Radius.Core/roleAssignments/<name>. Supported resource scopes include a single environment. A repeated PUT with the same role, principal identity, and scope is a no-op; changing that tuple fails with RoleAssignmentImmutable.

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `createdBy` | string | Server-owned identity of the creator, formatted as type:issuer:subject for display, not parsed to establish identity. |
| `description` | string | An optional description of why access was granted. |
| `managedBy` | [object](#managedby) | Server-owned provenance. Only the same GitOps source may modify its assignments unless an authorized deletion explicitly takes ownership. Bootstrap assignments are managed through installation settings. |
| `principal` | [object](#principal) | The principal. Its type, issuer, and subject cannot change. |
| `roleDefinitionId` | string | The immutable full role definition ID. The assignment scope must be covered by the role's assignableScopes. |
| `scope` | string | Server-owned canonical scope derived from the assignment ID, including / for installation assignments. |

## Object Properties

### `managedBy` {#managedby}

| Property | Type | Description |
|----------|------|-------------|
| `kind` | string | How the assignment was created.<br />Allowed values: `Bootstrap`, `Deployment`, `GitOps`, `Imperative`. |
| `path` | string | The template path within the source. |
| `principal` | string | The verified submitting principal, formatted for display. |
| `revision` | string | The Git revision. |
| `source` | string | The verified Git source URL for GitOps assignments. |

### `principal` {#principal}

| Property | Type | Description |
|----------|------|-------------|
| `displayName` | string | An optional mutable label that is never used to match principals. |
| `issuer` | string | The trusted identity system, including its trust domain. Kubernetes issuers use kubernetes:<cluster-id>; controller namespace principals use radius-controller. |
| `subject` | string | The identity within the issuer. Kubernetes service accounts use system:serviceaccount:<namespace>:<name>. |
| `type` | string | The kind of principal.<br />Allowed values: `group`, `user`, `workload`. |
