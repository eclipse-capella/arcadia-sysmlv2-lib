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

This repository contains the definition for the SysMLv2 Arcadia library and its mapping with current Capella desktop (v7.1.0) implementation.
As such it is used as a standard specification by the Capella for SysON and Capella SysMlv2 Bridge projects.
It is thus mandatory to follow versioning rules to ensure traceability over specification and mapping implementations.

Version numbers are formed as: MAJOR.MINOR.PATCH as recommended in [Semantic Versioning 2.0.0](https://semver.org/).

### Version bump rules

- MAJOR versions bump should be done only on rare occasions when specific project milestones are reached
- MINOR version bump should be done with changes of the following nature:
  - Breaking modifications on existing mapping in the [ArcadiaLibraryMapping.md file](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/doc/ArcadiaLibraryMapping.md)
  - Breaking modifications on existing model elements in the [arcadia.sysml library](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/lib/arcadia.sysml)
  - Breaking modifications on the [ArcadiaDefaultStructure.sysml sample file](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/lib/ArcadiaDefaultStructure.sysml)
  - Addition of new concepts mot likey impacting all the previously mentioned files
- PATCH version bump should be done with changes such as documentation, examples and corrections of the models that do not have impacts
- Version bump is to be impacted on the following files
  - [ArcadiaLibraryMapping.md](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/doc/ArcadiaLibraryMapping.md)
  - [arcadia.sysml](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/lib/arcadia.sysml)
  - [ArcadiaDefaultStructure.sysml](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/lib/ArcadiaDefaultStructure.sysml)
  - [main pom.xml](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/pom.xml)
- Not every modification on the repository require a bump

### Version update procedure

Version updates are done by updating both the root [pom.xml](./pom.xml) file and the version numbers in the [library](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/lib/arcadia.sysml), [mapping documentation](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/doc/ArcadiaLibraryMapping.md) and [ArcadiaDefaultStructure.sysml](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/lib/ArcadiaDefaultStructure.sysml).

## Reporting Issues

When reporting an issue, include:

- the version or commit used;
- the steps to reproduce the problem;
- the expected behavior;
- the actual behavior;
- relevant logs, screenshots, examples when available.

## Submitting Changes

### Follow the coding conventions already in place in the repository

When working on a feature, look for similar pieces of code/scripts/documents from contributions that have already been merged and are
maintained by the team.
This ensures your contribution fits well with the existing content and established best practices.

Make sure you keep the EPL-2.0 license headers and SPDX identifiers consistent with existing files.

Refer to the [development setup instructions](#development-setup) to configure your IDE with the appropriate resources (
checkstyle, code templates, etc).

### Keep changes focused and minimal

Keep your pull requests short.

If you think a change will be large, reach out to the team to discuss how to break it down before you start.
This clarifies what is acceptable and what is not, and ensure everyone is aligned.

Reviewers generally expect a single commit.
Some PRs legitimately contain several, but it is unusual, so mention it up front.
If you feel you need multiple commits, that often means the change could be split into several PRs.

A typical change to the [library](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/lib/arcadia.sysml) implies modifications on the [mapping description](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/doc/ArcadiaLibraryMapping.md), an update of the global examples located in the [examples folder](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/examples/), an update of the dedicated concepts examples located in the [concepts examples folder](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/examples/concepts/). If the change impacts elements used in the default Capella model then the [default structure model](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/lib/ArcadiaDefaultStructure.sysml) should also be updated.

Modifications to the [mapping description](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/doc/ArcadiaLibraryMapping.md) typically requires to check the global examples located in the [examples folder](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/examples/) and the [concepts examples](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/examples/concepts) for adaptation.

Modifications to the [examples](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/examples/) or the [concepts examples](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/examples/concepts) should be made compatible with the [mapping description](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/doc/ArcadiaLibraryMapping.md) and the [library](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/lib/arcadia.sysml).

### Review your own PR before requesting a review

Before asking for a review, go through your own PR and perform a self-review.
This lets you 1) make sure you haven't pushed changes you didn't intend to push, such as leftover content or comments that should be removed, and 2) point out the hot spots of the PR to help the reviewer.

Leave comments on the pieces of your contribution that aren't obvious or need to be discussed.
This greatly increases the reviewer's confidence in your contribution: it shows that you have checked the quality of what you pushed and are not trying to slip in shaky content.

This is especially important in an AI-assisted world, where you are expected to take full responsibility for the content you push.
If a tool wrote part of your contribution, you must be able to explain it, justify it, and modify it if needed.

We may have to set aside contributions that clearly don't fit with the existing repository content, as this usually means they haven't been reviewed.

### Document your changes

Document non-trivial choices.
This means choices that differ from the usual assumptions elsewhere in the project.
A PR description is useful during the review, but it gets lost over time, whereas a comment in the repository files stays visible to anyone who comes across it later.
Don't overdo it: the goal is to document what is out of the ordinary, not to explain every line.

### Update the changelog

Add an entry in the [changelog](https://github.com/eclipse-capella/arcadia-sysmlv2-lib/blob/master/CHANGELOG.md) referencing the related issue.

If your contribution is a breaking change to the library or the mapping, you must document it in the changelog.
The following should be considered breaking changes:

- Breaking modification of the library : replacing or removing elements
- Modifications in the mapping implying to modify the way elements should be mapped
- Renaming an element in the library: include both the original and the new name in the changelog, to make upgrades easier for projects

In general, there is never too much documentation for breaking changes.
Keep in mind that projects that depend on this one may be affected several weeks later, and that your contribution will only be one part of the API changes they have to absorb.
