{ pkgs }:
{ scheme, width, height, logoScale, fontName, versionText }:
pkgs.stdenv.mkDerivation {
  name = "generated-nix-wallpaper-${scheme.slug}.png";
  src = pkgs.writeTextFile {
    name = "template.svg";
    text = ''
        <svg width="${toString width}" height="${
          toString height
        }" version="1.1" xmlns="http://www.w3.org/2000/svg">
          <rect width="${toString width}" height="${
            toString height
          }" fill="#${scheme.colors.base00}"/>
          <svg x="${toString (width / 2 - (logoScale * 50))}" y="${
            toString (height / 2 - (logoScale * 50))
          }" version="1.1" xmlns="http://www.w3.org/2000/svg">
      <style>
        text {
          fill: #${scheme.colors.base07};
        }
       </style>
            <g transform="scale(${toString logoScale})">
              <g transform="matrix(.19936 0 0 .19936 80.161 27.828)">
      <path
         d="m -777.98354,105.84 -122.20003,-211.68 56.157,-0.5268 32.62401,56.869 32.85602,-56.565 27.90201,0.011 14.29101,24.69 -46.81003,80.49 33.22903,57.826 z m -142.26003,92.748 244.42009,0.012 -27.62202,48.897 -65.56204,-0.1813 32.55902,56.737 -13.961,24.158 -28.52802,0.031 -46.30103,-80.784 -66.693,-0.1359 z m -9.3752,-169.2 -122.22,211.67 -28.535,-48.37 32.938,-56.688 -65.415,-0.1717 -13.942,-24.169 14.237,-24.721 93.111,0.2937 33.464,-57.69 z"
         fill="#${scheme.colors.base0C}" />
      <path
         d="m -821.36757,193.01 122.22007,-211.67 28.53502,48.37 -32.93802,56.688 65.41504,0.1716 13.94101,24.169 -14.23701,24.721 -93.11106,-0.2937 -33.46401,57.69 z m -9.5985,-169.65 -244.42,-0.012 27.622,-48.897 65.562,0.1813 -32.559,-56.737 13.961,-24.158 28.528,-0.031 46.301,80.784 66.693,0.1359 z m -141.76,93.224 122.2,211.68 -56.157,0.5268 -32.624,-56.869 -32.856,56.565 -27.902,-0.011 -14.291,-24.69 46.81,-80.49 -33.229,-57.826 z"
         fill="#${scheme.colors.base0D}" style="isolation:auto;mix-blend-mode:normal"/>
      <text
         xml:space="preserve"
         style="font-size:214.991px;stroke-width:17.916"
         x="-572.62247"
         y="184.64108"
         ><tspan
           sodipodi:role="line"
           id="tspan367"
           style="font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;font-family:Inter;-inkscape-font-specification:Inter;stroke-width:17.916"
           x="-572.62247"
           y="184.64108">NixOS</tspan></text>
      <text
         xml:space="preserve"
         style="font-size:86.3171px;stroke-width:7.19314"
         x="-530.67476"
         y="282.20279"
         ><tspan
           sodipodi:role="line"
           id="tspan367-7-3"
           style="font-style:normal;font-variant:normal;fill:#${scheme.colors.base0D};font-weight:normal;font-stretch:normal;font-family:Inter;-inkscape-font-specification:Inter;stroke-width:7.19314"
           x="-530.67476"
           y="282.20279">${versionText}</tspan></text>
              </g>
            </g>
          </svg>
        </svg>
    '';
  };
  buildInputs = with pkgs; [ inkscape ];
  unpackPhase = "true";
  buildPhase = ''
    inkscape --export-type="png" $src -w ${toString width} -h ${
      toString height
    } -o wallpaper.png
  '';
  installPhase = "install -Dm0644 wallpaper.png $out";
}
