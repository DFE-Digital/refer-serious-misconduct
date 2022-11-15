# 4. Model most things directly on the Referral model

Date: 2022-11-15

## Status

Accepted

## Context

In the context of modelling allegations, we discussed what our options are to
store the relevant fields for some of the sections in the referral form.

We came up with 4 potential solutions:

1. Referral as the "god object," previous/current allegations fields live on it
2. Separate PreviousAllegtation and Allegation models
3. Allegation model with previous/current state
4. Single table inheritance/polymorphism

We realised that allegations are only superficially similar and that they might
end up diverging in the future.

We then focussed the discussion on the implications of adding all the columns
to the Referral object, implicit domain modelling, versus explicit domain
modelling via separate tables.

## Decision

We will store most application form fields directly on the Referral object,
even when the relationship includes optional fields and the added field count
seems high.

Taking this approach is simpler, requires no joins (and introduces no risk of
N+1 queries, or orphaned records), and is faster to iterate on. We can always
choose to split out models where it makes sense.

This approach is the one adopted by [Apply for teacher
training](https://github.com/DFE-Digital/apply-for-teacher-training).

## Consequences

It makes the table wider (more columns), it intuitively feels a bit wrong, and
optional fields might make the table noisy or harder to read.
