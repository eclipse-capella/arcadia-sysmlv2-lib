<!--
  Copyright (c) 2026 Obeo.
  This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v2.0
  which accompanies this distribution, and is available at
  https://www.eclipse.org/legal/epl-2.0/

  SPDX-License-Identifier: EPL-2.0

  Contributors:
      Obeo - initial API and implementation
-->
# Contributing to Arcadia SysML v2 Library

Thank you for your interest in contributing to the Arcadia SysML v2 Library.

## Development Setup

### Markdown edition

md files are to be edited using simple markdown compatible tools such as Visual Studio code or Obisidian.

### SysMLv2 edition

SysMLv2 files are to be edited using the [SysMLv2 pilot implementation](https://github.com/Systems-Modeling/SysML-v2-Release/releases).

## Versioning rules

This repository contains the definition for the SysMLv2 Arcadia library and its mapping with current Capella desktop (v7.0.1) implementation.
As such it is used as a standard specification by the Capella for SysON and Capella SysMlv2 Bridge projects
It is thus mandatory to follow versioning rules to ensure traceability over specification and mapping implementations.

- Version numbers are formed as: MAJOR.MINOR.PATCH as recommended in [Semantic Versioning 2.0.0](https://semver.org/).
- Modifications done on existing mapping ([ArcadiaLibraryMapping.md](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/doc/ArcadiaLibraryMapping.md)) or existing model elements ([arcadia.sysml](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/lib/arcadia.sysml)) require a bump of the MAJOR value
- Addition of new elements require a bump of the MINOR value
- Version bump is to be done on the [ArcadiaLibraryMapping.md](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/doc/ArcadiaLibraryMapping.md), [arcadia.sysml](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/lib/arcadia.sysml) and [main pom.xml](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/pom.xml) files
