import contextlib
import io
import os
import subprocess
import unittest
from unittest.mock import patch

import validate_bicep


SAMPLE = "docs/static/samples/demo/app-postgresql.bicep"
TLS_TYPE_WARNING = (
    'Warning BCP036: The property "tls" expected a value of type '
    '"\'optional\' | \'required\' | null" but the provided value is of type '
    '"\'disabled\'".'
)
TLS_PROPERTY_WARNING = (
    'Warning BCP037: The property "tls" is not allowed on objects of type '
    '"postgreSqlDatabasesProperties".'
)


class ValidationTests(unittest.TestCase):
    def test_diagnostic_fixtures(self):
        fixtures = [
            ("supported", SAMPLE, "", 0, False),
            ("unsupported value", SAMPLE, TLS_TYPE_WARNING, 0, True),
            ("unsupported property", SAMPLE, TLS_PROPERTY_WARNING, 0, True),
            ("windows path", SAMPLE.replace("/", "\\"), TLS_TYPE_WARNING, 0, True),
            ("relative windows path", ".\\" + SAMPLE.replace("/", "\\"), TLS_TYPE_WARNING, 0, True),
            ("relative path", "./" + SAMPLE, TLS_TYPE_WARNING, 0, True),
            ("single quotes", SAMPLE, TLS_TYPE_WARNING.replace('"tls"', "'tls'"), 0, True),
            ("served copy", SAMPLE.replace("/static/", "/public/"), TLS_TYPE_WARNING, 0, True),
            ("unrelated file", "other/app-postgresql.bicep", TLS_TYPE_WARNING, 0, False),
            ("other sample", SAMPLE.replace("postgresql", "redis"), TLS_TYPE_WARNING, 0, False),
            ("other property", SAMPLE, TLS_TYPE_WARNING.replace('"tls"', '"size"'), 0, False),
            ("different diagnostic", SAMPLE, TLS_TYPE_WARNING.replace("BCP036", "BCP035"), 0, False),
            ("lint warning", SAMPLE, 'Warning no-unused-vars: Variable "tls" is unused.', 0, False),
            ("separate diagnostic lines", SAMPLE, 'Warning BCP036: Other property.\nWarning no-unused-vars: The property "tls" is unused.', 0, False),
            ("compiler error", "other.bicep", "Error BCP001: Invalid syntax.", 0, True),
            ("nonzero exit", SAMPLE, "", 1, True),
        ]
        for name, filename, diagnostic, exitcode, expected in fixtures:
            with self.subTest(name=name):
                self.assertEqual(
                    validate_bicep.is_validation_failure(
                        filename, f"{filename}(93,7) : {diagnostic}", exitcode
                    ),
                    expected,
                )

    def test_validation_path_rejects_exit_zero_warning(self):
        for diagnostic, expected in [(TLS_TYPE_WARNING, 1), (TLS_PROPERTY_WARNING, 1), ("", 0)]:
            with self.subTest(diagnostic=diagnostic):
                result = subprocess.CompletedProcess(
                    args=[], returncode=0,
                    stderr=f"{SAMPLE}(61,10) : {diagnostic}".encode("utf-8")
                )
                output = io.StringIO()
                with patch.object(validate_bicep.os, "walk", return_value=[
                    ("docs/static/samples/demo", [], ["app-postgresql.bicep"])
                ]), patch.object(validate_bicep.subprocess, "run", return_value=result), contextlib.redirect_stdout(output):
                    self.assertEqual(validate_bicep.main(), expected)
                self.assertEqual("Failed:" in output.getvalue(), expected == 1)

    def test_diagnostic_must_belong_to_sample(self):
        for filename, expected in [
            (os.path.abspath(SAMPLE), True),
            (".\\" + SAMPLE.replace("/", "\\"), True),
            ("other/app-postgresql.bicep", False),
            (SAMPLE.replace("postgresql", "redis"), False),
        ]:
            with self.subTest(filename=filename):
                diagnostic = f"{filename}(120,9) : {TLS_TYPE_WARNING}"
                self.assertEqual(
                    validate_bicep.is_validation_failure(SAMPLE, diagnostic, 0),
                    expected,
                )
        self.assertFalse(validate_bicep.is_validation_failure(SAMPLE, TLS_TYPE_WARNING, 0))


if __name__ == "__main__":
    unittest.main()
