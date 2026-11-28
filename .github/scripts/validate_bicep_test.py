import contextlib
import io
import os
import stat
import tempfile
import unittest
from unittest import mock

import validate_bicep
from validate_bicep import POSTGRESQL_DEMO, REPO_ROOT, find_unsupported_tls_diagnostics

DEMO_ABSOLUTE = POSTGRESQL_DEMO
DEMO_RELATIVE = os.path.join(".", os.path.relpath(POSTGRESQL_DEMO))
OTHER_SAMPLE = os.path.join(".", "static", "samples", "demo", "app-redis.bicep")

TLS_NOT_ALLOWED = (
    '{path}(12,7) : Warning BCP037: The property "tls" is not allowed on objects '
    'of type "PostgreSqlDatabaseProperties". Permissible properties include "host".'
)
TLS_WRONG_TYPE = (
    '{path}(12,7) : Warning BCP036: The property "tls" expected a value of type '
    '"\'disabled\' | \'required\'" but the provided value is of type "\'optional\'".'
)


class FindUnsupportedTlsDiagnosticsTest(unittest.TestCase):
    def test_clean_output(self):
        self.assertEqual(find_unsupported_tls_diagnostics(DEMO_RELATIVE, ""), [])

    def test_bcp037_warning_is_reported(self):
        stderr = TLS_NOT_ALLOWED.format(path=DEMO_RELATIVE) + "\n"
        self.assertEqual(
            find_unsupported_tls_diagnostics(DEMO_RELATIVE, stderr),
            [TLS_NOT_ALLOWED.format(path=DEMO_RELATIVE)],
        )

    def test_bcp036_warning_is_reported(self):
        stderr = TLS_WRONG_TYPE.format(path=DEMO_RELATIVE)
        self.assertEqual(
            find_unsupported_tls_diagnostics(DEMO_RELATIVE, stderr),
            [TLS_WRONG_TYPE.format(path=DEMO_RELATIVE)],
        )

    def test_error_severity_is_reported(self):
        stderr = TLS_WRONG_TYPE.format(path=DEMO_RELATIVE).replace("Warning", "Error")
        self.assertEqual(len(find_unsupported_tls_diagnostics(DEMO_RELATIVE, stderr)), 1)

    def test_absolute_diagnostic_path_matches_relative_compiled_path(self):
        stderr = TLS_NOT_ALLOWED.format(path=DEMO_ABSOLUTE)
        self.assertEqual(len(find_unsupported_tls_diagnostics(DEMO_RELATIVE, stderr)), 1)

    def test_relative_diagnostic_path_matches_absolute_compiled_path(self):
        stderr = TLS_NOT_ALLOWED.format(path=os.path.relpath(POSTGRESQL_DEMO))
        self.assertEqual(len(find_unsupported_tls_diagnostics(DEMO_ABSOLUTE, stderr)), 1)

    def test_line_numbers_are_not_significant(self):
        stderr = TLS_NOT_ALLOWED.format(path=DEMO_RELATIVE).replace("(12,7)", "(301,3)")
        self.assertEqual(len(find_unsupported_tls_diagnostics(DEMO_RELATIVE, stderr)), 1)

    def test_only_matching_diagnostics_are_returned(self):
        stderr = "\n".join(
            [
                '{p}(3,1) : Warning no-unused-params: Parameter "x" is declared but never used.'.format(p=DEMO_RELATIVE),
                TLS_NOT_ALLOWED.format(path=DEMO_RELATIVE),
                TLS_WRONG_TYPE.format(path=DEMO_RELATIVE),
            ]
        )
        self.assertEqual(len(find_unsupported_tls_diagnostics(DEMO_RELATIVE, stderr)), 2)

    def test_unrelated_property_is_ignored(self):
        stderr = (
            '{p}(12,7) : Warning BCP037: The property "tlsMode" is not allowed on objects '
            'of type "PostgreSqlDatabaseProperties".\n'
            '{p}(13,7) : Warning BCP037: The property "ssl" is not allowed on objects '
            'of type "PostgreSqlDatabaseProperties".'
        ).format(p=DEMO_RELATIVE)
        self.assertEqual(find_unsupported_tls_diagnostics(DEMO_RELATIVE, stderr), [])

    def test_unrelated_code_is_ignored(self):
        stderr = (
            '{p}(12,7) : Warning BCP035: The specified "object" declaration is missing '
            'the following required properties: "tls". The property "tls" is required.'
        ).format(p=DEMO_RELATIVE)
        self.assertEqual(find_unsupported_tls_diagnostics(DEMO_RELATIVE, stderr), [])

    def test_unrelated_compiled_file_is_ignored(self):
        stderr = TLS_NOT_ALLOWED.format(path=OTHER_SAMPLE)
        self.assertEqual(find_unsupported_tls_diagnostics(OTHER_SAMPLE, stderr), [])

    def test_diagnostic_from_unrelated_imported_file_is_ignored(self):
        stderr = TLS_NOT_ALLOWED.format(path=os.path.join(".", "static", "shared", "module.bicep"))
        self.assertEqual(find_unsupported_tls_diagnostics(DEMO_RELATIVE, stderr), [])

    def test_same_file_name_in_another_directory_is_ignored(self):
        other = os.path.join(".", "elsewhere", "app-postgresql.bicep")
        stderr = TLS_NOT_ALLOWED.format(path=other)
        self.assertEqual(find_unsupported_tls_diagnostics(DEMO_RELATIVE, stderr), [])
        self.assertEqual(find_unsupported_tls_diagnostics(other, stderr), [])

    def test_normal_errors_are_not_promoted_by_this_check(self):
        stderr = '{p}(5,3) : Error BCP018: Expected the "=" character at this location.'.format(p=DEMO_RELATIVE)
        self.assertEqual(find_unsupported_tls_diagnostics(DEMO_RELATIVE, stderr), [])

    def test_windows_style_path_is_parsed(self):
        stderr = 'C:\\repo\\app.bicep(12,7) : Warning BCP037: The property "tls" is not allowed on objects of type "X".'
        match = validate_bicep.DIAGNOSTIC_PATTERN.match(stderr)
        self.assertIsNotNone(match)
        self.assertEqual(match.group("path"), "C:\\repo\\app.bicep")
        self.assertEqual(match.group("code"), "BCP037")


