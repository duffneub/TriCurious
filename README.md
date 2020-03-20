# TriCurious
For those curious about triathlon

## Description

TriCurious is an iOS app for staying up to date with all things triathlon. It uses a public Triathlon API offered at [https://developers.triathlon.org](https://developers.triathlon.org) for its backend.

## Known Issues

1. Fetched data is not cached locally

When presenting a list of rankings, the view will fetch the data for athlete headshots and country flags. Since this data is not cached, these images will be re-fetched when the user scrolls in the list. Not caching country flag data is particularly bad since the data could be easily shared across athletes.

2. Tests

TriCurious has 0 tests 😕. Some good candidates for testing...

- `TriathlonOrg`
	- Test that our requests match expectation
	- Test handles successful response
	- Test handles failure response
- `*ViewModel`
	- Test various backing model properties are formatted for presentation as expected


