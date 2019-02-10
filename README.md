# vfeatures

Feature flags are organized using these models:
* silos
* releases
* features
* flags

Each flag represents whether a feature is enabled (on) or disabled (off) for a given release.

Flags can be visualized like this:

  | release-4.22 | release-4.21 | release-4.20
- | ------------ | ------------ | ------------
FeatureFoo | off | off | off
FeatureBar | ON | off | off
FeatureBaz | ON | ON | ON

Each silo is assigned a release. More than one silo can be on the same release.

Silo | Release
---- | -------
qa | release-4.22
staging | release-4.21
hotfix | release-4.20
production | release-4.20

The selected release determines which features are enabled on that silo.
