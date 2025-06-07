# Example ZIO HTTP Service

This is an example implementation of a basic Scala HTTP service using:
* Zio HTTP
* Multi-Stage Container Build
  - Build Image containing Build Tools + JDK + Source Code
  - Final Image containing only JRE + Final Executable JAR

## Getting Started

### Requirements
- [JDK](https://adoptium.net/) == 21
  * Use Nix development shell provided by `flake.nix` which includes OpenJDK21
  * Or download Eclipse Temurin JDK21 from Adoptium https://adoptium.net/
    - Add `export JAVA_HOME=$(/usr/libexec/java_home -v 21)` to your shell profile
- [podman](https://podman.io/) >= 5.25
  * On MacOS: Install through Podman Desktop installer from https://podman.io/
  * On Ubuntu: `apt-get install -y podman`
- [podman-compose](https://docs.podman.io/en/stable/markdown/podman-compose.1.html) >= 1.2.0
  * On MacOS: `brew install podman-compose`
  * On Ubuntu: `apt-get install -y python3-pip` then `pip3 install podman-compose`

### Using Intellij
The Nix development shell includes Intellij CE with the Scala plugin installed.

```
# Start a development shell if not already in one:
> nix develop
# Then start Intellij and pass in the current directory:
(nix:nix-shell-env) bash-5.2$ idea .
```

This installation of Intellij launched through the Nix development shell should
also pick up the dev shell's JDK and Scala SDK.

### Running Tests

```
# Compile with scoverage instrumentation
./mill server.scoverage.compile

# Execute the tests
./mill server.test

# Generate the HTML report
./mill server.scoverage.htmlReport
```

### Starting The Server

There are multiple ways to start up the web server.

#### Using Mill
This is the quickest way to start the server.

```
./mill server.run
```

#### From The Executable JAR
This builds an executable jar.
This is how we would start the server in a production and containerized environment.

Note that it will use the JVM specified by the `JAVA_HOME` environment variable.

```
# This will generate the assembly jar
./mill show server.assembly

# This will start the server
./out/server/assembly.dest/out.jar
```

#### From within a container
This builds a container image that contains the executable jar of our server.

```
podman compose up
```

### Confirming Server Behavior
A server process should be bound on port 8080 and should respond to `GET /ping`.

```
❯ curl localhost:8080/ping
pong!
```
