import json
import unittest

from set_bicep_extension_tags import set_extension_tags


class SetBicepExtensionTagsTests(unittest.TestCase):
    def setUp(self):
        self.config = {
            "experimentalFeaturesEnabled": {"ociEnabled": True, "extensibility": True},
            "extensions": {
                "radius": "br:ghcr.io/radius-project/bicep-types-radius:edge",
                "aws": "br:ghcr.io/radius-project/bicep-types-aws:edge",
                "mycompany": "br:mycompany.azurecr.io/radius-resources:latest",
                "local": "./mycompany-radius-resources.tgz",
            },
            "moduleAliases": {
                "br": {
                    "recipes": {"registry": "mycompany.azurecr.io", "modulePath": "recipes"},
                },
            },
        }

    def config_text(self):
        return "// Bicep configuration for documentation samples\n" + json.dumps(self.config, indent="\t") + "\n"

    def test_stable_releases_use_the_release_channel(self):
        for version in ("0.62.0", "0.62.2", "0.62.2+build.1"):
            with self.subTest(version=version):
                before = self.config_text()
                expected = before.replace("bicep-types-radius:edge", "bicep-types-radius:0.62")
                expected = expected.replace("bicep-types-aws:edge", "bicep-types-aws:0.62")
                self.assertEqual(set_extension_tags(before, version), expected)

    def test_release_candidates_use_the_full_version(self):
        for version in ("0.62.0-rc.1", "0.62.0-rc1"):
            with self.subTest(version=version):
                before = self.config_text()
                expected = before.replace("bicep-types-radius:edge", f"bicep-types-radius:{version}")
                expected = expected.replace("bicep-types-aws:edge", f"bicep-types-aws:{version}")
                self.assertEqual(set_extension_tags(before, version), expected)

    def test_explicit_stable_tags_and_manifest_pins_are_preserved(self):
        for suffix in (":latest", ":0.60", ":0.60.2", "@sha256:" + "a" * 64):
            with self.subTest(suffix=suffix):
                for name in ("radius", "aws"):
                    self.config["extensions"][name] = f"br:ghcr.io/radius-project/bicep-types-{name}{suffix}"
                before = self.config_text()
                self.assertEqual(set_extension_tags(before, "0.62.2"), before)

    def test_only_development_references_are_updated(self):
        self.config["extensions"]["aws"] = "br:ghcr.io/radius-project/bicep-types-aws:0.60.2"
        before = self.config_text()
        self.assertEqual(
            set_extension_tags(before, "0.62.2"),
            before.replace("bicep-types-radius:edge", "bicep-types-radius:0.62"),
        )

    def test_invalid_release_versions_fail(self):
        for version in ("", "edge", "0.62", "v0.62.0", "0.62.0\n", "0.62.0-rc.1+build.1"):
            with self.subTest(version=version):
                with self.assertRaises(ValueError):
                    set_extension_tags(self.config_text(), version)

    def test_oci_support_is_required(self):
        for features in ({}, {"ociEnabled": False}, {"ociEnabled": "true"}):
            with self.subTest(features=features):
                self.config["experimentalFeaturesEnabled"] = features
                with self.assertRaisesRegex(ValueError, "ociEnabled"):
                    set_extension_tags(self.config_text(), "0.62.2")

    def test_missing_or_noncanonical_production_references_fail(self):
        for reference in (None, "br:mycompany.azurecr.io/aws:edge", "br:ghcr.io/radius-project/bicep-types-aws:"):
            with self.subTest(reference=reference):
                self.config["extensions"]["aws"] = reference
                with self.assertRaisesRegex(ValueError, "canonical GHCR"):
                    set_extension_tags(self.config_text(), "0.62.2")

    def test_invalid_json_fails(self):
        with self.assertRaises(ValueError):
            set_extension_tags("{", "0.62.2")


if __name__ == "__main__":
    unittest.main()
