#!/bin/bash
# NAME
#  strip-image - strips the bare essentials from an image and exports them
#
# SYNOPSIS
#  strip-image -i image-name -t target-image-name [-t target-image-name:version] [-p package | -f file] [-d Dockerfile] [-x expose-port] [-v]
#
#
# OPTIONS
#  -i image-name         to strip
#  -t target-image-name  the image name of the stripped image, multiple -t allowed.
#  -p package            package(s) to include from image, multiple -p allowed.
#  -f file               file(s) to include from image, multiple -f allowed.
#  -x port               to expose.
#  -d Dockerfile         to incorporate in the stripped image.
#  -v verbose
#
# DESCRIPTION
#     creates a new Docker image based on the scratch  which contains
#  only the the source image of selected packages and files.
#
# EXAMPLE
#  The following example strips the nginx installation from the default NGiNX docker image,
#
#        strip-image -i nginx -t stripped-nginx  \
#      -p nginx  \
#      -f /etc/passwd \
#      -f /etc/group \
#      -f '/lib/*/libnss*' \
#      -f /bin/ls \
#      -f /bin/cat \
#      -f /bin/sh \
#      -f /bin/mkdir \
#      -f /bin/ps \
#      -f /var/run \
#      -f /var/log/nginx
#
# AUTHOR
#  Mark van Holsteijn
#
# COPYRIGHT
#
#   Copyright 2015 Xebia Nederland B.V.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#
# EXTENDED BY
#  Peter Norris
#  University of Warwick
#  1) merging of host and container scripts into a single script,
#  2) addition of SELinux context to container run
#  3) copying of script file to ro mapped mybin_[h|c] directory for invocation in container
#  4) changing container -d to -e for export directory identification
#  5) permitting multiple targets
#  6) chowning exported directory to invoking user (to simplify deletion)
#  7) Changing DEPS to PACKAGE_MANAGER and only testing once
#  8) Adding stripped-manifest into the exported directory
#  9) using _h to identify host and _c to identify container volumes and function names

function debug() {
  echo "DEBUG: $@" >&2
}

function debug_break() {
  debug  $@
  exit 3
}

function usage_c() {
	echo "usage: $(basename $0) [-v] [-d export-dir ] [-p package | -f file]" >&2
	echo "	$@" >&2
}


function usage_h() {
  echo "usage: $(basename $0) -i image-name -t stripped-image-name [-t stripped-image-name] [-d Dockerfile] [-p package | -f file] [-v]" >&2
  echo "  $@" >&2
}

function parse_commandline_c() {
  while getopts "vp:f:e:u:" OPT; do
      case "$OPT" in
    v)
        VERBOSE="v"
        ;;
    p)
        PACKAGES="$PACKAGES $OPTARG"
        ;;
    f)
        FILES="$FILES $OPTARG"
        ;;
    e)
        EXPORT_DIR="$OPTARG"
        ;;
    u)
        CHOWN_UID="$OPTARG"
        ;;
    *)
        usage_c
        exit 21
        ;;
      esac
  done
  shift $((OPTIND-1))

  if [ ! -d $EXPORT_DIR ] ; then
    usage_c "$EXPORT_DIR is not a directory."
    exit 22
  fi

  if [ -z "$PACKAGES" -a -z "$FILES" ] ; then
    usage_c "Missing -p or -f options"
    exit 23
  fi
  export PACKAGES FILES VERBOSE EXPORT_DIR CHOWN_UID
}

function print_file_c() {
  if [ -e "$1" ] ; then
    echo "$1"
  else
    test -n "$VERBOSE" && echo "INFO: ignoring not existent file '$1'" >&2
  fi

  if [ -s "$1" ] ; then
    TARGET=$(readlink "$1")
    if  [ -n "$TARGET" ] ; then
      if expr "$TARGET" : '^/' >/dev/null 2>&1 ; then
        list_dependencies_c "$TARGET"
      else
        list_dependencies_c $(dirname "$1")/"$TARGET"
      fi
    fi
  fi
}

function list_dependencies_c() {
  for FILE in $@ ; do
    if [ -e "$FILE" ] ; then
      print_file_c "$FILE"
      if /usr/bin/ldd "$FILE" >/dev/null 2>&1 ; then
        /usr/bin/ldd "$FILE" | \
        awk '/statically/{next;} /=>/ { print $3; next; } { print $1 }' | \
        while read LINE ; do
          test -n "$VERBOSE" && echo "INFO: including $LINE" >&2
          print_file_c "$LINE"
        done
        # TODO: exclude /usr/share/man files
      fi
    else
      test -n "$VERBOSE" && echo "INFO: ignoring not existent file $FILE" >&2
    fi
  done
}

