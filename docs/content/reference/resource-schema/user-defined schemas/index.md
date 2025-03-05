---
type: docs
title: "Overview: User Defined Type Resource schemas"
linkTitle: "Overview"
description: "Schema docs for the resources of user defined type that can comprise a Radius Application"
categories: "Overview"
weight: 100
---

## User defined types

Radius supports creation of user defined types, which have an user defined schema. 
These types can be managed using [rad resource-type](docs/content/reference/cli/rad_resource-type.md) command. 

`rad resource-type create` command takes a resource type manifest as input argument. Users define an openAPI schema for their type 
in this manifest. A sample manifest is shown below:

```yaml
name: MyCompany.Resources
types:
  postgresDatabases:
    description: A postgreSQL database
    apiVersions:
      '2025-01-01-preview':
        schema: 
          type: object
          properties:
            size:
              type: string
              description: |
                The size of database to provision:
                  - 'S': 0.5 vCPU, 2 GiB memory, 20 GiB storage
                  - 'M': 1 vCPU, 4 GiB memory, 40 GiB storage
                  - 'L': 2 vCPU, 8 GiB memory, 60 GiB storage
                  - 'XL': 4 vCPU, 16 GiB memory, 100 GiB storage
              enum:
                - S
                - M
                - L
                - XL
            logging-verbosity:
              type: string
              description: >
                The logging level for the database:
                  - 'TERSE': Not recommended; does not provide guidance on what to do about an error
                  - 'DEFAULT': Recommended level
                  - 'VERBOSE': Use only if you plan to actually look up the Postgres source code
              enum:
                - TERSE
                - DEFAULT
                - VERBOSE
            connection-string:
              type: string
              readOnly: true
              description: 'Fully qualified string to connect to the resource'
              env-variable: POSTGRESQL_CONNECTION_STRING
            credentials:
              type: object
              readOnly: true
              properties:
                username:
                  type: string
                  description: 'Username for the database'
                  env-variable: POSTGRESQL_USERNAME
                password:
                  type: string
                  description: 'Password for the database user'
                  env-variable: POSTGRESQL_PASSWORD
          required:
            - size
```

## Resource type manifest schema

Manifest file has below keys at the top level:

| Key | Description | Example |
|-----|-------------|---------|
| **name** | The namespace in which the resource type is registered | `MyCompany.Resources` |
| [**types**](#types) | A list of types in the specified namespace. The resource type manifest usually has one type that should be registered. | `postgresDatabases` |

### types

| Key | Description | Example |
|-----|-------------|---------|
| [**name of the resource type**](#resource-type-name) | The namespace in which the resource type is registered | `MyCompany.Resources` |

## resource type name

| Key | Description | Example |
|-----|-------------|---------|
| **description** | Description of the resource type | `A postgreSQL database` |
| [**apiVersions**](#apiVersions) | A list of api versions which support this resource type | `2025-01-01-preview` |

## apiVersions

| Key | Description | Example |
|-----|-------------|---------|
| [**apiversion name**](#api-version-name) | a specific api version which supports this resource type | `2025-01-01-preview` |

## api version name

| Key | Description | 
|-----|-------------|
| [**schema**](#schema) | openAPI v3 structural schema of the resource type in a specific api version. Radius supports a subset of open API capabilities. This is covered in subsequent sections  | 


## schema

`schema` holds the description of the structural schema for new resource type use using [Open API v3](https://github.com/OAI/OpenAPI-Specification/blob/main/versions/3.0.2.md#schema-object)

| Key | Description | 
|-----|-------------|
| **type**| type of `schema`. This is always object, representing a open API v3 object  |
| [**properties**](#properties)| properties which are valid for a resource of the specified resource type|


### properties

| Key | Description | Example |
|-----|-------------|---------|
| **type**| type of `schema`. This is always object, representing a open API v3 object  |   |
| [**property name**](#property-name)| A property name. Property names MUST be strings and SHOULD conform to the regular expression: ^[a-zA-Z0-9\.\-_]+$.| logging-verbosity |

### property name

| Key | Description | Example |
|-----|-------------|---------|
| **type**| type of the value of property. This can be any primitive type defined in  [Open API v3 data types](https://github.com/OAI/OpenAPI-Specification/blob/main/versions/3.0.2.md#data-types) OR an array OR a map | [examples](#examples) |


#### Examples

##### primitive type property

```
    properties:
      size:
        type: string  
        description: The size of database to provision
        enum:
        - S
        - M
        - L
        - XL
      host:
        type: string
        description: hostname
        maxLength: 20
```

##### array

`array` must specify a `type` for item

```
schema:
  openAPIV3Schema: 
    type: object
    properties:
      ports:
        type: array
        description: "ports this resource binds to"
        item:
          type: integer
          format: uint32
```

##### map

We support map through `addionalProperties`. This is useful when the resource type allows for dynamic (user defined) keys. We still must specify a type for the value of the property.

```
schema:
  openAPIV3Schema:
    type: object
    properties:
      name:
        type: string
        description: The name of the resource
      labels:
        type: object
        description: A map of labels for the resource
        additionalProperties:
          type: string
```










































