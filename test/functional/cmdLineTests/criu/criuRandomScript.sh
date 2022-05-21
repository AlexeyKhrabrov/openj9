#!/bin/sh

#
# Copyright (c) 2022, 2022 IBM Corp. and others
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which accompanies this
# distribution and is available at https://www.eclipse.org/legal/epl-2.0/
# or the Apache License, Version 2.0 which accompanies this distribution and
# is available at https://www.apache.org/licenses/LICENSE-2.0.
#
# This Source Code may also be made available under the following
# Secondary Licenses when the conditions for such availability set
# forth in the Eclipse Public License, v. 2.0 are satisfied: GNU
# General Public License, version 2 with the GNU Classpath
# Exception [1] and GNU General Public License, version 2 with the
# OpenJDK Assembly Exception [2].
#
# [1] https://www.gnu.org/software/classpath/license.html
# [2] http://openjdk.java.net/legal/assembly-exception.html
#
# SPDX-License-Identifier: EPL-2.0 OR Apache-2.0 OR GPL-2.0 WITH Classpath-exception-2.0 OR LicenseRef-GPL-2.0 WITH Assembly-exception
#

echo "start running script"
# the expected arguments are:
# $1 is the TEST_ROOT
# $2 is the JAVA_COMMAND
# $3 is the JVM_OPTIONS
# $4 is the test type
if [ "$4" = "Checkpoint" ]
then
    # append to the file to capture the output before checkpoint and after both restores
    $2 $3 -XX:+EnableCRIUSupport -cp $1/criu.jar org.openj9.criu.CRIURandomTest >>testOutput 2>&1
fi
if [ "$4" = "FirstRestore" ] || [ "$4" = "SecondRestore" ]
then
    sleep 2
    criu restore -D cpData --shell-job
fi
cat testOutput
if [ "$4" = "SecondRestore" ]
then
    rm -rf testOutput
fi
echo "finished script"
