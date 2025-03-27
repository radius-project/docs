---
type: docs
title: "User Defined Type Resource schemas"
linkTitle: "User Defined Types"
description: "Schema docs for the resources of an user defined type that can comprise a Radius Application"
categories: "Schema"
weight: 100
---

## User defined types

Radius supports creation of user defined types, which have an user defined schema. 
These types can be managed using [rad resource-type](docs/content/reference/cli/rad_resource-type.md) command. 

`rad resource-type create` command takes a resource type manifest as input argument. Users define an openAPI schema for their type 
in this manifest. A sample manifest is shown below:


{{< tabs "Resource Manifest" >}}

{{< codetab >}}

{{< rad file="snippets/postgres.yaml" embed=true marker="//SAMPLE" >}}

{{< /codetab >}}

{{< /tabs >}}

## Resource type manifest schema

Manifest file has below keys at the top level:

| Key | Description | Example | Required |
|-----|-------------|---------|---------|
| **name** | The namespace in which the resource type is registered | `MyCompany.Resources` | yes |
| [**types**](#types) | type names in the specified namespace. The resource type manifest usually has one type that should be registered. | `postgresDatabases` | yes |

### types

| Key | Description | Example | Required |
|-----|-------------|---------|----------|
| [**resource type name**](#resource-type-name) | The namespace in which the resource type is registered | `MyCompany.Resources` | yes |

## resource type name

| Key | Description | Example | Required |
|-----|-------------|---------|----------|
| **description** | Description of the resource type | `A postgreSQL database` | yes |
| [**apiVersions**](#apiVersions) | api versions which support this resource type | `2025-01-01-preview` | yes |

## apiVersions

| Key | Description | Example | Required |
|-----|-------------|---------|----------|
| [**api version name**](#api-version-name) | a specific api version which supports this resource type | `2025-01-01-preview` | yes |

## api version name

| Key | Description | Required |
|-----|-------------|----------|
| [**schema**](#schema) | openAPI v3 structural schema of the resource type in a specific api version. Radius supports a subset of open API capabilities. This is covered in subsequent sections  | yes | 

## schema

`schema` holds the description of the structural schema for new resource type use using [Open API v3](https://github.com/OAI/OpenAPI-Specification/blob/main/versions/3.0.2.md#schema-object)

| Key | Description | Required|
|-----|-------------|-----------
| **type**| type of `schema`. This is always `object`, representing a open API v3 object  | yes |
| [**properties**](#properties)| properties which are valid for a resource of the specified resource type| yes |
| **required** | list of properties that are required for a resource | no |

### properties

| Key | Description | Example | Required |
|-----|-------------|---------|----------|
| [**property name**](#property-name)| A property name. Property names MUST be strings and SHOULD conform to the regular expression: ^[a-zA-Z0-9\.\-_]+$.| logging-verbosity | yes |

### property name

| Key | Description | Example | Required |
|-----|-------------|---------|----------|
| **type** | type of the value of property. This can be any [primitive type](#primitive-type-property),  an [array](#array-type-property) or a[map](#map-type-property) | - | yes |
| **description** | description of the property | "The size of database to provision" | no |

Depending on the type, there can be more keys in a property.


#### primitive type property

A property can be any primitive data type defined in [Open API v3 data types](https://github.com/OAI/OpenAPI-Specification/blob/main/versions/3.0.2.md#data-types).

** Numeric values **

| Type | Format |	Description |
|------|---------|-------------|
| integer	| int32 |	signed 32 bits |
| integer	| int64 |	signed 64 bits (a.k.a long) |
| integer	| uint32 | 	unsigned 32 bits |
| number | float | a float value |
| number | double | a double precision value |

** Strings **

| Type | Format |	Description |
|------|---------|-------------|
| string |  _  | any string 	|
| string | byte	| base64 encoded characters |
| string | binary | any sequence of octets |
| string | date	| As defined by full-date - RFC3339 |
| string | date-time |	As defined by date-time - RFC3339 |
| string | password |	A hint to UIs to obscure input |

** Boolean ** 

| Type | Format |	Description |
|------|---------|-------------|
| boolean | - | `true` or `false` |



**Example**

```
    properties:
      host:
        type: string
        description: hostname
        maxLength: 20
      port:
        type: uint32
        description: server listening port
      created:
        type: string
        description: date on which the resource was created
        format: date
      size:
        type: string  
        description: The size of database to provision
        enum:
        - S
        - M
        - L
        - XL
```
#### array type property

Arrays can be used to store a collection of items of same type. 
A property of type `array` must specify a `type` for each `item`. 

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

The above example specifies "ports" is an array property and each item in this array is of type integer.

#### map type property

We support map through `addionalProperties`. This is useful when the resource type allows for dynamic (user defined) keys. The keys are always `string` type. We must specify a type for the value of the property.

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

In the above example, we allow the resource to have labels such as "namespace:app, env: prod". Note that we did not have to define "namespace" and "env" explicitly by using this approach, which would not work for allowing labels.





