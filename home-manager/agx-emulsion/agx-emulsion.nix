{
    pkgs ? import <nixpkgs> { 
	overlays = [
	    (final: prev: {
	      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
		(python-final: python-prev: {
		  colour-science = final.callPackage ./colour-science.nix {};
		  pyfftw = final.callPackage ./pyfftw.nix {};
		})
	      ];
	    })
	]; 
    },
}:

pkgs.python3Packages.buildPythonApplication rec {
    pname = "agx-emulsion";
    version = "0.1.0-alpha";
    pyproject = true;
    doCheck = false;
    doInstallCheck = false;

    src = pkgs.fetchFromGitHub {
	owner = "andreavolpato";
	repo = "agx-emulsion";
	rev = "0e0baf2e3dd51032e89df92c8bb281f05e3ce977";
	hash = "sha256-9N9ozvw7/XGHWX1AjblZbR7GI9dbHAwFUuV/C2HGZjI=";
    };

    build-system = with pkgs.python3Packages; [ setuptools ];

    dependencies = with pkgs; [
	python3Packages.numpy
	python3Packages.matplotlib
	python3Packages.scipy
	python3Packages.colour-science
	python3Packages.scikit-image
	python3Packages.dotmap
	python3Packages.opt-einsum
	python3Packages.napari
	python3Packages.magicgui
	python3Packages.lmfit
	python3Packages.pyqt5
	openimageio
	python3Packages.numba
	python3Packages.pyfftw
	python3Packages.cython
    ]; 
    
    nativeBuildInputs = with pkgs; [
	wrapGAppsHook3
	qt5.wrapQtAppsHook
	libsForQt5.qmake
    ];

    dontWrapGApps = true;

    preFixup = ''
	qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
    '';
}