function list_packages_c() {
  while read FILE ; do
    if [ ! -d "$FILE" ] ; then
      list_dependencies_c "$FILE"
    fi
  done <<< "$($PACKAGE_MANAGER $1)"
}

function list_all_packages_c() {
  if command -v /usr/bin/dpkg --version >/dev/null 2>&1; then
    PACKAGE_MANAGER="/usr/bin/dpkg -L "
  elif command -v /usr/bin/rpm --version >/dev/null 2>&1; then
    PACKAGE_MANAGER="/usr/bin/rpm -ql "
  else
    usage "source image needs either /usr/bin/dpkg or /usr/bin/rpm to list its dependencies - neither is present."
    exit 127
  fi
  for i in "$@" ; do
    list_packages_c "$i"
  done
}

function exec_c() {
  parse_commandline_c "$@"
  tar -czf - $(

    (
      list_all_packages_c $PACKAGES
      list_dependencies_c $FILES
    )  | sort -u | tee $EXPORT_DIR/stripped-manifest

  ) | (cd $EXPORT_DIR && tar -xzh${VERBOSE}f -)
  chown -R $CHOWN_UID /export_c
}

function parse_commandline_h() {
  while getopts "vi:t:p:f:x:d:" OPT; do
    case "$OPT" in
    v)
        VERBOSE="-v"
        ;;
    p)
        PACKAGES="$PACKAGES -p $OPTARG"
        ;;
    f)
        FILES="$FILES -f $OPTARG"
        ;;
    i)
        IMAGE_NAME="$OPTARG"
        ;;
    t)
        TARGET_IMAGE_NAME="$TARGET_IMAGE_NAME -t $OPTARG"
        ;;
    x)
        EXPOSE_PORTS="$EXPOSE_PORTS $OPTARG"
        ;;
    d)
        DOCKERFILES="$DOCKERFILES \"$OPTARG\""
        ;;
    *)
        usage_h
        exit 10
        ;;
      esac
  done
  shift $((OPTIND-1))

  if [ -z "$IMAGE_NAME" ] ; then
    usage_h "source image name -i missing."
    exit 11
  fi

  if [ -z "$TARGET_IMAGE_NAME" ] ; then
    usage_h "target image name -t missing."
    exit 12
  fi

  if [ -z "$PACKAGES" -a -z "$FILES" ] ; then
    usage_h "Missing -p or -f options"
    exit 13
  fi
  export PACKAGES FILES VERBOSE EXPORT_DIR
}

function setup_h(){
  mkdir -p "$DIR/export_h" "$DIR/mybin_h"
  cp "${BASH_SOURCE[0]}" "$DIR/mybin_h/export-stripped-filesystem"
  chmod o+w "$DIR/export_h"
}

function run_container_h(){
  DIR_ABS_PATH="$(cd $DIR && pwd)"
  docker run \
      --rm \
      --name "container-to-strip-$$" \
      --volume $DIR_ABS_PATH/export_h:/export_c:rw,Z \
      --volume $DIR_ABS_PATH/mybin_h:/mybin_c:ro,Z \
      --user root \
      --entrypoint="/bin/bash" \
      $IMAGE_NAME \
      /mybin_c/export-stripped-filesystem \
      -e "/export_c" \
      -u "$(id -u)" \
      $VERBOSE \
      $PACKAGES \
      $FILES || debug_break "docker run had unsuccesful exit"
}

function build_stripped_image_h(){
  echo "FROM scratch" >  $DIR/Dockerfile
  echo "ADD export_h /" >> $DIR/Dockerfile

  for DOCKERFILE in $DOCKERFILES ; do
      sed ':x; /\\$/ { N; s/\\\n//; tx }' "$(eval echo $DOCKERFILE)" \
        | grep -v '^\(FROM\|RUN\|ADD\|COPY\)' \
        >> $DIR/Dockerfile
  done

  for PORT in $EXPOSE_PORTS ; do
    echo EXPOSE $PORT >> $DIR/Dockerfile
  done

  (
    cd $DIR
    docker build --no-cache $TARGET_IMAGE_NAME .
  ) || debug_break "docker build had unsuccesful exit"
}

function teardown_h(){
  rm -rf $DIR
}

function exec_h(){
  parse_commandline_h "$@"
  DIR="tmp-build-base-$$"
  setup_h
  run_container_h
  build_stripped_image_h
  teardown_h
}

case "$$" in
  1) 
    exec_c "$@"
    ;;
  *) 
    exec_h "$@"
    ;;
esac

