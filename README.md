==Warning: work in progress / not ready for use==
# Description
## What is this repo for?
Shell scripts to help measure [Eclipse](https://www.eclipse.org/) Boot duration.
## How does it work?
See install and Howto below.
## Who will use this repo or project?
Anyone interested to measure its Eclipse application startup time / performances, or by [speeding up Eclipse](https://stackoverflow.com/q/316265/912046) 
## What is the goal of this project?
Provide a measuring tool to help comparing different eclipse.ini configurations.

# Install
==TODO==

# Howto
See: `shell-scripts/getEclipseBootDuration.sh`

## Enable Eclipse finest log level
==TODO==
See `/path/to/eclipse-workspaces/my-workspace/.metadata/.plugins/org.eclipse.m2e.logback.configuration/logback.1.8.3.20180227-2137.xml`

## Run Eclipse
```
$ echo "$(date +"%Y-%m-%d %T,%3N") Command started" && ~/dev/eclipse ; # Run Eclipse preceded by a custom echo timestamp
```

Example of logs:
```
2018-09-16 07:00:24,501 Command started
org.eclipse.m2e.logback.configuration: The org.eclipse.m2e.logback.configuration bundle was activated before the state location was initialized.  Will retry after the state location is initialized.
org.eclipse.m2e.logback.configuration: Logback config file: /path/to/eclipse-workspaces/my-workspace/.metadata/.plugins/org.eclipse.m2e.logback.configuration/logback.1.8.3.20180227-2137.xml
org.eclipse.m2e.logback.configuration: Initializing logback
2018-09-16 07:00:29,810 [Worker-14] INFO  c.g.t.t.d.PublishedGradleVersions - Gradle version information cache is up-to-date. Trying to read.
```

First timestamp is `2018-09-16 07:00:24,501`.
Last timestamp is `2018-09-16 07:00:29,810`.

## Compute boot duration from logs
Copy / paste Eclipse logs in an empty file `/tmp/eclipse.log`:
```
cat<<EOF>>/tmp/eclipse.log
2018-09-16 07:00:24,501 Command started
org.eclipse.m2e.logback.configuration: The org.eclipse.m2e.logback.configuration bundle was activated before the state location was initialized.  Will retry after the state location is initialized.
org.eclipse.m2e.logback.configuration: Logback config file: /path/to/eclipse-workspaces/my-workspace/.metadata/.plugins/org.eclipse.m2e.logback.configuration/logback.1.8.3.20180227-2137.xml
org.eclipse.m2e.logback.configuration: Initializing logback
2018-09-16 07:00:29,810 [Worker-14] INFO  c.g.t.t.d.PublishedGradleVersions - Gradle version information cache is up-to-date. Trying to read.
EOF
```

Call `getEclipseDurationTime.sh` with log file as argument :
```
getEclipseDurationTime.sh '/tmp/eclipse.log' ;
```
Should output (duration in millis):
```
5309
```

You can `set -x` to debug computation:
```
set -x ; getEclipseDurationTime.sh '/tmp/eclipse.log' ;
```
