{ lib, ... }:
{
  home.activation.ensureArtifactLockerDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p \
      "$HOME/.local/share/artifact-locker" \
      "$HOME/tools/payloads/linux" \
      "$HOME/tools/payloads/windows"
  '';

  home.file.".local/share/artifact-locker/config.json".source = ../files/artifact-locker/config.json;
}
