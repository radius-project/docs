---
type: docs
title: "User Defined Type Resource schemas"
linkTitle: "User Defined Types"
description: "Schema docs for the resources of an user defined type that can comprise a Radius Application"
categories: "Schema"
weight: 100
---

## Overview

Radius supports creation of user defined types, which have an user defined schema. 
These types can be managed using [rad resource-type](docs/content/reference/cli/rad_resource-type.md) command. 

##  Schema Format

{{< tabs "Resource Manifest" >}}

{{< codetab >}}

{{< rad file="snippets/postgres.yaml" embed=true marker="//SAMPLE" >}}

{{< /codetab >}}

{{< /tabs >}}

## Top-level

Manifest file has below keys at the top level:

| Key | Required | Description | Example |
|-----|----------|---------|---------|
| **name** | yes | The namespace in which the resource type is registered | `MyCompany.Resources` | 
| [**types**](#types) | yes | type names in the specified namespace. The resource type manifest usually has one type that should be registered. | `postgresDatabases` | 

### types

| Key | Required | Description | Example | 
|-----|-------------|---------|-----------|
| [**resource type name**](#resource-type-name) | yes | The namespace in which the resource type is registered | `MyCompany.Resources` | 

## resource type name

| Key | Required | Description | Example | 
|-----|-------------|---------|
| **description** | yes | Description of the resource type | `A postgreSQL database` | 
| [**apiVersions**](#apiVersions) | yes | api versions which support this resource type | `2025-01-01-preview` | 

## apiVersions

| Key | Required |Description | Example | 
|-----|-------------|---------|
| [**api version name**](#api-version-name) | yes | a specific api version which supports this resource type | `2025-01-01-preview` | 

## api version name

| Key | Required | Description |
|-----|-------------|----------|
| [**schema**](#schema) | yes | openAPI v3 structural schema of the resource type in a specific api version. Radius supports a subset of open API capabilities. This is covered in subsequent sections  | 

## schema

`schema` holds the description of the structural schema for new resource type use using [Open API v3](https://github.com/OAI/OpenAPI-Specification/blob/main/versions/3.0.2.md#schema-object)

| Key | Required | Description | 
|-----|-------------|------------|
| **type**| yes | type of `schema`. This is always `object`, representing a open API v3 object  | 
| [**properties**](#properties)| yes | properties which are valid for a resource of the specified resource type| 

### properties

| Key | Required | Description | Example | 
|-----|-------------|---------|----------|
| [**property name**](#property-name)| yes | A property name. Property names MUST be strings and SHOULD conform to the regular expression: ^[a-zA-Z0-9\.\-_]+$.| logging-verbosity | 

### property name

| Key | Required | Description | Example | 
|-----|-------------|---------|----------|
| **type** | yes | type of the value of property. This can be `integer`, `number`, `string` or `boolean` | `true` |
| **description** | no | description of the property | "The size of database to provision" | 


#### example

```
    properties:
      host:
        type: string
        description: hostname
      port:
        type: integer
        description: server listening port
      cost:
        type: number
        description: cost till date 
      shared:
        type: boolean
        description: is this resource shared between different applications
```
