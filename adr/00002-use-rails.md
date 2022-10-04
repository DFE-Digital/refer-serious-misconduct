# 2. Use a Ruby on Rails monolith

Date: 2022-10-04

## Status

Accepted

## Context

Refer Serious Misconduct is a transactional service that allows teachers to
report serious misconduct using a wizard form.

## Decision

For the overall tech stack, we've chosen Ruby on Rails for the following
reasons:

- Rails sees ample use in DFE Digital, and wider government, and there's a
  community that can provide support, packages, and help
- The patterns and abstractions used by Rails fit our needs (MVC,
  server-side rendering)
- Rails is easy to extend to possible scenarios where we need to expose an
  API or serve new needs

We've decided to structure the app as a monolith, because that's the
standard Rails model, and it's simpler than a distributed system to deploy,
develop locally, and reason about.

On the frontend, we've settled on the GOV.UK Design System, because it's the
standard for accessible and performant services, and a requirement for passing
a service assessment.

## Consequences

- We won't be able to leverage any Microsoft or C# specific skillsets in our
  team