class SymlinkTest(unittest.TestCase):
    @unittest.skipIf(os.name == "nt", "symlinks need extra privileges on Windows")
    def test_symlinked_path_resolves_to_demo(self):
        with tempfile.TemporaryDirectory() as tmp:
            link = os.path.join(tmp, "link.bicep")
            os.symlink(DEMO_ABSOLUTE, link)
            stderr = TLS_NOT_ALLOWED.format(path=link)
            self.assertEqual(len(find_unsupported_tls_diagnostics(DEMO_RELATIVE, stderr)), 1)


# Stands in for the Bicep CLI: reports the unsupported `tls` property on the
# PostgreSQL demo as a warning and, like Bicep, exits 0.
STUB_BICEP = """#!/bin/sh
if [ "$1" = build ] && [ "$(basename "$2")" = app-postgresql.bicep ]; then
  printf '%s(12,7) : Warning BCP037: The property "tls" is not allowed on objects of type "X".\\n' "$2" >&2
fi
exit 0
"""


class MainTest(unittest.TestCase):
    @unittest.skipIf(os.name == "nt", "the stub Bicep CLI is a shell script")
    def test_tls_warning_fails_validation_from_a_subdirectory(self):
        with tempfile.TemporaryDirectory() as bicep_path:
            stub = os.path.join(bicep_path, "bicep")
            with open(stub, "w", encoding="utf-8") as f:
                f.write(STUB_BICEP)
            os.chmod(stub, os.stat(stub).st_mode | stat.S_IXUSR)

            self.addCleanup(os.chdir, os.getcwd())
            os.chdir(os.path.join(REPO_ROOT, "static"))

            output = io.StringIO()
            with (
                mock.patch.dict(os.environ, {"BICEP_PATH": bicep_path}),
                contextlib.redirect_stdout(output),
                self.assertRaises(SystemExit) as raised,
            ):
                validate_bicep.main()

        self.assertEqual(raised.exception.code, 1)
        demo = os.path.join(".", "samples", "demo", "app-postgresql.bicep")
        self.assertIn(f"Failed: {demo}\n", output.getvalue())


if __name__ == "__main__":
    unittest.main()
