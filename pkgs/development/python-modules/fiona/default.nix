{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, attrs, click, cligj, click-plugins, six, munch, enum34
, pytest, boto3
, gdal
}:

buildPythonPackage rec {
  pname = "Fiona";
  version = "1.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa31dfe8855b9cd0b128b47a4df558f1b8eda90d2181bff1dd9854e5556efb3e";
  };

  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11";

  nativeBuildInputs = [
    gdal # for gdal-config
  ];

  buildInputs = [
    gdal
  ];

  propagatedBuildInputs = [
    attrs
    click
    cligj
    click-plugins
    six
    munch
  ] ++ stdenv.lib.optional (!isPy3k) enum34;

  checkInputs = [
    pytest
    boto3
  ];

  checkPhase = ''
    rm -r fiona # prevent importing local fiona
    # Some tests access network, others test packaging
    pytest -k "not test_*_http \
           and not test_*_https \
           and not test_*_wheel"
  '';

  meta = with stdenv.lib; {
    description = "OGR's neat, nimble, no-nonsense API for Python";
    homepage = http://toblerity.org/fiona/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
