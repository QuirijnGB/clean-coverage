library clean_coverage;

import 'package:args/command_runner.dart';
import 'package:clean_coverage/commands/clean_command.dart';

/// A Calculator.
class CleanCoverageCommandRunner extends CommandRunner {
  CleanCoverageCommandRunner._()
      : super(
          'clean_coverage',
          'A CLI tool to clean up your lcov files',
        ) {
    addCommand(CleanCommand());
  }
  static CleanCoverageCommandRunner instance = CleanCoverageCommandRunner._();
}
