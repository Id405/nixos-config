{
    pkgs ? import <nixpkgs> {},
}:

pkgs.python3Packages.buildPythonPackage rec {
    pname = "OpenImageIO";
    version = "3.1.8.0";
    pyproject = true;

    src = pkgs.python3Packages.fetchPypi {
	inherit pname version;
	hash = "sha256-u83m1A0WXhy68S3eBi6/6+nkM5TKyMFm5pm6LJpLBGE=";
    };

    build-system = with pkgs.python3Packages; [
	setuptools
	setuptools-scm
    ];

    dependencies = with pkgs; [
	python3Packages.numpy
	python3Packages.scipy
    ];

    nativeBuildInputs = with pkgs; [
	fftw
    ];
}
