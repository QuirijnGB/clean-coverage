import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:clean_coverage/common/logger.dart';
import 'package:glob/glob.dart';

class CleanCommand extends Command {
  @override
  final String name = 'clean';

  @override
  final String description = 'Cleans the given lcov file based on the globs';

  CleanCommand() {
    argParser.addMultiOption(
      "exclusions",
      valueHelp: 'glob',
      help:
          'Exclude files with names matching the given glob. This option can be repeated.',
    );
    argParser.addOption(
      "exclusions-file",
      valueHelp: 'file',
      help: 'Exclude files with names matching the given globs in the file.',
    );
  }

  @override
  Future<void> run() async {
    final results = argResults;

    if (results == null) {
      logger.stdout("You're missing things\n");
      printUsage();
      exit(0);
    }

    final List<String> exclusions = [];

    if (results["exclusions"] != null &&
        results["exclusions"] is List<String>) {
      exclusions.addAll(results["exclusions"] as List<String>);
    }
    if (results["exclusions-file"] != null &&
        results["exclusions-file"] is String) {
      exclusions.addAll(
          await parseExclusionsFile(results["exclusions-file"] as String));
    }

    if (exclusions.isEmpty) {
      logger.stdout('No exclusions given. Nothing to do here\n');
      printUsage();
      exit(0);
    }
    final List<Glob> globs =
        exclusions.map((e) => Glob(e, recursive: true)).toList();
    logger.stdout('Excluding: $exclusions');

    final covFile = argResults!.rest.first;
    logger.stdout('From: $covFile');

    cleanCoverageFile(globs, covFile);

    logger.stdout('\nAll clean');
  }

  Future<List<String>> parseExclusionsFile(String path) async {
    final File f = File(path);

    return f.readAsLines();
  }

  File cleanCoverageFile(List<Glob> globs, String pathToCoverageFile) {
    final f = File(pathToCoverageFile);

    bool keep = true;

    bool keeper(String line) {
      if (line.startsWith('SF:') && matchesGlob(globs, line)) {
        keep = false;
      } else {
        if (!keep && line == 'end_of_record') {
          keep = true;
          return false;
        }
      }
      return keep;
    }

    f
        .readAsLines()
        .then((lines) => f.writeAsString(lines.where(keeper).join('\n')));

    return f;
  }

  bool matchesGlob(List<Glob> globs, String line) =>
      globs.any((r) => r.matches(line.substring(3)));
}
