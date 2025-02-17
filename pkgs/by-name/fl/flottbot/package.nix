{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, substituteAll
}:
buildGoModule rec {
  pname = "flottbot";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "target";
    repo = "flottbot";
    rev = version;
    hash = "sha256-ldWE5QcLHyIqap5Qe6OTTIJZ1sshI+CVoJoRUxWHfxM=";
  };

  patches = [
    # patch out debug.ReadBuidlInfo since version information is not available with buildGoModule
    (substituteAll {
      src = ./version.patch;
      version = version;
      vcsHash = version; # Maybe there is a way to get the git ref from src? idk.
    })
  ];

  vendorHash = "sha256-XRcTp3ZnoPupzI1kjoM4oF5+VlNJFV0Bu+WAwfRWl7g=";

  subPackages = [ "cmd/flottbot" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A chatbot framework written in Go";
    homepage = "https://github.com/target/flottbot";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanhonof ];
    sourceProvenance = [ sourceTypes.fromSource ];
    mainProgram = "flottbot";
    platforms = platforms.unix;
  };
}
