---
type: docs
title: "Radius.Core/roleDefinitions@2025-08-01-preview"
linkTitle: "RoleDefinitions"
---

{{< schemaExample >}}

## Description

A role definition. Built-ins live at /providers/Radius.Core/roleDefinitions/<name> and cannot be changed or deleted. Custom roles can live at installation, plane, or resource-group scope.

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `assignableScopes` | string array | Scopes where the role may be assigned, including descendants. Defaults to the role definition's scope. Writers must be allowed to create roles at every listed scope. |
| `description` | string | A description of the intended access. |
| `displayName` | string | A human-readable role name. |
| `permissions` | string array | Explicit catalog permissions. Unknown permissions fail with UnknownPermission; custom wildcards and deny rules are not supported. |
| `roleType` | string | Server-owned distinction between immutable release-defined built-ins and custom roles.<br />Allowed values: `BuiltIn`, `Custom`. |
