{ lib, stdenv, installShellFiles, fetchFromGitHub, freetype, gumbo, harfbuzz
, jbig2dec, mujs, mupdf, openjpeg, qt3d, qtbase, qmake, qtspeech, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sioyek";
  version = "unstable-2024-01-25";

  src = fetchFromGitHub {
    owner = "ahrm";
    repo = "sioyek";
    rev = "eaa6f5da86b409ca84085c512cfb42d661516685";
    sha256 = "sha256-PQdRHm0oIN3ZyAhsE3XkzrHhh981KL3gUdsxxtmO6Y4=";
  };

  buildInputs =
    [ gumbo harfbuzz jbig2dec mujs mupdf openjpeg qt3d qtbase qtspeech ]
    ++ lib.optionals stdenv.isDarwin [ freetype ];

  nativeBuildInputs = [ installShellFiles qmake wrapQtAppsHook ];

  qmakeFlags = lib.optionals stdenv.isDarwin [ "CONFIG+=non_portable" ];

  postPatch = ''
    substituteInPlace pdf_viewer_build_config.pro \
      --replace "-lmupdf-threads" "-lgumbo -lharfbuzz -lfreetype -ljbig2dec -ljpeg -lopenjp2" \
      --replace "-lmupdf-third" ""
    substituteInPlace pdf_viewer/main.cpp \
      --replace "/usr/share/sioyek" "$out/share" \
      --replace "/etc/sioyek" "$out/etc"
  '';

  postInstall = if stdenv.isDarwin then ''
    cp -r pdf_viewer/shaders sioyek.app/Contents/MacOS/shaders
    cp pdf_viewer/prefs.config sioyek.app/Contents/MacOS/
    cp pdf_viewer/prefs_user.config sioyek.app/Contents/MacOS/
    cp pdf_viewer/keys.config sioyek.app/Contents/MacOS/
    cp pdf_viewer/keys_user.config sioyek.app/Contents/MacOS/
    cp tutorial.pdf sioyek.app/Contents/MacOS/

    mkdir -p $out/Applications $out/bin
    cp -r sioyek.app $out/Applications
    ln -s $out/Applications/sioyek.app/Contents/MacOS/sioyek $out/bin/sioyek
  '' else ''
    install -Dm644 tutorial.pdf $out/share/tutorial.pdf
    cp -r pdf_viewer/shaders $out/share/
    install -Dm644 -t $out/etc/ pdf_viewer/{keys,prefs}.config
    installManPage resources/sioyek.1
  '';

  meta = with lib; {
    homepage = "https://sioyek.info/";
    description =
      "A PDF viewer designed for research papers and technical books";
    changelog =
      "https://github.com/ahrm/sioyek/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ podocarp xyven1 ];
    platforms = platforms.unix;
  };
})
