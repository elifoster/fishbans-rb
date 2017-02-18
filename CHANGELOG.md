# Changelog
## Version 2
### Version 2.0.0
* The `services` array is now a constant as `Fishbans::SERVICES`.
* Error strings are no longer returned from methods, but thrown as RuntimeErrors.
* `parse_generic_ban_result` no longer returns a hash of arrays, but a hash of hashes. See the docs for more details.
* Update to Ruby 2.4.0: `Fixnum` -> `Integer` in documentation.

## Version 1
### Version 1.1.4
* Remove a couple unnecessary things from the PlayerSkins and BlockEngine (is_a? check and downcase).

### Version 1.1.3
* Use pessimistic version requirements.
* Bump HTTPClient version.

### Version 1.1.2
* License as MIT.

### Version 1.1.1
* Update to require HTTPClient 2.7.1.

### Version 1.1.0
* New PlayerSkins module, including methods for getting player faces, fronts, and skins.
* New BlockEngine module, including methods for getting 3D block images, 2D monster face images, and 3D full monster images.

### Version 1.0.1
* Fix NoMethodError with get

### Version 1.0.0
* Initial version with all APIs documented on the Fishbans API Docs.
