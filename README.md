# vfeatures

Feature flags are organized using these models:
* silos
* releases
* features
* flags

Each flag represents whether a feature is enabled or disabled for a given release.

Flags can be visualized like this:

                                            RELEASES
                         | release-4.22 | release-4.21 | release-4.20
              FeatureFoo |      ❌      |      ❌      |      ❌
    FEATURES  FeatureBar |      ✅      |      ❌      |      ❌
              FeatureBaz |      ✅      |      ✅      |      ✅

Each silo is assigned a release. More than one silo can be on the same release.

    SILO      QA           | STAGING      | HOTFIX       | PRODUCTION
    RELEASE   release-4.22 | release-4.21 | release-4.20 | release-4.20

By selecting the release, you determine which flags are enabled on that silo.
