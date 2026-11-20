/*
 * Copyright (c) 2026 Obeo.
 * This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v2.0
 * which accompanies this distribution, and is available at
 * https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *     Obeo - initial API and implementation
 */
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import org.eclipse.xtext.diagnostics.Severity;
import org.eclipse.xtext.validation.Issue;
import org.omg.sysml.interactive.SysMLInteractive;
import org.omg.sysml.interactive.SysMLInteractiveResult;

/**
 * Validates SysML v2 files with the SysML v2 pilot implementation.
 *
 * Usage: java -cp <jupyter-sysml-kernel-all.jar> ci/Validate.java <sysml.library directory> <known warnings file>
 * <file.sysml>...
 *
 * The files are processed in the given order, in one session: a file can use the elements of the previous ones, so the
 * library must come first. The validation is strict: an error or a warning in a file fails the validation, except the
 * warnings whose message contains one of the lines of the known warnings file (empty lines and lines starting with '#'
 * are ignored). It stops at the first file that fails, because the following files would only report errors caused by
 * that one.
 */
public class Validate {

    public static void main(String[] args) throws Exception {
        if (args.length < 3) {
            System.err.println("Usage: Validate <sysml.library directory> <known warnings file> <file.sysml>...");
            System.exit(2);
        }
        List<String> knownWarnings = Files.readAllLines(Path.of(args[1])).stream()
                .map(String::strip)
                .filter(line -> !line.isEmpty() && !line.startsWith("#"))
                .toList();
        SysMLInteractive pilot = SysMLInteractive.createInstance();
        pilot.loadLibrary(args[0].endsWith("/") ? args[0] : args[0] + "/");
        int known = 0;
        for (int i = 2; i < args.length; i++) {
            SysMLInteractiveResult result = pilot.process(Files.readString(Path.of(args[i])));
            boolean failed = result.hasErrors();
            int knownInFile = 0;
            for (Issue issue : result.getIssues()) {
                boolean isKnown = issue.getSeverity() == Severity.WARNING
                        && knownWarnings.stream().anyMatch(issue.getMessage()::contains);
                if (isKnown) {
                    knownInFile++;
                } else {
                    failed = true;
                }
                System.out.println((isKnown ? "known " : "") + issue.getSeverity() + " " + args[i] + ":"
                        + issue.getLineNumber() + " " + issue.getMessage());
            }
            if (failed) {
                System.out.println("FAILED " + args[i]);
                System.out.println((args.length - 1 - i) + " file(s) not validated after this one.");
                System.exit(1);
            }
            known += knownInFile;
            System.out.println("OK     " + args[i]);
        }
        System.out.println((args.length - 2) + " file(s) validated: no error, no unknown warning (" + known
                + " known warning(s)).");
        // The pilot implementation may leave non-daemon threads running.
        System.exit(0);
    }
}
