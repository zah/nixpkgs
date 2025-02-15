/* This file defines the composition for CPAN (Perl) packages.  It has
   been factored out of all-packages.nix because there are so many of
   them.  Also, because most Nix expressions for CPAN packages are
   trivial, most are actually defined here.  I.e. there's no function
   for each package in a separate file: the call to the function would
   be almost as must code as the function itself. */

{pkgs, overrides}:

let self = _self // overrides; _self = with self; {

  inherit (pkgs) buildPerlPackage fetchurl stdenv perl fetchsvn gnused;

  inherit (stdenv.lib) maintainers;

  # Helper functions for packages that use Module::Build to build.
  buildPerlModule = { buildInputs ? [], ... } @ args:
    buildPerlPackage (args // {
      buildInputs = buildInputs ++ [ ModuleBuild ];
      preConfigure = "touch Makefile.PL";
      buildPhase = "perl Build.PL --prefix=$out; ./Build build";
      installPhase = "./Build install";
      checkPhase = "./Build test";
    });


  ack = buildPerlPackage rec {
    name = "ack-2.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "0gqv30666vlclnwylhk9i64s7raa70x4ncy6bg48s5gcxwrshjc5";
    };
    # use gnused so that the preCheck command passes
    buildInputs = stdenv.lib.optional stdenv.isDarwin [ gnused ];
    propagatedBuildInputs = [ FileNext ];
    meta = with stdenv.lib; {
      description = "A grep-like tool tailored to working with large trees of source code";
      homepage    = http://betterthangrep.com/;
      license     = licenses.artistic2;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
    # tests fails on nixos and hydra because of different purity issues
    doCheck = false;
  };

  AlgorithmAnnotate = buildPerlPackage {
    name = "Algorithm-Annotate-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/Algorithm-Annotate-0.10.tar.gz;
      sha256 = "1y92k4nqkscfwpriv8q7c90rjfj85lvwq1k96niv2glk8d37dcf9";
    };
    propagatedBuildInputs = [AlgorithmDiff];
  };

  AlgorithmC3 = buildPerlModule {
    name = "Algorithm-C3-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Algorithm-C3-0.08.tar.gz;
      sha256 = "016cjr63wivg54ms6sjnxz4g75fafgvgwralamv29phcic2cl2am";
    };
    meta = {
      description = "A module for merging hierarchies using the C3 algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AlgorithmDiff = buildPerlPackage rec {
    name = "Algorithm-Diff-1.1902";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TY/TYEMQ/Algorithm-Diff-1.1902.tar.gz;
      sha256 = "0xc315h7xwq65n9n6nq8flv5d89z6kra69hspnyccw3782zhvd68";
    };
    buildInputs = [ pkgs.unzip ];
  };

  AlgorithmMerge = buildPerlPackage rec {
    name = "Algorithm-Merge-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JS/JSMITH/Algorithm-Merge-0.08.tar.gz;
      sha256 = "1kqn13wd0lfjrf6h19b9kgdqqwp7k2d9yfq5i0wvii0xi8jqh1lw";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  aliased = buildPerlPackage rec {
    name = "aliased-0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "0gxfqdddlq5g1b2zs99b251hz52z9ys4yni7j2p8gyk5zij3wm1s";
    };
  };

  AlienWxWidgets = buildPerlPackage rec {
    name = "Alien-wxWidgets-0.65";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MD/MDOOTSON/${name}.tar.gz";
      sha256 = "0h4g7jl0p8a35kyvsji3qlb75mbcfqpvvmwh7s9krkbqklqjlxxl";
    };
    propagatedBuildInputs = [ pkgs.pkgconfig pkgs.gtk2 pkgs.wxGTK ModulePluggable ];
  };

  AnyEvent = buildPerlPackage rec {
    name = "AnyEvent-7.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "16nnqzxy5baiar6gxnq5w296mmjgijcn1jq8rp867nksph03mxz8";
    };
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  AnyEventI3 = buildPerlPackage rec {
    name = "AnyEvent-I3-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTPLBG/${name}.tar.gz";
      sha256 = "1qwva5vmmn929l6k9wzhp4h80ad4qm4m1g2dyv4nlas624003hig";
    };
    propagatedBuildInputs = [ AnyEvent JSONXS ];
    meta = {
      description = "Communicate with the i3 window manager";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  AnyEventRabbitMQ = buildPerlPackage {
    name = "AnyEvent-RabbitMQ-1.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/AnyEvent-RabbitMQ-1.15.tar.gz;
      sha256 = "fda292dfaae10f6d99aafc46831ce507153b58368e3eb2617bbb3f749605805a";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ AnyEvent DevelGlobalDestruction FileShareDir ListMoreUtils NetAMQP Readonly namespaceclean ];
    meta = {
      description = "An asynchronous and multi channel Perl AMQP client";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  AnyMoose = buildPerlPackage rec {
    name = "Any-Moose-0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "0g4w11chpnspnksw80jbdn5wp2m5hqzcyjzcy2hsjz9rkk2ncdbk";
    };
    propagatedBuildInputs = [ Mouse ];
  };

  ApacheLogFormatCompiler = buildPerlModule {
    name = "Apache-LogFormat-Compiler-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAZEBURO/Apache-LogFormat-Compiler-0.13.tar.gz;
      sha256 = "b4185125501e288efbc664da8b723ff86f0b69eb57d3c7c69c7d2069aab0efb0";
    };
    buildInputs = [ HTTPMessage TestRequires TryTiny URI ];
    meta = {
      homepage = https://github.com/kazeburo/Apache-LogFormat-Compiler;
      description = "Compile a log format string to perl-code";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ApacheTest = buildPerlPackage {
    name = "Apache-Test-1.38";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/Apache-Test-1.38.tar.gz;
      sha256 = "321717f58636ed0aa85cba6d69fc01e2ccbc90ba71ec2dcc2134d8401af65145";
    };
  };

  AppCLI = buildPerlPackage {
    name = "App-CLI-0.313";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORNELIUS/App-CLI-0.313.tar.gz;
      sha256 = "0ni1z14xis1b634qjc3zra9c9pl2icfr6sp5qxs0xy8nvib65037";
    };
    propagatedBuildInputs = [LocaleMaketextSimple];
  };

  AppCmd = buildPerlPackage {
    name = "App-Cmd-0.326";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/App-Cmd-0.326.tar.gz;
      sha256 = "1z6vp1am170fczc0srj63rdvrdbrjk3acmj6ka5v5n6qim4xsv9b";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ CaptureTiny ClassLoad DataOptList GetoptLongDescriptive IOTieCombine StringRewritePrefix SubExporter ModulePluggable SubInstall ];
    meta = {
      homepage = https://github.com/rjbs/app-cmd;
      description = "Write command line apps with less suffering";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  AppConfig = buildPerlPackage {
    name = "AppConfig-1.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABW/AppConfig-1.66.tar.gz;
      sha256 = "1p1vs9px20lrq9mdwpzp309a8r6rchibsdmxang4krk90pi2sh4b";
    };
    meta = {
      description = "A bundle of Perl5 modules for reading configuration files and parsing command line arguments";
    };
  };

  Appcpanminus = buildPerlPackage {
    name = "App-cpanminus-1.7027";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/App-cpanminus-1.7027.tar.gz;
      sha256 = "6853359493f8465abbe556d7409e7c0abecd1b48b6a63d2f851af83839c34b31";
    };
    meta = {
      homepage = https://github.com/miyagawa/cpanminus;
      description = "Get, unpack, build and install modules from CPAN";
      license = "perl";
      platforms = stdenv.lib.platforms.all;
    };
  };

  Appperlbrew = buildPerlPackage {
    name = "App-perlbrew-0.71";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GU/GUGOD/App-perlbrew-0.71.tar.gz;
      sha256 = "5e5de7c4d5235556f6cd5c5e56751fb2d73821ef58390e457db4253542224a09";
    };
    buildInputs = [ pkgs.curl IOAll PathClass TestException TestNoWarnings TestOutput TestSpec ];
    propagatedBuildInputs = [ CPANPerlReleases CaptureTiny DevelPatchPerl locallib ];
    meta = {
      description = "Manage perl installations in your $HOME";
      license = stdenv.lib.licenses.mit;
    };
  };

  AppSqitch = buildPerlModule rec {
    version = "0.999";
    name = "App-Sqitch-${version}";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/App-Sqitch-0.999.tar.gz;
      sha256 = "e7e02194a7b0c42fb4df046cd834d5eb99ff9a2c169f5c60a52c362e89351da6";
    };
    buildInputs = [
      CaptureTiny PathClass TestDeep TestDir TestException
      TestFile TestFileContents TestMockModule TestNoWarnings
    ];
    propagatedBuildInputs = [
      Clone ConfigGitLike DBI DateTime
      DevelStackTrace EncodeLocale FileHomeDir HashMerge IOPager IPCRun3
      IPCSystemSimple ListMoreUtils Moo PathClass PerlIOutf8_strict StringFormatter
      StringShellQuote SubExporter TemplateTiny Throwable TryTiny TypeTiny URI
      URIdb libintlperl namespaceautoclean
    ];
    doCheck = false;  # Can't find home directory.
    meta = {
      homepage = http://sqitch.org/;
      description = "Sane database change management";
      license = stdenv.lib.licenses.mit;
    };
  };

  AttributeHandlers = buildPerlPackage {
    name = "Attribute-Handlers-0.99";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Attribute-Handlers-0.99.tar.gz;
      sha256 = "937ea3ebfc9b14f4a4148bf3c32803709edbd12a387137a26370b38ee1fc9835";
    };
    meta = {
      description = "Simpler definition of attribute handlers";
      license = "perl";
    };
  };

  AttributeParamsValidate = buildPerlPackage {
    name = "Attribute-Params-Validate-1.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Attribute-Params-Validate-1.21.tar.gz;
      sha256 = "586b939ceffdb37188b7c461dd1a8f9f35695184c8703b05c35f6d508c8090f5";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ParamsValidate ];
    doCheck = false;
    meta = {
      homepage = http://metacpan.org/release/Attribute-Params-Validate;
      description = "Define validation through subroutine attributes";
      license = "artistic_2";
    };
  };

  ArrayCompare = buildPerlPackage {
    name = "Array-Compare-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAVECROSS/Array-Compare-1.18.tar.gz;
      sha256 = "0zbvr1bj9bp836b3g9s32193vvn53d03xv0zn317hz247skn15lh";
    };
  };

  ListCompare = buildPerlPackage {
    name = "List-Compare-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JK/JKEENAN/List-Compare-0.39.tar.gz;
      sha256 = "1v4gn176faanzf1kr9axdp1220da7nkvz0d66mnk34nd0skjjxcl";
    };
  };

  ArchiveCpio = buildPerlPackage {
    name = "Archive-Cpio-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PI/PIXEL/Archive-Cpio-0.09.tar.gz;
      sha256 = "1cf8k5zjykdbc1mn8lixlkij6jklwn6divzyq2grycj3rpd36g5c";
    };
    meta = {
      description = "Module for manipulations of cpio archives";
      platforms = stdenv.lib.platforms.linux;
    };
  };

  ArchiveExtract = buildPerlPackage {
    name = "Archive-Extract-0.74";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Archive-Extract-0.74.tar.gz;
      sha256 = "b297d230fe91720a423a01482db7e037b2acf589f9c8f58cef39f3148374e216";
    };
    propagatedBuildInputs = [ if_ ];
    meta = {
      description = "Generic archive extracting mechanism";
      license = "perl";
    };
  };

  ArchiveZip = buildPerlPackage {
    name = "Archive-Zip-1.16";
    src = fetchurl {
      url = http://tarballs.nixos.org/Archive-Zip-1.16.tar.gz;
      sha256 = "1ghgs64by3ybjlb0bj65kxysb03k72i7iwmw63g41bj175l44ima";
    };
  };

  AuthenDecHpwd = buildPerlPackage rec {
    name = "Authen-DecHpwd-2.006";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "67f45fef6a23b7548f387b675cbf7881bf9da62d7d007cbf90d3a4b851b99eb7";
    };
    propagatedBuildInputs = [ ScalarString DataInteger DigestCRC ];
  };

  AuthenHtpasswd = buildPerlPackage rec {
    name = "Authen-Htpasswd-0.171";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Authen/${name}.tar.gz";
      sha256 = "0rw06hwpxg388d26l0jvirczx304f768ijvc20l4b2ll7xzg9ymm";
    };
    propagatedBuildInputs = [ ClassAccessor CryptPasswdMD5 DigestSHA1 IOLockedFile ];
  };

  AuthenPassphrase = buildPerlPackage rec {
    name = "Authen-Passphrase-0.008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "55db4520617d859d88c0ee54965da815b7226d792b8cdc8debf92073559e0463";
    };
    propagatedBuildInputs = [ModuleRuntime ParamsClassify CryptPasswdMD5 CryptDES
      DataEntropy CryptUnixCryptXS CryptEksblowfish CryptMySQL DigestMD4 AuthenDecHpwd];
  };

  AuthenSASL = buildPerlPackage rec {
    name = "Authen-SASL-2.1401";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBARR/${name}.tar.gz";
      sha256 = "1vx97xnqj5jqlh767l04jbqmsiqd5qcbw2jnbd3qh7fhh0slff6d";
    };
    propagatedBuildInputs = [DigestHMAC];
  };

  autobox = pkgs.perlPackages.Autobox;

  Autobox = buildPerlPackage {
    name = "autobox-2.82";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHOCOLATE/autobox-2.82.tar.gz;
      sha256 = "0w008z8ych54czr6drmhqrrvikcfhra6ig3v1fhk36apq64p9k1p";
    };
    propagatedBuildInputs = [ ScopeGuard ];
    meta = {
      description = "Call methods on native types";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Autodia = buildPerlPackage rec {
    name = "Autodia-2.03";
    src = fetchurl {
      url = "http://www.aarontrevena.co.uk/opensource/autodia/download/${name}.tar.gz";
      sha256 = "1pzp30lnqkip2yrmnyzrf62g08xwn751nf9gmwdxjc09daaihwaz";
    };
    propagatedBuildInputs = [ TemplateToolkit Inline InlineJava GraphViz ];

    meta = {
      description = "AutoDia, create UML diagrams from source code";

      longDescription = ''
        AutoDia is a modular application that parses source code, XML or data
        and produces an XML document in Dia format (or images via graphviz
        and vcg).  Its goal is to be a UML / DB Schema diagram autocreation
        package.  The diagrams its creates are standard UML diagrams showing
        dependencies, superclasses, packages, classes and inheritances, as
        well as the methods, etc of each class.

        AutoDia supports any language that a Handler has been written for,
        which includes C, C++, Java, Perl, Python, and more.
      '';

      homepage = http://www.aarontrevena.co.uk/opensource/autodia/;
      license = stdenv.lib.licenses.gpl2Plus;

      maintainers = [ ];
    };
  };

  autodie = null; # part of Perl

  AutoLoader = buildPerlPackage {
    name = "AutoLoader-5.74";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/AutoLoader-5.74.tar.gz;
      sha256 = "2fac75b05309f71a6871804cd25e1a3ba0a28f43f294fb54528077558da3aff4";
    };
    meta = {
      description = "Load subroutines only on demand";
      license = "perl";
    };
  };

  autovivification = buildPerlPackage {
    name = "autovivification-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/V/VP/VPIT/autovivification-0.12.tar.gz;
      sha256 = "6ef8686766c63571389880e5d87a0ca1d46f7d127982e8ef38aca7568c44840c";
    };
    meta = {
      homepage = http://search.cpan.org/dist/autovivification/;
      description = "Lexically disable autovivification";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  base = buildPerlPackage {
    name = "base-2.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RG/RGARCIA/base-2.18.tar.gz;
      sha256 = "55b0d21f8edb5ef6dddcb1fd2457acb19c7584f2dfdea614685cd8ea62a1c306";
    };
  };

  BC = buildPerlPackage {
    name = "B-C-1.52";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/B-C-1.52.tar.gz;
      sha256 = "072b4b9e39431ad8ef5173557c26ade97f985cf150f6580a20f42dd9fc3651a7";
    };
    propagatedBuildInputs = [ BFlags IPCRun Opcodes ];
    meta = {
      homepage = http://www.perl-compiler.org;
      description = "Perl compiler";
      license = "perl";
    };
  };

  BFlags = buildPerlPackage {
    name = "B-Flags-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/B-Flags-0.13.tar.gz;
      sha256 = "6d00f08681772d0abec3aeedb5584910a6df5ced230c1525403a1c7da42f1352";
    };
    meta = {
      description = "Friendlier flags for B";
    };
  };

  BerkeleyDB = import ../development/perl-modules/BerkeleyDB {
    inherit buildPerlPackage fetchurl;
    inherit (pkgs) db;
  };

  BHooksEndOfScope = buildPerlPackage {
    name = "B-Hooks-EndOfScope-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/B-Hooks-EndOfScope-0.13.tar.gz;
      sha256 = "1f5d0lbkwf23dfjn60g6fynmjhy5rxdyxcpdfb07srm73qpg2zpi";
    };
    propagatedBuildInputs = [ ModuleImplementation ModuleRuntime SubExporterProgressive ];
    meta = {
      homepage = http://metacpan.org/release/B-Hooks-EndOfScope;
      description = "Execute code after a scope finished compilation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BHooksOPCheck = buildPerlPackage {
    name = "B-Hooks-OP-Check-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/Z/ZE/ZEFRAM/B-Hooks-OP-Check-0.19.tar.gz;
      sha256 = "0pp1piv74pv9irqlvl5xcs2dvzbb74niwjhnj6dsckxf1j34mzrg";
    };
    buildInputs = [ ExtUtilsDepends ];
    meta = {
      description = "Wrap OP check callbacks";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  bignum = buildPerlPackage {
    name = "bignum-0.37";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PJ/PJACKLAM/bignum-0.37.tar.gz;
      sha256 = "9d2e035222d8b00d062959cb5ae491cb6ce80b7ea0ea8c05e53c415022e4f871";
    };
    meta = {
      description = "Transparent BigNumber support for Perl";
      license = "perl";
    };
  };

  BitVector = buildPerlPackage {
    name = "Bit-Vector-7.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Bit-Vector-7.3.tar.gz;
      sha256 = "0gcg1173i1bsx2qvyw77kw90xbf03b861jc42hvq744vzc5k6xjs";
    };
    propagatedBuildInputs = [CarpClan];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  BKeywords = buildPerlPackage {
    name = "B-Keywords-1.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/B-Keywords-1.13.tar.gz;
      sha256 = "073eb916f69bd337261de6cb6cab8ccdb06f67415d8c7291453ebdfdfe0be405";
    };
    meta = {
      description = "Lists of reserved barewords and symbol names";
      license = "unknown";
    };
  };

  boolean = buildPerlPackage {
    name = "boolean-0.32";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IN/INGY/boolean-0.32.tar.gz;
      sha256 = "1icihm1cib90klfjrk069s7031n1c7xk3fmkr2bfxrwqda4di7jg";
    };
    meta = {
      homepage = https://github.com/ingydotnet/boolean-pm/tree;
      description = "Boolean support for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BoostGeometryUtils = buildPerlModule rec {
    name = "Boost-Geometry-Utils-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AA/AAR/${name}.tar.gz";
      sha256 = "1jnihz3029x51a455nxa0jx2z125x38q3vkkggsgdlrvawzxsm00";
    };
    propagatedBuildInputs = [ ModuleBuildWithXSpp ExtUtilsTypemapsDefault ];
    patches = [
      # Fix out of memory error on Perl 5.19.4 and later.
      ../development/perl-modules/boost-geometry-utils-fix-oom.patch
    ];
  };

  BusinessISBN = buildPerlPackage {
    name = "Business-ISBN-2.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Business-ISBN-2.07.tar.gz;
      sha256 = "4c11279580872bf3cc7176bb75c25b165d4b59a2828fc43d9a355cec3d0a45ff";
    };
    propagatedBuildInputs = [ BusinessISBNData URI ];
    meta = {
      description = "Parse and validate ISBNs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BusinessISBNData = buildPerlPackage {
    name = "Business-ISBN-Data-20120719.001";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Business-ISBN-Data-20120719.001.tar.gz;
      sha256 = "745f6bf8f7bd912c0a1865aa5f7e49343804de27783f544b2e2c714e14a704a3";
    };
    meta = {
      description = "Data pack for Business::ISBN";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BusinessISMN = buildPerlPackage {
    name = "Business-ISMN-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Business-ISMN-1.11.tar.gz;
      sha256 = "76d5240a5672c7a8b1ba9e9ea8238a5c8882139911acbb67b7059b5ee3da342d";
    };
    propagatedBuildInputs = [ TieCycle ];
    meta = {
      description = "Work with International Standard Music Numbers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  BusinessISSN = buildPerlPackage {
    name = "Business-ISSN-0.91";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Business-ISSN-0.91.tar.gz;
      sha256 = "f15b192c0f547bb2967811072b3d343b94bc5ea58d02704c19122f7ae0a9d6b5";
    };
    meta = {
      description = "Work with International Standard Serial Numbers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CacheCache = buildPerlPackage rec {
    name = "Cache-Cache-1.06";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Cache/${name}.tar.gz";
      sha256 = "14s75bsm5irisp8wkbwl3ycw160srr1rks7x9jcbvcxh79wr6gbh";
    };
    propagatedBuildInputs = [ DigestSHA1 Error IPCShareLite ];
    doCheck = false; # randomly fails
  };

  CacheFastMmap = buildPerlPackage rec {
    name = "Cache-FastMmap-1.40";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Cache/${name}.tar.gz";
      sha256 = "0h3ckr04cdn6dvl40m4m97vl5ybf30v1lwhw3jvkr92kpksvq4hd";
    };
  };

  CacheMemcached = buildPerlPackage rec {
    name = "Cache-Memcached-1.30";
    src = fetchurl {
      url =
      mirror://cpan/authors/id/D/DO/DORMANDO/Cache-Memcached-1.30.tar.gz;
      sha256 = "1aa2mjn5767b13063nnsrwcikrnbspby7j1c5q007bzaq0gcbcri";
    };
    propagatedBuildInputs = [ StringCRC32 ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CacheMemcachedFast = buildPerlPackage {
    name = "Cache-Memcached-Fast-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KR/KROKI/Cache-Memcached-Fast-0.21.tar.gz;
      sha256 = "0lvwkkyazbb7i6c5ga5ms3gsvy721njpcbc2icxcsvc8bz32nz5i";
    };
    meta = {
      description = "Perl client for B<memcached>, in C language";
      license = "unknown";
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CacheMemory = buildPerlPackage {
    name = "Cache-Memory-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLEISHMAN/Cache-2.04.tar.gz;
      sha256 = "1zykapgl9lxnlx79xfghzb26qimhry94xfxfyswwfhra1ywd9yyg";
    };
    propagatedBuildInputs = [ TimeDate DBFile DigestSHA1 FileNFSLock HeapFibonacci IOString ];
    doCheck = false; # can time out
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  Cairo = buildPerlPackage rec {
    name = "Cairo-1.105";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "0im025wy1346w7b7hi6im08bfn6x4ma0cxmjz6xnk8riizm1s84q";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig pkgs.cairo ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net/;
      description = "Perl interface to the cairo 2d vector graphics library";
      maintainers = with maintainers; [ nckx ];
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  cam_pdf = buildPerlPackage rec {
    name = "CAM-PDF-1.60";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CD/CDOLAN/${name}.tar.gz";
      sha256 = "12dv5ssf3y7yjz9mrrqnfzx8nf4ydk1qijf5fx59495671zzqsp7";
    };
    propagatedBuildInputs = [ CryptRC4 TextPDF ];
    buildInputs = [ TestMore ];
  };

  CaptchaReCAPTCHA = buildPerlPackage rec {
    name = "Captcha-reCAPTCHA-0.97";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/Captcha-reCAPTCHA-0.97.tar.gz;
      sha256 = "12f2yh89aji6mnkrqxjcllws5dlg545wvz0j7wamy149xyqi12wq";
    };
    propagatedBuildInputs = [HTMLTiny LWP];
    buildInputs = [TestPod];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CaptureTiny = buildPerlPackage {
    name = "Capture-Tiny-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.24.tar.gz;
      sha256 = "0rg0m9irhx8jwamxdi2ms4vhhxy7q050gjrn2m051spqfa26zkwv";
    };
    meta = {
      homepage = https://metacpan.org/release/Capture-Tiny;
      description = "Capture STDOUT and STDERR from Perl, XS or external programs";
      license = stdenv.lib.licenses.asl20;
    };
  };

  Carp = buildPerlPackage {
    name = "Carp-1.36";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Carp-1.36.tar.gz;
      sha256 = "dcc789935126461c80df0653f98c1d8d0b936dcc3d04174287cb02767eca123c";
    };
    meta = {
      description = "Alternative warn and die for modules";
      license = "perl";
    };
  };

  CarpAlways = buildPerlPackage rec {
    name = "Carp-Always-0.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/${name}.tar.gz";
      sha256 = "0i2rifkr7ybfcdsqana52487z7vxp2l5qdra0f6ik0ddhn6rzii1";
    };
    meta = {
      description = "Warns and dies noisily with stack backtraces";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CarpAssert = buildPerlPackage {
    name = "Carp-Assert-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/Carp-Assert-0.20.tar.gz;
      sha256 = "1wzy4lswvwi45ybsm65zlq17rrqx84lsd7rajvd0jvd5af5lmlqd";
    };
    meta = {
    };
  };

  CarpAssertMore = buildPerlPackage {
    name = "Carp-Assert-More-1.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Carp-Assert-More-1.14.tar.gz;
      sha256 = "0cq7qk4qbhqppm4raby5k24b5mx5qjgy1884nrddhxillnzlq01z";
    };
    propagatedBuildInputs = [ CarpAssert TestException ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      license = stdenv.lib.licenses.artistic2;
    };
  };

  CarpClan = buildPerlPackage {
    name = "Carp-Clan-6.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Carp-Clan-6.04.tar.gz;
      sha256 = "1v71k8s1pi16l5y579gnrg372c6pdvy6qqm6iddm8h1dx7n16bjl";
    };
    propagatedBuildInputs = [ TestException ];
    meta = {
      description = "Report errors from perspective of caller of a \"clan\" of modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystActionRenderView = buildPerlPackage rec {
    name = "Catalyst-Action-RenderView-0.16";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "0j1rrld13cjk7ks92b5hv3xw4rfm2lvmksb4rlzd8mx0a0wj0rc5";
    };
    propagatedBuildInputs =
      [ CatalystRuntime HTTPRequestAsCGI DataVisitor MROCompat ];
  };

  CatalystActionREST = buildPerlPackage {
    name = "Catalyst-Action-REST-1.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/Catalyst-Action-REST-1.17.tar.gz;
      sha256 = "c833c6ba2150b035b0486ff568c1e5928c14bb53d6a70758271feb969aaedde6";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ CatalystRuntime ClassInspector LWP MROCompat ModulePluggable Moose ParamsValidate URIFind namespaceautoclean ];
    meta = {
      description = "Automated REST Method Dispatching";
      license = "perl";
    };
  };

  CatalystAuthenticationCredentialHTTP = buildPerlPackage {
    name = "Catalyst-Authentication-Credential-HTTP-1.015";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Authentication-Credential-HTTP-1.015.tar.gz;
      sha256 = "02gyq0vkhj2psd7hvw4b095mvsz7vbq8kv4k8lq748jnx5kmnfrq";
    };
    buildInputs = [ TestException TestMockObject ];
    propagatedBuildInputs = [ CatalystPluginAuthentication CatalystRuntime ClassAccessorFast DataUUID StringEscape URI ];
    meta = {
      description = "HTTP Basic and Digest authentication";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CatalystAuthenticationStoreHtpasswd = buildPerlPackage rec {
    name = "Catalyst-Authentication-Store-Htpasswd-1.003";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "09mn0wjwfvnfi28y47g816nx50zdpvwvbxp0nrpsap0ir1m80wi3";
    };
    buildInputs = [ TestWWWMechanizeCatalyst Testuseok ];
    propagatedBuildInputs =
      [ CatalystPluginAuthentication ClassAccessor CryptPasswdMD5 AuthenHtpasswd HTMLForm ];
  };

  CatalystAuthenticationStoreDBIxClass = buildPerlPackage {
    name = "Catalyst-Authentication-Store-DBIx-Class-0.1506";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/Catalyst-Authentication-Store-DBIx-Class-0.1506.tar.gz;
      sha256 = "0i5ja7690fs9nhxcij6lw51j804sm8s06m5mvk1n8pi8jljrymvw";
    };
    propagatedBuildInputs = [ CatalystModelDBICSchema CatalystPluginAuthentication CatalystRuntime DBIxClass ListMoreUtils Moose namespaceautoclean TryTiny ];
    meta = {
      description = "A storage class for Catalyst Authentication using DBIx::Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystComponentInstancePerContext = buildPerlPackage rec {
    name = "Catalyst-Component-InstancePerContext-0.001001";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRODITI/${name}.tar.gz";
      sha256 = "0wfj4vnn2cvk6jh62amwlg050p37fcwdgrn9amcz24z6w4qgjqvz";
    };
    propagatedBuildInputs = [CatalystRuntime Moose];
  };

  CatalystControllerHTMLFormFu = buildPerlPackage rec {
    name = "Catalyst-Controller-HTML-FormFu-0.03007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "1vrd79d0nbqkana5q483fgsr41idlfgjhf7fpd3hc056z5nq8iyn";
    };
    propagatedBuildInputs = [
      CatalystRuntime CatalystActionRenderView CatalystViewTT
      CatalystPluginConfigLoader ConfigGeneral
      CatalystComponentInstancePerContext Moose
      RegexpAssemble TestWWWMechanize
      TestWWWMechanizeCatalyst HTMLFormFu
    ];
  };

  CatalystDevel = buildPerlPackage {
    name = "Catalyst-Devel-1.39";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/Catalyst-Devel-1.39.tar.gz;
      sha256 = "12m50bbkggjmpxihv3wnvr0g2qng0zwhlzi5ygppjz8wh2x73qxw";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ CatalystRuntime CatalystActionRenderView CatalystPluginConfigLoader CatalystPluginStaticSimple ConfigGeneral FileChangeNotify FileCopyRecursive FileShareDir ModuleInstall Moose MooseXDaemonize MooseXEmulateClassAccessorFast namespaceautoclean namespaceclean PathClass Starman TemplateToolkit ];
    meta = {
      homepage = http://dev.catalyst.perl.org/;
      description = "Catalyst Development Tools";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystDispatchTypeRegex = buildPerlModule {
    name = "Catalyst-DispatchType-Regex-5.90033";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MG/MGRIMES/Catalyst-DispatchType-Regex-5.90033.tar.gz;
      sha256 = "0rdi8jxj9fz81l9pxl7q190v69vkgxgixcpals555xyiafnqk4vy";
    };
    propagatedBuildInputs = [ Moose TextSimpleTable ];
    meta = {
      description = "Regex DispatchType";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystEngineHTTPPrefork = buildPerlPackage rec {
    name = "Catalyst-Engine-HTTP-Prefork-0.51";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGRUNDMA/${name}.tar.gz";
      sha256 = "1ygmrzc9akjaqfxid8br11ajj9qgfvhkimakcv4ffk4s5v7q2sii";
    };
    propagatedBuildInputs = [
      CatalystRuntime HTTPBody NetServer
      CookieXS HTTPHeaderParserXS
    ];
    buildInputs = [TestPod TestPodCoverage];
    patches = [
      # Fix chunked transfers (they were missing the final CR/LF at
      # the end, which makes curl barf).
      ../development/perl-modules/catalyst-fix-chunked-encoding.patch
    ];
  };

  CatalystManual = buildPerlPackage {
    name = "Catalyst-Manual-5.9007";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Catalyst-Manual-5.9007.tar.gz;
      sha256 = "140526pzzqc1vyxkk9fxvp9ds3kk2rncf8nf7iz0adlr219pkg3j";
    };
    meta = {
      description = "The Catalyst developer's manual";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystModelDBICSchema = buildPerlPackage {
    name = "Catalyst-Model-DBIC-Schema-0.65";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBJK/Catalyst-Model-DBIC-Schema-0.65.tar.gz;
      sha256 = "26a911ef5ef7ffc81b6ce65c3156f71fb35083c456ad27e6d82d2dc02493eeea";
    };
    buildInputs = [ DBDSQLite TestException TestRequires ];
    propagatedBuildInputs = [ CarpClan CatalystComponentInstancePerContext CatalystRuntime CatalystXComponentTraits DBIxClass DBIxClassSchemaLoader HashMerge ListMoreUtils ModuleRuntime Moose MooseXMarkAsMethods MooseXNonMoose MooseXTypes MooseXTypesLoadableClass TieIxHash TryTiny namespaceautoclean namespaceclean ];
    meta = {
      description = "DBIx::Class::Schema Model Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystRuntime = buildPerlPackage {
    name = "Catalyst-Runtime-5.90075";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JJ/JJNAPIORK/Catalyst-Runtime-5.90075.tar.gz;
      sha256 = "a80ed1b1600a8ababda34bc024756a6fb0275b0fff3fa1bb17104813e3ce8752";
    };
    buildInputs = [ DataDump HTTPMessage IOstringy JSONMaybeXS TestFatal ];
    propagatedBuildInputs = [ CGISimple CGIStruct ClassC3AdoptNEXT ClassDataInheritable ClassLoad DataDump DataOptList Encode HTMLParser HTTPBody HTTPMessage HTTPRequestAsCGI HashMultiValue JSONMaybeXS LWP ListMoreUtils MROCompat ModulePluggable Moose MooseXEmulateClassAccessorFast MooseXGetopt MooseXMethodAttributes MooseXRoleWithOverloading PathClass Plack PlackMiddlewareFixMissingBodyInRedirect PlackMiddlewareMethodOverride PlackMiddlewareRemoveRedundantBody PlackMiddlewareReverseProxy PlackTestExternalServer SafeIsa StreamBuffered StringRewritePrefix SubExporter TaskWeaken TermSizeAny TextSimpleTable TreeSimple TreeSimpleVisitorFactory TryTiny URI namespaceautoclean namespaceclean ];
    meta = {
      homepage = http://dev.catalyst.perl.org/;
      description = "The Catalyst Framework Runtime";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginAccessLog = buildPerlPackage {
    name = "Catalyst-Plugin-AccessLog-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AR/ARODLAND/Catalyst-Plugin-AccessLog-1.05.tar.gz;
      sha256 = "0hqvckaw91q5yc25a33bp0d4qqxlgkp7rxlvi8n8svxd1406r55s";
    };
    propagatedBuildInputs = [ CatalystRuntime DateTime Moose namespaceautoclean ];
    doCheck = false;
    meta = {
      description = "Request logging from within Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginAuthentication = buildPerlPackage {
    name = "Catalyst-Plugin-Authentication-0.10022";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Authentication-0.10022.tar.gz;
      sha256 = "1yxx89j6q10ydmwwhv3zq68gwndcnh4vvdqiv7az5w2rf2w1nvip";
    };
    buildInputs = [ ClassMOP Moose TestException ];
    propagatedBuildInputs = [ CatalystPluginSession CatalystRuntime ClassInspector Moose MooseXEmulateClassAccessorFast MROCompat namespaceautoclean StringRewritePrefix TryTiny ];
    meta = {
      description = "Infrastructure plugin for the Catalyst authentication framework";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginAuthorizationACL = buildPerlPackage rec {
    name = "Catalyst-Plugin-Authorization-ACL-0.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "12pj3c8hhm72jzyj83pjmxib0l48s3954spln97n3s0nsvliya98";
    };
    propagatedBuildInputs = [CatalystRuntime ClassThrowable];
  };

  CatalystPluginAuthorizationRoles = buildPerlPackage {
    name = "Catalyst-Plugin-Authorization-Roles-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Authorization-Roles-0.09.tar.gz;
      sha256 = "0l83lkwmq0lngwh8b1rv3r719pn8w1gdbyhjqm74rnd0wbjl8h7f";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ CatalystPluginAuthentication CatalystRuntime SetObject UNIVERSALisa ];
    meta = {
      description = "Role based authorization for Catalyst based on Catalyst::Plugin::Authentication";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginCache = buildPerlPackage {
    name = "Catalyst-Plugin-Cache-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Cache-0.12.tar.gz;
      sha256 = "1q23aipvrl888h06ldr4mmjbykz0j4rqwipxg1jv094kki2fspr9";
    };
    buildInputs = [ TestDeep TestException ];
    propagatedBuildInputs = [ CatalystRuntime MROCompat TaskWeaken ];
    meta = {
      description = "Flexible caching support for Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CatalystPluginCacheHTTP = buildPerlPackage {
    name = "Catalyst-Plugin-Cache-HTTP-0.001000";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRAF/Catalyst-Plugin-Cache-HTTP-0.001000.tar.gz;
      sha256 = "0v5iphbq4csc4r6wkvxnqlh97p8g0yhjky9qqmsdyqczn87agbba";
    };
    buildInputs = [ CatalystRuntime Testuseok TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ ClassAccessorFast HTTPMessage MROCompat ];
    meta = {
      description = "HTTP/1.1 cache validators for Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CatalystPluginCaptcha = buildPerlPackage {
    name = "Catalyst-Plugin-Captcha-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DI/DIEGOK/Catalyst-Plugin-Captcha-0.04.tar.gz;
      sha256 = "0llyj3v5nx9cx46jdbbvxf1lc9s9cxq5ml22xmx3wkb201r5qgaa";
    };
    propagatedBuildInputs = [ CatalystRuntime CatalystPluginSession GDSecurityImage HTTPDate ];
    meta = {
      description = "Create and validate Captcha for Catalyst";
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginConfigLoader = buildPerlPackage rec {
    name = "Catalyst-Plugin-ConfigLoader-0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "0m18yqcwx5fzz4lrd5db8x8wyir1061pclv5jb9g963wbg4zk43g";
    };
    propagatedBuildInputs = [CatalystRuntime DataVisitor ConfigAny MROCompat];
  };

  CatalystPluginUnicodeEncoding = buildPerlPackage {
    name = "Catalyst-Plugin-Unicode-Encoding-1.9";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-Unicode-Encoding-1.9.tar.gz;
      sha256 = "1glxkh79zz71bmgk44hnhsi37z2mgxcwf7bkmwlnwv3jh1iaz0ah";
    };
    buildInputs = [ HTTPMessage IOStringy ];
    propagatedBuildInputs = [ CatalystRuntime ClassDataInheritable LWP TryTiny URI ];
    meta = {
      description = "Unicode aware Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CatalystPluginHTMLWidget = buildPerlPackage {
    name = "Catalyst-Plugin-HTML-Widget-1.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SRI/Catalyst-Plugin-HTML-Widget-1.1.tar.gz;
      sha256 = "1zzyfhmzlqvbwk2w930k3mqk8z1lzhrja9ynx9yfq5gmc8qqg95l";
    };
    propagatedBuildInputs = [CatalystRuntime HTMLWidget];
  };

  CatalystPluginSession = buildPerlPackage {
    name = "Catalyst-Plugin-Session-0.39";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JJ/JJNAPIORK/Catalyst-Plugin-Session-0.39.tar.gz;
      sha256 = "0m4a003qgz7848iyckwbigg2vw3kmfxggh1razrnzxrbz3n6x5gi";
    };
    buildInputs = [ TestDeep TestException TestWWWMechanizePSGI ];
    propagatedBuildInputs = [ CatalystRuntime Moose MooseXEmulateClassAccessorFast MROCompat namespaceclean ObjectSignature ];
    meta = {
      description = "Generic Session plugin - ties together server side storage and client side state required to maintain session data";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystPluginSessionStateCookie = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-State-Cookie-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTROUT/${name}.tar.gz";
      sha256 = "1rvxbfnpf9x2pc2zgpazlcgdlr2dijmxgmcs0m5nazs0w6xikssb";
    };
    buildInputs = [ TestMockObject ];
    propagatedBuildInputs = [ CatalystRuntime CatalystPluginSession ];
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginSessionStoreFastMmap = buildPerlPackage rec {
    name = "Catalyst-Plugin-Session-Store-FastMmap-0.16";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Catalyst/${name}.tar.gz";
      sha256 = "0x3j6zv3wr41jlwr6yb2jpmcx019ibyn11y8653ffnwhpzbpzsxs";
    };
    propagatedBuildInputs =
      [ PathClass CatalystPluginSession CacheFastMmap MROCompat ];
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginStackTrace = buildPerlPackage {
    name = "Catalyst-Plugin-StackTrace-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-Plugin-StackTrace-0.12.tar.gz;
      sha256 = "1b2ksz74cpigxqzf63rddar3vfmnbpwpdcbs11v0ml89pb8ar79j";
    };
    propagatedBuildInputs = [ CatalystRuntime DevelStackTrace MROCompat ];
    meta = {
      description = "Display a stack trace on the debug screen";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystPluginStaticSimple = buildPerlPackage {
    name = "Catalyst-Plugin-Static-Simple-0.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABRAXXA/Catalyst-Plugin-Static-Simple-0.31.tar.gz;
      sha256 = "1mcns9qdpnja153prbyypwjicgpm1sn7rw75k7hm28g3vf59z733";
    };
    patches = [ ../development/perl-modules/catalyst-plugin-static-simple-etag.patch ];
    propagatedBuildInputs = [ CatalystRuntime MIMETypes Moose MooseXTypes namespaceautoclean ];
    meta = {
      description = "Make serving static pages painless";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CatalystViewDownload = buildPerlPackage rec {
    name = "Catalyst-View-Download-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAUDEON/${name}.tar.gz";
      sha256 = "1qgq6y9iwfbhbkbgpw9czang2ami6z8jk1zlagrzdisy4igqzkvs";
    };
    buildInputs = [  TestWWWMechanizeCatalyst Testuseok ];
    propagatedBuildInputs = [ CatalystRuntime TextCSV XMLSimple ];
    meta = {
      license = "perl";
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystViewJSON = buildPerlPackage {
    name = "Catalyst-View-JSON-0.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Catalyst-View-JSON-0.33.tar.gz;
      sha256 = "03yda9skcfnwkm4hf2a3y7g2rdjdia5hzfnll0h7z4wiyb8kxfii";
    };
    buildInputs = [ JSON ];
    propagatedBuildInputs = [ CatalystRuntime JSONAny MROCompat YAML ];
    meta = {
      description = "JSON view for your data";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystViewTT = buildPerlPackage {
    name = "Catalyst-View-TT-0.41";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JJ/JJNAPIORK/Catalyst-View-TT-0.41.tar.gz;
      sha256 = "1yrigxqapxj4k1qkykiiqy6a30ljb7hlkaw80d7n0n5mpm67j1nb";
    };
    propagatedBuildInputs = [ CatalystRuntime ClassAccessor MROCompat PathClass TemplateToolkit TemplateTimer ];
    meta = {
      description = "Template View Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystXComponentTraits = buildPerlPackage rec {
    name = "CatalystX-Component-Traits-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "0iq4ci8m6g2c4g01fvdl568y7pjz28f3widk986v3pyhr7ll8j88";
    };
    propagatedBuildInputs =
      [ CatalystRuntime MooseXTraitsPluggable namespaceautoclean ListMoreUtils ];
  };

  CatalystXRoleApplicator = buildPerlPackage rec {
    name = "CatalystX-RoleApplicator-0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HD/HDP/${name}.tar.gz";
      sha256 = "0vwaapxn8g5hs2xp63c4dwv9jmapmji4272fakssvgc9frklg3p2";
    };
    buildInputs = [ ];
    propagatedBuildInputs = [ MooseXRelatedClassRoles CatalystRuntime ];
  };

  CatalystTraitForRequestProxyBase = buildPerlPackage {
    name = "Catalyst-TraitFor-Request-ProxyBase-0.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Catalyst-TraitFor-Request-ProxyBase-0.000005.tar.gz;
      sha256 = "a7bf0faa7e12ca5df625d9f5fc710f11bfd16ba5385837e48d42b3d286c9710a";
    };
    buildInputs = [ CatalystRuntime HTTPMessage ];
    propagatedBuildInputs = [ CatalystXRoleApplicator Moose URI namespaceautoclean ];
    meta = {
      description = "Replace request base with value passed by HTTP proxy";
      license = "perl";
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CatalystXScriptServerStarman = buildPerlPackage {
    name = "CatalystX-Script-Server-Starman-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABRAXXA/CatalystX-Script-Server-Starman-0.02.tar.gz;
      sha256 = "0h02mpkc4cmi3jpvcd7iw7xyzx55bqvvl1qkf967gqkvpklm0qx5";
    };
    buildInputs = [ TestWWWMechanizeCatalyst ];
    propagatedBuildInputs = [ CatalystRuntime Moose namespaceautoclean Starman ];
    meta = {
      description = "Replace the development server with Starman";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  CGI = buildPerlPackage {
    name = "CGI-4.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEEJO/CGI-4.21.tar.gz;
      sha256 = "340d20a2b67211752d7c270c589e463d71aea8b8d75d9417250618219d3cf884";
    };
    propagatedBuildInputs = [ HTMLParser if_ ];
    doCheck = false;
    meta = {
      homepage = https://metacpan.org/module/CGI;
      description = "Handle Common Gateway Interface requests and responses";
    };
  };

  CGICookieXS = buildPerlPackage rec {
    name = "CGI-Cookie-XS-0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGENT/${name}.tar.gz";
      sha256 = "1iixvnm0l1q24vdlnayb4vd8fns2bdlhm6zb7fpi884ppm5cp6a6";
    };
  };

  CGIExpand = buildPerlPackage {
    name = "CGI-Expand-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOWMANBS/CGI-Expand-2.04.tar.gz;
      sha256 = "0jk2vvk4mlz7phq3h3wpryix46adi7fkkzvkv0ssn5xkqy3pqlny";
    };
    propagatedBuildInputs = [ TestException ];
    meta = {
      description = "Convert flat hash to nested data using TT2's dot convention";
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CGIFast = buildPerlPackage {
    name = "CGI-Fast-2.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEEJO/CGI-Fast-2.10.tar.gz;
      sha256 = "98263afcc9f5d88c7cbbd39651c5431b434c1c815fe284962d887ed7be3a1dd3";
    };
    propagatedBuildInputs = [ FCGI if_ ];
    doCheck = false;
    meta = {
      homepage = https://metacpan.org/module/CGI::Fast;
      license = "perl";
    };
  };

  CGIFormBuilder = buildPerlPackage rec {
    name = "CGI-FormBuilder-3.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NW/NWIGER/${name}.tgz";
      sha256 = "0qx8kxj0iy55ss9kraqr8q2m4igi2ylajff7d6qvphqpfx90fjb5";
    };
  };

  CGISession = buildPerlPackage rec {
    name = "CGI-Session-4.48";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSTOS/${name}.tar.gz";
      sha256 = "1xsl2pz1jrh127pq0b01yffnj4mnp9nvkp88h5mndrscq9hn8xa6";
    };
    buildInputs = [ DBFile ];
  };

  CGISimple = buildPerlPackage {
    name = "CGI-Simple-1.113";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AN/ANDYA/CGI-Simple-1.113.tar.gz;
      sha256 = "0g8v0jd7dk310k6ncz47qa1cfrysi8yib1zwkhasv4zhswgqiqjj";
    };
    propagatedBuildInputs = [ IOStringy ];
    meta = {
      description = "A Simple totally OO CGI interface that is CGI.pm compliant";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CGIStruct = buildPerlPackage {
    name = "CGI-Struct-1.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FU/FULLERMD/CGI-Struct-1.21.tar.gz;
      sha256 = "d13d8da7fdcd6d906054e4760fc28a718aec91bd3cf067a58927fb7cb1c09d6c";
    };
    buildInputs = [ TestDeep ];
    meta = {
      description = "Build structures from CGI data";
      license = "bsd";
    };
  };

  ClassAccessor = buildPerlPackage {
    name = "Class-Accessor-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KASEI/Class-Accessor-0.34.tar.gz;
      sha256 = "1z6fqg0yz8gay15r1iasslv8f1n1mzjkrhs47fvbj3rqz36y1cfd";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAccessorChained = buildPerlPackage {
    name = "Class-Accessor-Chained-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RC/RCLAMP/Class-Accessor-Chained-0.01.tar.gz;
      sha256 = "1lilrjy1s0q5hyr0888kf0ifxjyl2iyk4vxil4jsv0sgh39lkgx5";
    };
    propagatedBuildInputs = [ClassAccessor];
  };

  ClassAccessorFast = buildPerlPackage {
    name = "Class-Accessor-Fast-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KASEI/Class-Accessor-0.34.tar.gz;
      sha256 = "1z6fqg0yz8gay15r1iasslv8f1n1mzjkrhs47fvbj3rqz36y1cfd";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ClassAccessorGrouped = buildPerlPackage {
    name = "Class-Accessor-Grouped-0.10012";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RI/RIBASUSHI/Class-Accessor-Grouped-0.10012.tar.gz;
      sha256 = "c4613ee3307939f47a9afd40e8b173f3a22f501c3b139799aa030f01b627e7fe";
    };
    buildInputs = [ ClassXSAccessor DevelHide PackageStash SubName TestException ];
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Lets you build groups of accessors";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassAutouse = buildPerlPackage {
    name = "Class-Autouse-1.99_02";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Class-Autouse-1.99_02.tar.gz;
      sha256 = "1jkhczx2flxrz154ps90fj9wcchkpmnp5sapwc0l92rpn7jpsf08";
    };
  };

  ClassBase = buildPerlPackage rec {
    name = "Class-Base-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SZ/SZABGAB/${name}.tar.gz";
      sha256 = "0vryy6b64f2wbfc2zzzvh6ravkp5i4kjdxhjbj3s08g9pwyc67y6";
    };
  };

  ClassC3 = buildPerlPackage {
    name = "Class-C3-0.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/Class-C3-0.26.tar.gz;
      sha256 = "008xg6gf5qp2fdjqzfpg0fzhw7f308ddkxwvzdcaa9zq59sg5x6s";
    };
    propagatedBuildInputs = [ AlgorithmC3 ];
    meta = {
      description = "A pragma to use the C3 method resolution order algortihm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassC3AdoptNEXT = buildPerlPackage {
    name = "Class-C3-Adopt-NEXT-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Class-C3-Adopt-NEXT-0.13.tar.gz;
      sha256 = "1rwgbx6dsy4rpas94p8wakzj7hrla1p15jnbm24kwhsv79gp91ld";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ListMoreUtils MROCompat ];
    meta = {
      homepage = http://search.cpan.org/dist/Class-C3-Adopt-NEXT;
      description = "Make NEXT suck less";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassC3Componentised = buildPerlPackage {
    name = "Class-C3-Componentised-1.001000";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/Class-C3-Componentised-1.001000.tar.gz;
      sha256 = "1nzav8arxll0rya7r2vp032s3acliihbb9mjlfa13rywhh77bzvl";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ClassC3 ClassInspector MROCompat ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassClassgenclassgen = buildPerlPackage {
    name = "Class-Classgen-classgen-3.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHLUE/Class-Classgen-classgen-3.03.tar.gz;
      sha256 = "9b65d41b991538992e816b32cc4fa9b4a4a0bb3e9c10e7eebeff82658dbbc8f6";
    };
  };

  ClassContainer = buildPerlPackage {
    name = "Class-Container-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Class-Container-0.12.tar.gz;
      sha256 = "771206f2b7a916ce0dfb93d82200472beaeb910248482734179bf36808e486b1";
    };
    propagatedBuildInputs = [ ParamsValidate ];
    meta = {
      description = "Glues object frameworks together transparently";
      license = "perl";
    };
  };

  ClassDataAccessor = buildPerlPackage {
    name = "Class-Data-Accessor-0.04004";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLACO/Class-Data-Accessor-0.04004.tar.gz;
      sha256 = "0578m3rplk41059rkkjy1009xrmrdivjnv8yxadwwdk1vzidc8n1";
    };
  };

  ClassDataInheritable = buildPerlPackage {
    name = "Class-Data-Inheritable-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TM/TMTM/Class-Data-Inheritable-0.08.tar.gz;
      sha256 = "0jpi38wy5xh6p1mg2cbyjjw76vgbccqp46685r27w8hmxb7gwrwr";
    };
  };

  ClassFactory = buildPerlPackage {
    name = "Class-Factory-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/Class-Factory-1.06.tar.gz;
      sha256 = "c37a2d269eb935f36a23e113480ae0946fa7c12a12781396a1226c8e435f30f5";
    };
  };

  ClassFactoryUtil = buildPerlPackage rec {
    name = "Class-Factory-Util-1.7";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "09ifd6v0c94vr20n9yr1dxgcp7hyscqq851szdip7y24bd26nlbc";
    };
  };

  ClassInspector = buildPerlPackage {
    name = "Class-Inspector-1.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Class-Inspector-1.28.tar.gz;
      sha256 = "04iij8dbcgaim7g109frpyf7mh4ydsd8zh53r53chk0zxnivg91w";
    };
    meta = {
      description = "Get information about a class and its structure";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassISA = buildPerlPackage {
    name = "Class-ISA-0.36";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Class-ISA-0.36.tar.gz;
      sha256 = "0r5r574i6wgxm8zsq4bc34d0dzprrh6h6mpp1nhlks1qk97g65l8";
    };
  };

  ClassIterator = buildPerlPackage {
    name = "Class-Iterator-0.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TE/TEXMEC/Class-Iterator-0.3.tar.gz;
      sha256 = "db1ba87ca9107f161fe9c1e9e7e267c0026defc26fe3e73bcad8ab8ffc18ef9d";
    };
    meta = {
    };
  };

  ClassMakeMethods = buildPerlPackage rec {
    name = "Class-MakeMethods-1.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EV/EVO/${name}.tar.gz";
      sha256 = "10f65j4ywrnwyz0dm1q5ymmpv875drj40mj1xvsjv0bnjinnwzj8";
    };
  };

  ClassMethodMaker = buildPerlPackage {
    name = "Class-MethodMaker-2.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SC/SCHWIGON/class-methodmaker/Class-MethodMaker-2.21.tar.gz;
      sha256 = "0gca1cjy2k0mrpfnbyzm5islzfayqfvg3zzlrlm7n60p0cb48y7w";
    };
    preConfigure = "patchShebangs .";
    meta = {
      description = "A module for creating generic methods";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMethodModifiers = buildPerlPackage {
    name = "Class-Method-Modifiers-2.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Class-Method-Modifiers-2.10.tar.gz;
      sha256 = "1dp757rzv6a9k7q0bpmjxv69g4r893vb143qq7fyqlwzg0zva3s2";
    };
    buildInputs = [ TestFatal ];
    meta = {
      homepage = https://github.com/sartak/Class-Method-Modifiers/tree;
      description = "Provides Moose-like method modifiers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassMix = buildPerlPackage rec {
    name = "Class-Mix-0.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "054d0db62df90f22601f2a18fc84e9ca026d81601f5940b2fcc543e39d69b36b";
    };
    propagatedBuildInputs = [ParamsClassify];
  };

  ClassMOP = Moose;

  ClassSingleton = buildPerlPackage rec {
    name = "Class-Singleton-1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AB/ABW/${name}.tar.gz";
      sha256 = "0l4iwwk91wm2mrrh4irrn6ham9k12iah1ry33k0lzq22r3kwdbyg";
    };
  };

  ClassThrowable = buildPerlPackage {
    name = "Class-Throwable-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KM/KMX/Class-Throwable-0.11.tar.gz;
      sha256 = "1vjadr0kqmfi9s3wfxjbqqgc7fqrk87n6b1a5979sbxxk5yh8hyk";
    };
  };

  ClassLoad = buildPerlPackage {
    name = "Class-Load-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Class-Load-0.21.tar.gz;
      sha256 = "0z04r0jdk8l3qd96f75q3042p76hr4i747dg87s7xrpp0bjbmn8h";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ DataOptList ModuleImplementation ModuleRuntime PackageStash TryTiny ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "A working (require \"Class::Name\") and more";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ClassLoadXS = buildPerlModule {
    name = "Class-Load-XS-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Class-Load-XS-0.06.tar.gz;
      sha256 = "1dl739nnfw2j9rjgqxx24jqbanyvncqfnkwm27af8ik6kiqk50ik";
    };
    buildInputs = [ ModuleImplementation TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassLoad ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "XS implementation of parts of Class::Load";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  ClassObservable = buildPerlPackage {
    name = "Class-Observable-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CW/CWINTERS/Class-Observable-1.04.tar.gz;
      sha256 = "3ef18733a0f03c113f3bcf8ac50476e09ca1fe6234f4aaacaa24dfca95168094";
    };
    propagatedBuildInputs = [ ClassISA ];
  };

  ClassStd = buildPerlPackage {
    name = "Class-Std-0.013";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Class-Std-0.013.tar.gz;
      sha256 = "bcd6d82f6c8af0fe069fced7dd165a4795b0b6e92351c7d4e5a1ab9a14fc35c6";
    };
    meta = {
      description = "Support for creating standard 'inside-out' classes";
      license = "perl";
    };
  };

  ClassUnload = buildPerlPackage rec {
    name = "Class-Unload-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "097gr3r2jgnm1175m4lpg4a97hv2mxrn9r0b2c6bn1x9xdhkywgh";
    };
    propagatedBuildInputs = [ ClassInspector ];
  };

  ClassXSAccessor = buildPerlPackage {
    name = "Class-XSAccessor-1.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Class-XSAccessor-1.19.tar.gz;
      sha256 = "1wm6013il899jnm0vn50a7iv9v6r4nqywbqzj0csyf8jbwwnpicr";
    };
    meta = {
      description = "Generate fast XS accessors without runtime compilation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Clone = buildPerlPackage {
    name = "Clone-0.36";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GARU/Clone-0.36.tar.gz;
      sha256 = "1i90l24l46dyadmdz82klyh3y1lhfn75wjjpfmgl1kbr4plgdph3";
    };
    meta = {
      description = "Recursively copy Perl datatypes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CommonSense = buildPerlPackage rec {
    name = "common-sense-3.72";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/ML/MLEHMANN/common-sense-3.72.tar.gz;
      sha256 = "16q95qrjksyykdn3mfj9vx26kb6c3hg97scmcbd00hfbk332xyd4";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
    };
  };

  CompressBzip2 = buildPerlPackage {
    name = "Compress-Bzip2-2.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/Compress-Bzip2-2.22.tar.gz;
      sha256 = "1603e284e07953415b8eaa132698db8b03f46383f883c0902926f36eecb7e895";
    };
    meta = {
      description = "Interface to Bzip2 compression library";
      license = "perl";
    };
  };

  CompressRawBzip2 = buildPerlPackage {
    name = "Compress-Raw-Bzip2-2.064";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PM/PMQS/Compress-Raw-Bzip2-2.064.tar.gz;
      sha256 = "0aqbggr9yf4hn21a9fra111rlmva3w8f3mqvbchl5l86knkbkwy3";
    };

    # Don't build a private copy of bzip2.
    BUILD_BZIP2 = false;
    BZIP2_LIB = "${pkgs.bzip2}/lib";
    BZIP2_INCLUDE = "${pkgs.bzip2}/include";

    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Low-Level Interface to bzip2 compression library";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CompressRawZlib = import ../development/perl-modules/Compress-Raw-Zlib {
    inherit fetchurl buildPerlPackage stdenv;
    inherit (pkgs) zlib;
  };

  CompressZlib = IOCompress;

  CompressUnLZMA = buildPerlPackage rec {
    name = "Compress-unLZMA-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/${name}.tar.gz";
      sha256 = "0sg9gj3rhif6hgmhwpz6w0g52l65vj5hx9818v5cdhvcif0jhg0b";
    };
    propagatedBuildInputs = [ IOCompress ];
  };

  ConfigAny = buildPerlPackage {
    name = "Config-Any-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRICAS/Config-Any-0.24.tar.gz;
      sha256 = "710f8fc8f9414205cb58399bfbb4d9aaf7883f8ce046cee22913f6818795c61a";
    };
    propagatedBuildInputs = [ ModulePluggable ];
    meta = {
      description = "Load configuration from different file formats, transparently";
      license = "perl";
    };
  };

  ConfigAutoConf = buildPerlPackage {
    name = "Config-AutoConf-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AM/AMBS/Config/Config-AutoConf-0.22.tar.gz;
      sha256 = "1zk2xfvxd3yn3299i13vn5wm1c7jxgr7z3h0yh603xs2h9cg79wc";
    };
    propagatedBuildInputs = [ CaptureTiny ];
    meta = {
      description = "A module to implement some of AutoConf macros in pure perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigGeneral = buildPerlPackage {
    name = "Config-General-2.52";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TL/TLINDEN/Config-General-2.52.tar.gz;
      sha256 = "07rmabdh21ljyc9yy6gpjg4w1y0lzwz8daljf0jv2g521hpdfdwr";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigGitLike = buildPerlPackage {
    name = "Config-GitLike-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Config-GitLike-1.16.tar.gz;
      sha256 = "48c7f7e71405219582a96e5266cbec51c0ff3ec4bf0bb6db1fd12725ee23fe8f";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moo MooXTypesMooseLike ];
    meta = {
      description = "Git-compatible config file parsing";
      license = "perl";
    };
  };

  ConfigINI = buildPerlPackage {
    name = "Config-INI-0.020";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Config-INI-0.020.tar.gz;
      sha256 = "0ef298da75e3a7becd1f358422cea621c5cf0420278aa6a1bdd2dd14efe07bc9";
    };
    propagatedBuildInputs = [ IOString MixinLinewise ];
    meta = {
      homepage = https://github.com/rjbs/Config-INI;
      description = "Simple .ini-file format";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigMerge = buildPerlPackage {
    name = "Config-Merge-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DRTECH/Config-Merge-1.04.tar.gz;
      sha256 = "a932477b43ae5fb04a16f071a891da7bd2086c10c680592f2888fa9d9972cccf";
    };
    buildInputs = [ ConfigAny YAML ];
    propagatedBuildInputs = [ ConfigAny ];
    meta = {
      description = "Load a configuration directory tree containing YAML, JSON, XML, Perl, INI or Config::General files";
      license = "perl";
    };
  };

  ConfigMVP = buildPerlPackage {
    name = "Config-MVP-2.200010";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Config-MVP-2.200010.tar.gz;
      sha256 = "bfb5870452a12ead4d3fd485045d1fa92b2a11741c3b93b61eb43f3dcbd6099b";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ClassLoad ModulePluggable Moose MooseXOneArgNew ParamsUtil RoleHasMessage RoleIdentifiable Throwable TieIxHash TryTiny ];
    meta = {
      homepage = https://github.com/rjbs/Config-MVP;
      description = "Multivalue-property package-oriented configuration";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  ConfigMVPReaderINI = buildPerlPackage {
    name = "Config-MVP-Reader-INI-2.101462";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Config-MVP-Reader-INI-2.101462.tar.gz;
      sha256 = "cd113c3361cfb468655cfcd7b4747b50f990db2cb9452f5d8ffa409422d7df9f";
    };
    propagatedBuildInputs = [ ConfigINI ConfigMVP Moose ];
    meta = {
      homepage = https://github.com/rjbs/Config-MVP-Reader-INI;
      description = "An MVP config reader for .ini files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ConfigStd = buildPerlPackage {
    name = "Config-Std-0.901";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRICKER/Config-Std-0.901.tar.gz;
      sha256 = "c5c57eb82a37cc41ea152098fc8e5548acfea8861140fbac8fc3beccbb09c243";
    };
    propagatedBuildInputs = [ ClassStd ];
    meta = {
      description = "Load and save configuration files in a standard format";
    };
  };

  ConfigTiny = buildPerlPackage rec {
    name = "Config-Tiny-2.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/${name}.tgz";
      sha256 = "0grgb7av1hwpl20xh91jipla1xi0h7vx6c538arxmvgm1f71cql2";
    };
  };

  ConfigVersioned = buildPerlPackage {
    name = "Config-Versioned-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRSCOTTY/Config-Versioned-1.01.tar.gz;
      sha256 = "bc9a4ae3738bd89f86a07bca673627ca3c92ba969737cd6dbc7ab7ad17cd2348";
    };
    buildInputs = [ DateTime PathClass ];
    propagatedBuildInputs = [ ConfigStd GitPurePerl Moose ];
    doCheck = false;
    meta = {
      description = "Simple, versioned access to configuration data";
      license = "perl";
    };
  };

  Connector = buildPerlPackage {
    name = "Connector-1.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRSCOTTY/Connector-1.15.tar.gz;
      sha256 = "1p64gnkrik7f21jj0x5di0inmb4s1p33g0mxyk5gvwchkf43pyn4";
    };
    doCheck = false;
  };

  ConvertASN1 = buildPerlPackage rec {
    name = "Convert-ASN1-0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GB/GBARR/Convert-ASN1-0.26.tar.gz";
      sha256 = "188wpjnp4j2m1l1zzw9ak9ymiba1g7hzysf8mc6bsdnhl0pvdf2x";
    };
  };

  constant = buildPerlPackage {
    name = "constant-1.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/constant-1.27.tar.gz;
      sha256 = "0ari0jggiifz3q7vxb8nlcsc3g6bj8c0c0drsrphv0079c956i3l";
    };
  };

  constantboolean = buildPerlPackage {
    name = "constant-boolean-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/constant-boolean-0.02.tar.gz;
      sha256 = "1s8gxfg4xqp543aqanv5lbp64vqqyw6ic4x3fm4imkk1h3amjb6d";
    };
    propagatedBuildInputs = [ SymbolUtil ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  constantdefer = pkgs.perlPackages.constant-defer;

  constant-defer = buildPerlPackage rec {
    name = "constant-defer-5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/${name}.tar.gz";
      sha256 = "05fjw2n6liwlillrj3bkfm5fzxw1mcfbxrnk9m18vibx6yzf8pwq";
    };
  };

  ContextPreserve = buildPerlPackage rec {
    name = "Context-Preserve-0.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JR/JROCKWAY/${name}.tar.gz";
      sha256 = "0gssillawjknqks81x7fg7w2x94bnyklgd8ry2pr1k6ifkjhwz46";
    };
    buildInputs = [ TestException Testuseok ];
  };

  CookieXS = buildPerlPackage rec {
    name = "Cookie-XS-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AG/AGENT/${name}.tar.gz";
      sha256 = "1616rcn2qn1cwiv3rxb8mq5fmwxpj4gya1lxxxq2w952h03p3fd3";
    };
    buildInputs = [ TestMore ];
    propagatedBuildInputs = [ CGICookieXS ];
  };

  Coro = buildPerlPackage rec {
    name = "Coro-6.41";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/ML/MLEHMANN/${name}.tar.gz";
      sha256 = "1r1gam4yyl6w88ga8rkbvj33v1r5ald3ryqlpg13c7y1i79yizxa";
    };
    propagatedBuildInputs = [ AnyEvent Guard CommonSense ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CPAN = buildPerlPackage {
    name = "CPAN-2.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AN/ANDK/CPAN-2.10.tar.gz;
      sha256 = "090e9e3d9fca83b89341a75c514c7411b743c887743723dbfe80f30d4ee5f3ad";
    };
    propagatedBuildInputs = [ ArchiveZip CompressBzip2 Expect FileHomeDir FileWhich JSONPP LWP ModuleSignature TermReadKey TextGlob YAML YAMLLibYAML YAMLSyck ];
    meta = {
      description = "Query, download and build perl modules from CPAN sites";
      license = "perl";
    };
  };

  CPANChanges = buildPerlPackage {
    name = "CPAN-Changes-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRICAS/CPAN-Changes-0.27.tar.gz;
      sha256 = "14dizyvgzp81hmg0djwnvvkdhqd3bsmms462cj0ai84z221scv1q";
    };
    meta = {
      description = "Read and write Changes files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANMeta = buildPerlPackage {
    name = "CPAN-Meta-2.142690";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/CPAN-Meta-2.142690.tar.gz;
      sha256 = "495770e22e91e3d2bd04dc364f05061cabacfdce35baa3868bc0c05733d145db";
    };
    propagatedBuildInputs = [ ParseCPANMeta CPANMetaYAML CPANMetaRequirements JSONPP ];
    meta = {
      homepage = https://github.com/Perl-Toolchain-Gang/CPAN-Meta;
      description = "The distribution metadata for a CPAN dist";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANMetaCheck = buildPerlPackage {
    name = "CPAN-Meta-Check-0.009";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/CPAN-Meta-Check-0.009.tar.gz;
      sha256 = "eb2d43afd1da276e4acdebd24937f5171d0aaca8d19a5ef0c3e834b8792b7361";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ CPANMeta CPANMetaRequirements ];
    meta = {
      description = "Verify requirements in a CPAN::Meta object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANMetaRequirements = buildPerlPackage {
    name = "CPAN-Meta-Requirements-2.128";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/CPAN-Meta-Requirements-2.128.tar.gz;
      sha256 = "ff0ae309ed76d8c7381fdb8436659a594e6884eeac1c9a742ba9aa7ee2a1d52d";
    };
    meta = {
      homepage = https://github.com/dagolden/CPAN-Meta-Requirements;
      description = "A set of version requirements for a CPAN dist";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANMetaYAML = buildPerlPackage {
    name = "CPAN-Meta-YAML-0.012";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/CPAN-Meta-YAML-0.012.tar.gz;
      sha256 = "7c728c573ba74294d3df2f0cbae2cd1b3830ed47040649b49a33a086b8300d28";
    };
    buildInputs = [ JSONPP ];
    doCheck = false; # Test::More too old
    meta = {
      homepage = https://github.com/dagolden/CPAN-Meta-YAML;
      description = "Read and write a subset of YAML for CPAN Meta files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANPerlReleases = buildPerlPackage {
    name = "CPAN-Perl-Releases-1.94";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/CPAN-Perl-Releases-1.94.tar.gz;
      sha256 = "ebc70640541f5b6d1191ba7bf958d369d9e21be0908ac812663047290b95fdf2";
    };
    meta = {
      homepage = https://github.com/bingos/cpan-perl-releases;
      description = "Mapping Perl releases on CPAN to the location of the tarballs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CPANPLUS = buildPerlPackage {
    name = "CPANPLUS-0.9152";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/CPANPLUS-0.9152.tar.gz;
      sha256 = "732d9978ca6e8cde9b16431e1d1bafa543a66d8bce3fbfca4e5ac297a348ad17";
    };
    propagatedBuildInputs = [ ArchiveExtract LogMessage ModulePluggable ObjectAccessor PackageConstants ];
    doCheck = false;
    meta = {
      homepage = http://github.com/jib/cpanplus-devel;
      description = "Ameliorated interface to the CPAN";
      license = "perl";
    };
  };

  CPANUploader = buildPerlPackage {
    name = "CPAN-Uploader-0.103006";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/CPAN-Uploader-0.103006.tar.gz;
      sha256 = "1hkbi2j0a9v4577jxfzw586rvpzw0af61qbiggh3dd7j9b183w39";
    };
    propagatedBuildInputs = [ FileHomeDir GetoptLongDescriptive HTTPMessage LWP LWPProtocolhttps TermReadKey ];
    meta = {
      homepage = https://github.com/rjbs/cpan-uploader;
      description = "Upload things to the CPAN";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  CryptBlowfish = buildPerlPackage rec {
    name = "Crypt-Blowfish-2.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DP/DPARIS/${name}.tar.gz";
      sha256 = "1cb7g8cyfs9alrfdykxhs8m6azj091fmcycz6p5vkxbbzcgl7cs6";
    };
  };

  CryptCBC = buildPerlPackage rec {
    name = "Crypt-CBC-2.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/${name}.tar.gz";
      sha256 = "0ig698lmpjz7fslnznxm0609lvlnvf4f3s370082nzycnqhxww3a";
    };
  };

  CryptDES = buildPerlPackage rec {
    name = "Crypt-DES-2.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DP/DPARIS/${name}.tar.gz";
      sha256 = "1rypxlhpd1jc0c327aghgl9y6ls47drmpvn0a40b4k3vhfsypc9d";
    };
    buildInputs = [CryptCBC];
  };

  CryptDH = buildPerlPackage rec {
    name = "Crypt-DH-0.07";
    src = fetchurl {
      url    = "mirror://cpan/authors/id/M/MI/MITHALDU/${name}.tar.gz";
      sha256 = "0pvzlgwpx8fzdy64ki15155vhsj30i9zxmw6i4p7irh17d1g7368";
    };
    buildInputs = [ MathBigInt MathBigIntGMP ];
  };

  CryptDHGMP = buildPerlPackage rec {
    name = "Crypt-DH-GMP-0.00012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMAKI/${name}.tar.gz";
      sha256 = "0f5gdprcql4kwzgxl2s6ngcfg1jl45lzcqh7dkv5bkwlwmxa9rsi";
    };
    buildInputs = [ DevelChecklib TestRequires pkgs.gmp ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.gmp}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp}/lib -lgmp";
  };

  CryptEksblowfish = buildPerlPackage rec {
    name = "Crypt-Eksblowfish-0.009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "3cc7126d5841107237a9be2dc5c7fbc167cf3c4b4ce34678a8448b850757014c";
    };
    propagatedBuildInputs = [ClassMix];
  };

  CryptPasswdMD5 = buildPerlPackage {
    name = "Crypt-PasswdMD5-1.40";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSAVAGE/Crypt-PasswdMD5-1.40.tgz;
      sha256 = "0j0r74f18nk63phddzqbf7wqma2ci4p4bxvrwrxsy0aklbp6lzdp";
    };
  };

  CryptPKCS10 = buildPerlPackage {
    name = "Crypt-PKCS10-1.0";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GK/GKNOCKE/Crypt-PKCS10-1.0.zip;
      sha256 = "08de199411056df1a1e6374b503574d21089913daa3823ebb21aa399dc59bdb6";
    };
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ ConvertASN1 ];
    meta = {
      license = "perl";
    };
  };

  CryptRandomSource = buildPerlPackage {
    name = "Crypt-Random-Source-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Crypt-Random-Source-0.07.tar.gz;
      sha256 = "0kxcqcpknh9hhfnpiymxrjg74yj7nfr7k4fgrfmd9s2cw9p9mqdv";
    };
    buildInputs = [ Testuseok TestException ];
    propagatedBuildInputs = [ AnyMoose CaptureTiny ModuleFind namespaceclean SubExporter ];
    meta = {
      homepage = http://search.cpan.org/dist/Crypt-Random-Source;
      description = "Get weak or strong random data from pluggable sources";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  CryptRC4 = buildPerlPackage rec {
    name = "Crypt-RC4-2.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SI/SIFUKURT/${name}.tar.gz";
      sha256 = "1sp099cws0q225h6j4y68hmfd1lnv5877gihjs40f8n2ddf45i2y";
    };
  };

  CryptRandPasswd = buildPerlPackage {
    name = "Crypt-RandPasswd-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Crypt-RandPasswd-0.06.tar.gz;
      sha256 = "0ca8544371wp4vvqsa19lnhl02hczpkbwkgsgm65ziwwim3r1gdi";
    };
  };

  CryptMySQL = buildPerlPackage rec {
    name = "Crypt-MySQL-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IK/IKEBE/${name}.tar.gz";
      sha256 = "93ebdfaaefcfe9ab683f0121c85f24475d8197f0bcec46018219e4111434dde3";
    };
    propagatedBuildInputs = [DigestSHA1];
  };

  CryptRijndael = buildPerlPackage rec {
    name = "Crypt-Rijndael-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BD/BDFOY/${name}.tar.gz";
      sha256 = "1rgzlxp882cc52287awwha4ipglm6nxw5jryd6cshrr99qcx55m0";
    };
  };

  CryptUnixCryptXS = buildPerlPackage rec {
    name = "Crypt-UnixCrypt_XS-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BORISZ/${name}.tar.gz";
      sha256 = "1d3xamq2mm3v2bfb1ay66crljm0bigfbhay1fqglcsrb75b7ls7r";
    };
  };

  CryptSmbHash = buildPerlPackage rec {
    name = "Crypt-SmbHash-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BJ/BJKUIT/Crypt-SmbHash-0.12.tar.gz";
      sha256 = "0dxivcqmabkhpz5xzph6rzl8fvq9xjy26b2ci77pv5gsmdzari38";
    };
  };

  CryptOpenSSLAES = buildPerlPackage rec {
    name = "Crypt-OpenSSL-AES-0.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TT/TTAR/${name}.tar.gz";
      sha256 = "b66fab514edf97fc32f58da257582704a210c2b35e297d5c31b7fa2ffd08e908";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl}/lib -lcrypto";
    meta = with stdenv.lib; {
      homepage = https://metacpan.org/release/Crypt-OpenSSL-AES;
      description = "Perl wrapper around OpenSSL's AES library";
      license = with licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
      platforms = platforms.unix;
    };
  };

  CryptOpenSSLBignum = buildPerlPackage rec {
    name = "Crypt-OpenSSL-Bignum-0.04";
    src = fetchurl {
      url    = "mirror://cpan/authors/id/I/IR/IROBERTS/${name}.tar.gz";
      sha256 = "18vg2bqyhc0ahfdh5dkbgph5nh92qcz5vi99jq8aam4h86if78bk";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl}/lib -lcrypto";
  };

  CryptOpenSSLRandom = buildPerlPackage rec {
    name = "Crypt-OpenSSL-Random-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RU/RURBAN/${name}.tar.gz";
      sha256 = "10yhjh04jxdf4ghqqvrcfds7vvylxv671l57lkkbg3k8qzpdzd7g";
    };
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl}/lib -lcrypto";
  };

  CryptOpenSSLRSA = buildPerlPackage rec {
    name = "Crypt-OpenSSL-RSA-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PERLER/${name}.tar.gz";
      sha256 = "5357f977464bb3a8184cf2d3341851a10d5515b4b2b0dfb88bf78995c0ded7be";
    };
    propagatedBuildInputs = [ CryptOpenSSLRandom ];
    NIX_CFLAGS_COMPILE = "-I${pkgs.openssl}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.openssl}/lib -lcrypto";
  };

  CryptSSLeay = buildPerlPackage rec {
    name = "Crypt-SSLeay-0.57";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DL/DLAND/${name}.tar.gz";
      sha256 = "1f0i5y99ly39vf86jpzwqz8mkz1460vryv85jgqmfx007p781s0l";
    };
    makeMakerFlags = "--lib=${pkgs.openssl}/lib";
  };

  CwdGuard = buildPerlModule rec {
    name = "Cwd-Guard-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZEBURO/${name}.tar.gz";
      sha256 = "071k50n1yr48122jjjg50i1s2kwp06dmrisv35f3wjry8m6cqchm";
    };
    meta = {
      description = "Temporary changing working directory (chdir)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataClone = buildPerlPackage {
    name = "Data-Clone-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GF/GFUJI/Data-Clone-0.003.tar.gz;
      sha256 = "16ldkjfag4dc3gssj051j212rzr2mawy7d001jflcab9g8hg3f1g";
    };
    buildInputs = [ TestRequires ];
    meta = {
      description = "Polymorphic data cloning";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DataCompare = buildPerlPackage rec {
    name = "Data-Compare-1.2102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DC/DCANTRELL/${name}.tar.gz";
      sha256 = "0v1997gnq3gpcr7f64jmyay2l60s5z6gsiy5hbpn1p2l2hrfnwlj";
    };
    propagatedBuildInputs = [ FileFindRule ];
  };

  DataDump = buildPerlPackage {
    name = "Data-Dump-1.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Data-Dump-1.22.tar.gz;
      sha256 = "1ciqlwsy1q35s94dry9bjy1pwanbq6b7q4rhxm9z8prgkzbslg2k";
    };
    meta = {
      description = "Pretty printing of data structures";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataDumper = buildPerlPackage {
    name = "Data-Dumper-2.154";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Data-Dumper-2.154.tar.gz;
      sha256 = "e30fcb6dea290cda85b67fc46d227a2ea890a8bd36c213557adec9c99ebd212f";
    };
  };

  DataDumperConcise = buildPerlPackage rec {
    name = "Data-Dumper-Concise-2.020";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Data/${name}.tar.gz";
      sha256 = "0zb792d2dmpl0dnfmwcgh6wppb5h56hwycdbcf97wqxcgjk3k7hn";
    };
  };

  DataEntropy = buildPerlPackage rec {
    name = "Data-Entropy-0.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "2611c4a1a3038594d79ea4ed14d9e15a9af8f77105f51667795fe4f8a53427e4";
    };
    propagatedBuildInputs = [ParamsClassify DataFloat CryptRijndael HTTPLite];
  };

  DataFloat = buildPerlPackage rec {
    name = "Data-Float-0.012";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "698ecb092a3284e260cd3c3208408feb791d7d0f06a02673f9125ab2d51cc2d8";
    };
  };

  DataHierarchy = buildPerlPackage {
    name = "Data-Hierarchy-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/Data-Hierarchy-0.34.tar.gz;
      sha256 = "1vfrkygdaq0k7006i83jwavg9wgszfcyzbl9b7fp37z2acmyda5k";
    };
    propagatedBuildInputs = [TestException];
  };

  DataInteger = buildPerlPackage rec {
    name = "Data-Integer-0.004";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "3a52f7717d1ebda3af40036d72cbcadd1984210737743997abdad141d620f67e";
    };
  };

  DataOptList = buildPerlPackage {
    name = "Data-OptList-0.109";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Data-OptList-0.109.tar.gz;
      sha256 = "1j44rm2spprlq3bc80cxni3dzs3gfjiqv1qc9q7820n1qj0wgmqw";
    };
    propagatedBuildInputs = [ ParamsUtil SubInstall ];
    meta = {
      homepage = http://github.com/rjbs/data-optlist;
      description = "Parse and validate simple name/value option pairs";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataPage = buildPerlPackage {
    name = "Data-Page-2.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Data-Page-2.02.tar.gz;
      sha256 = "1hvi92c4h2angryc6pngw7gbm3ysc2jfmyxk2wh9ia4vdwpbs554";
    };
    propagatedBuildInputs = [TestException ClassAccessorChained];
  };

  DataPassword = buildPerlPackage {
    name = "Data-Password-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RA/RAZINF/Data-Password-1.12.tar.gz;
      sha256 = "830cde81741ff384385412e16faba55745a54a7cc019dd23d7ed4f05d551a961";
    };
  };

  DataSection = buildPerlPackage {
    name = "Data-Section-0.101622";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Data-Section-0.101622.tar.gz;
      sha256 = "33613e5daf0791fc2c5878fd82ef260e944b1e1fa205bcc753c31c62f5b7c7d3";
    };
    propagatedBuildInputs = [ MROCompat SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/data-section;
      description = "Read multiple hunks of data out of your DATA section";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSerializer = buildPerlPackage {
    name = "Data-Serializer-0.60";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEELY/Data-Serializer-0.60.tar.gz;
      sha256 = "0ca4s811l7f2bqkx7vnyxbpp4f0qska89g2pvsfb3k0bhhbk0jdk";
    };
    meta = {
      description = "Modules that serialize data structures";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataSpreadPagination = buildPerlPackage {
    name = "Data-SpreadPagination-0.1.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KN/KNEW/Data-SpreadPagination-0.1.2.tar.gz;
      sha256 = "74ebfd847132c38cc9e835e14e82c43f1809a95cbc98bb84d1f7ce2e4ef487e3";
    };
    propagatedBuildInputs = [ DataPage MathRound ];
    meta = {
      license = "perl";
    };
  };

  DataStreamBulk = buildPerlPackage {
    name = "Data-Stream-Bulk-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Data-Stream-Bulk-0.11.tar.gz;
      sha256 = "06e08432a6b97705606c925709b99129ad926516e477d58e4461e4b3d9f30917";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ Moose PathClass SubExporter namespaceclean ];
    meta = {
      homepage = http://metacpan.org/release/Data-Stream-Bulk;
      description = "N at a time iteration API";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DataTaxi = buildPerlPackage {
    name = "Data-Taxi-0.96";
    propagatedBuildInputs = [DebugShowStuff];
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIKO/Data-Taxi-0.96.tar.gz;
      sha256 = "0y4wls4jlwd6prvd77szymddhq9sfj06kaqnk4frlvd0zh83djxb";
    };
  };

  DataUUID = buildPerlPackage rec {
    name = "Data-UUID-1.219";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Data/${name}.tar.gz";
      sha256 = "0a6s6qwc548c1ldf459i5z55fvxsrdi4rnc57d167wdbdydd6dn7";
    };
  };

  DataUUIDMT = buildPerlPackage {
    name = "Data-UUID-MT-1.001";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Data-UUID-MT-1.001.tar.gz;
      sha256 = "0bb7qibq1c5lhaihxa1sck9pb744p8c7172jgx5zh4c32ac4nk1h";
    };
    buildInputs = [ ListAllUtils ];
    propagatedBuildInputs = [ MathRandomMTAuto ];
    meta = {
      homepage = https://metacpan.org/release/Data-UUID-MT;
      description = "Fast random UUID generator using the Mersenne Twister algorithm";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DataVisitor = buildPerlPackage rec {
    name = "Data-Visitor-0.30";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "0m7d1505af9z2hj5aw020grcmjjlvnkjpvjam457d7k5qfy4m8lf";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs =
      [ ClassLoad Moose TaskWeaken TieToObject namespaceclean ];
  };

  DateCalc = buildPerlPackage {
    name = "Date-Calc-6.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STBEY/Date-Calc-6.3.tar.gz;
      sha256 = "14yvbgy9n8icwlm5zi86lskvxd6nsl42i1g9f5dwdaw9my463diy";
    };
    propagatedBuildInputs = [CarpClan BitVector];
    doCheck = false; # some of the checks rely on the year being <2015
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DateManip = buildPerlPackage {
    name = "Date-Manip-6.43";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBECK/Date-Manip-6.43.tar.gz;
      sha256 = "0jwg87j31gw2fn8csm1zyfqxd0dxh8sbv940ma9idg6g7856zfrz";
    };
    propagatedBuildInputs = [ TestInter ];
    meta = {
      description = "Date manipulation routines";
    };
  };

  DateSimple = buildPerlPackage {
    name = "Date-Simple-3.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IZ/IZUT/Date-Simple-3.03.tar.gz;
      sha256 = "29a1926314ce1681a312d6155c29590c771ddacf91b7485873ce449ef209dd04";
    };
    meta = {
      license = "unknown";
    };
  };

  DateTime = buildPerlModule {
    name = "DateTime-1.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-1.19.tar.gz;
      sha256 = "07c8624a7827277e8eda35c77cfc6fd056bf2782238597f424ef6a6e33ed6009";
    };
    buildInputs = [ TestFatal TestWarnings ];
    propagatedBuildInputs = [ DateTimeLocale DateTimeTimeZone ParamsValidate TryTiny ];
    meta = {
      description = "A date and time object";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DateTimeEventICal = buildPerlPackage {
    name = "DateTime-Event-ICal-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FG/FGLOCK/DateTime-Event-ICal-0.11.tar.gz;
      sha256 = "6c3ca03c1810c996fa66943138f1f891bbc4baeb41ae2108a5f821040d78dd4c";
    };
    propagatedBuildInputs = [ DateTime DateTimeEventRecurrence ];
    meta = {
      description = "DateTime rfc2445 recurrences";
      license = "unknown";
    };
  };

  DateTimeEventRecurrence = buildPerlPackage {
    name = "DateTime-Event-Recurrence-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FG/FGLOCK/DateTime-Event-Recurrence-0.16.tar.gz;
      sha256 = "3872e0126cd9527a918d3e537f85342d1fbb1e6a9ae5833262201b31879f8609";
    };
    propagatedBuildInputs = [ DateTime DateTimeSet ];
  };

  DateTimeFormatBuilder = buildPerlPackage {
    name = "DateTime-Format-Builder-0.81";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-Builder-0.81.tar.gz;
      sha256 = "7cd58a8cb53bf698407cc992f89e4d49bf3dc55baf4f3f00f1def63a0fff33ef";
    };
    propagatedBuildInputs = [ ClassFactoryUtil DateTime DateTimeFormatStrptime ParamsValidate ];
    meta = {
      description = "Create DateTime parser classes and objects";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DateTimeFormatDateParse = buildPerlPackage {
    name = "DateTime-Format-DateParse-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JH/JHOBLITT/DateTime-Format-DateParse-0.05.tar.gz;
      sha256 = "f6eca4c8be66ce9992ee150932f8fcf07809fd3d1664caf200b8a5fd3a7e5ebc";
    };
    propagatedBuildInputs = [ DateTime DateTimeTimeZone TimeDate ];
    meta = {
      description = "Parses Date::Parse compatible formats";
      license = "perl";
    };
  };

  DateTimeFormatFlexible = buildPerlPackage {
    name = "DateTime-Format-Flexible-0.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TH/THINC/DateTime-Format-Flexible-0.26.tar.gz;
      sha256 = "436efbc5e87cc385112e1c44336427fea32df670caf2b7d6dbb7a113ac6e693d";
    };
    propagatedBuildInputs = [ DateTime DateTimeFormatBuilder DateTimeTimeZone ListMoreUtils ModulePluggable TestMockTime ];
    meta = {
      description = "DateTime::Format::Flexible - Flexibly parse strings and turn them into DateTime objects";
      license = "perl";
    };
  };

  DateTimeFormatHTTP = buildPerlPackage {
    name = "DateTime-Format-HTTP-0.40";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CK/CKRAS/DateTime-Format-HTTP-0.40.tar.gz;
      sha256 = "214e9e2e364090ebc5bc682b29709828944ae67f0bb4a989dd1e6d010845213f";
    };
    propagatedBuildInputs = [ DateTime HTTPDate ];
    meta = {
      description = "Date conversion routines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatICal = buildPerlPackage {
    name = "DateTime-Format-ICal-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-ICal-0.09.tar.gz;
      sha256 = "8b09f6539f5e9c0df0e6135031699ed4ef9eef8165fc80aefeecc817ef997c33";
    };
    propagatedBuildInputs = [ DateTime DateTimeEventICal DateTimeSet DateTimeTimeZone ParamsValidate ];
    meta = {
      description = "Parse and format iCal datetime and duration strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatISO8601 = buildPerlPackage {
    name = "DateTime-Format-ISO8601-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JH/JHOBLITT/DateTime-Format-ISO8601-0.08.tar.gz;
      sha256 = "1syccqd5jlwms8v78ksnf68xijzl97jky5vbwhnyhxi5gvgfx8xk";
    };
    propagatedBuildInputs = [ DateTime DateTimeFormatBuilder ];
    meta = {
      description = "Parses ISO8601 formats";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DateTimeFormatNatural = buildPerlPackage {
    name = "DateTime-Format-Natural-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SC/SCHUBIGER/DateTime-Format-Natural-1.03.tar.gz;
      sha256 = "1m3bmv90kww8xr4dda75isvzigy8y3clgvk58zp0bxc5d7k4qdxi";
    };
    buildInputs = [ ModuleUtil TestMockTime ];
    propagatedBuildInputs = [ Clone DateTime DateTimeTimeZone ListMoreUtils ParamsValidate boolean ];
    meta = {
      description = "Create machine readable date/time with natural parsing logic";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeFormatPg = buildPerlPackage {
    name = "DateTime-Format-Pg-0.16008";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DM/DMAKI/DateTime-Format-Pg-0.16008.tar.gz;
      sha256 = "0mvh4wp54vh7mnhfd2lndzjfikjify98vaav6vwbraxlhjvwyn3x";
    };
    propagatedBuildInputs = [ DateTime DateTimeFormatBuilder DateTimeTimeZone ];
    meta = {
      description = "Parse and format PostgreSQL dates and times";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DateTimeFormatStrptime = buildPerlPackage {
    name = "DateTime-Format-Strptime-1.56";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-Strptime-1.56.tar.gz;
      sha256 = "2ff69d0f5a0359aab04e7276db5bee3be10040da24fbf09de1d904e7ead78b28";
    };
    propagatedBuildInputs = [ DateTime DateTimeLocale DateTimeTimeZone ParamsValidate ];
    meta = {
      description = "Parse and format strp and strf time patterns";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DateTimeLocale = buildPerlPackage {
    name = "DateTime-Locale-0.46";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Locale-0.46.tar.gz;
      sha256 = "b4ceaa0dc0b89d4eb180eb970a927cf376e3d04ef42de98de2e034cd2021348d";
    };
    buildInputs = [ DistCheckConflicts ];
    propagatedBuildInputs = [ ListMoreUtils ParamsValidate ];
    meta = {
      homepage = http://datetime.perl.org/;
      description = "Localization support for DateTime.pm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeSet = buildPerlPackage {
    name = "DateTime-Set-0.3400";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FG/FGLOCK/DateTime-Set-0.3400.tar.gz;
      sha256 = "1b27699zkj68w5ll9chjhs52vmf39f9via6x5r5844as30qh9zxb";
    };
    propagatedBuildInputs = [ DateTime SetInfinite ];
    meta = {
      description = "DateTime set objects";
      license = "unknown";
    };
  };

  DateTimeTimeZone = buildPerlPackage {
    name = "DateTime-TimeZone-1.91";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-TimeZone-1.91.tar.gz;
      sha256 = "0b0899a1b1a32ed3928397323a06692223688db2c3c050734e7ff4c7b231bd32";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassSingleton ListAllUtils ModuleRuntime ParamsValidate TryTiny ];
    meta = {
      description = "Time zone object base class and factory";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DateTimeXEasy = buildPerlPackage {
    name = "DateTimeX-Easy-0.089";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROKR/DateTimeX-Easy-0.089.tar.gz;
      sha256 = "17e6d202e7ac6049523048e97bb8f195e3c79208570da1504f4313584e487a79";
    };
    buildInputs = [ TestMost ];
    propagatedBuildInputs = [ DateTime DateTimeFormatFlexible DateTimeFormatICal DateTimeFormatNatural TimeDate ];
    meta = {
      description = "Parse a date/time string using the best method available";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DebugShowStuff = buildPerlPackage {
    name = "Debug-ShowStuff-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIKO/Debug-ShowStuff-1.16.tar.gz;
      sha256 = "1drcrnji3yrd0s3xb69bxnqa51s19c13w68vhvjad3nvswn5vpd4";
    };
    propagatedBuildInputs = [ ClassISA DevelStackTrace StringUtil TermReadKey TextTabularDisplay TieIxHash ];
    meta = {
      description = "A collection of handy debugging routines for displaying the values of variables with a minimum of coding";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelCaller = buildPerlPackage {
    name = "Devel-Caller-2.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RC/RCLAMP/Devel-Caller-2.06.tar.gz;
      sha256 = "1pxpimifzmnjnvf4icclx77myc15ahh0k56sj1djad1855mawwva";
    };
    propagatedBuildInputs = [ PadWalker ];
    meta = {
      description = "Meatier versions of C<caller>";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelChecklib = buildPerlPackage rec {
    name = "Devel-CheckLib-1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATTN/${name}.tar.gz";
      sha256 = "14q9mibxdgqkia73426q6xw6km5bf1hhkgg2nf7x4zhnlksahbwr";
    };
    propagatedBuildInputs = [ IOCaptureOutput ];
  };

  DevelDProf = buildPerlPackage {
    name = "Devel-DProf-20110802.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Devel-DProf-20110802.00.tar.gz;
      sha256 = "b9eec466ab77aa9f6ab48d33134694d1aa5a8cd221b1aa0a00d09c93ab69643c";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Devel-DProf;
      description = "A B<DEPRECATED> Perl code profiler";
      license = "perl";
    };
  };

  DevelPatchPerl = buildPerlPackage {
    name = "Devel-PatchPerl-1.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Devel-PatchPerl-1.28.tar.gz;
      sha256 = "03085cd6a8b565a4f789c838e8208a8377e0d1aeb7f5becc3b0d3219409d6b82";
    };
    propagatedBuildInputs = [ Filepushd ];
    meta = {
      homepage = https://github.com/bingos/devel-patchperl;
      description = "Patch perl source a la Devel::PPPort's buildperl.pl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelPPPort = buildPerlPackage {
    name = "Devel-PPPort-3.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/W/WO/WOLFSAGE/Devel-PPPort-3.31.tar.gz;
      sha256 = "ead2c49f0442a26890723231a92d3c0ac6ac297b814839e421a77d7889a2471d";
    };
    meta = {
      description = "Perl/Pollution/Portability";
      license = "perl";
    };
  };

  DevelSelfStubber = buildPerlPackage {
    name = "Devel-SelfStubber-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Devel-SelfStubber-1.05.tar.gz;
      sha256 = "b7bd750e41ec2dbca3f2f1d48e5e8ba594dcc8bc7a923a2565611ab8d0846bf8";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Devel-SelfStubber;
      description = "Generate stubs for a SelfLoading module";
      license = "perl";
    };
  };

  DevelSizeMe = buildPerlPackage {
    name = "Devel-SizeMe-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TI/TIMB/Devel-SizeMe-0.19.tar.gz;
      sha256 = "546e31ba83c0bf7cef37b38a462860461850473479d7d4ac6c0dadfb78d54717";
    };
    propagatedBuildInputs = [ DBDSQLite DBI DataDumperConcise HTMLParser JSONXS Moo ];
    meta = {
      homepage = https://github.com/timbunce/devel-sizeme;
      description = "Unknown";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelTrace = buildPerlPackage {
    name = "Devel-Trace-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJD/Devel-Trace-0.12.tar.gz;
      sha256 = "0s1q1a05gk3xvwqkya3k05vqjk13rvb489g0frprhzpzfvvwl0gm";
    };
    meta = {
      description = "Print out each line before it is executed (like sh -x)";
      license = stdenv.lib.licenses.publicDomain;
    };
  };

  DBDMock = buildPerlPackage {
    name = "DBD-Mock-1.45";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DI/DICHI/DBD-Mock/DBD-Mock-1.45.tar.gz;
      sha256 = "40a80c37b31ef14536b58b4a8b483e65953b00b8fa7397817c7eb76d540bd00f";
    };
    propagatedBuildInputs = [ DBI TestException ];
  };

  DBDSQLite = import ../development/perl-modules/DBD-SQLite {
    inherit stdenv fetchurl buildPerlPackage DBI;
    inherit (pkgs) sqlite;
  };

  DBDmysql = import ../development/perl-modules/DBD-mysql {
    inherit fetchurl buildPerlPackage DBI;
    inherit (pkgs) mysql;
  };

  DBDPg = import ../development/perl-modules/DBD-Pg {
    inherit stdenv fetchurl buildPerlPackage DBI;
    inherit (pkgs) postgresql;
  };

  DBFile = import ../development/perl-modules/DB_File {
    inherit fetchurl buildPerlPackage;
    inherit (pkgs) db;
  };

  DBI = buildPerlPackage rec {
    name = "DBI-1.633";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TI/TIMB/${name}.tar.gz";
      sha256 = "1rsyrzmykl7fxpvxmrjmy3dh9szp639fqdhbccqvywpnr7fbmhg2";
    };
    meta = {
      homepage = http://dbi.perl.org/;
      description = "Database independent interface for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClass = buildPerlPackage {
    name = "DBIx-Class-0.082801";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RI/RIBASUSHI/DBIx-Class-0.082801.tar.gz;
      sha256 = "889d6f9139d8e73f5524dfa211019126042e84cb7a0ec30cd2ed7d315d73484b";
    };
    buildInputs = [ DBDSQLite PackageStash TestDeep TestException TestWarn ];
    propagatedBuildInputs = [ ClassAccessorGrouped ClassC3Componentised ClassInspector ConfigAny ContextPreserve DBI DataDumperConcise DataPage DevelGlobalDestruction HashMerge MROCompat ModuleFind Moo PathClass SQLAbstract ScopeGuard SubName TryTiny namespaceclean ];
    doCheck = false;
    meta = {
      homepage = http://www.dbix-class.org/;
      description = "Extensible and flexible object <-> relational mapper";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassCandy = buildPerlPackage {
    name = "DBIx-Class-Candy-0.002104";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/DBIx-Class-Candy-0.002104.tar.gz;
      sha256 = "0b0fsm3waqm43qmhcynb2s6p8hi9yr41p9c4c5aq6l58x3xwvp34";
    };
    propagatedBuildInputs = [ TestDeep TestFatal DBIxClass LinguaENInflect StringCamelCase ];
    meta = {
      description = "Sugar for your favorite ORM, DBIx::Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassCursorCached = buildPerlPackage {
    name = "DBIx-Class-Cursor-Cached-1.001002";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AR/ARCANEZ/DBIx-Class-Cursor-Cached-1.001002.tar.gz;
      sha256 = "19r7jr6pknxiirrybq0cd0lnr76xiw05arnfqgk9nrhp6c7vvil0";
    };
    buildInputs = [ CacheCache DBDSQLite ];
    propagatedBuildInputs = [ CarpClan DBIxClass ];
    meta = {
      description = "Cursor class with built-in caching support";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassHTMLWidget = buildPerlPackage rec {
    name = "DBIx-Class-HTMLWidget-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDREMAR/${name}.tar.gz";
      sha256 = "05zhniyzl31nq410ywhxm0vmvac53h7ax42hjs9mmpvf45ipahj1";
    };
    propagatedBuildInputs = [DBIxClass HTMLWidget];
  };

  DBIxClassHelpers = buildPerlPackage {
    name = "DBIx-Class-Helpers-2.016005";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/DBIx-Class-Helpers-2.016005.tar.gz;
      sha256 = "0nkskc0h284l2q3m33553i8g4pr1kcx7vmwz8bi1kmga16bs7nqk";
    };
    propagatedBuildInputs = [ DBIxClassCandy TestDeep CarpClan DBDSQLite ];
    meta = {
      description = "Simplify the common case stuff for DBIx::Class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassIntrospectableM2M = buildPerlPackage {
    name = "DBIx-Class-IntrospectableM2M-0.001001";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRODITI/DBIx-Class-IntrospectableM2M-0.001001.tar.gz;
      sha256 = "0p9zx1yc1f6jg583l206wilsni2v8mlngc2vf2q8yn10pmy4y6wm";
    };
    propagatedBuildInputs = [ DBIxClass ];
    meta = {
      description = "Introspect many-to-many relationships";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DBIxClassSchemaLoader = buildPerlPackage {
    name = "DBIx-Class-Schema-Loader-0.07043";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/DBIx-Class-Schema-Loader-0.07043.tar.gz;
      sha256 = "01944d429a420fcb961aa4ab002f884f3d54529b3346816502c27d31c956194d";
    };
    buildInputs = [ ConfigAny ConfigGeneral DBDSQLite DBIxClassIntrospectableM2M Moose MooseXMarkAsMethods MooseXNonMoose TestDeep TestDifferences TestException TestPod TestWarn namespaceautoclean ];
    propagatedBuildInputs = [ CarpClan ClassAccessorGrouped ClassC3Componentised ClassInspector ClassUnload DBIxClass DataDump HashMerge LinguaENInflectNumber LinguaENInflectPhrase LinguaENTagger MROCompat ScalarListUtils ScopeGuard StringCamelCase StringToIdentifierEN TryTiny namespaceclean ];
    meta = {
      description = "Create a DBIx::Class::Schema based on a database";
      license = "perl";
    };
  };

  DBIxConnector = buildPerlModule {
    name = "DBIx-Connector-0.53";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/DBIx-Connector-0.53.tar.gz;
      sha256 = "198qbi97rnq6zbh5vgy437vlca8hns1b995fm4w896m0v7zgjjiw";
    };
    buildInputs = [ TestMockModule ];
    propagatedBuildInputs = [ DBI ];
    meta = {
      homepage = http://search.cpan.org/dist/DBIx-Connector/;
      description = "Fast, safe DBI connection and transaction management";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DBIxHTMLViewLATEST = buildPerlPackage {
    name = "DBIx-HTMLView-LATEST";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAKANARDO/DBIx-HTMLView-LATEST.tar.gz;
      sha256 = "b1af44cba329a8f583d174c5e82a7a2e91fe4f3a35cc38cbf028449578114dfa";
    };
    doCheck = false;
  };

  DBIxSimple = buildPerlPackage {
    name = "DBIx-Simple-1.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JU/JUERD/DBIx-Simple-1.35.tar.gz;
      sha256 = "445535b3dfab88140c7a0d2776b1e78f254dc7e9c81072d5a01afc95a5db499a";
    };
    propagatedBuildInputs = [ DBI ];
    meta = {
      description = "Very complete easy-to-use OO interface to DBI";
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DevelCycle = buildPerlPackage {
    name = "Devel-Cycle-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LD/LDS/Devel-Cycle-1.11.tar.gz;
      sha256 = "17c73yx9r32xvrsh8y7q24y0m3b98yihjyf3q4y68j869nh2b4rs";
    };
    meta = {
      description = "Find memory cycles in objects";
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DevelDeclare = buildPerlPackage {
    name = "Devel-Declare-0.006011";
    src = fetchurl {
      url = mirror://cpan/authors/id/Z/ZE/ZEFRAM/Devel-Declare-0.006011.tar.gz;
      sha256 = "0wqa9n4mdlsld4cmhy2mg8ncqr5gsra1913x0kypisgdqvviin2k";
    };
    buildInputs = [ BHooksOPCheck ExtUtilsDepends ];
    propagatedBuildInputs = [ BHooksEndOfScope BHooksOPCheck SubName ];
    meta = {
      description = "Adding keywords to perl, in perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DevelFindPerl = buildPerlPackage {
    name = "Devel-FindPerl-0.012";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Devel-FindPerl-0.012.tar.gz;
      sha256 = "075p340m4pi761sjc3l0ymfsdwy4rrq48sqj38cyy80vg9scljh2";
    };
    buildInputs = [ CaptureTiny ];
    propagatedBuildInputs = [ ExtUtilsConfig ];
    meta = {
      description = "Find the path to your perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelGlobalDestruction = buildPerlPackage {
    name = "Devel-GlobalDestruction-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/Devel-GlobalDestruction-0.12.tar.gz;
      sha256 = "0w4a4y9w4yldxlhks95nx8qaivpbzc40b1p8xg3y8467ixkbg9cq";
    };
    propagatedBuildInputs = [ SubExporterProgressive ];
    meta = {
      homepage = http://search.cpan.org/dist/Devel-GlobalDestruction;
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelHide = buildPerlPackage rec {
    name = "Devel-Hide-0.0009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FE/FERREIRA/${name}.tar.gz";
      sha256 = "1phnzbw58v6551nhv6sg86m72nx9w5j4msh1hg4jvkakkq5w9pki";
    };
  };

  DevelPartialDump = buildPerlPackage {
    name = "Devel-PartialDump-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Devel-PartialDump-0.15.tar.gz;
      sha256 = "0xm42030qlbimay5x72sjj0na43ciniai2xdcdx8zf191jw5dz7n";
    };
    propagatedBuildInputs = [ Moose namespaceclean SubExporter Testuseok TestWarn ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DevelStackTrace = buildPerlPackage {
    name = "Devel-StackTrace-1.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Devel-StackTrace-1.34.tar.gz;
      sha256 = "e882ccd7f4cbab0d0cdad53897f3f3bf29bdcf47d2bdfde1ac07f1bc7d7ebd16";
    };
    meta = {
      homepage = http://metacpan.org/release/Devel-StackTrace;
      description = "An object representing a stack trace";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DevelStackTraceAsHTML = buildPerlPackage {
    name = "Devel-StackTrace-AsHTML-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Devel-StackTrace-AsHTML-0.14.tar.gz;
      sha256 = "0yl296y0qfwybwjgqjzd4j2w2bj5a2nz342qqgxchnf5bqynl1c9";
    };
    propagatedBuildInputs = [ DevelStackTrace ];
    meta = {
      description = "Displays stack trace in HTML";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DevelSymdump = buildPerlPackage rec {
    name = "Devel-Symdump-2.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDK/${name}.tar.gz";
      sha256 = "0i5m2w8rsmp5lqi1y5y6b6938pidpz9hg92xahrshaddph00358i";
    };
    propagatedBuildInputs = [
      TestPod /* cyclic dependency: TestPodCoverage */
    ];
  };

  Digest = buildPerlPackage {
    name = "Digest-1.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-1.17.tar.gz;
      sha256 = "2f6a54459fc7f37c0669d548bb224b695eb8d2ddc089aa5547645ce1f5fd86f7";
    };
    meta = {
      description = "Modules that calculate message digests";
      license = "perl";
    };
  };

  DigestCRC = buildPerlPackage rec {
    name = "Digest-CRC-0.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OL/OLIMAUL/${name}.tar.gz";
      sha256 = "5c5329f37c46eb79835169508583da8767d9839350b69bb2b48ac6f594f70374";
    };
  };

  DigestHMAC = buildPerlPackage {
    name = "Digest-HMAC-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-HMAC-1.03.tar.gz;
      sha256 = "0naavabbm1c9zgn325ndy66da4insdw9l3mrxwxdfi7i7xnjrirv";
    };
    meta = {
      description = "Keyed-Hashing for Message Authentication";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DigestHMAC_SHA1 = buildPerlPackage {
    name = "Digest-HMAC_SHA1-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-HMAC-1.03.tar.gz;
      sha256 = "0naavabbm1c9zgn325ndy66da4insdw9l3mrxwxdfi7i7xnjrirv";
    };
    meta = {
      description = "Keyed-Hashing for Message Authentication";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DigestMD4 = buildPerlPackage rec {
    name = "Digest-MD4-1.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEM/DigestMD4/${name}.tar.gz";
      sha256 = "19ma1hmvgiznq95ngzvm6v4dfxc9zmi69k8iyfcg6w14lfxi0lb6";
    };
  };

  DigestMD5 = buildPerlPackage {
    name = "Digest-MD5-2.54";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-MD5-2.54.tar.gz;
      sha256 = "90de11e3743ef1c753a5c2032b434e09472046fbcf346996cbe5d135b217f390";
    };
    meta = {
      description = "Perl interface to the MD-5 algorithm";
      license = "perl";
    };
  };

  DigestMD5File = buildPerlPackage {
    name = "Digest-MD5-File-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DM/DMUEY/Digest-MD5-File-0.08.tar.gz;
      sha256 = "060jzf45dlwysw5wsm7av1wvpl06xgk415kwwpvv89r6wda3md5d";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "Perl extension for getting MD5 sums for files and urls";
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  DigestSHA = null;

  DigestSHA1 = buildPerlPackage {
    name = "Digest-SHA1-2.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Digest-SHA1-2.13.tar.gz;
      sha256 = "1k23p5pjk42vvzg8xcn4iwdii47i0qm4awdzgbmz08bl331dmhb8";
    };
    meta = {
      description = "Perl interface to the SHA-1 algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistCheckConflicts = buildPerlPackage {
    name = "Dist-CheckConflicts-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Dist-CheckConflicts-0.02.tar.gz;
      sha256 = "1lh7j20vvsh4dyh74hr0wnabyv8vcdkilfi93m2fbk69qk3w995j";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ SubExporter ListMoreUtils ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Declare version conflicts for your dist";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZilla = buildPerlPackage {
    name = "Dist-Zilla-4.300039";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Dist-Zilla-4.300039.tar.gz;
      sha256 = "10cighwsqp53kbk2gwlnl9m18sbs7ijr2v37vwca9qxbscy2yr21";
    };
    buildInputs = [ FileShareDirInstall SoftwareLicense TestFatal TestFileShareDir TestScript ];
    propagatedBuildInputs = [ AppCmd CPANUploader ClassLoad ConfigINI ConfigMVP ConfigMVPReaderINI DataSection DateTime FileCopyRecursive FileFindRule FileHomeDir FileShareDir FileShareDirInstall Filepushd HashMergeSimple JSON ListAllUtils ListMoreUtils LogDispatchouli Moose MooseAutobox MooseXLazyRequire MooseXRoleParameterized MooseXSetOnce MooseXTypes MooseXTypesPathClass MooseXTypesPerl PPI ParamsUtil PathClass PerlPrereqScanner PerlVersion PodEventual SoftwareLicense StringFormatter StringRewritePrefix SubExporter SubExporterForMethods TermReadKey TestDeep TextGlob TextTemplate TryTiny YAMLTiny autobox namespaceautoclean CPANMetaRequirements ];
    meta = {
      homepage = http://dzil.org/;
      description = "Distribution builder; installer not included!";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    doCheck = false;
  };

  DistZillaPluginBundleTestingMania = buildPerlPackage {
    name = "Dist-Zilla-PluginBundle-TestingMania-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-PluginBundle-TestingMania-0.21.tar.gz;
      sha256 = "1cbq7v799bf93iqp19v1ln6bcf6gvmc0qw3gf4bq445wsm7w62wy";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox perl ];
    propagatedBuildInputs = [ DistZilla DistZillaPluginMojibakeTests DistZillaPluginNoTabsTests DistZillaPluginTestCPANChanges DistZillaPluginTestCPANMetaJSON DistZillaPluginTestCompile DistZillaPluginTestDistManifest DistZillaPluginTestEOL DistZillaPluginTestKwalitee DistZillaPluginTestMinimumVersion DistZillaPluginTestPerlCritic DistZillaPluginTestPodLinkCheck DistZillaPluginTestPortability DistZillaPluginTestSynopsis DistZillaPluginTestUnusedVars DistZillaPluginTestVersion JSONPP ListMoreUtils Moose PodCoverageTrustPod TestCPANMeta TestPerlCritic TestVersion namespaceautoclean ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-PluginBundle-TestingMania/;
      description = "Test your dist with every testing plugin conceivable";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginCheckChangeLog = buildPerlPackage {
    name = "Dist-Zilla-Plugin-CheckChangeLog-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FA/FAYLAND/Dist-Zilla-Plugin-CheckChangeLog-0.01.tar.gz;
      sha256 = "153dbe5ff8cb3c060901e003237a0515d7b9b5cc870eebfd417a6c91e28edec2";
    };
    propagatedBuildInputs = [ DistZilla ];
    meta = {
      description = "Dist::Zilla with Changes check";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginMojibakeTests = buildPerlPackage {
    name = "Dist-Zilla-Plugin-MojibakeTests-0.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SY/SYP/Dist-Zilla-Plugin-MojibakeTests-0.5.tar.gz;
      sha256 = "0630acc9bcb415feba49b55a1b70da6e49a740673b4a483fc8058d03c6a21676";
    };
    propagatedBuildInputs = [ DistZilla Moose TestMojibake UnicodeCheckUTF8 ];
    meta = {
      homepage = https://github.com/creaktive/Dist-Zilla-Plugin-MojibakeTests;
      description = "Release tests for source encoding";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginNoTabsTests = buildPerlPackage {
    name = "Dist-Zilla-Plugin-NoTabsTests-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Dist-Zilla-Plugin-NoTabsTests-0.01.tar.gz;
      sha256 = "fd4ed380de4fc2bad61db377cc50ab26b567e53b3a1efd0b8d8baab80256ef9e";
    };
    propagatedBuildInputs = [ DistZilla Moose TestNoTabs namespaceautoclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-NoTabsTests;
      description = "Release tests making sure hard tabs aren't used";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginPodWeaver = buildPerlPackage {
    name = "Dist-Zilla-Plugin-PodWeaver-3.102000";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Dist-Zilla-Plugin-PodWeaver-3.102000.tar.gz;
      sha256 = "0xayy50fgfc7wlsnygz28ka2ax9pmr0rn845i8d6p40amrkzzlml";
    };
    buildInputs = [ FileFindRule ];
    propagatedBuildInputs = [ DistZilla ListMoreUtils Moose PPI PodElementalPerlMunger PodWeaver namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/Dist-Zilla-Plugin-PodWeaver;
      description = "Weave your Pod together from configuration and Dist::Zilla";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginReadmeAnyFromPod = buildPerlPackage {
    name = "Dist-Zilla-Plugin-ReadmeAnyFromPod-0.131500";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RT/RTHOMPSON/Dist-Zilla-Plugin-ReadmeAnyFromPod-0.131500.tar.gz;
      sha256 = "4d02ce5f185e0d9061019c1925a410931d0c1848db7e5ba5f8e676f04634b06e";
    };
    buildInputs = [ DistZilla TestMost ];
    propagatedBuildInputs = [ DistZilla FileSlurp IOstringy Moose MooseAutobox MooseXHasSugar PodMarkdown ];
    meta = {
      homepage = https://github.com/DarwinAwardWinner/Dist-Zilla-Plugin-ReadmeAnyFromPod;
      description = "Automatically convert POD to a README in any format for Dist::Zilla";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginReadmeMarkdownFromPod = buildPerlPackage {
    name = "Dist-Zilla-Plugin-ReadmeMarkdownFromPod-0.120120";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RT/RTHOMPSON/Dist-Zilla-Plugin-ReadmeMarkdownFromPod-0.120120.tar.gz;
      sha256 = "5a3346daab4e2bba850ee4a7898467da9f80bc93cc10d2d625f9880a46092160";
    };
    buildInputs = [ DistZilla TestMost ];
    propagatedBuildInputs = [ DistZillaPluginReadmeAnyFromPod Moose ];
    meta = {
      homepage = https://github.com/DarwinAwardWinner/Dist-Zilla-Plugin-ReadmeMarkdownFromPod;
      description = "Automatically convert POD to a README.mkdn for Dist::Zilla";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestCPANChanges = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-CPAN-Changes-0.008";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-CPAN-Changes-0.008.tar.gz;
      sha256 = "e8e49a23fb6fa021dec4fc4ab0a05a2ad50ac26195536c109a96b681ba4decd2";
    };
    buildInputs = [ CPANChanges DistZilla MooseAutobox ];
    propagatedBuildInputs = [ CPANChanges DataSection DistZilla Moose ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-Plugin-Test-CPAN-Changes/;
      description = "Release tests for your changelog";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestCPANMetaJSON = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-CPAN-Meta-JSON-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-CPAN-Meta-JSON-0.003.tar.gz;
      sha256 = "c76b9f5745f4626969bb9c60e1330ebd0d8b197f8dd33f9a6e6fce63877b4883";
    };
    buildInputs = [ DistZilla ];
    propagatedBuildInputs = [ DistZilla Moose MooseAutobox ];
    meta = {
      homepage = http://p3rl.org/Dist::Zilla::Plugin::Test::CPAN::Meta::JSON;
      description = "Release tests for your META.json";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestCompile = buildPerlModule {
    name = "Dist-Zilla-Plugin-Test-Compile-2.021";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Test-Compile-2.021.tar.gz;
      sha256 = "665c48de1c7c33e9b00e8ddc0204d02b45009e60b9b65033fa4a832dfe9fc808";
    };
    buildInputs = [ DistCheckConflicts DistZilla JSON ModuleBuildTiny PathClass TestCheckDeps TestWarnings ];
    propagatedBuildInputs = [ DataSection DistCheckConflicts DistZilla Moose PathTiny SubExporterForMethods namespaceautoclean ModuleCoreList ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-Test-Compile/;
      description = "Common tests to check syntax of your modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestDistManifest = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-DistManifest-2.000004";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-DistManifest-2.000004.tar.gz;
      sha256 = "a832d9d04f85e9dd09f30af67c5d636efe79847ec3790939de081ee5e412fb68";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestDistManifest ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-Plugin-Test-DistManifest/;
      description = "Release tests for the manifest";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestEOL = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-EOL-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XE/XENO/Dist-Zilla-Plugin-Test-EOL-0.10.tar.gz;
      sha256 = "1sl7zvjzpwf7wl188a3j13k1qcb63hawx82iy6r3dx2gns8nc0nw";
    };
    buildInputs = [ DistZilla TestScript ];
    propagatedBuildInputs = [ DistZilla Moose TestEOL namespaceautoclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-Test-EOL/;
      description = "Author tests making sure correct line endings are used";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  DistZillaPluginTestKwalitee = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Kwalitee-2.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Dist-Zilla-Plugin-Test-Kwalitee-2.06.tar.gz;
      sha256 = "1723beb96d4048fd4fb0fea2ed36c0c6f3ea4648ce7f93d4cb73e5d49e274bf6";
    };
    buildInputs = [ CaptureTiny DistZilla PathClass perl ];
    propagatedBuildInputs = [ DataSection DistZilla Moose SubExporterForMethods namespaceautoclean ];
    meta = {
      homepage = https://metacpan.org/release/Dist-Zilla-Plugin-Test-Kwalitee;
      description = "Release tests for kwalitee";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestMinimumVersion = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-MinimumVersion-2.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-MinimumVersion-2.000005.tar.gz;
      sha256 = "988c71a3158e94e7a0b23f346f19af4a0ed67e101a2653c3185c5ae49981132b";
    };
    buildInputs = [ DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestMinimumVersion ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-Plugin-Test-MinimumVersion/;
      description = "Release tests for minimum required versions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestPerlCritic = buildPerlModule {
    name = "Dist-Zilla-Plugin-Test-Perl-Critic-2.112410";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JQ/JQUELIN/Dist-Zilla-Plugin-Test-Perl-Critic-2.112410.tar.gz;
      sha256 = "3ce59ce3ef6cf56d7de0debb33c26f899492d9742c8b82073e257787fd85630f";
    };
    buildInputs = [ DistZilla MooseAutobox ];
    propagatedBuildInputs = [ DataSection DistZilla Moose namespaceautoclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-Test-Perl-Critic/;
      description = "Tests to check your code against best practices";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestPodLinkCheck = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Pod-LinkCheck-1.001";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RW/RWSTAUNER/Dist-Zilla-Plugin-Test-Pod-LinkCheck-1.001.tar.gz;
      sha256 = "d75682175dff1f79928794ba30ea29389a4666f781a50cba281c25cfd3c95bbd";
    };
    propagatedBuildInputs = [ DistZilla Moose TestPodLinkCheck ];
    meta = {
      homepage = http://github.com/rwstauner/Dist-Zilla-Plugin-Test-Pod-LinkCheck;
      description = "Add release tests for POD links";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestPortability = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Portability-2.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-Portability-2.000005.tar.gz;
      sha256 = "b32d0a4b1d78ba76fabedd299c1a11efed05c3ce9752d7da6babe06d3515242b";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestPortabilityFiles ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-Plugin-Test-Portability/;
      description = "Release tests for portability";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestSynopsis = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Synopsis-2.000004";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-Synopsis-2.000004.tar.gz;
      sha256 = "d073de3206c5e588f60f55e4be64fab4c2595f5bc3013cd91307993691598d59";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestSynopsis ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-Plugin-Test-Synopsis/;
      description = "Release tests for synopses";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestUnusedVars = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-UnusedVars-2.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOHERTY/Dist-Zilla-Plugin-Test-UnusedVars-2.000005.tar.gz;
      sha256 = "37ec462dc82f45cfd9d6d92ee59b8fd215a9a14b18d179b05912baee77359804";
    };
    buildInputs = [ CaptureTiny DistZilla MooseAutobox TestOutput ];
    propagatedBuildInputs = [ DistZilla Moose TestVars namespaceautoclean ];
    meta = {
      homepage = http://metacpan.org/release/Dist-Zilla-Plugin-Test-UnusedVars/;
      description = "Release tests for unused variables";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  DistZillaPluginTestVersion = buildPerlPackage {
    name = "Dist-Zilla-Plugin-Test-Version-0.002004";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XE/XENO/Dist-Zilla-Plugin-Test-Version-0.002004.tar.gz;
      sha256 = "4ae5055071e07442223d07d818e9484430368b59c15966b90b18c8abc06f8e36";
    };
    buildInputs = [ DistZilla TestNoTabs TestScript ];
    propagatedBuildInputs = [ DistZilla Moose TestVersion namespaceautoclean ];
    meta = {
      homepage = http://search.cpan.org/dist/Dist-Zilla-Plugin-Test-Version/;
      description = "Release Test::Version tests";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  EmailAbstract = buildPerlPackage {
    name = "Email-Abstract-3.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Abstract-3.007.tar.gz;
      sha256 = "10915aa3a558f6ba9c51a13ea1c135aed765e185a14cd2cfc9b434599cf5eaa8";
    };
    propagatedBuildInputs = [ EmailSimple MROCompat ModulePluggable ];
    meta = {
      homepage = https://github.com/rjbs/Email-Abstract;
      description = "Unified interface to mail representations";
      license = "perl";
    };
  };

  EmailAddress = buildPerlPackage {
    name = "Email-Address-1.901";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Address-1.901.tar.gz;
      sha256 = "00svsmv2hk35ybpd7jxcsn7k54i0q9ph5lf8ksv9nkh1abraprkz";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "RFC 2822 Address Parsing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailDateFormat = buildPerlPackage {
    name = "Email-Date-Format-1.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Date-Format-1.002.tar.gz;
      sha256 = "114fqcnmvzi0z100yx89j6rgwbicb0bslswhyr8z2pzsvwv3czqc";
    };
    meta = {
      description = "Produce RFC 8822 date strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailMessageID = buildPerlPackage {
    name = "Email-MessageID-1.404";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-MessageID-1.404.tar.gz;
      sha256 = "0lyq9r3x7cs7cncf0yiazbi7aq4c5d4m3wxwgqdd4r5p9gxdjj4n";
    };
    propagatedBuildInputs = [ EmailAddress ];
    meta = {
      description = "Generate world unique message-ids";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  EmailMIME = buildPerlPackage {
    name = "Email-MIME-1.911";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-MIME-1.911.tar.gz;
      sha256 = "0nkvps2k1gkr5vh12qbl0djdnjxnp7jdi52zgda6k67wrghm5ryd";
    };
    propagatedBuildInputs = [ EmailMessageID EmailMIMEContentType EmailMIMEEncodings EmailSimple MIMETypes ];
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  EmailMIMEContentType = buildPerlPackage {
    name = "Email-MIME-ContentType-1.015";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-MIME-ContentType-1.015.tar.gz;
      sha256 = "1rlk3rxlw8ri4b7c68nhg6b3ykgc97rdaqb1dyam8f8k1z8cik0g";
    };
    meta = {
      description = "Parse a MIME Content-Type Header";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  EmailMIMEEncodings = buildPerlPackage {
    name = "Email-MIME-Encodings-1.313";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-MIME-Encodings-1.313.tar.gz;
      sha256 = "0fac34g44sn0l59wim68zrhih1mvlh1rxvyn3gc5pviaiz028lyy";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  EmailSend = buildPerlPackage rec {
    name = "Email-Send-2.198";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0ffmpqys7yph5lb28m2xan0zd837vywg8c6gjjd9p80dahpqknyx";
    };
    propagatedBuildInputs = [EmailSimple EmailAddress ModulePluggable ReturnValue];
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  EmailSender = buildPerlPackage {
    name = "Email-Sender-1.300016";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Sender-1.300016.tar.gz;
      sha256 = "00042de1b78fb26b2ff37bd92c0d61631810725a5235f4841e38a501a533a2a3";
    };
    buildInputs = [ CaptureTiny ];
    propagatedBuildInputs = [ EmailAbstract EmailAddress EmailSimple ListMoreUtils ModuleRuntime Moo MooXTypesMooseLike SubExporter Throwable TryTiny ];
    meta = {
      homepage = https://github.com/rjbs/Email-Sender;
      description = "A library for sending email";
      license = "perl";
      platforms = stdenv.lib.platforms.linux;
    };
  };

  EmailSimple = buildPerlPackage {
    name = "Email-Simple-2.203";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Simple-2.203.tar.gz;
      sha256 = "0hzbp8ay62d6jwrn4q7hqmhkaigf8lc0plz0g46yhwzp3x9xfa55";
    };
    propagatedBuildInputs = [ EmailDateFormat ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EmailValid = buildPerlPackage {
    name = "Email-Valid-1.192";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Email-Valid-1.192.tar.gz;
      sha256 = "0vpqgbr5bj4bvrd7c2fh9hs1mz0m6nfybl2rdn5yb4h67bmxfkbp";
    };
    propagatedBuildInputs = [MailTools NetDNS];
    doCheck = false;
  };

  Encode = buildPerlPackage {
    name = "Encode-2.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-2.63.tar.gz;
      sha256 = "1wrqm6c194l5yjaifc6nxx2b768sph2pv4n86fgh4blls0pvs6z4";
    };
  };

  EncodeEUCJPASCII = buildPerlPackage {
    name = "Encode-EUCJPASCII-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEZUMI/Encode-EUCJPASCII-0.03.tar.gz;
      sha256 = "f998d34d55fd9c82cf910786a0448d1edfa60bf68e2c2306724ca67c629de861";
    };
    meta = {
      description = "EucJP-ascii - An eucJP-open mapping";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  EncodeHanExtra = buildPerlPackage {
    name = "Encode-HanExtra-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Encode-HanExtra-0.23.tar.gz;
      sha256 = "1fd4b06cada70858003af153f94c863b3b95f2e3d03ba18d0451a81d51db443a";
    };
    meta = {
      description = "Extra sets of Chinese encodings";
      license = stdenv.lib.licenses.mit;
    };
  };

  EncodeJIS2K = buildPerlPackage {
    name = "Encode-JIS2K-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-JIS2K-0.02.tar.gz;
      sha256 = "5d718add5857f37fc270f24360bc9d100b72e0e13a11ca3149fe4e4d7c7cc4bf";
    };
    meta = {
    };
  };

  EncodeLocale = buildPerlPackage rec {
    name = "Encode-Locale-1.03";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Encode/${name}.tar.gz";
      sha256 = "0m9d1vdphlyzybgmdanipwd9ndfvyjgk3hzw250r299jjgh3fqzp";
    };
    preCheck = if stdenv.isCygwin then ''
      sed -i"" -e "s@plan tests => 13@plan tests => 10@" t/env.t
      sed -i"" -e "s@ok(env(\"\\\x@#ok(env(\"\\\x@" t/env.t
      sed -i"" -e "s@ok(\$ENV{\"\\\x@#ok(\$ENV{\"\\\x@" t/env.t
    '' else null;
  };

  Env = buildPerlPackage {
    name = "Env-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Env-1.04.tar.gz;
      sha256 = "d94a3d412df246afdc31a2199cbd8ae915167a3f4684f7b7014ce1200251ebb0";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Env;
      description = "Perl module that imports environment variables as scalars or arrays";
      license = "perl";
    };
  };

  EnvPath = buildPerlPackage {
    name = "Env-Path-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DS/DSB/Env-Path-0.19.tar.gz;
      sha256 = "1qhmj15a66h90pjl2dgnxsb9jj3b1r5mpvnr87cafcl8g69z0jr4";
    };
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  Error = buildPerlPackage rec {
    name = "Error-0.17022";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "1vzpz6syb82ir8svp2wjh95x6lpf01lgkxn2xy60ixrszc24zdya";
    };
  };

  EvalClosure = buildPerlPackage {
    name = "Eval-Closure-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Eval-Closure-0.11.tar.gz;
      sha256 = "1b3rc9smdyyi0janckfiyg1kwph893sqwx7dr5n4mky0x8x3v4m1";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ SubExporter TryTiny ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Safely and cleanly create closures via string eval";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExceptionBase = buildPerlPackage {
    name = "Exception-Base-0.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Exception-Base-0.25.tar.gz;
      sha256 = "1s2is862xba2yy633wn2nklrya36yrlwxlbpqjrv8m31xj2c8khw";
    };
    buildInputs = [ TestUnitLite ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExceptionClass = buildPerlPackage rec {
    name = "Exception-Class-1.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DR/DROLSKY/${name}.tar.gz";
      sha256 = "1p6f20fi82mr5bz7d2c7nqh0322r8n2kszfw37c77g8b1b4r72w3";
    };
    propagatedBuildInputs = [ ClassDataInheritable DevelStackTrace ];
  };

  ExceptionDied = buildPerlPackage {
    name = "Exception-Died-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Exception-Died-0.06.tar.gz;
      sha256 = "1dcajw2m3x5m76fpi3fvy9fjkmfrd171pnx087i5fkgx5ay41i1m";
    };
    buildInputs = [ TestAssert TestUnitLite ];
    propagatedBuildInputs = [ constantboolean ExceptionBase ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExceptionWarning = buildPerlPackage {
    name = "Exception-Warning-0.0401";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Exception-Warning-0.0401.tar.gz;
      sha256 = "1a6k3sbhkxmz00wrmhv70f9kxjf7fklp1y6mnprfvcdmrsk9qdkv";
    };
    buildInputs = [ TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExporterDeclare = buildPerlModule {
    name = "Exporter-Declare-0.113";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EX/EXODIST/Exporter-Declare-0.113.tar.gz;
      sha256 = "724de5e982c8477df14a360c82233f9e0c26b4af9191647f750f5e465ea42dce";
    };
    buildInputs = [ FennecLite TestException ];
    propagatedBuildInputs = [ MetaBuilder aliased ];
    meta = {
      homepage = http://open-exodus.net/projects/Exporter-Declare;
      description = "Exporting done right";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExporterLite = buildPerlPackage {
    name = "Exporter-Lite-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Exporter-Lite-0.04.tar.gz;
      sha256 = "01g6a2ixgdi825v0l4ny3vx4chzsfxirka741x0i057cf6y5ciir";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExporterTiny = buildPerlPackage {
    name = "Exporter-Tiny-0.042";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOBYINK/Exporter-Tiny-0.042.tar.gz;
      sha256 = "8f1622c5ebbfbcd519ead81df7917e48cb16cc527b1c46737b0459c3908a023f";
    };
    meta = {
      homepage = https://metacpan.org/release/Exporter-Tiny;
      description = "An exporter with the features of Sub::Exporter but only core dependencies";
      license = "perl";
    };
  };

  ExtUtilsCommand = buildPerlPackage {
    name = "ExtUtils-Command-1.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/ExtUtils-Command-1.20.tar.gz;
      sha256 = "740cccc93ba851aae803695b7a5b65ccbaa78bf4e96aa2e54f3f632c87a98c98";
    };
    meta = {
      homepage = http://search.cpan.org/dist/ExtUtils-Command;
      description = "Utilities to replace common UNIX commands in Makefiles etc";
      license = "perl";
    };
  };

  Expect = buildPerlPackage {
    name = "Expect-1.32";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SZ/SZABGAB/Expect-1.32.tar.gz;
      sha256 = "d1f96842a5c7dd8516b202b530d87a70b65e7054d3bf975c34f6a42084e54e25";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ IOTty ];
    meta = {
      description = "Automate interactions with command line programs that expose a text terminal interface";
      license = "perl";
    };
  };

  Exporter = buildPerlPackage {
    name = "Exporter-5.72";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/Exporter-5.72.tar.gz;
      sha256 = "cd13b7a0e91e8505a0ce4b25f40fab2c92bb28a99ef0d03da1001d95a32f0291";
    };
    meta = {
      description = "Implements default import method for modules";
      license = "perl";
    };
  };

  ExtUtilsCBuilder = buildPerlPackage rec {
    name = "ExtUtils-CBuilder-0.280216";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AM/AMBS/ExtUtils/${name}.tar.gz";
      sha256 = "09d5sq9mgcnmjf2yp8rwd0cc1fa8kq7nbwjqxiqdykwmavmgm5ml";
    };
    buildInputs = [ PerlOSType ];
  };

  ExtUtilsConfig = buildPerlPackage {
    name = "ExtUtils-Config-0.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/ExtUtils-Config-0.007.tar.gz;
      sha256 = "2c1465078b876fd16a90507092805265528c2532d4937b03547a6dbdb8ac0eef";
    };
    meta = {
      description = "A wrapper for perl's configuration";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsConstant = buildPerlPackage {
    name = "ExtUtils-Constant-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NW/NWCLARK/ExtUtils-Constant-0.23.tar.gz;
      sha256 = "23b77025c8a5d3b93c586d4f0e712bcca3ef934edbee00a78c3fad4285f48eab";
    };
  };

  ExtUtilsCppGuess = buildPerlModule rec {
    name = "ExtUtils-CppGuess-0.07";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "1a77hxf2pa8ia9na72rijv1yhpn2bjrdsybwk2dj2l938pl3xn0w";
    };
    propagatedBuildInputs = [ CaptureTiny ];
  };

  ExtUtilsDepends = buildPerlPackage {
    name = "ExtUtils-Depends-0.306";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XA/XAOC/ExtUtils-Depends-0.306.tar.gz;
      sha256 = "0s935hmxjl6md47i80abcfaghqwhnv0ikzzqln80w4ydhg5qn9a5";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ExtUtilsHelpers = buildPerlPackage {
    name = "ExtUtils-Helpers-0.022";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/ExtUtils-Helpers-0.022.tar.gz;
      sha256 = "15dalfwmpfmifw312i5pwiai8134pxf7b2804shlqhdk1xqczy6k";
    };
    meta = {
      description = "Various portability utilities for module builders";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsInstall = buildPerlPackage {
    name = "ExtUtils-Install-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/ExtUtils-Install-2.04.tar.gz;
      sha256 = "1b2e5370bc63d93cf99a75feb2b9b67227b693d16ebfb730ca90a483145de3b6";
    };
    meta = {
      homepage = https://metacpan.org/release/ExtUtils-Install;
      description = "Install files from here to there";
      license = "perl";
    };
  };

  ExtUtilsInstallPaths = buildPerlPackage {
    name = "ExtUtils-InstallPaths-0.010";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/ExtUtils-InstallPaths-0.010.tar.gz;
      sha256 = "0mi1px42in7i442jqncg3gmxd5zn7sw5b2s85h690rz433qvyk6i";
    };
    propagatedBuildInputs = [ ExtUtilsConfig ];
    meta = {
      description = "Build.PL install path logic made easy";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsLibBuilder = buildPerlModule {
    name = "ExtUtils-LibBuilder-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AM/AMBS/ExtUtils/ExtUtils-LibBuilder-0.04.tar.gz;
      sha256 = "0j4rhx3w6nbvmxqjg6q09gm10nnpkcmqmh29cgxsfc9k14d8bb6w";
    };
    meta = {
      description = "A tool to build C libraries";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsMakeMaker = buildPerlPackage {
    name = "ExtUtils-MakeMaker-6.98";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-6.98.tar.gz;
      sha256 = "2eb023189e5fa6b9dcc66858b1fde953d1f1b86f971ec5ab42dd36c172da63ef";
    };
    propagatedBuildInputs =
      [ ParseCPANMeta JSONPP JSONPPCompat5006 CPANMetaYAML FileCopyRecursive ];
    meta = {
      homepage = https://metacpan.org/release/ExtUtils-MakeMaker;
      description = "Create a module Makefile";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ExtUtilsManifest = buildPerlPackage rec {
    name = "ExtUtils-Manifest-1.63";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "0p4hj03nb5n6mk7pskpw066n1i3hr80nq7k7rc3fgl329v6syfmg";
    };
  };

  ExtUtilsParseXS = buildPerlPackage rec {
    name = "ExtUtils-ParseXS-3.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/${name}.tar.gz";
      sha256 = "07ipa2ssflw3ais8gbjdk4l8z2k1p65nfjwkxm37g6zw1210pdih";
    };
  };

  ExtUtilsPkgConfig = buildPerlPackage rec {
    name = "ExtUtils-PkgConfig-1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "1cxh6w8vmyqmhl6afys2q6z6jkp1m6zvacpk70196zmk48p1kcv9";
    };
    propagatedBuildInputs = [ pkgs.pkgconfig ];
    meta = {
      description = "Simplistic interface to pkg-config";
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  # From CPAN[1]:
  #   This module exists merely as a compatibility wrapper around
  #   ExtUtils::Typemaps. In a nutshell, ExtUtils::Typemap was renamed to
  #   ExtUtils::Typemaps because the Typemap directory in lib/ could collide with
  #   the typemap file on case-insensitive file systems.
  #
  #   The ExtUtils::Typemaps module is part of the ExtUtils::ParseXS distribution
  #   and ships with the standard library of perl starting with perl version
  #   5.16.
  #
  # [1] http://search.cpan.org/~smueller/ExtUtils-Typemap-1.00/lib/ExtUtils/Typemap.pm:
  ExtUtilsTypemap = buildPerlPackage rec {
    name = "ExtUtils-Typemap-1.00";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "1iqz0xlscg655gnwb2h1wrjj70llblps1zznl29qn1mv5mvibc5i";
    };
    buildInputs = [ ExtUtilsParseXS ];
  };

  ExtUtilsTypemapsDefault = buildPerlModule rec {
    name = "ExtUtils-Typemaps-Default-1.05";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "1phmha0ks95kvzl00r1kgnd5hvg7qb1q9jmzjmw01p5zgs1zbyix";
    };
    propagatedBuildInputs = [ ExtUtilsTypemap ExtUtilsParseXS ];
  };

  ExtUtilsXSBuilder = buildPerlPackage {
    name = "ExtUtils-XSBuilder-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRICHTER/ExtUtils-XSBuilder-0.28.tar.gz;
      sha256 = "8cced386e3d544c5ec2deb3aed055b72ebcfc2ea9a6c807da87c4245272fe80a";
    };
    propagatedBuildInputs = [ ParseRecDescent TieIxHash ];
  };

  ExtUtilsXSpp = buildPerlModule rec {
    name = "ExtUtils-XSpp-0.1700";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/ExtUtils/${name}.tar.gz";
      sha256 = "1msp79bdjzi59vignfz1cxwk5a2cjiahblvi0ka60pi8nnn0alrm";
    };
    buildInputs = [ Spiffy TestBase TestDifferences ];
  };

  FatalException = buildPerlPackage {
    name = "Fatal-Exception-0.0204";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Fatal-Exception-0.0204.tar.gz;
      sha256 = "10a9j0fa83s3apv0xgi01l2h6s43my031097hg72wa80n07rgs2c";
    };
    buildInputs = [ ExceptionWarning TestAssert TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase ExceptionDied ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FCGI = buildPerlPackage rec {
    name = "FCGI-0.74";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/FCGI/${name}.tar.gz";
      sha256 = "0m089q07kpsk8y8g2wmi3d8i1jzn5m5m00shs7vnf2lnvvv4d7pm";
    };
    buildInputs = [ ];
  };

  FennecLite = buildPerlModule {
    name = "Fennec-Lite-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EX/EXODIST/Fennec-Lite-0.004.tar.gz;
      sha256 = "dce28e3932762c2ff92aa52d90405c06e898e81cb7b164ccae8966ae77f1dcab";
    };
    meta = {
      homepage = http://open-exodus.net/projects/Fennec-Lite;
      description = "Minimalist Fennec, the commonly used bits";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FileChangeNotify = buildPerlModule {
    name = "File-ChangeNotify-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/File-ChangeNotify-0.24.tar.gz;
      sha256 = "3c8180169de0f97ad852a55942f74e520cbe433aa0889d0b65548ee38a111124";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs =
      [ ClassLoad ListMoreUtils ModulePluggable Moose MooseXParamsValidate MooseXSemiAffordanceAccessor namespaceautoclean ]
      ++ stdenv.lib.optional stdenv.isLinux LinuxInotify2;
    meta = with stdenv.lib; {
      description = "Watch for changes to files, cross-platform style";
      license = licenses.artistic2;
    };
  };

  Filechdir = buildPerlPackage rec {
    name = "File-chdir-0.1008";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "0n8dz80fgk3shfxncyr4aff5hnsd846c5np6d68kc0mxqj2g0flr";
    };
  };

  FileBaseDir = buildPerlPackage rec {
    version = "0.03";
    name = "File-BaseDir-${version}";
    configurePhase = ''
      preConfigure || true
      perl Build.PL PREFIX="$out" prefix="$out"
    '';
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "0029cba7a3b5d8aa5f7d03cb1b7ba2bcf2829382f7f26aa3bee06fce8611a886";
    };
  };

  FileCheckTree = buildPerlPackage {
    name = "File-CheckTree-4.42";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/File-CheckTree-4.42.tar.gz;
      sha256 = "66fb417f8ff8a5e5b7ea25606156e70e204861c59fa8c3831925b4dd3f155f8a";
    };
    propagatedBuildInputs = [ if_ ];
    meta = {
      homepage = http://search.cpan.org/dist/File-CheckTree;
      description = "Run many filetest checks on a tree";
      license = "perl";
    };
  };

  FileCopyRecursive = buildPerlPackage rec {
    name = "File-Copy-Recursive-0.38";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DM/DMUEY/${name}.tar.gz";
      sha256 = "1syyyvylr51iicialdmv0dw06q49xzv8zrkb5cn8ma4l73gvvk44";
    };
  };

  FileDesktopEntry = buildPerlPackage rec {
    version = "0.04";
    name = "File-DesktopEntry-${version}";
    configurePhase = ''
      preConfigure || true
      perl Build.PL PREFIX="$out" prefix="$out"
    '';
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "d7f80d8bd303651a43dc1810c73740d38a0d2b158fb33cd3b6ca4d3a566da7cb";
    };
    propagatedBuildInputs = [ FileBaseDir ];
  };

  FileFindIterator = buildPerlPackage {
    name = "File-Find-Iterator-0.4";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TE/TEXMEC/File-Find-Iterator-0.4.tar.gz;
      sha256 = "a2b87ab9756a2e5bb674adbd39937663ed20c28c716bf5a1095a3ca44d54ab2c";
    };
    propagatedBuildInputs = [ ClassIterator ];
    meta = {
    };
  };

  FileFindRule = buildPerlPackage rec {
    name = "File-Find-Rule-0.33";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "0w73b4jr2fcrd74a1w3b2jryq3mqzc8z5mk7ia9p85xn3qmpa5r4";
    };
    propagatedBuildInputs = [ NumberCompare TextGlob ];
  };

  FileFindRulePerl = buildPerlPackage {
    name = "File-Find-Rule-Perl-1.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/File-Find-Rule-Perl-1.13.tar.gz;
      sha256 = "d2ecb270778ddf54c536a78d02fe6ee7a675f7dcb7f3497ba1a76493f1bd2476";
    };
    propagatedBuildInputs = [ FileFindRule ParamsUtil ];
    meta = {
      description = "Common rules for searching for Perl things";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileHomeDir = buildPerlPackage {
    name = "File-HomeDir-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/File-HomeDir-1.00.tar.gz;
      sha256 = "85b94f3513093ec0a25b91f9f2571918519ae6f2b7a1e8546f8f78d09a877143";
    };
    propagatedBuildInputs = [ FileWhich ];
    meta = {
      description = "Find your home and other directories on any platform";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    preCheck = "export HOME=$TMPDIR";
    doCheck = !stdenv.isDarwin;
  };

  FileKeePass = buildPerlPackage rec {
    name = "File-KeePass-2.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RH/RHANDOM/${name}.tar.gz";
      sha256 = "c30c688027a52ff4f58cd69d6d8ef35472a7cf106d4ce94eb73a796ba7c7ffa7";
    };
    propagatedBuildInputs = [ CryptRijndael ];
  };

  FileListing = buildPerlPackage rec {
    name = "File-Listing-6.04";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "1xcwjlnxaiwwpn41a5yi6nz95ywh3szq5chdxiwj36kqsvy5000y";
    };
    propagatedBuildInputs = [ HTTPDate ];
  };

  FileMimeInfo = buildPerlPackage rec {
    name = "File-MimeInfo-0.23";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/File/${name}.tar.gz";
      sha256 = "006i9idnxv9hsz1gykc5bqs05ma5wz9dsjrpmah9293bgdy1ccxj";
    };
    doCheck = false; # Failed test 'desktop file is the right one'
    propagatedBuildInputs = [ FileBaseDir FileDesktopEntry ];
  };

  FileModified = buildPerlPackage {
    name = "File-Modified-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/File-Modified-0.07.tar.gz;
      sha256 = "11zkg171fa5vdbyrbfcay134hhgyf4yaincjxwspwznrfmkpi49h";
    };
  };

  FileNext = buildPerlPackage rec {
    name = "File-Next-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "cc3afd8eaf6294aba93b8152a269cc36a9df707c6dc2c149aaa04dabd869e60a";
    };
  };

  FileNFSLock = buildPerlPackage {
    name = "File-NFSLock-1.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BB/BBB/File-NFSLock-1.21.tar.gz;
      sha256 = "1kclhmyha2xijq49darlz82f3bn7gq3saycxpfiz3dndqhr5i9iz";
    };
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FilePath = buildPerlPackage {
    name = "File-Path-2.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RI/RICHE/File-Path-2.11.tar.gz;
      sha256 = "d94492c072d08bdbbd40fd75a1010ff279e99333b63b4308b1f818fe6309dd0f";
    };
    meta = {
      description = "Create or remove directory trees";
      license = "perl";
    };
  };

  Filepushd = buildPerlPackage {
    name = "File-pushd-1.005";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/File-pushd-1.005.tar.gz;
      sha256 = "50fdcc33e69a50bab1e32d1a7c96753938f6d95a06015e34e662958c58687842";
    };
    meta = {
      homepage = https://metacpan.org/release/File-pushd;
      description = "Change directory temporarily for a limited scope";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FileRemove = buildPerlPackage rec {
    name = "File-Remove-1.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "1p8bal9qhwkjbghivxn1d5m3qdj2qwm1agrjbmakm6la9dbxqm21";
    };
  };

  FileShare = buildPerlPackage {
    name = "File-Share-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JO/JOENIO/File-Share-0.03.tar.gz;
      sha256 = "0siy9p6b7zbln5yq6g8z1nwm76ia23kkdj1k5pywsh3n6dn2lxa2";
    };
    propagatedBuildInputs = [ FileShareDir ];
    meta = {
      homepage = http://github.com/ingydotnet/file-share-pm/tree;
      description = "Extend File::ShareDir to Local Libraries";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FileShareDir = buildPerlPackage {
    name = "File-ShareDir-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/File-ShareDir-1.03.tar.gz;
      sha256 = "0fczaqjxyzmzgrmn3ib84cj6pd2085wsvni3wf5b018i21j2wi2r";
    };
    propagatedBuildInputs = [ ClassInspector ];
    meta = {
      description = "Locate per-dist and per-module shared files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileShareDirInstall = buildPerlPackage {
    name = "File-ShareDir-Install-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GW/GWYN/File-ShareDir-Install-0.08.tar.gz;
      sha256 = "188pgn43wa6hgpcrv997lp3bad50030p4wmrcdzvfrqxj0bx2amf";
    };
    meta = {
      description = "Install shared files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  FilesysNotifySimple = buildPerlPackage {
    name = "Filesys-Notify-Simple-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Filesys-Notify-Simple-0.08.tar.gz;
      sha256 = "042klyvi8fbkhmyg1h7883bbjdhiclmky9w2wfga7piq5il6nxgi";
    };
    meta = {
      description = "Simple and dumb file system watcher";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FileTemp = null;

  FileSlurp = buildPerlPackage {
    name = "File-Slurp-9999.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/U/UR/URI/File-Slurp-9999.19.tar.gz;
      sha256 = "0hrn4nipwx40d6ji8ssgr5nw986z9iqq8cn0kdpbszh9jplynaff";
    };
    meta = {
      description = "Simple and Efficient Reading/Writing/Modifying of Complete Files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  FileWhich = buildPerlPackage rec {
    name = "File-Which-1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "b72fec6590160737cba97293c094962adf4f7d44d9e68dde7062ecec13f4b2c3";
    };
    propagatedBuildInputs = [ TestScript ];
  };

  Filter = buildPerlPackage {
    name = "Filter-1.55";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/Filter-1.55.tar.gz;
      sha256 = "7855f5f5f16777c14614b5d907794a170ed4cdeb4382bf03ffca825c8c6bc4a0";
    };
    meta = {
      description = "Source Filters";
      license = "perl";
    };
  };

  FilterSimple = buildPerlPackage {
    name = "Filter-Simple-0.91";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/Filter-Simple-0.91.tar.gz;
      sha256 = "c75a4945e94ecfe97e1409f49df036700d2e072e288497e205c4d319a80f694d";
    };
    meta = {
      description = "Simplified source filtering";
      license = "perl";
    };
  };

  FinanceQuote = buildPerlPackage rec {
    name = "Finance-Quote-1.37";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/EC/ECOCODE/${name}.tar.gz";
      sha256 = "1b6pbh7f76fb5sa4f0lhx085xy55pprz5v7z7li7pqiyw7i4f4bf";
    };
    propagatedBuildInputs = [ CryptSSLeay HTMLTableExtract HTMLTree HTTPMessage LWP DateCalc DateTime JSON ];
    meta = with stdenv.lib; {
      homepage = http://finance-quote.sourceforge.net/;
      description = "Get stock and mutual fund quotes from various exchanges";
      license = licenses.gpl2;
    };
  };

  FontAFM = buildPerlPackage rec {
    name = "Font-AFM-1.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "32671166da32596a0f6baacd0c1233825a60acaf25805d79c81a3f18d6088bc1";
    };
  };

  FontTTF = buildPerlPackage rec {
    name = "Font-TTF-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MH/MHOSKEN/${name}.tar.gz";
      sha256 = "0l7vxag0v3hf7w1kjyjv02zqrjzhg6xczcv60z00l3z0fr78xi16";
    };
    propagatedBuildInputs = [ IOString ];
    meta = {
      description = "TTF font support for Perl";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  ForksSuper = buildPerlPackage {
    name = "Forks-Super-0.72";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MO/MOB/Forks-Super-0.72.tar.gz;
      sha256 = "0zyqwyndb3gnbsh43b6xyl3wmlnyi18vz3yrbsvp3lccz4d0v7qp";
    };
    doCheck = false;
    meta = {
      description = "Extensions and convenience methods to manage background processes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  FreezeThaw = buildPerlPackage {
    name = "FreezeThaw-0.5001";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILYAZ/modules/FreezeThaw-0.5001.tar.gz;
      sha256 = "0h8gakd6b9770n2xhld1hhqghdar3hrq2js4mgiwxy86j4r0hpiw";
    };
    doCheck = false;
  };

  GamesSolitaireVerify = buildPerlModule {
    name = "Games-Solitaire-Verify-0.1400";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/Games-Solitaire-Verify-0.1400.tar.gz;
      sha256 = "0c897c17f23ed6710d0e3ddfb54cce0f00f5b68c55277181adc94a03b7d8c659";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ ClassXSAccessor ExceptionClass ListMoreUtils MooXlate ];
    meta = {
      description = "Verify solutions for solitaire games";
      license = "mit";
    };
  };

  GD = buildPerlPackage rec {
    name = "GD-2.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LD/LDS/${name}.tar.gz";
      sha256 = "1ampz82kf0ixybncfgpvq2bp9nq5sjsmmw4c8srsv0g5jpz02pfh";
    };

    buildInputs = [ pkgs.gd pkgs.libjpeg pkgs.zlib pkgs.freetype
                    pkgs.libpng pkgs.fontconfig pkgs.xlibs.libXpm GetoptLong ];

    # Patch needed to get arguments past the first GetOptions call
    # and to specify libfontconfig search path.
    # Patch has been sent upstream.
    patches = [ ../development/perl-modules/gd-options-passthrough-and-fontconfig.patch ];

    # tests fail
    doCheck = false;

    makeMakerFlags = "--lib_png_path=${pkgs.libpng} --lib_jpeg_path=${pkgs.libjpeg} --lib_zlib_path=${pkgs.zlib} --lib_ft_path=${pkgs.freetype} --lib_fontconfig_path=${pkgs.fontconfig} --lib_xpm_path=${pkgs.xlibs.libXpm}";
  };

  GDSecurityImage = buildPerlPackage {
    name = "GD-SecurityImage-1.72";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BU/BURAK/GD-SecurityImage-1.72.tar.gz;
      sha256 = "07a025krdaml5ls7gyssfdcsif6cnsnksrxkqk48n9dmv7rz7q1r";
    };
    propagatedBuildInputs = [ GD ];
    meta = {
      description = "Security image (captcha) generator";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GeoIP = buildPerlPackage rec {
    name = "Geo-IP-1.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BORISZ/${name}.tar.gz";
      sha256 = "0p7mcn4rzvhrblx72f5a1yg88mqgv6f46mq0rvhhkmkpwckb0yjq";
    };
    makeMakerFlags = "LIBS=-L${pkgs.geoip}/lib INC=-I${pkgs.geoip}/include";
    doCheck = false; # seems to access the network
  };

  GetoptLong = buildPerlPackage rec {
    name = "Getopt-Long-2.42";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JV/JV/${name}.tar.gz";
      sha256 = "12c5pvmx0jxx0mls8qll9ixb1lbacs7p1rwvmciv0dvw3w25dmr7";
    };
  };

  GetoptLongDescriptive = buildPerlPackage {
    name = "Getopt-Long-Descriptive-0.093";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Getopt-Long-Descriptive-0.093.tar.gz;
      sha256 = "0iccps0jlcjm68i5yywgs477plfnkc6b2386bzb99blm3jwdfyac";
    };
    propagatedBuildInputs = [ ParamsValidate SubExporter SubExporterUtil ];
    meta = {
      homepage = https://github.com/rjbs/Getopt-Long-Descriptive;
      description = "Getopt::Long, but simpler and more powerful";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  GitPurePerl = buildPerlPackage {
    name = "Git-PurePerl-0.51";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BROQ/Git-PurePerl-0.51.tar.gz;
      sha256 = "3775f385ae566ea392ece0913a06ffec46441a1273c19ba9a6d990574ec34d00";
    };
    buildInputs = [ Testutf8 ];
    propagatedBuildInputs = [ ConfigGitLike DataStreamBulk DateTime FileFindRule IODigest Moose MooseXStrictConstructor MooseXTypesPathClass namespaceautoclean ];
    doCheck = false;
    meta = {
      description = "A Pure Perl interface to Git repositories";
      license = "perl";
    };
  };

  Glib = buildPerlPackage rec {
    name = "Glib-1.312";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "1aqww3ncaxiclfiqvl81hx7k3w4pri3k52rrar0hpzcasics5zr3";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig pkgs.glib ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net/;
      description = "Perl wrappers for the GLib utility and Object libraries";
      maintainers = with maintainers; [ nckx ];
      license = stdenv.lib.licenses.lgpl3Plus;
    };
  };

  GnuPG = buildPerlPackage {
    name = "GnuPG-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/Y/YA/YANICK/GnuPG-0.19.tar.gz;
      sha256 = "af53f2d3f63297e046676eae14a76296afdd2910e09723b6b113708622b7989b";
    };
    buildInputs = [ pkgs.gnupg1orig ];
    meta = {
      platforms = stdenv.lib.platforms.linux;
      maintainers = with maintainers; [ ocharles ];
    };
  };

  GoferTransporthttp = buildPerlPackage {
    name = "GoferTransport-http-1.017";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TI/TIMB/GoferTransport-http-1.017.tar.gz;
      sha256 = "f73effe3ea7afa1907ce8977c87387abb0d4404f85a724ae2637b29a73154a9b";
    };
    propagatedBuildInputs = [ mod_perl2 DBI HTTPMessage LWP URI ];
    doCheck = false; # no make target 'test'
    meta = {
      description = "HTTP transport for DBI stateless proxy driver DBD::Gofer";
    };
  };

  GoogleProtocolBuffers = buildPerlPackage rec {
    name = "Google-ProtocolBuffers-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAXJAZMAN/protobuf/${name}.tar.gz";
      sha256 = "0k2skcbfzn2aw1f218l47h4kgq5rj9qsam3sd6zw4qq3zyp0amb1";
    };
    propagatedBuildInputs = [ ClassAccessor ParseRecDescent ];
    patches =
      [ ../development/perl-modules/Google-ProtocolBuffers-multiline-comments.patch ];
    meta = {
      description = "Simple interface to Google Protocol Buffers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Graph = buildPerlPackage rec {
    name = "Graph-0.96";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JH/JHI/${name}.tar.gz";
      sha256 = "09wpiz7v0gv07zb7h8gwgjrwj16cdycs60d08cjlyj1s926zlbl3";
    };

    buildInputs = [ TestPod TestPodCoverage ];
  };

  GraphViz = buildPerlPackage rec {
    name = "GraphViz-2.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RS/RSAVAGE/${name}.tgz";
      sha256 = "0ngm90vd1ymrm2c9k4dbgzpbip501gklll32l9jsj8j00x845iz2";
    };

    # XXX: It'd be nicer it `GraphViz.pm' could record the path to graphviz.
    buildInputs = [ pkgs.graphviz ];
    propagatedBuildInputs = [ IPCRun TestMore ];

    meta = with stdenv.lib; {
      description = "Perl interface to the GraphViz graphing tool";
      license = licenses.artistic2;
      maintainers = [ ];
    };
  };

  GrowlGNTP = buildPerlModule rec {
    name = "Growl-GNTP-0.20";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Growl/${name}.tar.gz";
      sha256 = "150x65lwf7pfsygcpmvj3679lhlfwx87xylwnrmwll67f9dpkjdi";
    };
    buildInputs = [ DataUUID CryptCBC ];
  };

  Gtk2 = buildPerlPackage rec {
    name = "Gtk2-1.2495";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "1mpxkcy8j7r95z4g4xx6ggbgzaxj4zl0szz54y1k120z95rcgg3a";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig Pango pkgs.gtk2 ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net/;
      description = "Perl interface to the 2.x series of the Gimp Toolkit library";
      maintainers = with maintainers; [ nckx ];
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  Guard = buildPerlPackage {
    name = "Guard-1.022";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/ML/MLEHMANN/Guard-1.022.tar.gz;
      sha256 = "0saq9949d13mdvpnls7mw1cy74lm4ncl7agbs7n2jl4sy6bvmw9m";
    };
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HashFlatten = buildPerlPackage rec {
    name = "Hash-Flatten-1.19";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Hash/${name}.tar.gz";
      sha256 = "162b9qgkr19f97w4pic6igyk3zd0sbnrhl3s8530fikciffw9ikh";
    };
    buildInputs = [ TestAssertions LogTrace ];
  };

  HashMerge = buildPerlPackage rec {
    name = "Hash-Merge-0.200";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RE/REHSACK/${name}.tar.gz";
      sha256 = "0r1a2axz85wn6573zrl9rk8mkfl2cvf1gp9vwya5qndp60rz1ya7";
    };
    propagatedBuildInputs = [ Clone ];
    meta = {
      description = "Merges arbitrarily deep hashes into a single hash";
    };
  };

  HashMergeSimple = buildPerlPackage {
    name = "Hash-Merge-Simple-0.051";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROKR/Hash-Merge-Simple-0.051.tar.gz;
      sha256 = "1c56327873d2f04d5722777f044863d968910466997740d55a754071c6287b73";
    };
    buildInputs = [ TestMost ];
    propagatedBuildInputs = [ Clone ];
    meta = {
      description = "Recursively merge two or more hashes, simply";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashMultiValue = buildPerlPackage {
    name = "Hash-MultiValue-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Hash-MultiValue-0.15.tar.gz;
      sha256 = "1jc37kwpa1fl88va8bd1p95h0vjv1gsvmn7pc2pxj62ga6x0wpc0";
    };
    meta = {
      description = "Store multiple values per key";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HashUtilFieldHashCompat = buildPerlPackage {
    name = "Hash-Util-FieldHash-Compat-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Hash-Util-FieldHash-Compat-0.07.tar.gz;
      sha256 = "1fbqcjvp5slkfyf63g8scrbdpkpw3g9z9557xvfaxn09aki7g1bn";
    };
    propagatedBuildInputs = [ Testuseok ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HeapFibonacci = buildPerlPackage {
    name = "Heap-Fibonacci-0.80";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JM/JMM/Heap-0.80.tar.gz;
      sha256 = "1plv2djbyhvkdcw2ic54rdqb745cwksxckgzvw7ssxiir7rjknnc";
    };
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HookLexWrap = buildPerlPackage rec {
    name = "Hook-LexWrap-0.24";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/${name}.tar.gz";
      sha256 = "0nyfirbdrgs2cknifqr1pf8xd5q9xnv91gy7jha4crp1hjqvihj4";
    };
    buildInputs = [ pkgs.unzip ];
  };

  HTMLElementExtended = buildPerlPackage {
    name = "HTML-Element-Extended-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSISK/HTML-Element-Extended-1.18.tar.gz;
      sha256 = "f3ef1af108f27fef15ebec66479f251ce08aa49bd00b0462c9c80c86b4b6b32b";
    };
    propagatedBuildInputs = [ HTMLTree ];
  };

  HTMLFromANSI = buildPerlPackage {
    name = "HTML-FromANSI-2.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/HTML-FromANSI-2.03.tar.gz;
      sha256 = "21776345ed701b2c04c7b09380af943f9984cc7f99624087aea45db5fc09c359";
    };
    propagatedBuildInputs = [ HTMLParser TermVT102Boundless Testuseok ];
    meta = {
    };
  };

  HTMLForm = buildPerlPackage {
    name = "HTML-Form-6.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTML-Form-6.03.tar.gz;
      sha256 = "0dpwr7yz6hjc3bcqgcbdzjjk9l58ycdjmbam9nfcmm85y2a1vh38";
    };
    propagatedBuildInputs = [ HTMLParser HTTPMessage URI ];
    meta = {
      description = "Class that represents an HTML form element";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLFormFu = buildPerlPackage rec {
    name = "HTML-FormFu-0.09010";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTML/${name}.tar.gz";
      sha256 = "08hf6z35yhfd1521ip8x5hpwb7h09k643s9sqf6ddmi9yvqini1k";
    };
    buildInputs = [ CGISimple ];
    propagatedBuildInputs =
      [ ClassAccessorChained Clone ConfigAny
        DateCalc ListMoreUtils EmailValid
        DataVisitor DateTime DateTimeFormatBuilder
        DateTimeFormatStrptime DateTimeFormatNatural
        Readonly YAMLLibYAML NumberFormat HashFlatten
        HTMLTokeParserSimple RegexpCommon
        CaptchaReCAPTCHA HTMLScrubber FileShareDir
        TemplateToolkit CryptCBC CryptDES PathClass
        MooseXAttributeChained MooseXAliases MooseXSetOnce
      ];
  };

  HTMLFormHandler = buildPerlPackage {
    name = "HTML-FormHandler-0.40057";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GS/GSHANK/HTML-FormHandler-0.40057.tar.gz;
      sha256 = "1hn9shhbsi4pdp396ia2hky3i0imnxgwvhy57gp0jjhy5qyvafvm";
    };
    # a single test is failing on perl 5.20
    doCheck = false;
    buildInputs = [ FileShareDirInstall PadWalker TestDifferences TestException TestMemoryCycle ];
    propagatedBuildInputs = [ ClassLoad DataClone DateTime DateTimeFormatStrptime EmailValid FileShareDir HTMLTree JSON ListAllUtils Moose MooseXGetopt MooseXTypes MooseXTypesCommon MooseXTypesLoadableClass SubExporter SubName TryTiny aliased namespaceautoclean ];
    meta = {
      description = "HTML forms using Moose";
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLMason = buildPerlPackage {
    name = "HTML-Mason-1.56";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/HTML-Mason-1.56.tar.gz;
      sha256 = "84ac24fb1d551f998145435265e5b6fd4a52ec61e4fadd3d7755eb648be2c4b2";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ CacheCache ClassContainer ExceptionClass HTMLParser LogAny ParamsValidate ];
    meta = {
      homepage = http://metacpan.org/release/HTML-Mason;
      description = "High-performance, dynamic web site authoring system";
      license = "perl";
    };
  };

  HTMLParser = buildPerlPackage {
    name = "HTML-Parser-3.71";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTML-Parser-3.71.tar.gz;
      sha256 = "00nqzdgl7c3jilx7mil19k5jwcw3as14pvkjgxi97zyk94vqp4dy";
    };
    propagatedBuildInputs = [ HTMLTagset ];
    meta = {
      description = "HTML parser class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLSelectorXPath = buildPerlPackage {
    name = "HTML-Selector-XPath-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/HTML-Selector-XPath-0.16.tar.gz;
      sha256 = "0v12plal866ifcv7m8x22abrddd6cf12gn55qclk53qqa6c8f8m6";
    };
    buildInputs = [ TestBase ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HTMLScrubber = buildPerlPackage {
    name = "HTML-Scrubber-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PO/PODMASTER/HTML-Scrubber-0.08.tar.gz;
      sha256 = "0xb5zj67y2sjid9bs3yfm81rgi91fmn38wy1ryngssw6vd92ijh2";
    };
    propagatedBuildInputs = [HTMLParser];
  };

  HTMLTableExtract = buildPerlPackage {
    name = "HTML-TableExtract-2.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSISK/HTML-TableExtract-2.11.tar.gz;
      sha256 = "1861d55a2aa1728ef56ea2d08d630b9a008456f1106994e4e49e76f56e4955ee";
    };
    propagatedBuildInputs = [ HTMLElementExtended HTMLParser ];
  };

  HTMLTagset = buildPerlPackage rec {
    name = "HTML-Tagset-3.20";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTML/${name}.tar.gz";
      sha256 = "1qh8249wgr4v9vgghq77zh1d2zs176bir223a8gh3k9nksn7vcdd";
    };
  };

  HTMLTemplate = buildPerlPackage rec {
    name = "HTML-Template-2.95";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WO/WONKO/${name}.tar.gz";
      sha256 = "07ahpfgidxsw2yb7y8i7bbr8s64aq6qgq832h9jswmksxbd0l43q";
    };
  };

  HTMLTiny = buildPerlPackage rec {
    name = "HTML-Tiny-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "18zxg7z51f5daidnwl9vxsrs3lz0y6n5ddqhpb748bjyk3awkkfp";
    };
  };

  HTMLTokeParserSimple = buildPerlPackage rec {
    name = "HTML-TokeParser-Simple-3.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "17aa1v62sp8ycxcicwhankmj4brs6nnfclk9z7mf1rird1f164gd";
    };
    propagatedBuildInputs = [HTMLParser SubOverride];
    buildInputs = [TestPod];
  };

  HTMLTree = buildPerlModule {
    name = "HTML-Tree-5.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CJ/CJM/HTML-Tree-5.03.tar.gz;
      sha256 = "13qlqbpixw470gnck0xgny8hyjj576m8y24bba2p9ai2lvy76vbx";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ HTMLParser HTMLTagset ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Work with HTML in a DOM-like tree structure";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTMLTreeBuilderXPath = buildPerlPackage {
    name = "HTML-TreeBuilder-XPath-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIROD/HTML-TreeBuilder-XPath-0.14.tar.gz;
      sha256 = "1wx4i1scng20n405fp3a4vrwvvq9bvbmg977wnd5j2ja8jrbvsr5";
    };
    propagatedBuildInputs = [ HTMLTree XMLXPathEngine ];
    meta = {
      description = "Add XPath support to HTML::TreeBuilder";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  HTMLWidget = buildPerlPackage {
    name = "HTML-Widget-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CF/CFRANKS/HTML-Widget-1.11.tar.gz;
      sha256 = "02w21rd30cza094m5xs9clzw8ayigbhg2ddzl6jycp4jam0dyhmy";
    };
    doCheck = false;
    propagatedBuildInputs = [
      TestNoWarnings ClassAccessor ClassAccessorChained
      ClassDataAccessor ModulePluggableFast HTMLTree
      HTMLScrubber EmailValid DateCalc
    ];
  };

  HTTPBody = buildPerlPackage {
    name = "HTTP-Body-1.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GE/GETTY/HTTP-Body-1.19.tar.gz;
      sha256 = "0ahhksj0zg6wq6glpjkxdr3byd5riwvq2f5aw21n1jcsl71nll01";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "HTTP Body Parser";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPCookies = buildPerlPackage {
    name = "HTTP-Cookies-6.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Cookies-6.01.tar.gz;
      sha256 = "087bqmg22dg3vj7gssh3pcsh9y1scimkbl5h1kc8jqyfhgisvlzm";
    };
    propagatedBuildInputs = [ HTTPDate HTTPMessage ];
    meta = {
      description = "HTTP cookie jars";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPDaemon = buildPerlPackage {
    name = "HTTP-Daemon-6.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Daemon-6.01.tar.gz;
      sha256 = "1hmd2isrkilf0q0nkxms1q64kikjmcw9imbvrjgky6kh89vqdza3";
    };
    propagatedBuildInputs = [ HTTPDate HTTPMessage LWPMediaTypes ];
    meta = {
      description = "A simple http server class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPDate = buildPerlPackage {
    name = "HTTP-Date-6.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Date-6.02.tar.gz;
      sha256 = "0cz357kafhhzw7w59iyi0wvhw7rlh5g1lh38230ckw7rl0fr9fg8";
    };
    meta = {
      description = "Date conversion routines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPHeaderParserXS = buildPerlPackage rec {
    name = "HTTP-HeaderParser-XS-0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MARKSMITH/${name}.tar.gz";
      sha256 = "1vs6sw431nnlnbdy6jii9vqlz30ndlfwdpdgm8a1m6fqngzhzq59";
    };
  };

  HTTPLite = buildPerlPackage rec {
    name = "HTTP-Lite-2.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NE/NEILB/${name}.tar.gz";
      sha256 = "10svyy8r5ca86spz21r0k2mdy8g2slzssin4qbg101zc9kr5r65a";
    };
  };

  HTTPMessage = buildPerlPackage {
    name = "HTTP-Message-6.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Message-6.06.tar.gz;
      sha256 = "0qxdrcak97azjvqyx1anpb2ky6vp6vc37x0wcfjdqfajkh09fzh8";
    };
    propagatedBuildInputs = [ EncodeLocale HTTPDate IOHTML LWPMediaTypes URI ];
    meta = {
      description = "HTTP style messages";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPNegotiate = buildPerlPackage {
    name = "HTTP-Negotiate-6.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz;
      sha256 = "05p053vjs5g91v5cmjnny7a3xzddz5k7vnjw81wfh01ilqg9qwhw";
    };
    propagatedBuildInputs = [ HTTPMessage ];
    meta = {
      description = "Choose a variant to serve";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPParserXS = buildPerlPackage rec {
    name = "HTTP-Parser-XS-0.16";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KA/KAZUHO/${name}.tar.gz";
      sha256 = "1sp9vllf012paslmn11b7z7fbk3hhkcp7gj59yp6qzh11xzpxlai";
    };
    buildInputs = [ TestMore ];
  };

  HTTPRequestAsCGI = buildPerlPackage rec {
    name = "HTTP-Request-AsCGI-1.2";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/HTTP/${name}.tar.gz";
      sha256 = "1smwmiarwcgq7vjdblnb6ldi2x1s5sk5p15p7xvm5byiqq3znnwl";
    };
    propagatedBuildInputs = [ ClassAccessor LWP ];
  };

  HTTPResponseEncoding = buildPerlPackage {
    name = "HTTP-Response-Encoding-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DANKOGAI/HTTP-Response-Encoding-0.06.tar.gz;
      sha256 = "1am8lis8107s5npca1xgazdy5sknknzcqyhdmc220s4a4f77n5hh";
    };
    propagatedBuildInputs = [ LWPUserAgent HTTPMessage ];
    meta = {
      description = "Adds encoding() to HTTP::Response";
    };
  };

  HTTPServerSimple = buildPerlPackage {
    name = "HTTP-Server-Simple-0.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/HTTP-Server-Simple-0.44.tar.gz;
      sha256 = "05klpfkss2a6i5ihmvcm27fyar0f2v4ispg2f49agab3va1gix6g";
    };
    doCheck = false;
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  HTTPServerSimpleMason = buildPerlPackage {
    name = "HTTP-Server-Simple-Mason-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/HTTP-Server-Simple-Mason-0.14.tar.gz;
      sha256 = "b7a49d8e6e55bff0b1f0278d951685466b143243b6f9e59e071f5472ca2a025a";
    };
    propagatedBuildInputs = [ HTMLMason HTTPServerSimple HookLexWrap ];
    meta = {
      description = "A simple mason server";
      license = "perl";
    };
  };

  I18NCollate = buildPerlPackage {
    name = "I18N-Collate-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/I18N-Collate-1.02.tar.gz;
      sha256 = "9174506bc903eda89690394e3f45558ab7e013114227896d8569d6164648fe37";
    };
    meta = {
      homepage = http://search.cpan.org/dist/I18N-Collate;
      description = "Compare 8-bit scalar data according to the current locale";
      license = "perl";
    };
  };

  I18NLangTags = buildPerlPackage {
    name = "I18N-LangTags-0.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBURKE/I18N-LangTags-0.35.tar.gz;
      sha256 = "0idwfi7k8l44d9akpdj6ygdz3q8zxr690m18s7w23ms9d55bh3jy";
    };
  };

  if_ = buildPerlPackage {
    name = "if-0.0601";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILYAZ/modules/if-0.0601.tar.gz;
      sha256 = "fb2b7329aa111a673cd22dc2889167e52058aead0de2fe0855b32dd658d5c1b7";
    };
  };

  ImageSize = buildPerlPackage rec {
    name = "Image-Size-3.232";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJRAY/${name}.tar.gz";
      sha256 = "1mx065134gy75pgdldh65118bpcs6yfbqmr7bf9clwq44zslxhxc";
    };
    buildInputs = [ TestMore ];
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Read the dimensions of an image in several popular formats";
      license = with stdenv.lib.licenses; [ artistic1 lgpl21Plus ];
    };
  };

  IMAPClient = buildPerlPackage {
    name = "IMAP-Client-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CONTEB/IMAP-Client-0.13.tar.gz;
      sha256 = "15fa4hpw2rqg2iadyz10rnv99hns78wph5qlh3257a3mbfjjyyla";
    };
    propagatedBuildInputs = [IOSocketSSL URIIMAP];
    doCheck = false; # nondeterministic
  };

  ImportInto = buildPerlPackage {
    name = "Import-Into-1.002004";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Import-Into-1.002004.tar.gz;
      sha256 = "110hifk3cj14lxgjq2vaa2qfja21gll4lpn8vbimy0gzqadjbjyy";
    };
    propagatedBuildInputs = [ ModuleRuntime ];
    meta = {
      description = "Import packages into other packages";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IO = buildPerlPackage {
    name = "IO-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/IO-1.25.tar.gz;
      sha256 = "89790db8b9281235dc995c1a85d532042ff68a90e1504abd39d463f05623e7b5";
    };
    doCheck = false;
    meta = {
      description = "Perl core IO modules";
      license = "perl";
    };
  };

  IOAll = buildPerlPackage {
    name = "IO-All-0.60";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/IO-All-0.60.tar.gz;
      sha256 = "1bwsd2f5rlivcqyd7rb0ap5vrzv8s8fappi3b1v553yr5vl5pyq9";
    };
    propagatedBuildInputs = [ IOString ];
    meta = {
      homepage = https://github.com/ingydotnet/io-all-pm/tree;
      description = "IO::All of it to Graham and Damian!";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  IOCaptureOutput = buildPerlPackage rec {
    name = "IO-CaptureOutput-1.1103";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "1bcl7p87ysbzab6hssq19xn3djzc0yk9l4hk0a2mqbqb8hv6p0m5";
    };
  };

  IOCompress = buildPerlPackage {
    name = "IO-Compress-2.063";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PM/PMQS/IO-Compress-2.063.tar.gz;
      sha256 = "1198jqsfyshc8pc74dvn04gmqa0x6nwngkbf731zgd4chrjlylhd";
    };
    propagatedBuildInputs = [ CompressRawBzip2 CompressRawZlib ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "IO Interface to compressed data files/buffers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
    doCheck = !stdenv.isDarwin;
  };

  IODigest = buildPerlPackage {
    name = "IO-Digest-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/IO-Digest-0.11.tar.gz;
      sha256 = "14kz7z4xw179aya3116wxac29l4y2wmwrba087lya4v2gxdgiz4g";
    };
    propagatedBuildInputs = [PerlIOviadynamic];
  };

  IOHTML = buildPerlPackage {
    name = "IO-HTML-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CJ/CJM/IO-HTML-0.04.tar.gz;
      sha256 = "0c4hc76c1gypdwfasnibr2qlf9x3bnhyw357lhqlrczbm6vn8hw5";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Open an HTML file with automatic charset detection";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOInteractive = buildPerlPackage {
    name = "IO-Interactive-0.0.6";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/IO-Interactive-0.0.6.tar.gz;
      sha256 = "9cc016cbd94b500027e137cb5070d19487e4431bf822f0cb534c38b6b2c1038c";
    };
    meta = {
      description = "Utilities for interactive I/O";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOLockedFile = buildPerlPackage rec {
    name = "IO-LockedFile-0.23";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/IO/${name}.tar.gz";
      sha256 = "1dgq8zfkaszisdb5hz8jgcl0xc3qpv7bbv562l31xgpiddm7xnxi";
    };
  };

  IOPager = buildPerlPackage {
    name = "IO-Pager-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JP/JPIERCE/IO-Pager-0.06.tgz;
      sha256 = "0r3af4gyjpy0f7bhs7hy5s7900w0yhbckb2dl3a1x5wpv7hcbkjb";
    };
  };

  IOPrompt = buildPerlPackage {
    name = "IO-Prompt-0.997002";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DC/DCONWAY/IO-Prompt-0.997002.tar.gz;
      sha256 = "08ad24f58335ce9696666e4411b2f3cd9c2e1fb72b306b6018c1a13971361ced";
    };
    propagatedBuildInputs = [ TermReadKey Want ];
    doCheck = false; # needs access to /dev/tty
    meta = {
      description = "Interactively prompt for user input";
    };
  };

  IOSocketInet6 = buildPerlPackage rec {
    name = "IO-Socket-INET6-2.72";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "1fqypz6qa5rw2d5y2zq7f49frwra0aln13nhq5gi514j2zx21q45";
    };
    propagatedBuildInputs = [Socket6];
    doCheck = false;
  };

  IOSocketSSL = buildPerlPackage {
    name = "IO-Socket-SSL-2.016";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SU/SULLR/IO-Socket-SSL-2.016.tar.gz;
      sha256 = "0hgyggdbw16nm85fds48m79lxy5318panqhpkh7r192jq6rnhqlk";
    };
    propagatedBuildInputs = [ URI NetSSLeay ];
    meta = {
      homepage = https://github.com/noxxi/p5-io-socket-ssl;
      description = "Nearly transparent SSL encapsulation for IO::Socket::INET";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
    doCheck = false; # tries to connect to facebook.com etc.
  };

  IOString = buildPerlPackage rec {
    name = "IO-String-1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0";
    };
  };

  IOstringy = pkgs.perlPackages.IOStringy;

  IOStringy = buildPerlPackage rec {
    name = "IO-stringy-2.110";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DS/DSKOLL/${name}.tar.gz";
      sha256 = "1vh4n0k22hx20rwvf6h7lp25wb7spg0089shrf92d2lkncwg8g3y";
    };
  };

  IOTieCombine = buildPerlPackage {
    name = "IO-TieCombine-1.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/IO-TieCombine-1.004.tar.gz;
      sha256 = "0awyyjdbjjawdkzs08rfjhfkkm7pni523x3ddmq9ixa82ibnn430";
    };
    meta = {
      homepage = https://github.com/rjbs/io-tiecombine;
      description = "Produce tied (and other) separate but combined variables";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  IOTty = buildPerlPackage rec {
    name = "IO-Tty-1.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TODDR/${name}.tar.gz";
      sha256 = "0399anjy3bc0w8xzsc3qx5vcyqryc9gc52lc7wh7i49hsdq8gvx2";
    };
  };

  IPCRun = buildPerlPackage {
    name = "IPC-Run-0.92";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/IPC-Run-0.92.tar.gz;
      sha256 = "1lj6kmr8rs6na77b3v673vvw6qsr511bmhgf257x4xqmvxnv91p1";
    };
    doCheck = false; /* attempts a network connection to localhost */
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "System() and background procs w/ piping, redirs, ptys (Unix, Win32)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    };
  };

  IPCRun3 = buildPerlPackage rec {
    name = "IPC-Run3-0.048";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0r9m8q78bg7yycpixd7738jm40yz71p2q7inm766kzsw3g6c709x";
    };
  };

  IPCShareLite = buildPerlPackage rec {
    name = "IPC-ShareLite-0.17";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/IPC/${name}.tar.gz";
      sha256 = "1gz7dbwxrzbzdsjv11kb49jlf9q6lci2va6is0hnavd93nwhdm0l";
    };
  };

  IPCSystemSimple = buildPerlPackage {
    name = "IPC-System-Simple-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PJ/PJF/IPC-System-Simple-1.25.tar.gz;
      sha256 = "f1b6aa1dfab886e8e4ea825f46a1cbb26038ef3e727fef5d84444aa8035a4d3b";
    };
    meta = {
      description = "Run commands simply, with detailed diagnostics";
      license = "perl";
    };
  };

  IPCSysV = buildPerlPackage {
    name = "IPC-SysV-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MH/MHX/IPC-SysV-2.04.tar.gz;
      sha256 = "93248930e667034899bf2b09b9a23348e2b800a5437fbb9b4f34c37316da3fcc";
    };
    meta = {
      description = "System V IPC constants and system calls";
      license = "perl";
    };
  };

  ImageExifTool = buildPerlPackage rec {
    name = "Image-ExifTool-9.27";

    src = fetchurl {
      url = "http://www.sno.phy.queensu.ca/~phil/exiftool/${name}.tar.gz";
      sha256 = "1f37pi7a6fcphp0kkhj7yr9b5c95m2wvy5jcwjq1xdiq74gdi16c";
    };

    meta = with stdenv.lib; {
      description = "ExifTool, a tool to read, write and edit EXIF meta information";
      homepage = http://www.sno.phy.queensu.ca/~phil/exiftool/;

      longDescription = ''
        ExifTool is a platform-independent Perl library plus a command-line
        application for reading, writing and editing meta information in
        image, audio and video files.  ExifTool supports many different types
        of metadata including EXIF, GPS, IPTC, XMP, JFIF, GeoTIFF, ICC
        Profile, Photoshop IRB, FlashPix, AFCP and ID3, as well as the maker
        notes of many digital cameras by Canon, Casio, FujiFilm, HP,
        JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta, Nikon,
        Olympus/Epson, Panasonic/Leica, Pentax/Asahi, Ricoh, Sanyo,
        Sigma/Foveon and Sony.
      '';

      license = with licenses; [ gpl1Plus /* or */ artistic2 ];

      maintainers = [ ];
      platforms = platforms.unix;
    };
  };

  Inline = buildPerlPackage rec {
    name = "Inline-0.64";

    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETJ/${name}.tar.gz";
      sha256 = "17n3gbc9jigpfwqfhgmxpvbgr9rkdrij8jayxqpzw611ixcxrplw";
    };

    buildInputs = [ TestWarn ];
    propagatedBuildInputs = [ ParseRecDescent ];

    meta = {
      description = "Inline -- Write Perl subroutines in other programming languages";

      longDescription = ''
        The Inline module allows you to put source code from other
        programming languages directly "inline" in a Perl script or
        module. The code is automatically compiled as needed, and then loaded
        for immediate access from Perl.
      '';

      license = stdenv.lib.licenses.artistic2;

      maintainers = [ ];
    };
  };

  InlineC = buildPerlPackage rec {
    name = "Inline-C-0.62";

    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETJ/${name}.tar.gz";
      sha256 = "0clggdpj5mmi35vm2991f9jsgv2a3s8r4f1bd88xxk8akv5b8i3r";
    };

    postPatch = ''
      # this test will fail with chroot builds
      rm -f t/08taint.t
    '';

    buildInputs = [ TestWarn FileCopyRecursive ];
    propagatedBuildInputs = [ Inline ];

    meta = {
      description = "Write Perl Subroutines in C";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  InlineJava = buildPerlPackage rec {
    name = "Inline-Java-0.52";

    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PA/PATL/${name}.tar.gz";
      sha256 = "0xdx1nnjvsih2njcncmwxwdi3w2zf74vqb9wpn1va8ii93mlakff";
    };

    propagatedBuildInputs = [ Inline ];

    makeMakerFlags = "J2SDK=${pkgs.jdk}";

    # FIXME: Apparently tests want to access the network.
    doCheck = false;

    meta = {
      description = "Inline::Java -- Write Perl classes in Java";

      longDescription = ''
        The Inline::Java module allows you to put Java source code directly
        "inline" in a Perl script or module.  A Java compiler is launched and
        the Java code is compiled.  Then Perl asks the Java classes what
        public methods have been defined.  These classes and methods are
        available to the Perl program as if they had been written in Perl.
      '';

      license = stdenv.lib.licenses.artistic2;

      maintainers = [ ];
    };
  };

  IPCSignal = buildPerlPackage rec {
    name = "IPC-Signal-1.00";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/${name}.tar.gz";
      sha256 = "1l3g0zrcwf2whwjhbpwdcridb7c77mydwxvfykqg1h6hqb4gj8bw";
    };
  };

  JSON = buildPerlPackage {
    name = "JSON-2.90";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz;
      sha256 = "127yppvr17qik9pkd1vy901hs4l13kg6rhp76jdgcyask35v7nsd";
    };
    buildInputs = [ TestPod ];
    meta = {
      description = "JSON (JavaScript Object Notation) encoder/decoder";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONAny = buildPerlPackage {
    name = "JSON-Any-1.29";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PERIGRIN/JSON-Any-1.29.tar.gz;
      sha256 = "15v2j9dh58r7r4s7rnnmgnzzbyz61bhyxwpx1z7r811ixs9bkks2";
    };
    propagatedBuildInputs = [ JSON ];
    meta = {
      description = "Wrapper Class for the various JSON classes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONMaybeXS = buildPerlPackage {
    name = "JSON-MaybeXS-1.002005";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/JSON-MaybeXS-1.002005.tar.gz;
      sha256 = "f576caf2b10bf3a8eedaf05c0d65e7d3deb52f9c5e1894579ff9ffe71207157f";
    };
    buildInputs = [ TestWithoutModule ];
    propagatedBuildInputs = [ JSONPP ];
    meta = {
      description = "Use L<Cpanel::JSON::XS> with a fallback to L<JSON::XS> and L<JSON::PP>";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONPP = buildPerlPackage rec {
    name = "JSON-PP-2.27203";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-PP-2.27203.tar.gz;
      sha256 = "0ljwya1fb4969pckcq2j1g6axgx8qh9yscxbs6qf62qxf8wkj1mp";
    };
    meta = {
      description = "JSON::XS compatible pure-Perl module";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONPPCompat5006 = buildPerlPackage {
    name = "JSON-PP-Compat5006-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAKAMAKA/JSON-PP-Compat5006-1.09.tar.gz;
      sha256 = "197030df52635f9bbe25af10742eea5bd74971473118c11311fcabcb62e3716a";
    };
    meta = {
      description = "Helper module in using JSON::PP in Perl 5.6";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  JSONXS = buildPerlPackage {
    name = "JSON-XS-2.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/ML/MLEHMANN/JSON-XS-2.34.tar.gz;
      sha256 = "1sh0i73skxp3rvd9w8phxqncw9m1r5ibnb9qxxm21bmrfwkxybx6";
    };
    propagatedBuildInputs = [ CommonSense ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    };
  };

  lib = buildPerlPackage {
    name = "lib-0.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/lib-0.63.tar.gz;
      sha256 = "72f63db9220098e834d7a38231626bd0c9b802c1ec54a628e2df35f3818e5a00";
    };
    meta = {
      description = "Manipulate @INC at compile time";
      license = "perl";
    };
  };

  libapreq2 = buildPerlPackage {
    name = "libapreq2-2.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IS/ISAAC/libapreq2-2.13.tar.gz;
      sha256 = "5731e6833b32d88e4a5c690e45ddf20fcf969ce3da666c5627d775e92da0cf6e";
    };
    buildInputs = [ ApacheTest ExtUtilsXSBuilder mod_perl2 pkgs.apacheHttpd pkgs.apr pkgs.aprutil ];
    propagatedBuildInputs = [ mod_perl2 ];
    makeMakerFlags = "--with-apache2-src=${pkgs.apacheHttpd} --with-apache2-apxs=${pkgs.apacheHttpd}/bin/apxs --with-apache2-httpd=${pkgs.apacheHttpd}/bin/httpd --with-apr-config=${pkgs.apr}/bin/apr-1-config --with-apu-config=${pkgs.aprutil}/bin/apu-1-config";
    preConfigure = ''
      # override broken prereq check
      substituteInPlace configure --replace "prereq_check=\"\$PERL \$PERL_OPTS build/version_check.pl\"" "prereq_check=\"echo\""
      '';
    preBuild = ''
      substituteInPlace apreq2-config --replace "dirname" "${pkgs.coreutils}/bin/dirname"
      '';
    installPhase = ''
      mkdir $out
      make install DESTDIR=$out
      cp -r $out/${pkgs.apacheHttpd}/. $out/.
      cp -r $out/$out/. $out/.
      rm -r $out/nix
      '';
    doCheck = false; # test would need to start apache httpd
    meta = {
      license = "open_source";
    };
  };

  libintlperl = pkgs.perlPackages.libintl_perl;

  libintl_perl = buildPerlPackage rec {
    name = "libintl-perl-1.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GU/GUIDO/libintl-perl-1.23.tar.gz;
      sha256 = "1ylz6yhjifblhmnva0k05ch12a4cdii5v0icah69ma1gdhsidnk0";
    };
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  libnet = buildPerlPackage {
    name = "libnet-3.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/libnet-3.07.tar.gz;
      sha256 = "d9a23d8907e681e788a6f1a71915b1d37d057091e88049e5a4064c99ca2c9cd7";
    };
    meta = {
      description = "Collection of network protocol modules";
      license = "perl";
    };
  };

  libxml_perl = buildPerlPackage rec {
    name = "libxml-perl-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KM/KMACLEOD/${name}.tar.gz";
      sha256 = "1jy9af0ljyzj7wakqli0437zb2vrbplqj4xhab7bfj2xgfdhawa5";
    };
    propagatedBuildInputs = [XMLParser];
  };

  LinguaENFindNumber = buildPerlPackage {
    name = "Lingua-EN-FindNumber-1.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Lingua-EN-FindNumber-1.31.tar.gz;
      sha256 = "f67f4d4983bd29da5cbbff3cb18dd70788692b35e2dabcd4c65bef1cd2bf658f";
    };
    propagatedBuildInputs = [ LinguaENWords2Nums ];
    meta = {
      homepage = https://github.com/neilbowers/Lingua-EN-FindNumber;
      description = "Locate (written) numbers in English text";
      license = "perl";
    };
  };

  LinguaENInflect = buildPerlPackage {
    name = "Lingua-EN-Inflect-1.895";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DC/DCONWAY/Lingua-EN-Inflect-1.895.tar.gz;
      sha256 = "0drzg9a2dkjxgf00n6jg0jzhd8972bh3j4wdnmdxpqi3zmfqhwcy";
    };
    meta = {
      description = "Convert singular to plural";
    };
  };

  LinguaENInflectNumber = buildPerlPackage rec {
    name = "Lingua-EN-Inflect-Number-1.1";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Lingua/${name}.tar.gz";
      sha256 = "13hlr1srp9cd9mcc78snkng9il8iavvylfyh81iadvn2y7wikwfy";
    };
    propagatedBuildInputs = [ LinguaENInflect ];
  };

  LinguaENInflectPhrase = buildPerlPackage {
    name = "Lingua-EN-Inflect-Phrase-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RK/RKITOVER/Lingua-EN-Inflect-Phrase-0.18.tar.gz;
      sha256 = "290a5b8fc2be28d6d479517655027a90e944476cb3552f10cbf6db37af79f9a6";
    };
    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ LinguaENFindNumber LinguaENInflect LinguaENInflectNumber LinguaENNumberIsOrdinal LinguaENTagger ];
    meta = {
      homepage = http://metacpan.org/release/Lingua-EN-Inflect-Phrase;
      description = "Inflect short English Phrases";
      license = "perl";
    };
  };

  LinguaENNumberIsOrdinal = buildPerlPackage {
    name = "Lingua-EN-Number-IsOrdinal-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RK/RKITOVER/Lingua-EN-Number-IsOrdinal-0.05.tar.gz;
      sha256 = "28d5695400c0f4e2bd209793cb74f6da2b9257356aacb2947c603425e09618d6";
    };
    buildInputs = [ TestFatal TryTiny ];
    propagatedBuildInputs = [ LinguaENFindNumber ];
    meta = {
      homepage = http://metacpan.org/release/Lingua-EN-Number-IsOrdinal;
      description = "Detect if English number is ordinal or cardinal";
      license = "perl";
    };
  };

  LinguaENTagger = buildPerlPackage {
    name = "Lingua-EN-Tagger-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AC/ACOBURN/Lingua-EN-Tagger-0.24.tar.gz;
      sha256 = "0qksqh1zi8fz76a29s2ll4g6yr8y6agmzgq7ngccvgj3gza5q241";
    };
    propagatedBuildInputs = [ HTMLParser HTMLTagset LinguaStem /* MemoizeExpireLRU */ ];
    meta = {
      description = "Part-of-speech tagger for English natural language processing";
      license = stdenv.lib.licenses.gpl3;
    };
  };

  LinguaENWords2Nums = buildPerlPackage {
    name = "Lingua-EN-Words2Nums-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JO/JOEY/Lingua-EN-Words2Nums-0.18.tar.gz;
      sha256 = "686556797cd2a4eaa066f19bbf03ab25c06278292c9ead2f187dfd9031ea1d85";
    };
    meta = {
      description = "Convert English text to numbers";
      license = "unknown";
    };
  };

  LinguaStem = buildPerlPackage rec {
    name = "Lingua-Stem-0.84";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Lingua/${name}.tar.gz";
      sha256 = "12avh2mnnc7llmmshrr5bgb473fvydxnlqrqbl2815mf2dp4pxcg";
    };
    doCheck = false;
  };

  LinuxInotify2 = buildPerlPackage rec {
    name = "Linux-Inotify2-1.22";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Linux/${name}.tar.gz";
      sha256 = "1l916p8xak6c51x4x1vrzd8wpi55bld74wf0p5w5m4vr80zjb7dw";
    };
    propagatedBuildInputs = [ CommonSense ];
  };

  ListAllUtils = buildPerlPackage {
    name = "List-AllUtils-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/List-AllUtils-0.09.tar.gz;
      sha256 = "4cfe6359cc6c9f4ba0d178e223f4b468d3cf7768d645334962f05de069bdaee2";
    };
    buildInputs = [ TestWarnings ];
    propagatedBuildInputs = [ ListMoreUtils ];
    meta = {
      description = "Combines List::Util and List::MoreUtils in one bite-sized package";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ListBinarySearch = pkgs.buildPerlPackage {
    name = "List-BinarySearch-0.20";
    src = pkgs.fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAVIDO/List-BinarySearch-0.20.tar.gz;
      sha256 = "1piyl65m38bwqaap13wkgs033wiwb6m5zmr5va86ya4696cir7wd";
    };
  };

  ListMoreUtils = buildPerlPackage {
    name = "List-MoreUtils-0.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/List-MoreUtils-0.33.tar.gz;
      sha256 = "1bcljhhsk5g0xykvgbxz10ilmj02s58ydiy3g8hbzdr29i20np1i";
    };
    meta = {
      description = "Provide the stuff missing in List::Util";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ListUtilsBy = buildPerlPackage rec {
    name = "List-UtilsBy-0.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/List-UtilsBy-0.09.tar.gz;
      sha256 = "1xcsgz8898h670zmwqd8azfn3a2y9nq7z8cva9dsyhzkk8ajmra1";
    };
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  LocaleCodes = buildPerlPackage {
    name = "Locale-Codes-3.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBECK/Locale-Codes-3.35.tar.gz;
      sha256 = "b1a2f944b03972d2b7282767cf88100e3c0d7daa3f4ca7aef8460c1c5e246480";
    };
    meta = {
      description = "A distribution of modules to handle locale codes";
      license = "perl";
    };
  };

  LocaleGettext = buildPerlPackage {
    name = "LocaleGettext-1.05";
    buildInputs = stdenv.lib.optional (stdenv.isDarwin || stdenv.isCygwin) pkgs.gettext;
    NIX_CFLAGS_LINK = if (stdenv.isDarwin || stdenv.isCygwin) then "-lintl" else null;
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PV/PVANDRY/gettext-1.05.tar.gz;
      sha256 = "15262a00vx714szpx8p2z52wxkz46xp7acl72znwjydyq4ypydi7";
    };
  };

  LocaleMaketext = buildPerlPackage {
    name = "Locale-Maketext-1.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/Locale-Maketext-1.23.tar.gz;
      sha256 = "1r1sq7djafvk5abzc4l068p39dz44hlpgdldj3igvn2bjz78cli1";
    };
    propagatedBuildInputs = [I18NLangTags];
  };

  LocaleMaketextLexicon = buildPerlPackage {
    name = "Locale-Maketext-Lexicon-0.66";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Locale-Maketext-Lexicon-0.66.tar.gz;
      sha256 = "1cd2kbcrlyjcmlr7m8kf94mm1hlr7hpv1r80a596f4ljk81f2nvd";
    };
    propagatedBuildInputs = [LocaleMaketext];
  };

  LocaleMaketextSimple = buildPerlPackage {
    name = "Locale-Maketext-Simple-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/Locale-Maketext-Simple-0.21.tar.gz;
      sha256 = "1ad9vh45j8c32nzkbjipinawyg1pnjckwlhsjqcqs47vyi8zy2dh";
    };
  };

  LocalePO = buildPerlPackage {
    name = "Locale-PO-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/COSIMO/Locale-PO-0.23.tar.gz;
      sha256 = "52e5fdc88ec4eb00512418a938dc5089476ea66c9e744fee3c6bbfdf17a0d302";
    };
    propagatedBuildInputs = [ FileSlurp ];
    meta = {
      description = "Perl module for manipulating .po entries from GNU gettext";
      license = "unknown";
      platforms = stdenv.lib.platforms.linux;
      maintainers = with maintainers; [ ocharles ];
    };
  };

  locallib = buildPerlPackage {
    name = "local-lib-2.000014";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/local-lib-2.000014.tar.gz;
      sha256 = "ae63356ab780c5a3aa46287b48daea748a3dd021d9b52dff8bf480b43787fa2b";
    };
    meta = {
      description = "Create and use a local lib/ for perl modules with PERL5LIB";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LockFileSimple = buildPerlPackage rec {
    name = "LockFile-Simple-0.208";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCHWIGON/lockfile-simple/LockFile-Simple-0.208.tar.gz";
      sha256 = "18pk5a030dsg1h6wd8c47wl8pzrpyh9zi9h2c9gs9855nab7iis5";
    };
  };

  LogAny = buildPerlPackage {
    name = "Log-Any-1.032";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Log-Any-1.032.tar.gz;
      sha256 = "808558fa42aa96365ed0af773973a5618b4ad50511d81fc7548f67133efdb956";
    };
    meta = {
      homepage = https://github.com/dagolden/Log-Any;
      description = "Bringing loggers and listeners together";
      license = "perl";
    };
  };

  LogContextual = buildPerlPackage {
    name = "Log-Contextual-0.006003";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/Log-Contextual-0.006003.tar.gz;
      sha256 = "0940s910n67arqvz7aji4z6vgzzl52aq3l3jg8vq4ygnkn7c9k21";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ DataDumperConcise ExporterDeclare Moo ];
    meta = {
      description = "Simple logging interface with a contextual log";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  LogDispatch = buildPerlPackage {
    name = "Log-Dispatch-2.41";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Log-Dispatch-2.41.tar.gz;
      sha256 = "0vsmlkx2g9lc13pl9v96kn575yszfvd79a236b8v0s1di83gm09z";
    };
    propagatedBuildInputs = [ ClassLoad ParamsValidate ];
    meta = {
      description = "Dispatches messages to one or more outputs";
      license = stdenv.lib.licenses.artistic2;
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  LogMessage = buildPerlPackage {
    name = "Log-Message-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Log-Message-0.08.tar.gz;
      sha256 = "bd697dd62aaf26d118e9f0a0813429deb1c544e4501559879b61fcbdfe99fe46";
    };
    propagatedBuildInputs = [ if_ ];
    meta = {
      description = "Powerful and flexible message logging mechanism";
      license = "perl";
    };
  };

  LogTrace = buildPerlPackage rec {
    name = "Log-Trace-1.070";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Log/${name}.tar.gz";
      sha256 = "1qrnxn9b05cqyw1286djllnj8wzys10754glxx6z5hihxxc85jwy";
    };
  };

  Log4Perl = buildPerlPackage rec {
    name = "Log-Log4perl-1.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSCHILLI/${name}.tar.gz";
      sha256 = "19rmm1nlcradfj74rrvkjwmfighmjj9fiisml2j23i248vyz4cay";
    };
  };

  LogDispatchArray = buildPerlPackage {
    name = "Log-Dispatch-Array-1.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Log-Dispatch-Array-1.003.tar.gz;
      sha256 = "0dvzp0gsh17jqg02460ndchyapr1haahndq1p9v6mwkv5wf9680c";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ LogDispatch ];
    meta = {
      homepage = https://github.com/rjbs/log-dispatch-array;
      description = "Log events to an array (reference)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LogDispatchouli = buildPerlPackage {
    name = "Log-Dispatchouli-2.009";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Log-Dispatchouli-2.009.tar.gz;
      sha256 = "09iw27r36gmljlm6gjfczn2sf4s1js697q8na8xw4wlnz7x4bv59";
    };
    buildInputs = [ TestDeep TestFatal ];
    propagatedBuildInputs = [ LogDispatch LogDispatchArray ParamsUtil StringFlogger SubExporter SubExporterGlobExporter TryTiny ];
    meta = {
      homepage = https://github.com/rjbs/log-dispatchouli;
      description = "A simple wrapper around Log::Dispatch";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWP = buildPerlPackage rec {
    name = "libwww-perl-6.13";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "1cpqjl59viw50bnbdyn8xzrwzg7g54b2rszw0fifacqrppp17gaz";
    };
    propagatedBuildInputs = [ EncodeLocale FileListing HTMLParser HTTPCookies HTTPDaemon HTTPDate HTTPNegotiate HTTPMessage LWPMediaTypes NetHTTP URI WWWRobotRules ];
    doCheck = false; # tries to start a daemon
    meta = {
      description = "The World-Wide Web library for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    };
  };

  LWPMediaTypes = buildPerlPackage {
    name = "LWP-MediaTypes-6.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/LWP-MediaTypes-6.02.tar.gz;
      sha256 = "0xmnblp962qy02akah30sji8bxrqcyqlff2w95l199ghql60ny8q";
    };
    meta = {
      description = "Guess media type for a file or a URL";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPProtocolconnect = pkgs.perlPackages.LWPProtocolConnect;

  LWPProtocolConnect = buildPerlPackage {
    name = "LWP-Protocol-connect-6.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BE/BENNING/LWP-Protocol-connect-6.09.tar.gz;
      sha256 = "9f252394775e23aa42c3176611e5930638ab528d5190110b4731aa5b0bf35a15";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ HTTPMessage IOSocketSSL LWP LWPProtocolhttps URI ];
    meta = {
      description = "Provides HTTP/CONNECT proxy support for LWP::UserAgent";
      license = "perl";
    };
  };

  LWPProtocolhttps = pkgs.perlPackages.LWPProtocolHttps;

  LWPProtocolHttps = buildPerlPackage rec {
    name = "LWP-Protocol-https-6.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/LWP-Protocol-https-6.04.tar.gz;
      sha256 = "0agnga5dg94222h6rlzqxa0dri2sh3gayncvfb7jad9nxr87gxhy";
    };
    patches = [ ../development/perl-modules/lwp-protocol-https-cert-file.patch ];
    propagatedBuildInputs = [ LWP IOSocketSSL ];
    doCheck = false; # tries to connect to https://www.apache.org/.
    meta = {
      description = "Provide https support for LWP::UserAgent";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  LWPUserAgent = buildPerlPackage {
    name = "LWP-UserAgent-6.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/libwww-perl-6.05.tar.gz;
      sha256 = "08wgwyz7748pv5cyngxia0xl6nragfnhrp4p9s78xhgfyygpj9bv";
    };
    propagatedBuildInputs = [ EncodeLocale FileListing HTMLParser HTTPCookies HTTPDaemon HTTPDate HTTPNegotiate HTTPMessage LWPMediaTypes NetHTTP URI WWWRobotRules ];
    meta = {
      description = "The World-Wide Web library for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  LWPUserAgentDetermined = buildPerlPackage {
    name = "LWP-UserAgent-Determined-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/LWP-UserAgent-Determined-1.06.tar.gz;
      sha256 = "c31d8e16dc92e2113c81cdbfb11149cfd19039e789f77cd34333ac9184346fc5";
    };
    propagatedBuildInputs = [ LWP ];
    meta = {
      description = "A virtual browser that retries errors";
      license = "unknown";
    };
  };

  LWPUserAgentMockable = buildPerlPackage {
    name = "LWP-UserAgent-Mockable-1.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MM/MMORGAN/LWP-UserAgent-Mockable-1.10.tgz;
      sha256 = "1z89jszgifvjb8irzd8wrzim7l5m4hypdl9mj4dpkb4jm4189kmn";
    };
    propagatedBuildInputs = [ LWP HookLexWrap ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
    # Tests require network connectivity
    # https://rt.cpan.org/Public/Bug/Display.html?id=63966 is the bug upstream,
    # which doesn't look like it will get fixed anytime soon.
    doCheck = false;
  };

  LWPxParanoidAgent = buildPerlPackage rec {
    name = "LWPx-ParanoidAgent-1.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SAXJAZMAN/lwp/${name}.tar.gz";
      sha256 = "0i306p7mdqx09qfsf6b3rnn5xw9v9r3md4swlbk9z0mskjl0l4w4";
    };
    doCheck = false; # 3 tests fail, probably because they try to connect to the network
    propagatedBuildInputs = [ LWP NetDNS ];
  };

  maatkit = import ../development/perl-modules/maatkit {
    inherit fetchurl buildPerlPackage stdenv DBDmysql;
  };

  MailDKIM = buildPerlPackage rec {
    name = "Mail-DKIM-0.40";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JASLONG/${name}.tar.gz";
      sha256 = "1wd6mab4fp47v1nh85jfxsjmysnyv5mwvfv47cn5m2h2lb1s0piw";
    };
    propagatedBuildInputs = [ CryptOpenSSLRSA NetDNS MailTools ];
    doCheck = false; # tries to access the domain name system
  };

  MailIMAPClient = buildPerlPackage {
    name = "Mail-IMAPClient-3.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PL/PLOBBES/Mail-IMAPClient-3.35.tar.gz;
      sha256 = "0qzn8370cr91jnq1kawy6v16bcz49pch6inmw85rhzg87j1h6ica";
    };
    buildInputs = [ParseRecDescent];
  };

  MailRFC822Address = buildPerlPackage {
    name = "Mail-RFC822-Address-0.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PD/PDWARREN/Mail-RFC822-Address-0.3.tar.gz;
      sha256 = "351ef4104ecb675ecae69008243fae8243d1a7e53c681eeb759e7b781684c8a7";
    };
  };

  MailTools = buildPerlPackage {
    name = "MailTools-2.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKOV/MailTools-2.13.tar.gz;
      sha256 = "1djjl05ndn8dmwri4vw5wfky5sqy7sf63qaijvhf9g5yh53405kj";
    };
    propagatedBuildInputs = [TimeDate TestPod];
  };

  MathLibm = buildPerlPackage rec {
    name = "Math-Libm-1.00";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Math/${name}.tar.gz";
      sha256 = "0xn2a950mzzs5q1c4q98ckysn9dz20x7r35g02zvk35chgr0klxz";
    };
  };

  MathBigInt = buildPerlPackage rec {
    name ="Math-BigInt-1.9993";
    src = fetchurl {
      url    = "mirror://cpan/authors/id/P/PJ/PJACKLAM/${name}.tar.gz";
      sha256 = "0zmzd4d2sjnhg5cdnqvqj78w5dkickszlxv1csdxsgdvmz8w0dyr";
    };
  };

  MathBigIntGMP = buildPerlPackage rec {
    name = "Math-BigInt-GMP-1.38";
    src = fetchurl {
      url    = "mirror://cpan/authors/id/P/PJ/PJACKLAM/${name}.tar.gz";
      sha256 = "05bg10gg3ksn4h08yyyj7f31rqhdqap8d0jsbq61b3x0274wml0s";
    };
    buildInputs = [ pkgs.gmp ];
    doCheck = false;
    NIX_CFLAGS_COMPILE = "-I${pkgs.gmp}/include";
    NIX_CFLAGS_LINK = "-L${pkgs.gmp}/lib -lgmp";
  };

  MathBigRat = buildPerlPackage {
    name = "Math-BigRat-0.2606";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PJ/PJACKLAM/Math-BigRat-0.2606.tar.gz;
      sha256 = "a69506468dd3067249e6ba9ce35eb9d5509471d939c1efae8283cbd038ca7e28";
    };
    meta = {
      description = "Arbitrary big rational numbers";
      license = "perl";
    };
  };

  MathClipper = buildPerlModule rec {
    name = "Math-Clipper-1.23";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Math/${name}.tar.gz";
      sha256 = "0i9wzvig7ayijc9nvh5x5rryk1jrcj1hcvfmlcj449rnnxx24dav";
    };
    propagatedBuildInputs = [ ModuleBuildWithXSpp ExtUtilsXSpp ExtUtilsTypemapsDefault TestDeep ];
  };

  MathComplex = buildPerlPackage {
    name = "Math-Complex-1.59";
    src = fetchurl {
      url = mirror://cpan/authors/id/Z/ZE/ZEFRAM/Math-Complex-1.59.tar.gz;
      sha256 = "f35eb4987512c51d2c47294a008ede210d8dd759b90b887d04847c69b42dd6d1";
    };
  };

  MathConvexHullMonotoneChain = buildPerlPackage rec {
    name = "Math-ConvexHull-MonotoneChain-0.01";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Math/${name}.tar.gz";
      sha256 = "1xcl7cz62ydddji9qzs4xsfxss484jqjlj4iixa4aci611cw92r8";
    };
  };

  MathGeometryVoronoi = buildPerlPackage rec {
    name = "Math-Geometry-Voronoi-1.3";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Math/${name}.tar.gz";
      sha256 = "0b206k2q5cznld45cjhgm0as0clc9hk135ds8qafbkl3k175w1vj";
    };
    propagatedBuildInputs = [ ClassAccessor ParamsValidate ];
  };

  MathPlanePath = buildPerlPackage rec {
    name = "Math-PlanePath-114";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KR/KRYDE/${name}.tar.gz";
      sha256 = "11808k6aqf7gfkv0k0r8586zk8dm0jg5idkdb839gzlr97ns2y61";
    };
    propagatedBuildInputs = [ MathLibm constant-defer ];
  };

  MathRandomISAAC = buildPerlPackage {
    name = "Math-Random-ISAAC-1.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JA/JAWNSY/Math-Random-ISAAC-1.004.tar.gz;
      sha256 = "0z1b3xbb3xz71h25fg6jgsccra7migq7s0vawx2rfzi0pwpz0wr7";
    };
    buildInputs = [ TestNoWarnings ];
    meta = {
      homepage = http://search.cpan.org/dist/Math-Random-ISAAC;
      description = "Perl interface to the ISAAC PRNG algorithm";
      license = "unrestricted";
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MathRandomMTAuto = buildPerlPackage {
    name = "Math-Random-MT-Auto-6.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JD/JDHEDDEN/Math-Random-MT-Auto-6.22.tar.gz;
      sha256 = "07zha5zjxyvqwnycb1vzk4hk2m46n9yc5lrbvhkc22595dsyjahz";
    };
    propagatedBuildInputs = [ ExceptionClass ObjectInsideOut ];
    meta = {
      description = "Auto-seeded Mersenne Twister PRNGs";
      license = "unrestricted";
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MathRandomSecure = buildPerlPackage {
    name = "Math-Random-Secure-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MK/MKANAT/Math-Random-Secure-0.06.tar.gz;
      sha256 = "0392h78l3shkba9l2c43rgz6sm5qv7pzdylgb7gp9milprn77crc";
    };
    buildInputs = [ ListMoreUtils TestWarn ];
    propagatedBuildInputs = [ AnyMoose CryptRandomSource MathRandomISAAC ];
    meta = {
      description = "Cryptographically-secure, cross-platform replacement for rand()";
      license = stdenv.lib.licenses.artistic2;
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MathRound = buildPerlPackage rec {
    name = "Math-Round-0.06";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Math/${name}.tar.gz";
      sha256 = "194dvggf1cmzc701j4wma38jgrcv2pwwzk69rnysjjdcjdv6y255";
    };
  };

  Memoize = buildPerlPackage {
    name = "Memoize-1.03.tgz";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJD/Memoize-1.03.tgz;
      sha256 = "5239cc5f644a50b0de9ffeaa51fa9991eb06ecb1bf4678873e3ab89af9c0daf3";
    };
  };

  MetaBuilder = buildPerlModule {
    name = "Meta-Builder-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EX/EXODIST/Meta-Builder-0.003.tar.gz;
      sha256 = "e7ac289b88d1662e87708d716877ac66a1a8414660996fe58c1db96d834a5375";
    };
    buildInputs = [ FennecLite TestException ];
    meta = {
      description = "Tools for creating Meta objects to track custom metrics";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MethodSignaturesSimple = buildPerlPackage {
    name = "Method-Signatures-Simple-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RH/RHESA/Method-Signatures-Simple-1.07.tar.gz;
      sha256 = "1p6sf6iyyn73pc89mfr65bzxvbw1ibcsp4j10iv8ik3p353pvkf8";
    };
    propagatedBuildInputs = [ DevelDeclare ];
    meta = {
      description = "Basic method declarations with signatures, without source filters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MHonArc = buildPerlPackage rec {
    name = "MHonArc-2.6.18";

    src = fetchurl {
      url    = "http://dcssrv1.oit.uci.edu/indiv/ehood/release/MHonArc/tar/${name}.tar.gz";
      sha256 = "1xmf26dfwr8achprc3n1pxgl0mkiyr6pf25wq3dqgzqkghrrsxa2";
    };
    propagatedBuildInputs = [ ];

    installTargets = "install";

    meta = with stdenv.lib; {
      homepage    = http://dcssrv1.oit.uci.edu/indiv/ehood/mhonarch.html;
      description = "A mail-to-HTML converter";
      maintainers = with maintainers; [ lovek323 ];
      license     = licenses.gpl2;
      platforms   = platforms.unix;
    };
  };

  MIMEBase64 = buildPerlPackage rec {
    name = "MIME-Base64-3.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "1qbcipxij7pv25qhnfdc2lnkqi2cf60frlhlh86gjxslc8kr8nhj";
    };
  };

  MIMECharset = buildPerlPackage {
    name = "MIME-Charset-1.011.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEZUMI/MIME-Charset-1.011.1.tar.gz;
      sha256 = "2955a3b617fe12654efc2a13ae1dc7d32aad81d35cfae21f74337213cf2435d5";
    };
    meta = {
      description = "Charset Information for MIME";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  mimeConstruct = buildPerlPackage rec {
    name = "mime-construct-1.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROSCH/${name}.tar.gz";
      sha256 = "00wk9950i9q6qwp1vdq9xdddgk54lqd0bhcq2hnijh8xnmhvpmsc";
    };
    buildInputs = [ ProcWaitStat ];
  };

  MIMETypes = buildPerlPackage {
    name = "MIME-Types-2.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKOV/MIME-Types-2.04.tar.gz;
      sha256 = "13yci99n8kl8p4ac5n5f1j968p7va2phlvfc5qgpnn1d6yfhddi2";
    };
    meta = {
      description = "Definition of MIME types";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MixinLinewise = buildPerlPackage {
    name = "Mixin-Linewise-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Mixin-Linewise-0.004.tar.gz;
      sha256 = "7a50d171850d3e0dde51e041eecd40abc68396ea822baa4381951a7710833dd9";
    };
    propagatedBuildInputs = [ IOString SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/mixin-linewise;
      description = "Write your linewise code for handles; this does the rest";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModernPerl = buildPerlPackage {
    name = "Modern-Perl-1.20140107";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/Modern-Perl-1.20140107.tar.gz;
      sha256 = "9cf66b2f93340dfe1cd7162262a47e7c4ba82475a52dc2a036c2fdc8a65298b8";
    };
    propagatedBuildInputs = [ perl ];
    meta = {
      homepage = https://github.com/chromatic/Modern-Perl;
      description = "Enable all of the features of Modern Perl with one import";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuild = buildPerlPackage {
    name = "Module-Build-0.4005";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Module-Build-0.4005.tar.gz;
      sha256 = "eb2522507251550f459c11223ea6d86b34f1dee9b3e3928d0d6a0497505cb7ef";
    };
    buildInputs = [ CPANMeta ExtUtilsCBuilder ];
    meta = {
      description = "Build and install Perl modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildDeprecated = buildPerlModule {
    name = "Module-Build-Deprecated-0.4210";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Module-Build-Deprecated-0.4210.tar.gz;
      sha256 = "be089313fc238ee2183473aca8c86b55fb3cf44797312cbe9b892d6362621703";
    };
    doCheck = false;
    meta = {
      description = "A collection of modules removed from Module-Build";
      license = "perl";
    };
  };

  ModuleBuildTiny = buildPerlModule {
    name = "Module-Build-Tiny-0.039";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Module-Build-Tiny-0.039.tar.gz;
      sha256 = "7d580ff6ace0cbe555bf36b86dc8ea232581530cbeaaea09bccb57b55797f11c";
    };
    buildInputs = [ ExtUtilsConfig ExtUtilsHelpers ExtUtilsInstallPaths JSONPP TestHarness perl ];
    propagatedBuildInputs = [ ExtUtilsConfig ExtUtilsHelpers ExtUtilsInstallPaths JSONPP TestHarness ];
    meta = {
      description = "A tiny replacement for Module::Build";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleBuildWithXSpp = buildPerlModule rec {
    name = "Module-Build-WithXSpp-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMUELLER/${name}.tar.gz";
      sha256 = "0d39fjg9c0n820bk3fb50vvlwhdny4hdl69xmlyzql5xzp4cicsk";
    };
    propagatedBuildInputs = [ ExtUtilsXSpp ExtUtilsCppGuess ];
  };

  ModuleBuildXSUtil = buildPerlModule rec {
    name = "Module-Build-XSUtil-0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HI/HIDEAKIO/${name}.tar.gz";
      sha256 = "1323vxp8vf5xdz66lbc1wfciaks93mrbqfsjgb9nz1w9bb21xj36";
    };
    buildInputs = [ FileCopyRecursive CwdGuard CaptureTiny ];
    meta = {
      description = "A Module::Build class for building XS modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleCoreList = buildPerlPackage {
    name = "Module-CoreList-3.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Module-CoreList-3.01.tar.gz;
      sha256 = "10vf18x9qk4hdpwazxq8c0qykals36dxj0bjazqqcbp5xfb4fnyg";
    };
    meta = {
      homepage = http://dev.perl.org/;
      description = "What modules shipped with versions of perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleFind = buildPerlPackage {
    name = "Module-Find-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CR/CRENZ/Module-Find-0.12.tar.gz;
      sha256 = "1lc33jdv4pgmm7nkr9bff0lhwjhhw91kaf6iiy2n7i7mw8dfv47l";
    };
    meta = {
      description = "Find and use installed modules in a (sub)category";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleImplementation = buildPerlPackage {
    name = "Module-Implementation-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Module-Implementation-0.07.tar.gz;
      sha256 = "15r93l8danysfhb7wn2zww1s02hajki4k3xjfxbpz7ckadqq6jbk";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ ModuleRuntime TryTiny ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Loads one of several alternate underlying implementations for a module";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  ModuleInfo = buildPerlPackage rec {
    name = "Module-Info-0.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBARBON/Module-Info-0.35.tar.gz";
      sha256 = "0r7vxg1iy3lam0jgb2sk8ghgpmp3x5fskvzqlgkb09bssq83s1xb";
    };
    buildInputs = [ TestPod TestPodCoverage ];
    meta = {
      description = "Information about Perl modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleInstall = buildPerlPackage {
    name = "Module-Install-1.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Module-Install-1.14.tar.gz;
      sha256 = "3f02f0a33603aff2f5cf06d15f74d1a9be65e844ada99e1a9c2102330ffa0d49";
    };
    buildInputs = [ YAMLTiny ];
    propagatedBuildInputs = [ FileRemove ModuleScanDeps YAMLTiny ];
    meta = {
      description = "Standalone, extensible Perl module installer";
      license = "perl";
    };
  };

  ModuleInstallAuthorRequires = buildPerlPackage {
    name = "Module-Install-AuthorRequires-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Module-Install-AuthorRequires-0.02.tar.gz;
      sha256 = "1v2ciw75dj5y8lh10d1vrhwmjx266gpqavr8m21jlpblgm9j2qyc";
    };
    propagatedBuildInputs = [ ModuleInstall ];
    meta = {
      description = "Declare author-only dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ModuleInstallAuthorTests = buildPerlPackage {
    name = "Module-Install-AuthorTests-0.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Module-Install-AuthorTests-0.002.tar.gz;
      sha256 = "121dyggy38316xss06v1zkwx4b59gl7b00c5q99xyzimwqnp49a0";
    };
    propagatedBuildInputs = [ ModuleInstall ];
    meta = {
      description = "Designate tests only run by module authors";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ModuleManifest = buildPerlPackage {
    name = "Module-Manifest-1.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Module-Manifest-1.08.tar.gz;
      sha256 = "722ed428afcbe5b5b441b0165cbafbd8534fa63d7856d4089e6e25ac21e6445d";
    };
    buildInputs = [ TestException TestWarn ];
    propagatedBuildInputs = [ ParamsUtil ];
    meta = {
      description = "Parse and examine a Perl distribution MANIFEST file";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleMetadata = buildPerlPackage rec {
    name = "Module-Metadata-1.000019";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Module/${name}.tar.gz";
      sha256 = "0m755qn44nasbaj578628jgdqg0k4ldyn6fm3880hdi1q16skz2s";
    };
    propagatedBuildInputs = [ version ];
  };

  ModulePath = buildPerlPackage {
    name = "Module-Path-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Module-Path-0.13.tar.gz;
      sha256 = "1kzsi0z142gcspyyp81za29bq0y74l57a8i2q7gz4zcchf2xm23g";
    };
    buildInputs = [ DevelFindPerl ];
    meta = {
      description = "Get the full path to a locally installed module";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModulePluggable = buildPerlPackage {
    name = "Module-Pluggable-5.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SI/SIMONW/Module-Pluggable-5.1.tar.gz;
      sha256 = "0vwi433pk7n1ia5wy67j3545jvmjf1hb4jwcvzrz25mv8d03bp72";
    };
    patches = [
      # !!! merge this patch into Perl itself (which contains Module::Pluggable as well)
      ../development/perl-modules/module-pluggable.patch
    ];
    meta = {
      description = "Automatically give your module the ability to have plugins";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModulePluggableFast = buildPerlPackage {
    name = "Module-Pluggable-Fast-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/Module-Pluggable-Fast-0.19.tar.gz;
      sha256 = "0pq758wlasmh77xyd2xh75m5b2x14s8pnsv63g5356gib1q5gj08";
    };
    propagatedBuildInputs = [UNIVERSALrequire];
  };

  ModuleRuntime = buildPerlPackage {
    name = "Module-Runtime-0.014";
    src = fetchurl {
      url = mirror://cpan/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.014.tar.gz;
      sha256 = "19326f094jmjs6mgpwkyisid54k67w34br8yfh0gvaaml87gwi2c";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Runtime module handling";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleRuntimeConflicts = buildPerlPackage {
    name = "Module-Runtime-Conflicts-0.001";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Module-Runtime-Conflicts-0.001.tar.gz;
      sha256 = "0f73d03846575dd1492d3760deeb9627afaa1f8b04d4d526b1775174201be25f";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ DistCheckConflicts ModuleRuntime ];
    meta = {
      homepage = https://github.com/karenetheridge/Module-Runtime-Conflicts;
      description = "Provide information on conflicts for Module::Runtime";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleScanDeps = buildPerlPackage {
    name = "Module-ScanDeps-1.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSCHUPP/Module-ScanDeps-1.17.tar.gz;
      sha256 = "1b2999344919826476c59e08e65e4877121b4da1e847c9f354841df688927dd2";
    };
    buildInputs = [ TestRequires ];
    meta = {
      description = "Recursively scan Perl code for dependencies";
      license = "perl";
    };
  };

  ModuleSignature = buildPerlPackage {
    name = "Module-Signature-0.79";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Module-Signature-0.79.tar.gz;
      sha256 = "22df2ce097fb5d176efa951c782633d8debe594924a25ca66666252512ce462c";
    };
    buildInputs = [ IPCRun ];
    meta = {
      description = "Module signature file manipulation";
      license = "cc0";
    };
  };

  ModuleUtil = buildPerlPackage {
    name = "Module-Util-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MATTLAW/Module-Util-1.09.tar.gz;
      sha256 = "6cfbcb6a45064446ec8aa0ee1a7dddc420b54469303344187aef84d2c7f3e2c6";
    };
    buildInputs = [ ModuleBuild ];
    meta = {
      description = "Module name tools and transformations";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ModuleVersions = buildPerlPackage {
    name = "Module-Versions-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TH/THW/Module-Versions-0.02.zip;
      sha256 = "0g7qs6vqg91xpwg1cdy91m3kh9m1zbkzyz1qsy453b572xdscf0d";
    };
    buildInputs = [ pkgs.unzip ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  mod_perl2 = buildPerlPackage {
    name = "mod_perl-2.0.9";
    src = fetchurl {
      url = http://apache.mirror.iphh.net/perl/mod_perl-2.0.9.tar.gz;
      sha256 = "0azmir4hbb825mfmcxwa1frhnhhf82rl8xf6mmgwkhbinxmg4q02";
    };
    makeMakerFlags = "MP_AP_DESTDIR=$out";
    buildInputs = [ pkgs.apacheHttpd ];
    doCheck = false; # would try to start Apache HTTP server
    meta = {
      description = "Embed a Perl interpreter in the Apache HTTP server";
    };
  };

  Mojolicious = buildPerlPackage {
    name = "Mojolicious-4.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SR/SRI/Mojolicious-4.63.tar.gz;
      sha256 = "f20f77e86fc560dac1c958e765ed64242dcf6343939ed605b45f2bbe2596d5e9";
    };
    meta = {
      homepage = http://mojolicio.us;
      description = "Real-time web framework";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  Moo = buildPerlPackage {
    name = "Moo-1.006000";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/Moo-1.006000.tar.gz;
      sha256 = "0gjh6dyz825cwjibq2wlpx14drjqx4pxxh931p4x3jd2617hax17";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ClassMethodModifiers DevelGlobalDestruction ImportInto ModuleRuntime RoleTiny strictures ];
    meta = {
      description = "Minimalist Object Orientation (with Moose compatibility)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Moose = buildPerlPackage {
    name = "Moose-2.1213";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Moose-2.1213.tar.gz;
      sha256 = "0f3b196ae67dc1daaa43c44ae7703f27c4f92c391ad3e252a90e90c50c851e03";
    };
    buildInputs = [ CPANMetaCheck CPANMetaRequirements DistCheckConflicts TestCleanNamespaces TestFatal TestRequires ];
    propagatedBuildInputs = [ ClassLoad ClassLoadXS DataOptList DevelGlobalDestruction DevelStackTrace DistCheckConflicts EvalClosure ListMoreUtils MROCompat ModuleRuntime ModuleRuntimeConflicts PackageDeprecationManager PackageStash PackageStashXS ParamsUtil SubExporter SubName TaskWeaken TryTiny ];
    meta = {
      homepage = http://moose.perl.org/;
      description = "A postmodern object system for Perl 5";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.eelco ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooXTypesMooseLike = buildPerlPackage rec {
    name = "MooX-Types-MooseLike-0.27";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MATEU/${name}.tar.gz";
      sha256 = "1489almsam2zcrs5039sh0y88gjicwna8kws8j2jgfs8bpcf4dgf";
    };
    propagatedBuildInputs = [ Moo TestFatal ];
  };

  MooseAutobox = buildPerlPackage {
    name = "Moose-Autobox-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Moose-Autobox-0.15.tar.gz;
      sha256 = "0xcayrfm08dqas1mq8lnf8nxkvzdgcmv6xs5lqah17bxqxgznrl9";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moose SyntaxKeywordJunction autobox ];
    meta = {
      description = "Autoboxed wrappers for Native Perl datatypes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXABC = buildPerlPackage {
    name = "MooseX-ABC-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/MooseX-ABC-0.06.tar.gz;
      sha256 = "1sky0dpi22wrymmkjmqba4k966zn7vrbpx918wn2nmg48swyrgjf";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      homepage = http://metacpan.org/release/MooseX-ABC;
      description = "Abstract base classes for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXAliases = buildPerlPackage rec {
    name = "MooseX-Aliases-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DO/DOY/${name}.tar.gz";
      sha256 = "0j07zqczjfmng3md6nkha7560i786d0cp3gdmrx49hr64jbhz1f4";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ Moose ];
  };

  MooseXAppCmd = buildPerlPackage {
    name = "MooseX-App-Cmd-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJGARDNER/MooseX-App-Cmd-0.27.tar.gz;
      sha256 = "18wf8xmp0b8g76rlkmzw9m026w0l5k972w3z9xcskwqmg9p0wg3k";
    };
    buildInputs = [ MooseXConfigFromFile TestOutput YAML MouseXGetOpt ];
    propagatedBuildInputs = [ AppCmd GetoptLongDescriptive Moose AnyMoose MooseXConfigFromFile MooseXGetopt MooseXHasOptions MooseXMarkAsMethods Testuseok ];
    meta = {
      homepage = http://metacpan.org/release/MooseX-App-Cmd;
      description = "Mashes up MooseX::Getopt and App::Cmd";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooXlate = buildPerlPackage {
    name = "MooX-late-0.015";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOBYINK/MooX-late-0.015.tar.gz;
      sha256 = "175326af3076fa8698669f289fad1322724978cddaf40ea04e600fcd7f6afbbf";
    };
    buildInputs = [ TestFatal TestRequires ];
    propagatedBuildInputs = [ Moo TypeTiny ];
    meta = {
      homepage = https://metacpan.org/release/MooX-late;
      description = "Easily translate Moose code to Moo";
      license = "perl";
    };
  };

  MouseXSimpleConfig = buildPerlPackage {
    name = "MouseX-SimpleConfig-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJGARDNER/MouseX-SimpleConfig-0.11.tar.gz;
      sha256 = "257f384091d33d340373a6153947039c698dc449d1ef989335644fc3d2da0069";
    };
    buildInputs = [ Mouse PathClass ];
    propagatedBuildInputs = [ ConfigAny Mouse MouseXConfigFromFile ];
    meta = {
      description = "A Mouse role for setting attributes from a simple configfile";
      license = "perl";
    };
  };

  TestUseAllModules = buildPerlPackage {
    name = "Test-UseAllModules-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IS/ISHIGAKI/Test-UseAllModules-0.17.tar.gz;
      sha256 = "a71f2fe8b96ab8bfc2760aa1d3135ea049a5b20dcb105457b769a1195c7a2509";
    };
    meta = {
      description = "Do use_ok() for all the MANIFESTed modules";
      license = "perl";
    };
  };

  MouseXTypesPathClass = buildPerlPackage {
    name = "MouseX-Types-Path-Class-0.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MASAKI/MouseX-Types-Path-Class-0.07.tar.gz;
      sha256 = "228d4b4f3f0ed9547278691d0b7c5fe53d90874a69df709a49703c6af87c09de";
    };
    buildInputs = [ TestUseAllModules ];
    propagatedBuildInputs = [ Mouse MouseXTypes PathClass ];
    meta = {
      description = "A Path::Class type library for Mouse";
      license = "perl";
    };
  };

  MouseXTypes = buildPerlPackage {
    name = "MouseX-Types-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GF/GFUJI/MouseX-Types-0.06.tar.gz;
      sha256 = "77288441fdadd15beeec9a0813ece8aec1542f1d8ceaaec14755b3f316fbcf8b";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ AnyMoose Mouse ];
    meta = {
      description = "Organize your Mouse types in libraries";
      license = "perl";
    };
  };

  MouseXConfigFromFile = buildPerlPackage {
    name = "MouseX-ConfigFromFile-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MASAKI/MouseX-ConfigFromFile-0.05.tar.gz;
      sha256 = "921b31cb13fc1f982a602f8e23815b7add23a224257e43790e287504ce879534";
    };
    buildInputs = [ TestUseAllModules ];
    propagatedBuildInputs = [ Mouse MouseXTypesPathClass ];
    meta = {
      description = "An abstract Mouse role for setting attributes from a configfile";
      license = "perl";
    };
  };
  
  MouseXGetOpt = buildPerlModule {
    name = "mousex-getopt-0.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOKUHIROM/mousex-getopt-0.35.tar.gz;
      sha256 = "5abe243a1ab05d64562358604de1d31d36994414c5c5eaeac688897129d2f9ae";
    };
    buildInputs = [ Mouse MouseXConfigFromFile MouseXSimpleConfig TestException TestWarn ];
    propagatedBuildInputs = [ GetoptLongDescriptive Mouse ];
    meta = {
      homepage = https://github.com/gfx/mousex-getopt;
      description = "A Mouse role for processing command line options";
      license = "perl";
    };
  };


  MooseXAttributeChained = buildPerlModule rec {
    name = "MooseX-Attribute-Chained-1.0.1";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "101kwjzidppcsnyvp9x1vw8vpvkp1cc1csqmzbashwvqy8d0g4af";
    };
    propagatedBuildInputs = [ Moose TryTiny ];
  };

  MooseXAttributeHelpers = buildPerlPackage {
    name = "MooseX-AttributeHelpers-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-AttributeHelpers-0.23.tar.gz;
      sha256 = "3f63f60d94d840a309d9137f78605e15f07c977fd15a4f4b55bd47b65ed52be1";
    };
    patches = [ ../development/perl-modules/MooseXAttributeHelpers-perl-5.20.patch ];
    buildInputs = [ Moose TestException ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "Extend your attribute interfaces (deprecated)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXClone = buildPerlPackage {
    name = "MooseX-Clone-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/MooseX-Clone-0.05.tar.gz;
      sha256 = "11pbw3zdbcn54hrj6z74qisnmj9k4qliy6yjj9d71qndq3xg3x0f";
    };
    propagatedBuildInputs = [ DataVisitor HashUtilFieldHashCompat Moose namespaceclean Testuseok ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXConfigFromFile = buildPerlPackage {
    name = "MooseX-ConfigFromFile-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-ConfigFromFile-0.13.tar.gz;
      sha256 = "0pf5f05hs2i765cnw9sw1hdxf7vz480iyyngjawr4yqjkv4r5nz7";
    };
    buildInputs = [ Moose TestCheckDeps TestDeep TestFatal TestNoWarnings TestRequires TestWithoutModule ];
    propagatedBuildInputs = [ Moose MooseXTypes MooseXTypesPathTiny TryTiny namespaceautoclean ];
    meta = {
      description = "An abstract Moose role for setting attributes from a configfile";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXDaemonize = buildPerlPackage {
    name = "MooseX-Daemonize-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MICHAELR/MooseX-Daemonize-0.15.tar.gz;
      sha256 = "1h6rzdmk68q4p0nh2bzmwwvr5iaf7pvdfrpwdxmr3z5pc64wajvd";
    };
    buildInputs = [ TestMoose ];
    propagatedBuildInputs = [ Moose MooseXGetopt MooseXTypesPathClass ];
    meta = {
      description = "Role for daemonizing your Moose based application";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXEmulateClassAccessorFast = buildPerlPackage {
    name = "MooseX-Emulate-Class-Accessor-Fast-0.00903";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/MooseX-Emulate-Class-Accessor-Fast-0.00903.tar.gz;
      sha256 = "1lkn1h4sxr1483jicsgsgzclbfw63g2i2c3m4v4j9ar75yrb0kh8";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ Moose namespaceclean ];
    meta = {
      description = "Emulate Class::Accessor::Fast behavior using Moose attributes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXGetopt = buildPerlPackage {
    name = "MooseX-Getopt-0.65";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Getopt-0.65.tar.gz;
      sha256 = "c07c2b7312c471bf2d331025c0ad6cc02068633eda1e208cbdb5511ef5da7fda";
    };
    buildInputs = [ CPANMeta ModuleBuildTiny ModuleRuntime Moose PathTiny TestDeep TestFatal TestRequires TestTrap TestWarnings if_ ];
    propagatedBuildInputs = [ GetoptLongDescriptive Moose MooseXRoleParameterized TryTiny namespaceautoclean ];
    meta = {
      homepage = https://github.com/moose/MooseX-Getopt;
      description = "A Moose role for processing command line options";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXHasOptions = buildPerlPackage {
    name = "MooseX-Has-Options-0.003";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PS/PSHANGOV/MooseX-Has-Options-0.003.tar.gz;
      sha256 = "07c21cf8ed500b272020ff8da19f194728bb414e0012a2f0cc54ef2ef6222a68";
    };
    buildInputs = [ Moose TestMost namespaceautoclean ];
    propagatedBuildInputs = [ ClassLoad ListMoreUtils PackageStash StringRewritePrefix ];
    meta = {
      homepage = https://github.com/pshangov/moosex-has-options;
      description = "Succinct options for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXHasSugar = buildPerlModule {
    name = "MooseX-Has-Sugar-0.05070421";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KE/KENTNL/MooseX-Has-Sugar-0.05070421.tar.gz;
      sha256 = "5acf92a6dcac50a6edfcbdb2c38802f8c1f9dc7194a79d0b85a3d4105ebba7df";
    };
    buildInputs = [ Moose MooseXTypes TestFatal namespaceautoclean ];
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      homepage = https://github.com/kentfredric/MooseX-Has-Sugar;
      description = "Sugar Syntax for moose 'has' fields";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXLazyRequire = buildPerlPackage {
    name = "MooseX-LazyRequire-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-LazyRequire-0.10.tar.gz;
      sha256 = "a555f80c0e91bc428f040015f00dd98f3c022704ec089516b9b3507f3d437090";
    };
    buildInputs = [ TestCheckDeps TestFatal ];
    propagatedBuildInputs = [ Moose aliased namespaceautoclean ];
    meta = {
      homepage = https://github.com/karenetheridge/moosex-lazyrequire;
      description = "Required attributes which fail only when trying to use them";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXMarkAsMethods = buildPerlPackage {
    name = "MooseX-MarkAsMethods-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSRCHBOY/MooseX-MarkAsMethods-0.15.tar.gz;
      sha256 = "1y3yxwcjjajm66pvca54cv9fax7a6dy36xqr92x7vzyhfqrw3v69";
    };
    buildInputs = [ TestMoose ];
    propagatedBuildInputs = [ BHooksEndOfScope Moose namespaceautoclean ];
    meta = {
      homepage = http://metacpan.org/release/MooseX-MarkAsMethods/;
      description = "Mark overload code symbols as methods";
      license = stdenv.lib.licenses.lgpl21;
    };
  };

  MooseXMethodAttributes = buildPerlPackage {
    name = "MooseX-MethodAttributes-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-MethodAttributes-0.28.tar.gz;
      sha256 = "0srk85z6py9brw1jfvacd76y6219wycq3dj0wackbkmmbq04ln0g";
    };
    buildInputs = [ namespaceautoclean TestCheckDeps TestException ];
    propagatedBuildInputs = [ Moose MooseXTypes namespaceautoclean ];
    meta = {
      homepage = https://github.com/karenetheridge/moosex-methodattributes;
      description = "Code attribute introspection";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXNonMoose = buildPerlPackage {
    name = "MooseX-NonMoose-0.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/MooseX-NonMoose-0.26.tar.gz;
      sha256 = "0zdaiphc45s5xj0ax5mkijf5d8v6w6yccb3zplgj6f30y7n55gnb";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ListMoreUtils Moose ];
    meta = {
      description = "Easy subclassing of non-Moose classes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXOneArgNew = buildPerlPackage {
    name = "MooseX-OneArgNew-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/MooseX-OneArgNew-0.004.tar.gz;
      sha256 = "1frfrqaj283z1x95cqbbj3cvmb6rj50ngs47jq8myz6d1bg4zwff";
    };
    buildInputs = [ Moose ];
    propagatedBuildInputs = [ Moose MooseXRoleParameterized namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/moosex-oneargnew;
      description = "Teach ->new to accept single, non-hashref arguments";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRelatedClassRoles = buildPerlPackage rec {
    name = "MooseX-RelatedClassRoles-0.004";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "17vynkf6m5d039qkr4in1c9lflr8hnwp1fgzdwhj4q6jglipmnrh";
    };
    buildInputs = [ ];
    propagatedBuildInputs = [ MooseXRoleParameterized ];
  };

  MooseXParamsValidate = buildPerlPackage {
    name = "MooseX-Params-Validate-0.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-Params-Validate-0.18.tar.gz;
      sha256 = "02yim0lmr7p2nzswy97d5ylbs4ksmgklqq350p119i2611x7ai0k";
    };
    buildInputs = [ Moose TestFatal ];
    propagatedBuildInputs = [ DevelCaller Moose ParamsValidate SubExporter ];
    meta = {
      description = "An extension of Params::Validate using Moose's types";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRoleParameterized = buildPerlPackage {
    name = "MooseX-Role-Parameterized-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SARTAK/MooseX-Role-Parameterized-1.02.tar.gz;
      sha256 = "089czh2pipvdajjy4rxlix0y20ilp3ldbzi0vs68b7k6k9q3mqdk";
    };
    buildInputs = [ TestFatal TestMoose ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      homepage = http://github.com/sartak/MooseX-Role-Parameterized/tree;
      description = "Roles with composition parameters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRoleWithOverloading = buildPerlPackage {
    name = "MooseX-Role-WithOverloading-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Role-WithOverloading-0.13.tar.gz;
      sha256 = "01mqpvbz7yw993918hgp72vl22i6mgicpq5b3zrrsp6vl8sqj2sw";
    };
    buildInputs = [ TestCheckDeps TestNoWarnings ];
    propagatedBuildInputs = [ aliased Moose namespaceautoclean namespaceclean ];
    meta = {
      homepage = http://metacpan.org/release/MooseX-Role-WithOverloading;
      description = "Roles which support overloading";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXRunnable = buildPerlPackage {
    name = "MooseX-Runnable-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JR/JROCKWAY/MooseX-Runnable-0.03.tar.gz;
      sha256 = "1hl3pnldjlbyj6gm3bzwj827qp54di14hp4zhypmrmbg1lscfdwc";
    };
    buildInputs = [ Testuseok TestTableDriven ];
    propagatedBuildInputs = [ ListMoreUtils Moose MooseXGetopt MooseXTypes MooseXTypesPathClass namespaceautoclean ParamsUtil ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXSemiAffordanceAccessor = buildPerlPackage rec {
    name = "MooseX-SemiAffordanceAccessor-0.09";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "1724cxvgy1wh1kfawcj2sanlm90zarfh7k186pgyx1lk8fhnlj4m";
    };
    propagatedBuildInputs = [ Moose ];
  };

  MooseXSetOnce = buildPerlPackage rec {
    name = "MooseX-SetOnce-0.200002";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "0ndnl8dj7nh8lvckl6r3jw31d0dmq30qf2pqkgcz0lykzjvhdvfb";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose ];
  };

  MooseXSingleton = buildPerlPackage rec {
    name = "MooseX-Singleton-0.29";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAARE/MooseX-Singleton-0.29.tar.gz;
      sha256 = "0103f0hi7fp3mc0y0ydnz4ghcnag5gwgn2160y2zp6rnydx2p2sc";
    };
    buildInputs = [ Moose TestFatal TestRequires ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXStrictConstructor = buildPerlPackage {
    name = "MooseX-StrictConstructor-0.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/MooseX-StrictConstructor-0.19.tar.gz;
      sha256 = "486573c16901e83c081da3d90a544281af1baa40bbf036337d6fa91994e48a31";
    };
    buildInputs = [ Moose TestFatal ];
    propagatedBuildInputs = [ Moose namespaceautoclean ];
    meta = {
      description = "Make your object constructors blow up on unknown attributes";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  MooseXTraits = buildPerlPackage rec {
    name = "MooseX-Traits-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "0sqmpf2kw25847fwrrwpcfhrq694bgs8jbix7qxp9qyjm769np6n";
    };
    buildInputs = [ TestException Testuseok ];
    propagatedBuildInputs = [ ClassMOP Moose namespaceautoclean ];
  };

  MooseXTraitsPluggable = buildPerlPackage rec {
    name = "MooseX-Traits-Pluggable-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "1jjqmcidy4kdgp5yffqqwxrsab62mbhbpvnzdy1rpwnb1savg5mb";
    };
    buildInputs =[ TestException ];
    propagatedBuildInputs =
      [ ClassMOP Moose namespaceautoclean ListMoreUtils ];
  };

  MooseXTypes = buildPerlPackage {
    name = "MooseX-Types-0.45";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-0.45.tar.gz;
      sha256 = "d01ff4a3db78e1150101b4b63569e4bce3ced3b5b0024c52c87575e0820609c7";
    };
    buildInputs = [ ModuleBuildTiny Moose TestFatal TestRequires if_ ];
    propagatedBuildInputs = [ CarpClan ModuleRuntime Moose SubExporter SubName namespaceautoclean ];
    meta = {
      homepage = https://github.com/moose/MooseX-Types;
      description = "Organise your Moose types in libraries";
      license = "perl";
    };
  };

  MooseXTypesCommon = buildPerlPackage rec {
    name = "MooseX-Types-Common-0.001008";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/MooseX/${name}.tar.gz";
      sha256 = "0s0z6v32vyykni8an6jzyvl0icr5d5b8kbi4qqp4vwc5438jrpdz";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose MooseXTypes ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXTypesDateTime = buildPerlPackage {
    name = "MooseX-Types-DateTime-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/MooseX-Types-DateTime-0.08.tar.gz;
      sha256 = "0q0d1dd8737rc3k3jb22wvybf03hg3lp1iyda0ivkd8020cib996";
    };
    propagatedBuildInputs = [ DateTime DateTimeLocale DateTimeTimeZone Moose MooseXTypes namespaceclean TestException Testuseok ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXTypesDateTimeMoreCoercions = buildPerlPackage {
    name = "MooseX-Types-DateTime-MoreCoercions-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/MooseX-Types-DateTime-MoreCoercions-0.11.tar.gz;
      sha256 = "c746a9284b7db49ce9acb2fbce26629fa816e6636e883d2ed6c62e336cfc52cb";
    };
    buildInputs = [ TestException Testuseok ];
    propagatedBuildInputs = [ DateTime DateTimeXEasy Moose MooseXTypes MooseXTypesDateTime TimeDurationParse namespaceclean ];
    meta = {
      description = "Extensions to MooseX::Types::DateTime";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesLoadableClass = buildPerlPackage {
    name = "MooseX-Types-LoadableClass-0.012";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-LoadableClass-0.012.tar.gz;
      sha256 = "a1d2b186c2b69f416bb0c9271dc8692c2287c2f6ce144cc3b9b2c922427060df";
    };
    buildInputs = [ ModuleBuildTiny Moose TestFatal ];
    propagatedBuildInputs = [ ClassLoad ModuleRuntime Moose MooseXTypes namespaceautoclean ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
      homepage = https://github.com/moose/MooseX-Types-LoadableClass;
      description = "ClassName type constraint with coercion to load the class";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesPathClass = buildPerlPackage {
    name = "MooseX-Types-Path-Class-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TH/THEPLER/MooseX-Types-Path-Class-0.06.tar.gz;
      sha256 = "02lw86r6pp6saiwc7ns890mlwq93vhkqyri3cipsfwhnhcap847g";
    };
    propagatedBuildInputs = [ ClassMOP Moose MooseXTypes PathClass ];
    meta = {
      description = "A Path::Class type library for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesPathTiny = buildPerlModule {
    name = "MooseX-Types-Path-Tiny-0.006";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Path-Tiny-0.006.tar.gz;
      sha256 = "0260c6fbbf84d411b145238ffd92a73f754bd92434448d9f78798fba0a2dfdd6";
    };
    buildInputs = [ Filepushd ModuleBuildTiny TestCheckDeps TestFatal ];
    propagatedBuildInputs = [ Moose MooseXTypes MooseXTypesStringlike PathTiny ];
    meta = {
      homepage = https://github.com/karenetheridge/moosex-types-path-tiny;
      description = "Path::Tiny types and coercions for Moose";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXTypesPerl = buildPerlPackage {
    name = "MooseX-Types-Perl-0.101343";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/MooseX-Types-Perl-0.101343.tar.gz;
      sha256 = "0nijy676q27bvjb8swxrb1j4lq2xq8jbqkaxs1l9q81k7jpvx17h";
    };
    propagatedBuildInputs = [ MooseXTypes ParamsUtil ];
    meta = {
      description = "Moose types that check against Perl syntax";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MooseXTypesStringlike = buildPerlPackage {
    name = "MooseX-Types-Stringlike-0.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/MooseX-Types-Stringlike-0.002.tar.gz;
      sha256 = "18g07bvhcrhirb1yhcz55y7nsvkw1wq285d1hyb0jxrzgr0ga94k";
    };
    buildInputs = [ Moose ];
    propagatedBuildInputs = [ MooseXTypes ];
    meta = {
      homepage = https://github.com/dagolden/moosex-types-stringlike;
      description = "Moose type constraints for strings or string-like objects";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXTypesStructured = buildPerlPackage {
    name = "MooseX-Types-Structured-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-Structured-0.30.tar.gz;
      sha256 = "0svfgbyzwdipywh7bfp954hncm8ihfr8xpppcyy59wr1inx2f55c";
    };
    buildInputs = [ DateTime MooseXTypesDateTime TestFatal ];
    propagatedBuildInputs = [ DevelPartialDump Moose MooseXTypes SubExporter ];
    meta = {
      homepage = http://metacpan.org/release/MooseX-Types-Structured;
      description = "MooseX::Types::Structured - Structured Type Constraints for Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  MooseXTypesURI = buildPerlPackage {
    name = "MooseX-Types-URI-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/MooseX-Types-URI-0.05.tar.gz;
      sha256 = "08acqm23ff22hicb3l4wc7szvdhlxpan7qmpgl15ilawrmz60p82";
    };
    propagatedBuildInputs = [ Moose MooseXTypes MooseXTypesPathClass namespaceclean Testuseok URI URIFromHash ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  Mouse = buildPerlModule rec {
    name = "Mouse-2.3.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/${name}.tar.gz";
      sha256 = "0ycl521mmc5989934502730rzsi9xqihdpnjihrkhflqmrzmaqwq";
    };
    buildInputs = [
      ModuleBuildXSUtil TestException TestLeakTrace TestRequires TestOutput
      TestFatal
    ];
  };

  MouseXNativeTraits = buildPerlPackage rec {
    name = "MouseX-NativeTraits-1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/${name}.tar.gz";
      sha256 = "0pnbchkxfz9fwa8sniyjqp0mz75b3k2fafq9r09znbbh51dbz9gq";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ AnyMoose ];
    meta = {
      description = "Extend attribute interfaces for Mouse";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MozillaCA = buildPerlPackage {
    name = "Mozilla-CA-20130114";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABH/Mozilla-CA-20130114.tar.gz;
      sha256 = "82342614add1dbca8a00daa1ee55af3e0036245aed7d445537918c045008ccd7";
    };
    meta = {
      description = "Mozilla's CA cert bundle in PEM format";
      license = "unknown";
    };
  };

  MozillaLdap = buildPerlPackage {
    name = "Mozilla-Ldap-1.5.3";
    USE_OPENLDAP=1;
    LDAPSDKDIR=pkgs.openldap;
    src = fetchurl {
      url = "ftp://ftp.mozilla.org/pub/mozilla.org/directory/perldap/releases/1.5.3/src/perl-mozldap-1.5.3.tar.gz";
      sha256 = "0s0albdw0zvg3w37s7is7gddr4mqwicjxxsy400n1p96l7ipnw4x";
    };
    meta = {
      description = "Mozilla's ldap client library";
      license = "unknown";
    };
  };

  MROCompat = buildPerlPackage {
    name = "MRO-Compat-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/MRO-Compat-0.12.tar.gz;
      sha256 = "1mhma2g83ih9f8nkmg2k9l0x6izhhbb6k5lli4rpllxad4wbk9dv";
    };
    meta = {
      description = "Mro::* interface compatibility for Perls < 5.9.5";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  MusicBrainzDiscID = buildPerlModule rec {
    name = "MusicBrainz-DiscID-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NJ/NJH/${name}.tar.gz";
      sha256 = "0fjph2q3yp0aa87gckv3391s47m13wbyylj7jb7vqx7hv0pzj0jh";
    };
    # Build.PL in this package uses which to find pkg-config -- make it use path instead
    patchPhase = ''sed -ie 's/`which pkg-config`/"pkg-config"/' Build.PL'';
    doCheck = false; # The main test performs network access
    #buildInputs = [ TestMore TestPod ];
    buildInputs = [ pkgs.pkgconfig ];
    propagatedBuildInputs = [ pkgs.libdiscid ];
  };

  MusicBrainz = buildPerlPackage rec {
    name = "WebService-MusicBrainz-0.93";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BF/BFAIST/${name}.tar.gz";
      sha256 = "1gg62x6qv4jj73jsqh0sb237k96i22blj29afpbp1scp3m7i5g61";
    };
    propagatedBuildInputs = [ XMLLibXML LWP ClassAccessor URI ];
    doCheck = false; # Test performs network access.
  };

  namespaceautoclean = buildPerlPackage {
    name = "namespace-autoclean-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/namespace-autoclean-0.20.tar.gz;
      sha256 = "42a199314d07b7a29044d6072529ca53037c75a43550193b1586bd19c690a05f";
    };
    buildInputs = [ ModuleBuildTiny TestRequires ];
    propagatedBuildInputs = [ BHooksEndOfScope SubIdentify namespaceclean ];
    meta = {
      homepage = https://github.com/moose/namespace-autoclean;
      description = "Keep imports out of your namespace";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  namespaceclean = buildPerlPackage rec {
    name = "namespace-clean-0.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RI/RIBASUSHI/namespace-clean-0.25.tar.gz;
      sha256 = "016dds70ql1mp18b07chkxiy4drn976ibnbshqc2hmhrh9xjnsll";
    };
    propagatedBuildInputs = [ BHooksEndOfScope PackageStash ];
    meta = {
      homepage = http://search.cpan.org/dist/namespace-clean;
      description = "Keep imports and functions out of your namespace";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NamespaceAutoclean = buildPerlPackage {
    name = "namespace-autoclean-0.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/namespace-autoclean-0.26.tar.gz;
      sha256 = "c0f805acd3b565c611324b7bde20d32f6ffc31afefc5b8e52f54994802594d43";
    };
    buildInputs = [ ModuleBuildTiny TestRequires ];
    propagatedBuildInputs = [ BHooksEndOfScope SubIdentify NamespaceClean ];
    meta = {
      homepage = https://github.com/moose/namespace-autoclean;
      description = "Keep imports out of your namespace";
      license = "perl";
    };
  };

  NamespaceClean = buildPerlPackage {
    name = "namespace-clean-0.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RI/RIBASUSHI/namespace-clean-0.25.tar.gz;
      sha256 = "946a2b7b8219562818867ad915cd493637e2639f901db050b835500c8e6ecd04";
    };
    propagatedBuildInputs = [ BHooksEndOfScope PackageStash ];
    meta = {
      homepage = http://search.cpan.org/dist/namespace-clean;
      description = "Keep imports and functions out of your namespace";
      license = "perl";
    };
  };

  NetAddrIP = buildPerlPackage rec {
    name = "NetAddr-IP-4.075";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKER/${name}.tar.gz";
      sha256 = "0fc8jvrcp42szscnn41sxz8z8qa4fr4dr9i9s067hvrhiyxpb0mb";
    };
  };

  NetAmazonAWSSign = buildPerlPackage {
    name = "Net-Amazon-AWSSign-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NA/NATON/Net-Amazon-AWSSign-0.12.tar.gz;
      sha256 = "0gpdjz5095hd3y1xhnbv45m6q2shw0c9r7spj1jvb8hy7dmhq10x";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Perl extension to create signatures for AWS requests";
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetAmazonEC2 = buildPerlPackage rec {
    name = "Net-Amazon-EC2-0.14-stanaka-bc66577e13";
    src = fetchurl {
      url = https://github.com/stanaka/net-amazon-ec2/zipball/bc66577e1312e828e252937d95f9f5f637af6a0b;
      sha256 = "1c0k3addkaaf4zj7z87svm9xc3c06v0r06rf5rpqmps413lqisbn";
      name  = "${name}.zip";
    };
    buildInputs = [ pkgs.unzip ];
    patches =
      [ # In DescribeInstance requests, say "InstanceId.1" instead of
        # "InstanceId", as required by the Amazon spec.  EC2 tolerates
        # "InstanceId", but Nova doesn't.
        ../development/perl-modules/net-amazon-ec2-nova-compat.patch
        # Support DescribeInstancesV6.
        ../development/perl-modules/net-amazon-ec2-ipv6.patch
      ];
    propagatedBuildInputs =
      [ DigestHMAC LWP LWPProtocolHttps Moose URI ParamsValidate XMLSimple ];
    doCheck = false; # wants to create actual EC2 instances (for $$$)
  };

  NetAmazonMechanicalTurk = buildPerlPackage rec {
    name = "Net-Amazon-MechanicalTurk-1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MT/MTURK/${name}.tar.gz";
      sha256 = "17xh6qcp2sw721r8cpcal80an49264db497namms4k139fsr1yig";
    };
    patches =
      [ ../development/perl-modules/net-amazon-mechanicalturk.patch ];
    propagatedBuildInputs =
      [ DigestHMAC LWP LWPProtocolHttps URI XMLParser IOString ];
    buildInputs = [ DBI DBDSQLite ];
  };

  NetAmazonS3 = buildPerlPackage {
    name = "Net-Amazon-S3-0.60";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PF/PFIG/Net-Amazon-S3-0.60.tar.gz;
      sha256 = "628937132268e501fb82410f96636e01b183423ea133b6c362894da109d6ac81";
    };
    buildInputs = [ LWP TestException ];
    propagatedBuildInputs = [ DataStreamBulk DateTimeFormatHTTP DigestHMAC DigestMD5File FileFindRule HTTPDate HTTPMessage LWPUserAgentDetermined MIMETypes Moose MooseXStrictConstructor MooseXTypesDateTimeMoreCoercions PathClass RegexpCommon TermEncoding TermProgressBarSimple URI XMLLibXML JSON ];
    # See https://github.com/pfig/net-amazon-s3/pull/25
    patches =
      [ ../development/perl-modules/net-amazon-s3-credentials-provider.patch
        ../development/perl-modules/net-amazon-s3-moose-warning.patch
      ];
    meta = {
      description = "Use the Amazon S3 - Simple Storage Service";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  NetAmazonS3Policy = buildPerlPackage {
    name = "Net-Amazon-S3-Policy-0.1.6";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PO/POLETTIX/Net-Amazon-S3-Policy-0.1.6.tar.gz;
      sha256 = "056rhq6vsdpwi2grbmxj8341qjrz0258civpnhs78j37129nxcfj";
    };
    propagatedBuildInputs = [ JSON ];
    meta = {
      description = "Manage Amazon S3 policies for HTTP POST forms";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetAMQP = buildPerlModule {
    name = "Net-AMQP-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHIPS/Net-AMQP-0.06.tar.gz;
      sha256 = "0b2ba7de2cd7ddd5fe102a2e2ae7aeba21eaab1078bf3bfd3c5a722937256380";
    };
    doCheck = false; # failures on 32bit
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ ClassAccessor ClassDataInheritable XMLLibXML ];
    meta = {
      description = "Advanced Message Queue Protocol (de)serialization and representation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetCIDR = buildPerlPackage {
    name = "Net-CIDR-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRSAM/Net-CIDR-0.17.tar.gz;
      sha256 = "4a968e700d382cf0946e47df420d0151fbd8e0135f037d404c7c63713b66daf0";
    };
    meta = {
      description = "Manipulate IPv4/IPv6 netblocks in CIDR notation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.unix;
      maintainers = [ maintainers.bjornfor ];
    };
  };

  NetCoverArtArchive = buildPerlPackage {
    name = "Net-CoverArtArchive-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CY/CYCLES/Net-CoverArtArchive-1.02.tar.gz;
      sha256 = "1lfx8lrjgb3s11fcm243jp5sghngd9svkgmg7xmssmj34q4f49ap";
    };
    buildInputs = [ FileFindRule TryTiny ];
    propagatedBuildInputs = [ JSONAny LWP Moose namespaceautoclean ];
    meta = {
      homepage = https://github.com/metabrainz/CoverArtArchive;
      description = "Query the coverartarchive.org";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetDBus = buildPerlPackage rec {
    name = "Net-DBus-1.0.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANBERR/${name}.tar.gz";
      sha256 = "03srw98nn7r4k6fmnr5bhwsxbhgrsmzdja98jl8b8a72iayg7l5z";
    };
    propagatedBuildInputs = [ pkgs.pkgconfig pkgs.dbus XMLTwig ];
  };

  NetDNS = buildPerlPackage {
    name = "Net-DNS-0.74";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NL/NLNETLABS/Net-DNS-0.74.tar.gz;
      sha256 = "0clwl4nqzg23d6l9d9gc8ijl1lbghhfrbavjlvhd1wll5r8ayr7g";
    };
    propagatedBuildInputs = [NetIP DigestHMAC];
    doCheck = false;
  };

  NetHTTP = buildPerlPackage {
    name = "Net-HTTP-6.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/Net-HTTP-6.06.tar.gz;
      sha256 = "1m1rvniffadq99gsy25298ia3lixwymr6kan64jd3ylyi7nkqkhx";
    };
    meta = {
      description = "Low-level HTTP connection (client)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetIP = buildPerlPackage {
    name = "Net-IP-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MANU/Net-IP-1.26.tar.gz;
      sha256 = "0ffn2xqqbkfi7v303sp5dwgbv36jah3vg8r4nxhxfiv60vric3q4";
    };
    meta = {
      description = "Perl extension for manipulating IPv4/IPv6 addresses";
    };
  };

  NetLDAP = buildPerlPackage {
    name = "Net-LDAP-0.4001";
    propagatedBuildInputs = [ ConvertASN1 ];
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/perl-ldap-0.4001.tar.gz;
      sha256 = "0spwid70yxkh5zbad3ldw8yb2m5shkm59a7f0kllw8bb7ccczqps";
    };
  };

  NetOAuth = buildPerlPackage {
    name = "Net-OAuth-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KG/KGRENNAN/Net-OAuth-0.28.tar.gz;
      sha256 = "0k4h4a5048h7qgyx25ih64x0l4airx8a6d9gjq08wmxcl2fk3z3v";
    };
    buildInputs = [ TestWarn ];
    propagatedBuildInputs = [ ClassAccessor ClassDataInheritable DigestHMAC DigestSHA1 LWPUserAgent URI ];
    meta = {
      description = "An implementation of the OAuth protocol";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NetPing = buildPerlPackage {
    name = "Net-Ping-2.41";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMPETERS/Net-Ping-2.41.tar.gz;
      sha256 = "cbff21a8d323f235b70237c7ee56ffa5f22e87511e70608c027e2ec27fce47e0";
    };
    meta = {
      description = "Check a remote host for reachability";
    };
  };

  NetRabbitFoot = buildPerlPackage {
    name = "Net-RabbitFoot-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IK/IKUTA/Net-RabbitFoot-1.03.tar.gz;
      sha256 = "0544b1914e7847b32b60a643abc6f0b1fdc6d4a816afd84bcd3eee0c28b001ac";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ AnyEventRabbitMQ ConfigAny Coro JSONXS ListMoreUtils Moose MooseXAppCmd MooseXAttributeHelpers MooseXConfigFromFile ];
    meta = {
      description = "An Asynchronous and multi channel Perl AMQP client";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  NetServer = buildPerlPackage {
    name = "Net-Server-2.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RH/RHANDOM/Net-Server-2.007.tar.gz;
      sha256 = "0a03m237cw6j5bvm2yxk2b2gbfx7wj0w2x5zivi9ddqvbcad6vqw";
    };
    doCheck = false; # seems to hang waiting for connections
    meta = {
      description = "Extensible, general Perl server engine";
    };
  };

  NetSMTP = buildPerlPackage {
    name = "Net-SMTP-1.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/libnet-1.25.tar.gz;
      sha256 = "01f3l4aj3ynl8syyrl122k4bmfds77yw5q36aafrgaq22fnb3b2a";
    };
    patchPhase = "chmod a-x Configure";
    doCheck = false; # The test suite fails, because it requires network access.
  };

  NetSMTPSSL = buildPerlPackage {
    name = "Net-SMTP-SSL-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CW/CWEST/Net-SMTP-SSL-1.01.tar.gz;
      sha256 = "12b2xvrd253ngvzwf81s9han4jr94l39vs5ca70pzr3wpi39qn8k";
    };
    propagatedBuildInputs = [IOSocketSSL];
  };

  NetSMTPTLS = buildPerlPackage {
    name = "Net-SMTP-TLS-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AW/AWESTHOLM/Net-SMTP-TLS-0.12.tar.gz;
      sha256 = "19g48kabj22v66jbf69q78xplhi7r1y2kdbddfwh4xy3g9k75rzg";
    };
    propagatedBuildInputs = [IOSocketSSL DigestHMAC];
  };

  NetSMTPTLSButMaintained = buildPerlPackage {
    name = "Net-SMTP-TLS-ButMaintained-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FA/FAYLAND/Net-SMTP-TLS-ButMaintained-0.24.tar.gz;
      sha256 = "0vi5cv7f9i96hgp3q3jpxzn1ysn802kh5xc304f8b7apf67w15bb";
    };
    propagatedBuildInputs = [NetSSLeay DigestHMAC IOSocketSSL];
  };

  NetSNMP = buildPerlPackage rec {
    name = "Net-SNMP-6.0.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DT/DTOWN/Net-SNMP-v6.0.1.tar.gz";
      sha256 = "0hdpn1cw52x8cw24m9ayzpf4rwarm0khygn1sv3wvwxkrg0pphql";
    };
    doCheck = false; # The test suite fails, see https://rt.cpan.org/Public/Bug/Display.html?id=85799
  };

  NetSSLeay = buildPerlPackage rec {
    name = "Net-SSLeay-1.58";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIKEM/${name}.tar.gz";
      sha256 = "0mizg2g07fa4c13zpnhmjc87psal5gp5hi23kqpynigmkp0m1p0b";
    };
    buildInputs = [ pkgs.openssl ];
    OPENSSL_PREFIX = pkgs.openssl;
    doCheck = false; # Test performs network access.
    meta = {
      description = "Perl extension for using OpenSSL";
      license = "SSLeay";
    };
  };

  NetTwitterLite = buildPerlPackage {
    name = "Net-Twitter-Lite-0.11002";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MM/MMIMS/Net-Twitter-Lite-0.11002.tar.gz;
      sha256 = "032gyn1h3r5d83wvz7nj3k7g50wcf73lbbmjc18466ml90vigys0";
    };
    propagatedBuildInputs = [ CryptSSLeay LWPUserAgent NetOAuth URI ];
    doCheck = false;
    meta = {
      homepage = http://github.com/semifor/Net-Twitter-Lite;
      description = "A perl interface to the Twitter API";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  NumberCompare = buildPerlPackage rec {
    name = "Number-Compare-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "09q8i0mxvr7q9vajwlgawsi0hlpc119gnhq4hc933d03x0vkfac3";
    };
  };

  NumberFormat = buildPerlPackage rec {
    name = "Number-Format-1.73";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Number/${name}.tar.gz";
      sha256 = "0v74hscnc807kf65x0am0rddk74nz7nfk3gf16yr5ar1xwibg8l4";
    };
  };

  ObjectAccessor = buildPerlPackage {
    name = "Object-Accessor-0.48";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Object-Accessor-0.48.tar.gz;
      sha256 = "76cb824a27b6b4e560409fcf6fd5b3bfbbd38b72f1f3d37ed0b54bd9c0baeade";
    };
    meta = {
      description = "Per object accessors";
      license = "perl";
    };
  };

  ObjectInsideOut = buildPerlPackage {
    name = "Object-InsideOut-3.98";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JD/JDHEDDEN/Object-InsideOut-3.98.tar.gz;
      sha256 = "1zxfm2797p8b9dsvnbgd6aa4mgpxqxjqzbpfbla1g7f9alxm9f1z";
    };
    propagatedBuildInputs = [ ExceptionClass ];
    meta = {
      description = "Comprehensive inside-out object support module";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  ObjectSignature = buildPerlPackage {
    name = "Object-Signature-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Object-Signature-1.07.tar.gz;
      sha256 = "0c8l7195bjvx0v6zmkgdnxvwg7yj2zq8hi7xd25a3iikd12dc4f6";
    };
  };

  OLEStorageLight = buildPerlPackage rec {
    name = "OLE-Storage_Lite-0.19";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/${name}.tar.gz";
      sha256 = "179cxwqxb0f9dpx8954nvwjmggxxi5ndnang41yav1dx6mf0abp7";
    };
  };

  Opcodes = buildPerlPackage {
    name = "Opcodes-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/Opcodes-0.14.tar.gz;
      sha256 = "7f7365447e4d1c5b87b43091448f0488e67c9f036b26c022a5409cd73d343893";
    };
    meta = {
      description = "More Opcodes information from opnames.h and opcode.h";
      license = "perl";
    };
  };

  OpenGL = buildPerlPackage rec {
    name = "OpenGL-0.6703";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHM/${name}.tar.gz";
      sha256 = "0k2k8zg84qj1ry77i9dvmfdfpg13s6117wy5bc4nvnzv37qcvy32";
    };

    buildInputs = with pkgs; [ mesa mesa_glu freeglut xlibs.libX11 xlibs.libXi xlibs.libXmu xlibs.libXext xdummy ];

    patches = [ ../development/perl-modules/perl-opengl.patch ];

    configurePhase = ''
      substituteInPlace Makefile.PL \
        --replace "@@libpaths@@" '${stdenv.lib.concatStringsSep "\n" (map (f: "-L${f}/lib") buildInputs)}'

      cp -v ${../development/perl-modules/perl-opengl-gl-extensions.txt} utils/glversion.txt

      perl Makefile.PL PREFIX=$out INSTALLDIRS=site $makeMakerFlags
    '';

    doCheck = false;
  };

  NetOpenIDCommon = buildPerlPackage rec {
    name = "Net-OpenID-Common-1.18";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/${name}.tar.gz";
      sha256 = "13hy5j6hcggb4l2r4pnwdh30p20wwja0chpmqm8y6wnnsp1km07f";
    };
    propagatedBuildInputs = [ CryptDHGMP URI HTMLParser HTTPMessage XMLSimple ];
  };

  NetOpenIDConsumer = buildPerlPackage rec {
    name = "Net-OpenID-Consumer-1.15";
    src = fetchurl {
      url = "mirror://cpan/authors/id/W/WR/WROG/${name}.tar.gz";
      sha256 = "1nh9988436rmmmd6x2zz1fyrqy2005a1gvqzgvnc1pg2ylg61fqf";
    };
    propagatedBuildInputs = [ NetOpenIDCommon JSON LWP ];
  };

  PackageConstants = buildPerlPackage {
    name = "Package-Constants-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BINGOS/Package-Constants-0.04.tar.gz;
      sha256 = "7e09a88da2c0df24f498eb3a133f7d979404a7bc853f21afa2ba68dfd859a880";
    };
    meta = {
      description = "List constants defined in a package";
      license = "perl";
    };
  };

  PackageDeprecationManager = buildPerlPackage {
    name = "Package-DeprecationManager-0.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Package-DeprecationManager-0.13.tar.gz;
      sha256 = "0fkvq3xxwc3l5hg64dr9sj3l12dl59i44cg407qx9sd6r51j3qfi";
    };
    buildInputs = [ TestRequires TestFatal ];
    propagatedBuildInputs = [ ParamsUtil SubInstall ListMoreUtils ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Manage deprecation warnings for your distribution";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  PackageStash = buildPerlPackage {
    name = "Package-Stash-0.37";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Package-Stash-0.37.tar.gz;
      sha256 = "06ab05388f9130cd377c0e1d3e3bafeed6ef6a1e22104571a9e1d7bfac787b2c";
    };
    buildInputs = [ DistCheckConflicts TestFatal TestRequires ];
    propagatedBuildInputs = [ DistCheckConflicts ModuleImplementation ];
    meta = {
      homepage = http://metacpan.org/release/Package-Stash;
      description = "Routines for manipulating stashes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PackageStashXS = buildPerlPackage {
    name = "Package-Stash-XS-0.28";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Package-Stash-XS-0.28.tar.gz;
      sha256 = "11nl69n8i56p91pd0ia44ip0vpv2cxwpbfakrv01vvv8az1cbn13";
    };
    buildInputs = [ TestRequires TestFatal ];
    meta = {
      homepage = http://metacpan.org/release/Package-Stash-XS;
      description = "Faster and more correct implementation of the Package::Stash API";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Pango = buildPerlPackage rec {
    name = "Pango-1.226";
    src = fetchurl {
      url = "mirror://cpan/authors/id/X/XA/XAOC/${name}.tar.gz";
      sha256 = "0r4jx7d6gj6ixk2r5yr70biy1lpjxir08aywkw02g85wg6zkjw4z";
    };
    buildInputs = [ ExtUtilsDepends ExtUtilsPkgConfig pkgs.pango ];
    propagatedBuildInputs = [ Cairo Glib ];
    meta = {
      homepage = http://gtk2-perl.sourceforge.net/;
      description = "Layout and render international text";
      maintainers = with maintainers; [ nckx ];
      license = stdenv.lib.licenses.lgpl21Plus;
    };
  };

  ParamsClassify = buildPerlPackage rec {
    name = "Params-Classify-0.013";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Params/${name}.tar.gz";
      sha256 = "1d4ysd95flszrxrnjgy6s7b80jkagjsb939h42i2hix4q20sy0a1";
    };
    buildInputs = [ ExtUtilsParseXS ];
  };

  ParamsUtil = buildPerlPackage {
    name = "Params-Util-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Params-Util-1.07.tar.gz;
      sha256 = "0v67sx93yhn7xa0nh9mnbf8mixf54czk6wzrjsp6dzzr5hzyrw9h";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Simple, compact and correct param-checking functions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParamsValidate = buildPerlModule {
    name = "Params-Validate-1.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Params-Validate-1.08.tar.gz;
      sha256 = "0641hbz5bx6jnk8dx2djnkd67fh7h1zx6x1bgmivkrh2yky9ch6h";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ModuleImplementation ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Validate method/function parameters";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  PARDist = buildPerlPackage {
    name = "PAR-Dist-0.49";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSCHUPP/PAR-Dist-0.49.tar.gz;
      sha256 = "078ycyn8pw3rba4k3qwcqrqfcym5c1pivymwa0bvs9sab45j4iwy";
    };
    meta = {
      description = "Create and manipulate PAR distributions";
    };
  };

  Parent = buildPerlPackage {
    name = "parent-0.228";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/parent-0.228.tar.gz;
      sha256 = "0w0i02y4z8465z050kml57mvhv7c5gl8w8ivplhr3cms0zbaq87b";
    };
  };

  ParseCPANMeta = buildPerlPackage {
    name = "Parse-CPAN-Meta-1.4414";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Parse-CPAN-Meta-1.4414.tar.gz;
      sha256 = "cd7608154dfb72c9e110f012befe6b75d78448cb3e761716b60aa7545e16ca1b";
    };
    propagatedBuildInputs = [ CPANMetaYAML JSONPP ];
    meta = {
      homepage = https://github.com/Perl-Toolchain-Gang/Parse-CPAN-Meta;
      description = "Parse META.yml and META.json CPAN metadata files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ParseDebControl = buildPerlPackage rec {
    name = "Parse-DebControl-2.005";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JA/JAYBONCI/${name}.tar.gz";
      sha256 = "0ad78qri4sg9agghqdm83xsjgks94yvffs23kppy7mqjy8gwwjxn";
    };
    buildInputs = [ TestPod LWPUserAgent ];
    propagatedBuildInputs = [ IOStringy ];
    meta = with stdenv.lib; {
      homepage = http://search.cpan.org/~jaybonci/Parse-DebControl;
      license = with licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ nckx ];
    };
  };

  ParseRecDescent = buildPerlPackage rec {
    name = "Parse-RecDescent-1.967009";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JT/JTBRAUN/${name}.tar.gz";
      sha256 = "11y6fpz4j6kdimyaz2a6ig0jz0x7csqslhxaipxnjqi5h85hy071";
    };
  };

  PathClass = buildPerlPackage {
    name = "Path-Class-0.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KW/KWILLIAMS/Path-Class-0.33.tar.gz;
      sha256 = "0xy6s04xpslpzbb90x67yvfv0pjqnj1szxlx16vfx690iskcd36d";
    };
    meta = {
      description = "Cross-platform path specification manipulation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PathTiny = buildPerlPackage {
    name = "Path-Tiny-0.052";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.052.tar.gz;
      sha256 = "1b70yhbdww9k5m4a4lhdd71jrxdxhi10533slmxynxa04nyn2f0a";
    };
    buildInputs = [ DevelHide Filepushd TestDeep TestFailWarnings TestFatal perl ];
    propagatedBuildInputs = [ autodie ];
    meta = {
      homepage = https://metacpan.org/release/Path-Tiny;
      description = "File path utility";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
    preConfigure =
      ''
        substituteInPlace lib/Path/Tiny.pm --replace 'use File::Spec 3.40' \
          'use File::Spec 3.39'
      '';
    # This appears to be currently failing tests, though I don't know why.
    # -- ocharles
    doCheck = false;
  };

  PathTools = buildPerlPackage {
    name = "PathTools-3.47";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/PathTools-3.47.tar.gz;
      sha256 = "caa8d4b45372b8cb0ef0f6f696efa3a60b0fd394b115cad39a7fbb8f6bd38026";
    };
  };

  Perl5lib = buildPerlPackage rec {
    name = "perl5lib-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/N/NO/NOBULL/${name}.tar.gz";
      sha256 = "1b6fgs8wy2a7ff8rr1qdvdghhvlpr1pv760k4i2c8lq1hhjnkf94";
    };
  };

  PerlCritic = buildPerlModule {
    name = "Perl-Critic-1.125";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TH/THALJEF/Perl-Critic-1.125.tar.gz;
      sha256 = "503b718356b14d4c00ed486b66a0f622f4bef2b206be406ee7922c8270463fa1";
    };
    buildInputs = [ TestDeep ];
    propagatedBuildInputs = [ BKeywords ConfigTiny EmailAddress ExceptionClass FileHomeDir FileWhich IOString ListMoreUtils ModulePluggable PPI PPIxRegexp PPIxUtilities PerlTidy PodSpell Readonly StringFormat TaskWeaken ];
    meta = {
      homepage = http://perlcritic.com;
      description = "Critique Perl source code for best-practices";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  PerlIOeol = buildPerlPackage {
    name = "PerlIO-eol-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/PerlIO-eol-0.14.tar.gz;
      sha256 = "1rwj0r075jfvvd0fnzgdqldc7qdb94wwsi21rs2l6yhcv0380fs2";
    };
  };

  PerlIOutf8_strict = buildPerlModule {
    name = "PerlIO-utf8_strict-0.005";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/PerlIO-utf8_strict-0.005.tar.gz;
      sha256 = "8956064ac2bf1f79bac868a9db93a44aade77df4d3e8b07ce31a40f987ef2e0e";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "Fast and correct UTF-8 IO";
      license = "perl";
    };
  };

  PerlIOviadynamic = buildPerlPackage {
    name = "PerlIO-via-dynamic-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/PerlIO-via-dynamic-0.14.tar.gz;
      sha256 = "0jbb3xpbqzmr625blvnjszd69l3cwxzi7bhmkj5x48dgv3s7mkca";
    };
  };

  PerlIOviaQuotedPrint = buildPerlPackage {
    name = "PerlIO-via-QuotedPrint-0.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/PerlIO-via-QuotedPrint-0.08.tar.gz;
      sha256 = "9b999a54134816de5217f7a8cac69fa5d89ab32dc589fcd5c9e84902f608cb9c";
    };
    meta = {
      description = "PerlIO Layer for quoted-printable encoding";
    };
  };

  PerlIOviasymlink = buildPerlPackage {
    name = "PerlIO-via-symlink-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/PerlIO-via-symlink-0.05.tar.gz;
      sha256 = "0lidddcaz9anddqrpqk4zwm550igv6amdhj86i2jjdka9b1x81s1";
    };
  };

  PerlMagick = buildPerlPackage rec {
    name = "PerlMagick-6.89-1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JC/JCRISTY/${name}.tar.gz";
      sha256 = "0n9afy1z5bhf9phrbahnkwhgcmijn8jggpbzwrivw1zhliliiy68";
    };
    buildInputs = [ pkgs.imagemagick ];
    preConfigure =
      ''
        sed -i -e 's|my \$INC_magick = .*|my $INC_magick = "-I${pkgs.imagemagick}/include/ImageMagick";|' Makefile.PL
      '';
    doCheck = false;
  };

  PerlOSType = buildPerlPackage rec {
    name = "Perl-OSType-1.007";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/${name}.tar.gz";
      sha256 = "0aryn8dracfjfnks07b5rvsza4csinlsj6cn92jv3sv8sg3rmdxk";
    };
  };

  PerlTidy = buildPerlPackage rec {
    name = "Perl-Tidy-20130922";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHANCOCK/${name}.tar.gz";
      sha256 = "0qmp6308917lsvms5dbihdj85cnkhy821azc5i6q3p3703qdd375";
    };
  };

  PHPSerialization = buildPerlPackage {
    name = "PHP-Serialization-0.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/PHP-Serialization-0.34.tar.gz;
      sha256 = "0yphqsgg7zrar2ywk2j2fnjxmi9rq32yf0p5ln8m9fmfx4kd84mr";
    };
    meta = {
      description = "Simple flexible means of converting the output of PHP's serialize() into the equivalent Perl memory structure, and vice versa";
      license = "unknown";
    };
  };

  Plack = buildPerlPackage {
    name = "Plack-1.0031";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-1.0031.tar.gz;
      sha256 = "0vvppxs36729lggrx4s1gn37lzsm794wfkm3k386bwhkmk7sr31i";
    };
    buildInputs = [ FileShareDirInstall TestRequires ];
    propagatedBuildInputs = [ ApacheLogFormatCompiler DevelStackTrace DevelStackTraceAsHTML FileShareDir FilesysNotifySimple HTTPBody HTTPMessage HashMultiValue LWP StreamBuffered TestTCP TryTiny URI ];
    meta = {
      homepage = https://github.com/plack/Plack;
      description = "Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareDebug = buildPerlPackage {
    name = "Plack-Middleware-Debug-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-Middleware-Debug-0.14.tar.gz;
      sha256 = "0349563ic6fw4kwx3k3l4v9gq59b5cpymmn1k8bkxsw9n7s10rb9";
    };
    buildInputs = [ TestRequires ];
    propagatedBuildInputs = [ ClassMethodModifiers DataDump FileShareDir ModuleVersions Plack TextMicroTemplate ];
    meta = {
      description = "Display information about the current request/response";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  PlackMiddlewareFixMissingBodyInRedirect = buildPerlPackage {
    name = "Plack-Middleware-FixMissingBodyInRedirect-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SW/SWEETKID/Plack-Middleware-FixMissingBodyInRedirect-0.11.tar.gz;
      sha256 = "eb4d4232344e7da3217347b847736ea55df962d11b870a225315d9241e8fbefb";
    };
    buildInputs = [ HTTPMessage Plack ];
    propagatedBuildInputs = [ HTMLParser Plack ];
    meta = {
      homepage = https://github.com/Sweet-kid/Plack-Middleware-FixMissingBodyInRedirect;
      description = "Plack::Middleware which sets body for redirect response, if it's not already set";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareMethodOverride = buildPerlModule {
    name = "Plack-Middleware-MethodOverride-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/Plack-Middleware-MethodOverride-0.10.tar.gz;
      sha256 = "f8d6a33b56d69dddd5db289f855e100d86ff39099abe31ef40e2672d0dc5568d";
    };
    propagatedBuildInputs = [ Plack URI ];
    meta = {
      homepage = http://search.cpan.org/dist/Plack-Middleware-MethodOverride/;
      description = "Override REST methods to Plack apps via POST";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareRemoveRedundantBody = buildPerlPackage {
    name = "Plack-Middleware-RemoveRedundantBody-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SW/SWEETKID/Plack-Middleware-RemoveRedundantBody-0.05.tar.gz;
      sha256 = "a0676e1c792bea7f25f1d901bee59054d35012d5ea8cd42529d336143fa87cd8";
    };
    buildInputs = [ HTTPMessage Plack ];
    propagatedBuildInputs = [ Plack ];
    meta = {
      homepage = https://github.com/Sweet-kid/Plack-Middleware-RemoveRedundantBody;
      description = "Plack::Middleware which sets removes body for HTTP response if it's not required";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackMiddlewareReverseProxy = buildPerlPackage {
    name = "Plack-Middleware-ReverseProxy-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Plack-Middleware-ReverseProxy-0.15.tar.gz;
      sha256 = "1zmsccdy6wr5hxzj07r1nsmaymyibk87p95z0wzknjw10lwmqs9f";
    };
    propagatedBuildInputs = [ Plack ];
    meta = {
      description = "Supports app to run as a reverse proxy backend";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PlackTestExternalServer = buildPerlPackage {
    name = "Plack-Test-ExternalServer-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Plack-Test-ExternalServer-0.01.tar.gz;
      sha256 = "1dbg1p3rgvvbkkpvca5jlc2mzx8iqyiybk88al93pvbca65h1g7h";
    };
    propagatedBuildInputs = [ HTTPMessage LWPUserAgent Plack TestTCP URI ];
    meta = {
      description = "Run HTTP tests on external live servers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PPI = buildPerlPackage {
    name = "PPI-1.220";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MITHALDU/PPI-1.220.tar.gz;
      sha256 = "1e15be50e7d95a36d351af8bf5074f6695a2c72165e586d93e616183e7602b83";
    };
    buildInputs = [ ClassInspector FileRemove TestNoWarnings TestObject TestSubCalls ];
    propagatedBuildInputs = [ Clone IOString ListMoreUtils ParamsUtil TaskWeaken ];

    # Remove test that fails due to unexpected shebang after
    # patchShebang.
    preCheck = "rm t/03_document.t";

    meta = {
      homepage = https://github.com/adamkennedy/PPI;
      description = "Parse, Analyze and Manipulate Perl (without perl)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  PPIxRegexp = buildPerlPackage {
    name = "PPIx-Regexp-0.036";
    src = fetchurl {
      url = mirror://cpan/authors/id/W/WY/WYANT/PPIx-Regexp-0.036.tar.gz;
      sha256 = "1nnaxf1dmywacdgh8f1s2ki8jkrf2vi6bfhk70p1r9k1001idlfk";
    };
    propagatedBuildInputs = [ ListMoreUtils PPI TaskWeaken ];
    meta = {
      description = "Parse regular expressions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PPIxUtilities = buildPerlPackage {
    name = "PPIx-Utilities-1.001000";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EL/ELLIOTJS/PPIx-Utilities-1.001000.tar.gz;
      sha256 = "03a483386fd6a2c808f09778d44db06b02c3140fb24ba4bf12f851f46d3bcb9b";
    };
    buildInputs = [ PPI TestDeep ];
    propagatedBuildInputs = [ ExceptionClass PPI Readonly TaskWeaken ];
    meta = {
      description = "Extensions to L<PPI|PPI>";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProcProcessTable = buildPerlPackage {
    name = "Proc-ProcessTable-0.51";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JW/JWB/Proc-ProcessTable-0.51.tar.gz;
      sha256 = "66636e102985a2a05ef4334b53a7893d627c192fac5dd7ff37dd1a0a50c0128d";
    };
    meta = {
      description = "Perl extension to access the unix process table";
      license = "perl";
    };
  };

  ProcSafeExec = buildPerlPackage {
    name = "Proc-SafeExec-1.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BI/BILBO/Proc-SafeExec-1.5.tar.gz;
      sha256 = "1b4d0908bcac563d34a7e5be61c5da3eee98e4a6c7fa68c2670cc5844b5a2d78";
    };
  };

  ProcWaitStat = buildPerlPackage rec {
    name = "Proc-WaitStat-1.00";
    src = fetchurl {
      url = "mirror://cpan//authors/id/R/RO/ROSCH/${name}.tar.gz";
      sha256 = "1g3l8jzx06x4l4p0x7fyn4wvg6plfzl420irwwb9v447wzsn6xfh";
    };
    propagatedBuildInputs = [ IPCSignal ];
  };

  PSGI = buildPerlPackage rec {
    name = "PSGI-1.102";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/${name}.tar.gz";
      sha256 = "0iqzxs8fv63510knm3zr3jr3ky4x7diwd7y24mlshzci81kl8v55";
    };
  };

  PadWalker = buildPerlPackage {
    name = "PadWalker-1.98";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROBIN/PadWalker-1.98.tar.gz;
      sha256 = "0v2pldb5awflf10w1p9pwn8w37lkpfc2h459gd9zz6p57883ibw0";
    };
    meta = {
    };
  };

  Perl6Junction = buildPerlPackage rec {
    name = "Perl6-Junction-1.60000";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CF/CFRANKS/${name}.tar.gz";
      sha256 = "0r3in9pyrm6wfrhcvxbq5w1617x8x5537lxj9hdzks4pa7l7a8yh";
    };
  };

  PerlMinimumVersion = buildPerlPackage {
    name = "Perl-MinimumVersion-1.32";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Perl-MinimumVersion-1.32.tar.gz;
      sha256 = "fa9884abee80c7afc260a28a4e6a6804a0335f5f582e3931c3a53b8504f1a27a";
    };
    buildInputs = [ TestScript ];
    propagatedBuildInputs = [ FileFindRule FileFindRulePerl PPI PPIxRegexp ParamsUtil PerlCritic ];
    meta = {
      description = "Find a minimum required version of perl for Perl code";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlPrereqScanner = buildPerlPackage {
    name = "Perl-PrereqScanner-1.019";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Perl-PrereqScanner-1.019.tar.gz;
      sha256 = "1ndgq2c7s1042c3zxjsmjfpf4lnwfg6w36hmvhh3yk9qihcprbgj";
    };
    buildInputs = [ PPI TryTiny ];
    propagatedBuildInputs = [ GetoptLongDescriptive ListMoreUtils ModulePath Moose PPI ParamsUtil StringRewritePrefix namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/perl-prereqscanner;
      description = "A tool to scan your Perl code for its prerequisites";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PerlVersion = buildPerlPackage {
    name = "Perl-Version-1.011";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AN/ANDYA/Perl-Version-1.011.tar.gz;
      sha256 = "12ede8a87a12574fcd525c1d23d8a5b2fa2918ff5b78eb56cf701251a81af19b";
    };
    propagatedBuildInputs = [ FileSlurp ];
    meta = {
      description = "Parse and manipulate Perl version strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodChecker = buildPerlPackage {
    name = "Pod-Checker-1.71";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAREKR/Pod-Checker-1.71.tar.gz;
      sha256 = "4b90e745f4d6357bb7e8999e0e7d192216b98e3f3c8a86fa6ed446f8c36601df";
    };
  };

  PodCoverage = buildPerlPackage rec {
    name = "Pod-Coverage-0.23";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RC/RCLAMP/${name}.tar.gz";
      sha256 = "01xifj83dv492lxixijmg6va02rf3ydlxly0a9slmx22r6qa1drh";
    };
    propagatedBuildInputs = [DevelSymdump];
  };

  PodCoverageTrustPod = buildPerlPackage {
    name = "Pod-Coverage-TrustPod-0.100003";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Pod-Coverage-TrustPod-0.100003.tar.gz;
      sha256 = "19lyc5a5hg3pqhw0k5fnd0q4l2mrdq0ck4kw1smjvwkccp24431z";
    };
    propagatedBuildInputs = [ PodCoverage PodEventual ];
    meta = {
      homepage = https://github.com/rjbs/pod-coverage-trustpod;
      description = "Allow a module's pod to contain Pod::Coverage hints";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodElemental = buildPerlPackage {
    name = "Pod-Elemental-0.103000";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Pod-Elemental-0.103000.tar.gz;
      sha256 = "0ykf49n6ysm7ab5zwm8a009zzrzsnhxw94a9jvbq80yywzhnm847";
    };
    buildInputs = [ TestDeep TestDifferences ];
    propagatedBuildInputs = [ MixinLinewise Moose MooseAutobox MooseXTypes PodEventual StringRewritePrefix StringTruncate SubExporter SubExporterForMethods TestDeep TestDifferences namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/pod-elemental;
      description = "Work with nestable Pod elements";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodElementalPerlMunger = buildPerlPackage {
    name = "Pod-Elemental-PerlMunger-0.200003";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Pod-Elemental-PerlMunger-0.200003.tar.gz;
      sha256 = "94b3abe6894c96b7990cb324a3789af05489dc2b5d1ec8961d37309cc6e8c243";
    };
    buildInputs = [ Moose PodElemental ];
    propagatedBuildInputs = [ ListMoreUtils Moose PPI ParamsUtil PodElemental namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/Pod-Elemental-PerlMunger;
      description = "A thing that takes a string of Perl and rewrites its documentation";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = [ maintainers.rycee ];
    };
  };

  PodEscapes = buildPerlPackage {
    name = "Pod-Escapes-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Pod-Escapes-1.06.tar.gz;
      sha256 = "15dpzlgc2ywyxk2svc810nmyx6pm1nj8cji7a0rqr9x6m0v11xdm";
    };
  };

  PodEventual = buildPerlPackage {
    name = "Pod-Eventual-0.093330";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Pod-Eventual-0.093330.tar.gz;
      sha256 = "29de14a69df8a26f7e8ff73daca5afa7acc84cc9b7ae28093a5b1af09a4830b6";
    };
    propagatedBuildInputs = [ MixinLinewise TestDeep ];
    meta = {
      description = "Read a POD document as a series of trivial events";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodParser = buildPerlPackage {
    name = "Pod-Parser-1.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAREKR/Pod-Parser-1.63.tar.gz;
      sha256 = "dbe0b56129975b2f83a02841e8e0ed47be80f060686c66ea37e529d97aa70ccd";
    };
    meta = {
      description = "Modules for parsing/translating POD format documents";
      license = "unknown";
    };
  };

  PodLaTeX = buildPerlModule {
    name = "Pod-LaTeX-0.61";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJENNESS/Pod-LaTeX-0.61.tar.gz;
      sha256 = "15a840ea1c8a76cd3c865fbbf2fec33b03615c0daa50f9c800c54e0cf0659d46";
    };
    propagatedBuildInputs = [ if_ ];
    meta = {
      homepage = http://github.com/timj/perl-Pod-LaTeX/tree/master;
      description = "Convert Pod data to formatted Latex";
      license = "perl";
    };
  };

  podlators = buildPerlPackage {
    name = "podlators-2.5.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RR/RRA/podlators-2.5.3.tar.gz;
      sha256 = "c80d6d65a8694720deff1c6b2067d7564727db713b6d6b536afbad70299647d1";
    };
    meta = {
      description = "Convert POD data to various other formats";
      license = "perl";
    };
  };

  podlinkcheck = buildPerlPackage {
    name = "podlinkcheck-12";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KR/KRYDE/podlinkcheck-12.tar.gz;
      sha256 = "c5da0e390b58655934e1df57937d29d7de13b99f5638fe44833832a5b39c8aa5";
    };
    propagatedBuildInputs = [ FileFindIterator IPCRun constantdefer libintlperl ];
    meta = with stdenv.lib; {
      homepage = http://user42.tuxfamily.org/podlinkcheck/index.html;
      description = "Check POD L<> link references";
      license = licenses.gpl3Plus;
    };
  };

  PodPerldoc = buildPerlPackage {
    name = "Pod-Perldoc-3.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MALLEN/Pod-Perldoc-3.25.tar.gz;
      sha256 = "f1a4b3ac7aa244485456b0e8733c773bbb39ae35b01a59515f6cba6bbe293a84";
    };
    meta = {
      description = "Look up Perl documentation in Pod format";
      license = "perl";
    };
  };

  PodPlainer = buildPerlPackage {
    name = "Pod-Plainer-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RM/RMBARKER/Pod-Plainer-1.04.tar.gz;
      sha256 = "1bbfbf7d1d4871e5a83bab2137e22d089078206815190eb1d5c1260a3499456f";
    };
    meta = {
      description = "Perl extension for converting Pod to old-style Pod";
      license = "perl";
    };
  };

  PodMarkdown = buildPerlPackage {
    name = "Pod-Markdown-2.000";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RW/RWSTAUNER/Pod-Markdown-2.000.tar.gz;
      sha256 = "0qix7gmrc2ypm5dl1w5ajnjy32xlmy73wb3zycc1pxl5lipigsx8";
    };
    buildInputs = [ TestDifferences ];
    meta = {
      homepage = https://github.com/rwstauner/Pod-Markdown;
      description = "Convert POD to Markdown";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  PodSimple = buildPerlPackage {
    name = "Pod-Simple-3.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AR/ARANDAL/Pod-Simple-3.05.tar.gz;
      sha256 = "1j0kqcvr9ykcqlkr797j1npkbggykb3p4w5ri73s8mi163lzxkqb";
    };
    propagatedBuildInputs = [constant PodEscapes];
  };

  PodSpell = buildPerlPackage rec {
    name = "Pod-Spell-1.01";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SB/SBURKE/${name}.tar.gz";
      sha256 = "938648dca5b62e591783347f9d4d4e2a5239f9629c6adfed9a581b9457ef7d2e";
    };
  };

  PodUsage = buildPerlPackage {
    name = "Pod-Usage-1.67";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MAREKR/Pod-Usage-1.67.tar.gz;
      sha256 = "c8be6d29b0dfe304c4ddfcc140f93d4c4de7a8362ea6e2651611c288b53cc68a";
    };
    propagatedBuildInputs = [ perl ];
    meta = {
      description = "Pod::Usage extracts POD documentation and shows usage information";
    };
  };

  PodWeaver = buildPerlPackage {
    name = "Pod-Weaver-4.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Pod-Weaver-4.004.tar.gz;
      sha256 = "0hw500qkbmnwm385za5x7ypijx0lqk8cfc9jq232v95ka0hqcg29";
    };
    buildInputs = [ PPI SoftwareLicense TestDifferences ];
    propagatedBuildInputs = [ ConfigMVP ConfigMVPReaderINI DateTime ListMoreUtils LogDispatchouli Moose MooseAutobox ParamsUtil PodElemental StringFlogger StringFormatter StringRewritePrefix namespaceautoclean ];
    meta = {
      homepage = https://github.com/rjbs/pod-weaver;
      description = "Weave together a Pod document from an outline";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ProbePerl = buildPerlPackage rec {
    name = "Probe-Perl-0.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KW/KWILLIAMS/${name}.tar.gz";
      sha256 = "0c9wiaz0mqqknafr4jdr0g2gdzxnn539182z0icqaqvp5qgd5r6r";
    };
  };

  Readonly = buildPerlPackage rec {
    name = "Readonly-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROODE/${name}.tar.gz";
      sha256 = "1shkyxajh6l87nif47ygnfxjwvqf3d3kjpdvxaff4957vqanii2k";
    };
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  ReadonlyXS = buildPerlPackage rec {
    name = "Readonly-XS-1.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RO/ROODE/${name}.tar.gz";
      sha256 = "8ae5c4e85299e5c8bddd1b196f2eea38f00709e0dc0cb60454dc9114ae3fff0d";
    };
  };

  Redis = buildPerlPackage {
    name = "Redis-1.2001";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DP/DPAVLIN/Redis-1.2001.tar.gz;
      sha256 = "1d16dr2qjmb3vswghrk5ygggcmz2rzw7qnw3g87prwi08z5ryih0";
    };
    buildInputs = [ IOString TestDeep TestFatal ];
    propagatedBuildInputs = [ TryTiny ];
    meta = {
      homepage = http://metacpan.org/release/Redis/;
      description = "Perl binding for Redis database";
      license = stdenv.lib.licenses.artistic2;
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  RegexpAssemble = buildPerlPackage rec {
    name = "Regexp-Assemble-0.35";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Regexp/${name}.tar.gz";
      sha256 = "1msxrriq74q8iacn2hkcw6g4qjjwv777avryiyz1w29h55mwq083";
    };
  };

  RegexpCommon = buildPerlPackage {
    name = "Regexp-Common-2013031301";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABIGAIL/Regexp-Common-2013031301.tar.gz;
      sha256 = "729a8198d264aa64ecbb233ff990507f97fbb66bda746b95f3286f50f5f25c84";
    };
    meta = with stdenv.lib; {
      description = "Provide commonly requested regular expressions";
      license = licenses.mit;
    };
  };

  RegexpCopy = buildPerlPackage rec {
    name = "Regexp-Copy-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JD/JDUNCAN/${name}.tar.gz";
      sha256 = "09c8xb43p1s6ala6g4274az51mf33phyjkp66dpvgkgbi1xfnawp";
    };
  };

  RegexpParser = buildPerlPackage {
    name = "Regexp-Parser-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/Regexp-Parser-0.21.tar.gz;
      sha256 = "d70cb66821f1f67a9b1ff53f0fa33c06aec8693791e0a5943be6760c25d2768d";
    };
    meta = {
      homepage = http://wiki.github.com/toddr/Regexp-Parser;
      description = "Base class for parsing regexes";
      license = "unknown";
    };
  };

  RESTUtils = buildPerlPackage {
    name = "REST-Utils-0.6";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JA/JALDHAR/REST-Utils-0.6.tar.gz;
      sha256 = "1zdrf3315rp2b8r9dwwj5h93xky7i33iawf4hzszwcddhzflmsfl";
    };
    buildInputs = [ TestWWWMechanizeCGI ];
    meta = {
      homepage = http://jaldhar.github.com/REST-Utils;
      description = "Utility functions for REST applications";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  RpcXML = buildPerlPackage {
    name = "RPC-XML-0.78";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJRAY/RPC-XML-0.78.tar.gz;
      sha256 = "0spci3sj2hq9k916sk9k2gchqrbnz9lwmlcnwf1k33wzl8j2gh52";
    };
    propagatedBuildInputs = [LWP XMLLibXML XMLParser];
    doCheck = false;
  };

  ReturnValue = buildPerlPackage {
    name = "Return-Value-1.666004";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Return-Value-1.666004.tar.gz;
      sha256 = "0xr7ic212p36arzdpph2l2yy1y88c7qaf4nng3gqb29zc9kzy3bc";
    };
  };

  RoleHasMessage = buildPerlPackage {
    name = "Role-HasMessage-0.006";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Role-HasMessage-0.006.tar.gz;
      sha256 = "1lylfvarjfy6wy34dfny3032pc6r33mjby5yzzhmxybg8zhdp9pn";
    };
    buildInputs = [ Moose ];
    propagatedBuildInputs = [ Moose MooseXRoleParameterized StringErrf TryTiny namespaceclean ];
    meta = {
      description = "A thing with a message method";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleIdentifiable = buildPerlPackage {
    name = "Role-Identifiable-0.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Role-Identifiable-0.007.tar.gz;
      sha256 = "1bbkj2wqpbfdw1cbm99vg9d94rvzba19m18xhnylaym0l78lc4sn";
    };
    buildInputs = [ Moose ];
    propagatedBuildInputs = [ Moose ];
    meta = {
      description = "A thing with a list of tags";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RoleTiny = buildPerlPackage {
    name = "Role-Tiny-1.003003";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/Role-Tiny-1.003003.tar.gz;
      sha256 = "1k823g4wnya18yx2v1xrfl73qqavqpzvaydyg1r7gdzcdvdwl4mp";
    };
    buildInputs = [ TestFatal ];
    meta = {
      description = "Roles, like a nouvelle cuisine portion size slice of Moose";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  RSSParserLite = buildPerlPackage {
    name = "RSS-Parser-Lite-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EB/EBOSRUP/RSS-Parser-Lite-0.10.tar.gz;
      sha256 = "1spvi0z62saz2cam8kwk2k561aavw2w42g3ykj38w1kmydvsk8z6";
    };
    propagatedBuildInputs = [ SOAPLite ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  RTClientREST = buildPerlPackage {
    name = "RT-Client-REST-0.49";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DM/DMITRI/RT-Client-REST-0.49.tar.gz;
      sha256 = "832c84b4f19e97781e8902f123a659fdcfef68e0ed9cfe09055852e9d68f7afc";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ DateTime DateTimeFormatDateParse Error ExceptionClass HTTPCookies HTTPMessage LWP ParamsValidate URI ];
    meta = {
      description = "Talk to RT installation using REST protocol";
      license = "perl";
    };
  };

  Safe = buildPerlPackage {
    name = "Safe-2.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RG/RGARCIA/Safe-2.35.tar.gz;
      sha256 = "e5d09756580287d7dc183ddaf26e4b2467e6f75b52ad73decdbe62d0750979b1";
    };
  };

  SafeIsa = buildPerlPackage {
    name = "Safe-Isa-1.000004";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Safe-Isa-1.000004.tar.gz;
      sha256 = "0sqwma0xqxrgnsm0jfy17szq87bskzq67cdh7p934qdifh5nfwn9";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Call isa, can, does and DOES safely on things that may not be objects";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScalarListUtils = buildPerlPackage {
    name = "Scalar-List-Utils-1.42";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/Scalar-List-Utils-1.42.tar.gz;
      sha256 = "3507f72541f66a2dce850b9b56771e5fccda3d215c52f74946c6e370c0f4a4da";
    };
    meta = {
      description = "Common Scalar and List utility subroutines";
      license = "perl";
    };
  };

  ScalarString = buildPerlPackage rec {
    name = "Scalar-String-0.002";
    src = fetchurl {
      url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/${name}.tar.gz";
      sha256 = "d3a45cc137bb9f7d8848d5a10a5142d275a98f8dcfd3adb60593cee9d33fa6ae";
    };
  };

  ScopeGuard = buildPerlPackage {
    name = "Scope-Guard-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHOCOLATE/Scope-Guard-0.20.tar.gz;
      sha256 = "1lsagnz6pli035zvx5c1x4qm9fabi773vns86yd8lzfpldhfv3sv";
    };
    meta = {
      description = "Lexically-scoped resource management";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  ScopeUpper = buildPerlPackage {
    name = "Scope-Upper-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/V/VP/VPIT/Scope-Upper-0.24.tar.gz;
      sha256 = "159jcwliyb7j80858pi052hkmhgy4cdbjha419kmhhqc9s1rhd5g";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Scope-Upper/;
      description = "Act on upper scopes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SearchDict = buildPerlPackage {
    name = "Search-Dict-1.07";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Search-Dict-1.07.tar.gz;
      sha256 = "b128cdae4712fe53e83a219ca65478a84c1b128a2c6c86933e47923cf19c6554";
    };
    meta = {
      description = "Look - search for key in dictionary file";
      license = "perl";
    };
  };

  SelfLoader = buildPerlPackage {
    name = "SelfLoader-1.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SM/SMUELLER/SelfLoader-1.20.tar.gz;
      sha256 = "79b1e2b8e4081854fba666441287c18b6bd822defb5bbee79067370edba1a042";
    };
    meta = {
      description = "Load functions only on demand";
      license = "perl";
    };
  };

  SetInfinite = buildPerlPackage {
    name = "Set-Infinite-0.65";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FG/FGLOCK/Set-Infinite-0.65.tar.gz;
      sha256 = "07bc880734492de40b4a3a8b5a331762f64e69b4629029fd9a9d357b25b87e1f";
    };
    meta = {
      description = "Infinite Sets math";
    };
  };

  SetObject = buildPerlPackage {
    name = "Set-Object-1.34";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RU/RURBAN/Set-Object-1.34.tar.gz;
      sha256 = "1dipd6k572pzqjzbj9vagb2k347qcg29lsxzx9y214bhnw7fgvjp";
    };
  };

  SetScalar = buildPerlPackage {
    name = "Set-Scalar-1.29";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAVIDO/Set-Scalar-1.29.tar.gz;
      sha256 = "07aiqkyi1p22drpcyrrmv7f8qq6fhrxh007achy2vryxyck1bp53";
    };
    meta = {
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  SGMLSpm = buildPerlPackage {
    name = "SGMLSpm-1.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RA/RAAB/SGMLSpm-1.1.tar.gz;
      sha256 = "1gdjf3mcz2bxir0l9iljxiz6qqqg3a9gg23y5wjg538w552r432m";
    };
  };

  SOAPLite = buildPerlPackage {
    name = "SOAP-Lite-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHRED/SOAP-Lite-1.11.tar.gz;
      sha256 = "1zhy06v72r95ih3lx5rlx0bvkq214ndmcmn97m5k2rkxxy4ybpp4";
    };
    propagatedBuildInputs = [ ClassInspector HTTPDaemon LWP TaskWeaken URI XMLParser ];
    meta = {
      description = "Perl's Web Services Toolkit";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  Socket = buildPerlPackage {
    name = "Socket-2.020";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PEVANS/Socket-2.020.tar.gz;
      sha256 = "9ad4174c45b4c31d5e0b8019ada1fc767093849e77f268f0d1831eeb891dfdd7";
    };
    meta = {
      description = "Networking constants and support functions";
      license = "perl";
    };
  };

  Socket6 = buildPerlPackage rec {
    name = "Socket6-0.25";
    src = fetchurl {
      url = "mirror://cpan/authors/id/U/UM/UMEMOTO/${name}.tar.gz";
      sha256 = "1ads4k4vvq6pnxkdw0s8gaj03w4h9snxyw7zyikfzd20fy76yx6s";
    };
    buildInputs = [ pkgs.which ];
  };

  SoftwareLicense = buildPerlPackage {
    name = "Software-License-0.103005";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Software-License-0.103005.tar.gz;
      sha256 = "050a14e0b3fb15763fd267fdd8ccc7ec8c459d8cc830b0bdc39ce09f5910f88c";
    };
    propagatedBuildInputs = [ DataSection SubInstall TextTemplate ];
    meta = {
      homepage = https://github.com/rjbs/software-license;
      description = "Packages that provide templated software licenses";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SortVersions = buildPerlPackage rec {
    name = "Sort-Versions-1.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ED/EDAVIS/${name}.tar.gz";
      sha256 = "1yhyxaakyhcffgr9lwd314badhlc2gh9f6n47013ljshbnkgzhh9";
    };
  };

  Spiffy = buildPerlPackage rec {
    name = "Spiffy-0.31";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "11pnsbyjzpp8y8ss7mrmz8nnbvv5vr7x71f13pwii9m8cam04blj";
    };
    buildInputs = [ ExtUtilsMakeMaker ];
  };

  SpreadsheetParseExcel = buildPerlPackage rec {
    name = "Spreadsheet-ParseExcel-0.2603";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KW/KWITKNR/${name}.tar.gz";
      sha256 = "0q5qq982528cdpqdj2wszrnf5g2rfphx0b413lczx7nvkkyy9xqz";
    };

    propagatedBuildInputs = [ IOStringy OLEStorageLight ];
  };

  SQLAbstract = buildPerlPackage {
    name = "SQL-Abstract-1.80";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RI/RIBASUSHI/SQL-Abstract-1.80.tar.gz;
      sha256 = "de4d0507fca0c6340c17867abca0632017bd56594443e67ea6ace826ba9a07a2";
    };
    buildInputs = [ TestDeep TestException TestWarn ];
    propagatedBuildInputs = [ HashMerge MROCompat Moo ];
    meta = {
      description = "Generate SQL from Perl data structures";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SQLAbstractLimit = buildPerlPackage rec {
    name = "SQL-Abstract-Limit-0.141";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DAVEBAIRD/${name}.tar.gz";
      sha256 = "1qqh89kz065mkgyg5pjcgbf8qcpzfk8vf1lgkbwynknadmv87zqg";
    };
    propagatedBuildInputs =
      [ SQLAbstract TestException DBI TestDeep ];
    buildInputs = [ TestPod TestPodCoverage ];
  };

  SQLSplitStatement = buildPerlPackage rec {
    name = "SQL-SplitStatement-1.00020";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/SQL/${name}.tar.gz";
      sha256 = "0bqg45k4c9qkb2ypynlwhpvzsl4ssfagmsalys18s5c79ps30z7p";
    };
    buildInputs = [ TestException ];
    propagatedBuildInputs = [ ClassAccessor ListMoreUtils RegexpCommon SQLTokenizer ];
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  SQLTokenizer = buildPerlPackage rec {
    name = "SQL-Tokenizer-0.24";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/SQL/${name}.tar.gz";
      sha256 = "1qa2dfbzdlr5qqdam9yn78z5w3al5r8577x06qan8wv58ay6ka7s";
    };
  };

  SQLTranslator = buildPerlPackage rec {
    name = "SQL-Translator-0.11020";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IL/ILMARI/${name}.tar.gz";
      sha256 = "18mqnppwk1076sxcink5ajk75ysway0bd049hwxvk8md39x0y7ar";
    };
    propagatedBuildInputs = [
      ClassBase ClassDataInheritable ClassMakeMethods DigestSHA1 CarpClan IOStringy
      ParseRecDescent ClassAccessor DBI FileShareDir XMLWriter YAML TestDifferences
      TemplateToolkit GraphViz XMLLibXML TestPod TextRecordParser HTMLParser
      SpreadsheetParseExcel Graph GD Moo TryTiny PackageVariant
    ];
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };
  
  PackageVariant = buildPerlPackage {
    name = "Package-Variant-1.002002";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/Package-Variant-1.002002.tar.gz;
      sha256 = "826780f19522f42c6b3d9f717ab6b5400f198cec08f4aa15b71aef9aa17e9b13";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ ImportInto ModuleRuntime strictures ];
    meta = {
      description = "Parameterizable packages";
      license = "perl";
    };
  };

  SortNaturally = buildPerlPackage rec {
    name = "Sort-Naturally-1.03";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BI/BINGOS/${name}.tar.gz";
      sha256 = "eaab1c5c87575a7826089304ab1f8ffa7f18e6cd8b3937623e998e865ec1e746";
    };
  };

  Starman = buildPerlModule {
    name = "Starman-0.4010";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Starman-0.4010.tar.gz;
      sha256 = "abe8e2e0519b7326d64db1e93d9c32d853a7be083792d0d7e5f5a1ddf1472d42";
    };
    buildInputs = [ LWP ModuleBuildTiny TestRequires ];
    propagatedBuildInputs = [ DataDump HTTPDate HTTPMessage HTTPParserXS NetServer Plack TestTCP ];
    doCheck = false; # binds to various TCP ports
    meta = {
      homepage = https://github.com/miyagawa/Starman;
      description = "High-performance preforking PSGI/Plack web server";
      license = "perl";
    };
  };

  StatisticsBasic = buildPerlPackage {
    name = "Statistics-Basic-1.6607";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JETTERO/Statistics-Basic-1.6607.tar.gz;
      sha256 = "105agxl2581iqmwj1crgz33l5r19snf47h91hnjgm1nf555z79r7";
    };
    propagatedBuildInputs = [ NumberFormat ];
    meta = {
      license = "open_source";
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  StatisticsDescriptive = buildPerlPackage {
    name = "Statistics-Descriptive-3.0605";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/Statistics-Descriptive-3.0605.tar.gz;
      sha256 = "8e7dae184444e27ee959e33b3ae161cc83115d11da189ed5003b004450e04b48";
    };
    meta = {
      #homepage = http://web-cpan.berlios.de/modules/Statistics-Descriptive/; # berlios shut down; I found no replacement
      description = "Module of basic descriptive statistical functions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StatisticsDistributions = buildPerlPackage rec {
    name = "Statistics-Distributions-1.02";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Statistics/${name}.tar.gz";
      sha256 = "1j1kswl98f4i9dn176f9aa3y9bissx2sscga5jm3gjl4pxm3k7zr";
    };
  };

  StatisticsTTest = buildPerlPackage rec {
    name = "Statistics-TTest-1.1.0";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Statistics/${name}.tar.gz";
      sha256 = "0rkifgzm4rappiy669dyi6lyxn2sdqaf0bl6gndlfa67b395kndj";
    };
    propagatedBuildInputs = [ StatisticsDescriptive StatisticsDistributions ];
  };

  Storable = buildPerlPackage {
    name = "Storable-2.51";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AM/AMS/Storable-2.51.tar.gz;
      sha256 = "a566b792112bbba21131ec1d7a2bf78170c648484895283ae53c7f0c3dc2f0be";
    };
    meta = {
      license = "unknown";
    };
  };

  StreamBuffered = buildPerlPackage {
    name = "Stream-Buffered-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Stream-Buffered-0.02.tar.gz;
      sha256 = "0bfa3h2pryrbrcd1r7235k0ik4gw35r5ig8h8y3dfmk9l3y96vjr";
    };
    meta = {
      homepage = http://plackperl.org;
      description = "Temporary buffer to save bytes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  strictures = buildPerlPackage {
    name = "strictures-1.005004";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HA/HAARG/strictures-1.005004.tar.gz;
      sha256 = "0y9q0v68060x5r3wfprwnjry6si7x9x5rkqz7nrf8fkxng7ndw5v";
    };
    meta = {
      homepage = http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=p5sagit/strictures.git;
      description = "Turn on strict and make all warnings fatal";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringCamelCase = buildPerlPackage rec {
    name = "String-CamelCase-0.02";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/String/${name}.tar.gz";
      sha256 = "17kh8nap2z5g5rqcvw0m7mvbai7wr7h0al39w8l827zhqad8ss42";
    };
  };

  StringCRC32 = buildPerlPackage rec {
      name = "String-CRC32-1.5";
      src = fetchurl {
        url = mirror://cpan/authors/id/S/SO/SOENKE/String-CRC32-1.5.tar.gz;
        sha256 = "0m3hjk292hnxyi8nkfy8hlr1khnbf2clgkb4kzj0ycq8gcd2z0as";
      };
      meta = {
        maintainers = with maintainers; [ ocharles ];
        platforms   = stdenv.lib.platforms.unix;
      };
  };

  StringErrf = buildPerlPackage {
    name = "String-Errf-0.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-Errf-0.007.tar.gz;
      sha256 = "1apnmxdsqwrvn1kkbba4sw6yh6hdfxxar545p6m9dkid7xsiqjfj";
    };
    buildInputs = [ JSON TimeDate ];
    propagatedBuildInputs = [ ParamsUtil StringFormatter SubExporter ];
    meta = {
      description = "A simple sprintf-like dialect";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringEscape = buildPerlPackage rec {
    name = "String-Escape-2010.002";
    src = fetchurl {
        url = mirror://cpan/authors/id/E/EV/EVO/String-Escape-2010.002.tar.gz;
        sha256 = "12ls7f7847i4qcikkp3skwraqvjphjiv2zxfhl5d49326f5myr7x";
    };
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  StringFlogger = buildPerlPackage {
    name = "String-Flogger-1.101244";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-Flogger-1.101244.tar.gz;
      sha256 = "0cx3d85sz1dqjvbczpf9wx0i1b05jwbxcg7lpq5qygdkblq85nzd";
    };
    propagatedBuildInputs = [ JSON ParamsUtil SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/string-flogger;
      description = "String munging for loggers";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringFormat = buildPerlPackage rec {
    name = "String-Format-1.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DARREN/${name}.tar.gz";
      sha256 = "0sxfavcsb349rfafxflq2f9h3xpxabrw0q7vhmh9n3hjij8fa1jk";
    };
  };

  StringFormatter = buildPerlPackage {
    name = "String-Formatter-0.102084";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-Formatter-0.102084.tar.gz;
      sha256 = "0mlwm0rirv46gj4h072q8gdync5zxxsxy8p028gdyrhczl942dc3";
    };
    propagatedBuildInputs = [ ParamsUtil SubExporter ];
    meta = with stdenv.lib; {
      description = "Build sprintf-like functions of your own";
      license = licenses.gpl2;
    };
  };

  StringMkPasswd = buildPerlPackage {
    name = "String-MkPasswd-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CG/CGRAU/String-MkPasswd-0.05.tar.gz;
      sha256 = "15lvcc8c9hp6mg3jx02wd3b85aphn8yl5db62q3pam04c0sgh42k";
    };
  };

  StringRewritePrefix = buildPerlPackage {
    name = "String-RewritePrefix-0.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-RewritePrefix-0.007.tar.gz;
      sha256 = "18nxl1vgkcx0r7ifkmbl9fp73f8ihiqhqqf3vq6sj5b3cgawrfsw";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Rewrite strings based on a set of known prefixes";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringShellQuote = buildPerlPackage {
    name = "String-ShellQuote-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz;
      sha256 = "0dfxhr6hxc2majkkrm0qbx3qcbykzpphbj2ms93dc86f7183c1p6";
    };
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  StringToIdentifierEN = buildPerlPackage rec {
    name = "String-ToIdentifier-EN-0.11";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RK/RKITOVER/${name}.tar.gz";
      sha256 = "1bawghkgkkx7j3avnrj5sg3vix1z5564ks6wf9az3jc2knh8s5nh";
    };
    propagatedBuildInputs =
      [ LinguaENInflectPhrase TextUnidecode namespaceclean ];
  };

  StringTruncate = buildPerlPackage {
    name = "String-Truncate-1.100602";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/String-Truncate-1.100602.tar.gz;
      sha256 = "0vjz4fd4cvcy12gk5bdha7z73ifmfpmk748khha94dhiq3pd98xa";
    };
    propagatedBuildInputs = [ SubExporter SubInstall ];
    meta = {
      description = "A module for when strings are too long to be displayed in";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  StringTT = buildPerlPackage {
    name = "String-TT-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/String-TT-0.03.tar.gz;
      sha256 = "1asjr79wqcl9wk96afxrm1yhpj8lk9bk8kyz78yi5ypr0h55yq7p";
    };
    buildInputs = [ Testuseok TestException TestTableDriven ];
    propagatedBuildInputs = [ PadWalker SubExporter TemplateToolkit ];
    meta = {
      description = "Use TT to interpolate lexical variables";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  StringUtil = buildPerlPackage {
    name = "String-Util-1.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIKO/String-Util-1.21.tar.gz;
      sha256 = "1ndvm9pbngf1j0fm02ghl4nfcqi5404sxdlm42g3ismf1ms1fnxa";
    };
    meta = {
      description = "String::Util -- String processing utilities";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporter = buildPerlPackage {
    name = "Sub-Exporter-0.984";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-0.984.tar.gz;
      sha256 = "190qly7nv7zf17c1v0gnqhyf25p6whhh2m132mh4xzs5mqadwq0f";
    };
    propagatedBuildInputs = [ DataOptList ParamsUtil SubInstall ];
    meta = {
      homepage = https://github.com/rjbs/sub-exporter;
      description = "A sophisticated exporter for custom-built routines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterForMethods = buildPerlPackage {
    name = "Sub-Exporter-ForMethods-0.100051";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-ForMethods-0.100051.tar.gz;
      sha256 = "127wniw53p7pp7r2vazicply3v1gmnhw4w7jl6p74i0grnsixipm";
    };
    propagatedBuildInputs = [ SubExporter SubName ];
    meta = {
      description = "Helper routines for using Sub::Exporter to build methods";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterGlobExporter = buildPerlPackage {
    name = "Sub-Exporter-GlobExporter-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-GlobExporter-0.004.tar.gz;
      sha256 = "025wgjavrbzh52jb4v0w2fxqh7r5181k935h9cyy2rm1qk49fg8p";
    };
    propagatedBuildInputs = [ SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/sub-exporter-globexporter;
      description = "Export shared globs with Sub::Exporter collectors";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterProgressive = buildPerlPackage {
    name = "Sub-Exporter-Progressive-0.001011";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001011.tar.gz;
      sha256 = "01kwzbqwdhvadpphnczid03nlyj0h4cxaq3m3v2401bckkkcc606";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Only use Sub::Exporter if you need it";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubExporterUtil = buildPerlPackage {
    name = "Sub-Exporter-Util-0.984";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Exporter-0.984.tar.gz;
      sha256 = "190qly7nv7zf17c1v0gnqhyf25p6whhh2m132mh4xzs5mqadwq0f";
    };
    propagatedBuildInputs = [ DataOptList ParamsUtil SubInstall ];
    meta = {
      homepage = https://github.com/rjbs/sub-exporter;
      description = "A sophisticated exporter for custom-built routines";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubIdentify = buildPerlPackage rec {
    name = "Sub-Identify-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RG/RGARCIA/${name}.tar.gz";
      sha256 = "16g4dkmb4h5hh15jsq0kvsf3irrlrlqdv7qk6605wh5gjjwbcjxy";
    };
  };

  SubInstall = buildPerlPackage {
    name = "Sub-Install-0.927";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Sub-Install-0.927.tar.gz;
      sha256 = "0nmgsdbwi8f474jkyd6w9jfnpav99xp8biydcdri8qri623f6plm";
    };
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Install subroutines into packages easily";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SubName = buildPerlPackage {
    name = "Sub-Name-0.0502";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHIPS/Sub-Name-0.0502.tar.gz;
      sha256 = "1r197binpdy4xfh65qkxxvi9c39pmvvcny4rl8a7zrk1jcws6fac";
    };
    meta = {
      description = "(Re)name a sub";
    };
  };

  SubOverride = buildPerlPackage rec {
    name = "Sub-Override-0.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OV/OVID/${name}.tar.gz";
      sha256 = "13s5zi6qz02q50vv4bmwdmhn9gvg0988fydjlrrv500g6hnyzlkj";
    };
    propagatedBuildInputs = [SubUplevel TestException];
  };

  SubUplevel = buildPerlPackage {
    name = "Sub-Uplevel-0.24";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Sub-Uplevel-0.24.tar.gz;
      sha256 = "1yzxqsim8vpavzqm2wfksh8dpmy6qbr9s3hdqqicp38br3lzd4qg";
    };
    meta = {
      homepage = https://github.com/dagolden/sub-uplevel;
      description = "Apparently run a function in a higher stack frame";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SVK = buildPerlPackage {
    name = "SVK-2.0.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/SVK-v2.0.2.tar.gz;
      sha256 = "0c4m2q7cvzwh9kk1nc1vd8lkxx2kss5nd4k20dpkal4c7735jns0";
    };
    propagatedBuildInputs = [
      AlgorithmDiff AlgorithmAnnotate AppCLI
      ClassDataInheritable DataHierarchy Encode FileTemp
      IODigest ListMoreUtils PathClass PerlIOeol
      PerlIOviadynamic PerlIOviasymlink PodEscapes
      PodSimple SVNMirror TimeHiRes UNIVERSALrequire
      URI YAMLSyck ClassAutouse IOPager
      LocaleMaketextLexicon FreezeThaw
    ];
  };

  SVNMirror = buildPerlPackage {
    name = "SVN-Mirror-0.73";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/SVN-Mirror-0.73.tar.gz;
      sha256 = "1scjaq7qjz6jlsk1c2l5q15yxf0sqbydvf22mb2xzy1bzaln0x2c";
    };
    propagatedBuildInputs = [
      ClassAccessor Filechdir pkgs.subversion URI
      TermReadKey TimeDate SVNSimple
    ];
  };

  SVNSimple = buildPerlPackage {
    name = "SVN-Simple-0.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CL/CLKAO/SVN-Simple-0.27.tar.gz;
      sha256 = "0p7p52ja6sf4j0w3b05i0bbqi5wiambckw2m5dsr63bbmlhv4a71";
    };
    propagatedBuildInputs = [pkgs.subversion];
  };

  Switch = buildPerlPackage rec {
    name = "Switch-2.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CH/CHORNY/Switch-2.17.tar.gz";
      sha256 = "0xbdjdgzfj9zwa4j3ipr8bfk7bcici4hk89hq5d27rhg2isljd9i";
    };
    doCheck = false;                             # FIXME: 2/293 test failures
  };

  SymbolUtil = buildPerlPackage {
    name = "Symbol-Util-0.0203";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Symbol-Util-0.0203.tar.gz;
      sha256 = "0cnwwrd5d6i80f33s7n2ak90rh4s53ss7q57wndrpkpr4bfn3djm";
    };
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  syntax = buildPerlPackage {
    name = "syntax-0.004";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHAYLON/syntax-0.004.tar.gz;
      sha256 = "fe19b6da8a8f43a5aa2ee571441bc0e339fb156d0081c157a1a24e9812c7d365";
    };
    propagatedBuildInputs = [ DataOptList namespaceclean ];
    meta = {
      homepage = https://github.com/phaylon/syntax/wiki;
      description = "Activate syntax extensions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SyntaxKeywordJunction = buildPerlPackage {
    name = "Syntax-Keyword-Junction-0.003007";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FR/FREW/Syntax-Keyword-Junction-0.003007.tar.gz;
      sha256 = "0c8jvy5lkshw5gyl037gmkh7c51k3sdvpywq0zwlw4ikvrcgsglj";
    };
    propagatedBuildInputs = [ SubExporterProgressive TestRequires syntax ];
    meta = {
      description = "Perl6 style Junction operators in Perl5";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  SysHostnameLong = buildPerlPackage rec {
    name = "Sys-Hostname-Long-1.4";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOTT/${name}.tar.gz";
      sha256 = "0hy1225zg2yg11xhgj0wbiapzjyf6slx17ln36zqvfm07k6widlx";
    };
    doCheck = false; # no `hostname' in stdenv
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  SysSigAction = buildPerlPackage {
    name = "Sys-SigAction-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBAXTER/Sys-SigAction-0.21.tar.gz;
      sha256 = "e144207a6fd261eb9f98554c76bea66d95870ee1f62d2d346a1ea95fdccf80db";
    };
    meta = {
      description = "Perl extension for Consistent Signal Handling";
      license = "perl";
    };
  };

  SysSyslog = buildPerlPackage {
    name = "Sys-Syslog-0.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/Sys-Syslog-0.33.tar.gz;
      sha256 = "d5d901d9d9333a66db95fb1c7692ff457f7c7ad17287b51a87e40734f7c2741d";
    };
    meta = {
      description = "Perl interface to the UNIX syslog(3) calls";
      license = "perl";
    };
  };

  SysVirt = buildPerlPackage rec {
    name = "Sys-Virt-1.2.9";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DANBERR/${name}.tar.gz";
      sha256 = "1ag55mlkbf63iq3q5mxdawf29c2nyphd52kbshnlim3lax247ml7";
    };
    propagatedBuildInputs = [XMLXPath];
    buildInputs = [TestPodCoverage TimeHiRes TestPod pkgs.pkgconfig pkgs.libvirt];
    meta = {
      platforms = stdenv.lib.platforms.linux;
    };
  };

  TAPParserSourceHandlerpgTAP = buildPerlModule {
    name = "TAP-Parser-SourceHandler-pgTAP-3.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/TAP-Parser-SourceHandler-pgTAP-3.30.tar.gz;
      sha256 = "08gadqf898r23sx07sn13555cp9zkwp8igjlh1fza2ycfivpfl9f";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Tap-Parser-Sourcehandler-pgTAP/;
      description = "Stream TAP from pgTAP test scripts";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      platforms = stdenv.lib.platforms.linux;
      maintainers = with maintainers; [ ocharles ];
    };
  };

  TaskCatalystTutorial = buildPerlPackage rec {
    name = "Task-Catalyst-Tutorial-0.06";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MR/MRAMBERG/${name}.tar.gz";
      sha256 = "07nn8a30n3qylpnf7s4ma6w462g31pywwikib117hr2mc7cv5cbm";
    };
    propagatedBuildInputs = [
      CatalystManual CatalystRuntime CatalystDevel
      CatalystPluginSession CatalystPluginAuthentication
      CatalystAuthenticationStoreDBIxClass
      CatalystPluginAuthorizationRoles
      CatalystPluginSessionStateCookie
      CatalystPluginAuthorizationACL
      CatalystPluginHTMLWidget
      CatalystPluginSessionStoreFastMmap
      CatalystPluginStackTrace
      CatalystViewTT
      DBIxClass DBIxClassHTMLWidget
      CatalystControllerHTMLFormFu
    ];
    buildInputs = [TestPodCoverage];
    meta.platforms = stdenv.lib.platforms.linux;
  };

  TaskPlack = buildPerlPackage rec {
    name = "Task-Plack-0.25";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Task/${name}.tar.gz";
      sha256 = "1mk3z7xis1akf8245qgw5mnnsl7570kdidx83nj81kv410pw2v43";
    };
    propagatedBuildInputs = [ Plack PSGI ];
  };

  TaskWeaken = buildPerlPackage {
    name = "Task-Weaken-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Task-Weaken-1.04.tar.gz;
      sha256 = "1i7kd9v8fjsqyhr4rx4a1jv7n5vfjjm1v4agb24pizh0b72p3qk7";
    };
    meta = {
      description = "Ensure that a platform has weaken support";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplatePluginAutoformat = buildPerlPackage {
    name = "Template-Plugin-Autoformat-2.77";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KARMAN/Template-Plugin-Autoformat-2.77.tar.gz;
      sha256 = "bddfb4919f0abb2a2be7a9665333e0d4e098032f0e383dbaf04c4d896c7486ed";
    };
    propagatedBuildInputs = [ TemplateToolkit TextAutoformat ];
    meta = {
      homepage = https://github.com/karpet/template-plugin-autoformat;
      description = "TT plugin for Text::Autoformat";
      license = "perl";
    };
  };

  TemplatePluginClass = buildPerlPackage {
    name = "Template-Plugin-Class-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RC/RCLAMP/Template-Plugin-Class-0.14.tar.gz;
      sha256 = "1hq7jy6zg1iaslsyi05afz0i944y9jnv3nb4krkxjfmzwy5gw106";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TemplatePluginIOAll = buildPerlPackage {
    name = "Template-Plugin-IO-All-0.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XE/XERN/Template-Plugin-IO-All-0.01.tar.gz;
      sha256 = "1f7445422a21932e09bbef935766e0af6b7cceb088e9d8e030cd7a84bcdc5ee4";
    };
    propagatedBuildInputs = [ IOAll TemplateToolkit ];
    meta = {
      maintainers = with maintainers; [ eelco ];
      description = "Perl Template Toolkit Plugin for IO::All";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TemplatePluginJavaScript = buildPerlPackage {
    name = "Template-Plugin-JavaScript-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Template-Plugin-JavaScript-0.02.tar.gz;
      sha256 = "1mqqqs0dhfr6bp1305j9ns05q4pq1n3f561l6p8848k5ml3dh87a";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TemplatePluginJSONEscape = buildPerlPackage {
    name = "Template-Plugin-JSON-Escape-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NA/NANTO/Template-Plugin-JSON-Escape-0.02.tar.gz;
      sha256 = "051a8b1d3bc601d58fc51e246067d36450cfe970278a0456e8ab61940f13cd86";
    };
    propagatedBuildInputs = [ JSON TemplateToolkit ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TemplateTimer = buildPerlPackage {
    name = "Template-Timer-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Template-Timer-1.00.tar.gz;
      sha256 = "1d3pbcx1kz73ncg8s8lx3ifwphz838qy0m40gdar7790cnrlqcdp";
    };
    propagatedBuildInputs = [ TemplateToolkit ];
    meta = {
      description = "Rudimentary profiling for Template Toolkit";
      license = "null";
    };
  };

  TemplateTiny = buildPerlPackage {
    name = "Template-Tiny-1.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Template-Tiny-1.12.tar.gz;
      sha256 = "073e062c630b51dfb725cd6485a329155cb72d5c596e8cb698eb67c4566f0a4a";
    };
    meta = {
      description = "Template Toolkit reimplemented in as little code as possible";
      license = "perl";
    };
  };

  TemplateToolkit = buildPerlPackage rec {
    name = "Template-Toolkit-2.25";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABW/Template-Toolkit-2.25.tar.gz;
      sha256 = "048yg07j48rix3cly13j5wzms7kd5argviicj0kwykb004xpc8zl";
    };
    propagatedBuildInputs = [ AppConfig ];
    meta = {
      description = "Comprehensive template processing system";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermANSIColor = buildPerlPackage {
    name = "Term-ANSIColor-4.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RR/RRA/Term-ANSIColor-4.03.tar.gz;
      sha256 = "e89b6992030fa713f928f653dcdb71d66fa2493f873bacf5653aa121ca862450";
    };
    meta = {
      description = "Color output using ANSI escape sequences";
      license = "perl";
    };
  };

  TermCap = buildPerlPackage {
    name = "Term-Cap-1.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JS/JSTOWE/Term-Cap-1.16.tar.gz;
      sha256 = "b99728ac19b740b43e6a8d3c749c336f4a5d59ffd684c42c222681ee924e4a20";
    };
    meta = {
      description = "Perl termcap interface";
      license = "perl";
    };
  };

  TermEncoding = buildPerlPackage {
    name = "Term-Encoding-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Term-Encoding-0.02.tar.gz;
      sha256 = "f274e72346a0c0cfacfb53030ac1e38b57425512fc5bdc5cd9ef75ab0f26cfcc";
    };
    meta = {
      description = "Detect encoding of the current terminal";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermProgressBar = buildPerlPackage {
    name = "Term-ProgressBar-2.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SZ/SZABGAB/Term-ProgressBar-2.14.tar.gz;
      sha256 = "18cj7mzbis9xk0v32g2700vq9b4p9v5msk02mglf244cj77bflf6";
    };
    buildInputs = [ CaptureTiny TestException ];
    propagatedBuildInputs = [ ClassMethodMaker TermReadKey ];
    meta = {
      description = "Provide a progress meter on a standard terminal";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermProgressBarQuiet = buildPerlPackage {
    name = "Term-ProgressBar-Quiet-0.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Term-ProgressBar-Quiet-0.31.tar.gz;
      sha256 = "25675292f588bc29d32e710cf3667da9a2a1751e139801770a9fdb18cd2184a6";
    };
    propagatedBuildInputs = [ IOInteractive TermProgressBar TestMockObject ];
    meta = {
      description = "";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TermProgressBarSimple = buildPerlPackage {
    name = "Term-ProgressBar-Simple-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EV/EVDB/Term-ProgressBar-Simple-0.03.tar.gz;
      sha256 = "a20db3c67d5bdfd0c1fab392c6d1c26880a7ee843af602af4f9b53a7043579a6";
    };
    propagatedBuildInputs = [ TermProgressBarQuiet ];
  };

  TermReadKey = buildPerlPackage {
    name = "TermReadKey-2.31";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JS/JSTOWE/TermReadKey-2.31.tar.gz;
      sha256 = "1czarrdxgnxmmbaasjnq3sj14nf1cvzhm37padq6xvl7h7r2acb2";
    };
  };

  TermReadLineGnu = buildPerlPackage rec {
    name = "Term-ReadLine-Gnu-1.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/H/HA/HAYASHI/${name}.tar.gz";
      sha256 = "1s2dvjbh501c04s5hpf17mwirslmhqmsymg3ri4hcvh5yvp7bw7q";
    };
    buildInputs = [ pkgs.readline pkgs.ncurses ];
    NIX_CFLAGS_LINK = "-lreadline";

    # For some crazy reason Makefile.PL doesn't generate a Makefile if
    # AUTOMATED_TESTING is set.
    AUTOMATED_TESTING = false;

    # Makefile.PL looks for ncurses in Glibc's prefix.
    preConfigure =
      ''
        substituteInPlace Makefile.PL --replace '$Config{libpth}' \
          "'${pkgs.ncurses}/lib'"
      '';

    # Tests don't work because they require /dev/tty.
    doCheck = false;
  };

  TermShellUI = buildPerlPackage rec {
    name = "Term-ShellUI-0.92";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BR/BRONSON/${name}.tar.gz";
      sha256 = "3279c01c76227335eeff09032a40f4b02b285151b3576c04cacd15be05942bdb";
    };
  };

  TermSizeAny = buildPerlPackage {
    name = "Term-Size-Any-0.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FE/FERREIRA/Term-Size-Any-0.002.tar.gz;
      sha256 = "64fa5fdb1ae3a823134aaa95aec75354bc17bdd9ca12ba0a7ae34a7e51b3ded2";
    };
    propagatedBuildInputs = [ DevelHide TermSizePerl ];
    meta = {
      description = "Retrieve terminal size";
      license = "perl";
    };
  };

  TermSizePerl = buildPerlPackage {
    name = "Term-Size-Perl-0.029";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FE/FERREIRA/Term-Size-Perl-0.029.tar.gz;
      sha256 = "8c1aaab73646ee1d233e827213ea3b5ab8afcf1d02a8f94be7aed306574875e7";
    };
    meta = {
      description = "Perl extension for retrieving terminal size (Perl version)";
      license = "perl";
    };
  };

  TermVT102 = buildPerlPackage {
    name = "Term-VT102-0.91";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AJ/AJWOOD/Term-VT102-0.91.tar.gz;
      sha256 = "f954e0310941d45c0fc3eb4a40f5d3a00d68119e277d303a1e6af11ded6fbd94";
    };
    meta = {
    };
  };

  TermVT102Boundless = buildPerlPackage {
    name = "Term-VT102-Boundless-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Term-VT102-Boundless-0.04.tar.gz;
      sha256 = "5bb88b5aecb44ebf56d3ac7240be80cd26def9dcf1ebeb4e77d9983dfc7a8f19";
    };
    propagatedBuildInputs = [ TermVT102 Testuseok ];
    meta = {
      license = "unknown";
    };
  };

  Test = buildPerlPackage {
    name = "Test-1.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JE/JESSE/Test-1.26.tar.gz;
      sha256 = "f7701bd28e05e7f82fe9a181bbab38f53fa6aeae48d2a810da74d1b981d4f392";
    };
    meta = {
      description = "Provides a simple framework for writing test scripts";
    };
  };

  TestAssert = buildPerlPackage {
    name = "Test-Assert-0.0504";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Test-Assert-0.0504.tar.gz;
      sha256 = "194bzflmzc0cw5727kznbj1zwzj7gnj7nx1643zk2hshdjlnv8yg";
    };
    buildInputs = [ ClassInspector TestUnitLite ];
    propagatedBuildInputs = [ constantboolean ExceptionBase SymbolUtil ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestAssertions = buildPerlPackage rec {
    name = "Test-Assertions-1.054";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "10026w4r3yv6k3vc6cby7d61mxddlqh0ls6z39c82f17awfy9p7w";
    };
    buildInputs = [ LogTrace ];
  };

  TestBase = buildPerlPackage rec {
    name = "Test-Base-0.62";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "1b11xllllp49kkq1wwr57pijqlx1c37nbyssdlszvvhrp6kww363";
    };
    propagatedBuildInputs = [ Spiffy ];
  };

  TestCheckDeps = buildPerlModule {
    name = "Test-CheckDeps-0.006";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Test-CheckDeps-0.006.tar.gz;
      sha256 = "774c1455566d11746118fd95305d1dbd111af86eac78058918e72468c43d9bcb";
    };
    buildInputs = [ ModuleBuildTiny ];
    propagatedBuildInputs = [ CPANMetaCheck ];
    meta = {
      description = "Check for presence of dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestCleanNamespaces = buildPerlPackage {
    name = "Test-CleanNamespaces-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Test-CleanNamespaces-0.16.tar.gz;
      sha256 = "9779378394b9be32cf04129fafe2d40d74f6f200f593f1494998bd128a6ed9fa";
    };
    buildInputs = [ ModuleRuntime TestDeep TestRequires TestTester TestWarnings if_ ];
    propagatedBuildInputs = [ FileFindRule FileFindRulePerl ModuleRuntime PackageStash SubExporter SubIdentify namespaceclean ];
    meta = {
      homepage = https://github.com/karenetheridge/Test-CleanNamespaces;
      description = "Check for uncleaned imports";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestCPANMeta = buildPerlPackage {
    name = "Test-CPAN-Meta-0.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BA/BARBIE/Test-CPAN-Meta-0.23.tar.gz;
      sha256 = "dda70c5cb61eddc6d3148cb66b6ff5eb4546a065257f4c104112a8a8a3575116";
    };
    meta = {
      description = "Validate your CPAN META.yml files";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  TestDeep = buildPerlPackage {
    name = "Test-Deep-0.112";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Test-Deep-0.112.tar.gz;
      sha256 = "1vg1bb1lpqpj0pxk738ykip4kw3agbi88g90wxb3pc11l84nlsan";
    };
    propagatedBuildInputs = [ TestNoWarnings TestTester ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
    };
  };

  TestDir = buildPerlPackage {
    name = "Test-Dir-1.014";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MT/MTHURN/Test-Dir-1.014.tar.gz;
      sha256 = "b36efc286f8127b04fd7bb0dfdf4bd0a090b175872e35b5ce6d4d80c772c28bf";
    };
    meta = {
      description = "Test directory attributes";
      license = "perl";
    };
  };

  TestDifferences = buildPerlPackage {
    name = "Test-Differences-0.63";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DC/DCANTRELL/Test-Differences-0.63.tar.gz;
      sha256 = "7c657a178c32f48de3b469f6d4f67b75f018a3a19c1e6d0d8892188b0d261a66";
    };
    propagatedBuildInputs = [ CaptureTiny TextDiff ];
    meta = {
      description = "Test strings and data structures and show differences if not ok";
      license = "unknown";
    };
  };

  TestDistManifest = buildPerlPackage {
    name = "Test-DistManifest-1.012";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Test-DistManifest-1.012.tar.gz;
      sha256 = "4b128bef9beea2f03bdca037ceb722de43b4a2c516c3f50c2a26421548a72208";
    };
    buildInputs = [ TestNoWarnings ];
    propagatedBuildInputs = [ ModuleManifest ];
    meta = {
      homepage = http://search.cpan.org/dist/Test-DistManifest;
      description = "Author test that validates a package MANIFEST";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestEOL = buildPerlPackage {
    name = "Test-EOL-1.5";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Test-EOL-1.5.tar.gz;
      sha256 = "0qfdn71562xzmgnhmkkdbpp3vj851ldl1zlmxvharxsr16gjh6s3";
    };
    meta = {
      homepage = http://metacpan.org/release/Test-EOL;
      description = "Check the correct line endings in your project";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestException = buildPerlPackage rec {
    name = "Test-Exception-0.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADIE/${name}.tar.gz";
      sha256 = "0issbjh5yl62lpaff5zhn28zhbf8sv8n2g79vklfr5s703k2fi5s";
    };
    propagatedBuildInputs = [ SubUplevel ];
  };

  TestFailWarnings = buildPerlPackage {
    name = "Test-FailWarnings-0.008";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-FailWarnings-0.008.tar.gz;
      sha256 = "0vx9chcp5x8m0chq574p9fnfckh5gl94j7904rh9v17n568fyd6s";
    };
    buildInputs = [ CaptureTiny ];
    meta = {
      homepage = https://metacpan.org/release/Test-FailWarnings;
      description = "Add test failures if warnings are caught";
      license = stdenv.lib.licenses.asl20;
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestFatal = buildPerlPackage {
    name = "Test-Fatal-0.013";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Test-Fatal-0.013.tar.gz;
      sha256 = "1rrndzkjff3bdlzzdsfsd3fhng142la2m74ihkgv17islkp17yq2";
    };
    propagatedBuildInputs = [ TryTiny ];
    meta = {
      homepage = https://github.com/rjbs/test-fatal;
      description = "Incredibly simple helpers for testing code with exceptions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestFile = buildPerlPackage {
    name = "Test-File-1.41";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Test-File-1.41.tar.gz;
      sha256 = "45ec1b714f64d05e34205c40b08c49549f257910e4966fa28e2ac170d5516316";
    };
    buildInputs = [ Testutf8 ];
    meta = {
      description = "Check file attributes";
      license = "perl";
    };
  };

  TestFileContents = buildPerlModule {
    name = "Test-File-Contents-0.21";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/Test-File-Contents-0.21.tar.gz;
      sha256 = "1b5a13f86f5df625ffd30361f628d34b0ceda80b9f39ca74bf0a4c1105828317";
    };
    propagatedBuildInputs = [ TextDiff ];
    meta = {
      homepage = http://search.cpan.org/dist/Test-File-Contents/;
      description = "Test routines for examining the contents of files";
      license = "perl";
    };
  };

  TestFileShareDir = buildPerlModule {
    name = "Test-File-ShareDir-0.3.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KE/KENTNL/Test-File-ShareDir-0.3.3.tar.gz;
      sha256 = "877e14afb6f432bd888ef730c0afd776dd149b14bc520bc2ce842d114e5886a2";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ FileCopyRecursive FileShareDir PathTiny ];
    meta = {
      homepage = https://github.com/kentfredric/Test-File-ShareDir;
      description = "Create a Fake ShareDir for your modules for testing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestHarness = buildPerlPackage {
    name = "Test-Harness-3.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LE/LEONT/Test-Harness-3.33.tar.gz;
      sha256 = "c22e36287d5cee3c28fd2006e3c8b6e7cc76c6fc39d79c7ab74f1936d35e8fe2";
    };
    doCheck = false; # makes assumptions about path to Perl
    meta = {
      homepage = http://testanything.org/;
      description = "Run Perl standard test scripts with statistics";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestHarnessStraps = buildPerlModule {
    name = "Test-Harness-Straps-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/Test-Harness-Straps-0.30.tar.gz;
      sha256 = "8b00efaa35723c1a35c8c8f5fa46a99e4bc528dfa520352b54ac418ef6d1cfa8";
    };
    meta = {
      description = "Detailed analysis of test results";
      license = "perl";
    };
  };

  TestHTTPServerSimple = buildPerlPackage {
    name = "Test-HTTP-Server-Simple-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AL/ALEXMV/Test-HTTP-Server-Simple-0.11.tar.gz;
      sha256 = "85c97ebd4deb805291b17277032da48807228f24f89b1ce2fb3c09f7a896bb78";
    };
    propagatedBuildInputs = [ HTTPServerSimple ];
    meta = {
      description = "Test::More functions for HTTP::Server::Simple";
    };
  };

  TestJSON = buildPerlPackage {
    name = "Test-JSON-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OV/OVID/Test-JSON-0.11.tar.gz;
      sha256 = "1cyp46w3q7dg89qkw31ik2h2a6mdx6pzdz2lmp8m0a61zjr8mh07";
    };
    propagatedBuildInputs = [ JSONAny TestDifferences TestTester ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestLeakTrace = buildPerlPackage rec {
    name = "Test-LeakTrace-0.14";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GF/GFUJI/${name}.tar.gz";
      sha256 = "06cn4g35l2gi9vbsdi2j49cxsji9fvfi7xp4xgdyxxds9vrxydia";
    };
    meta = {
      description = "Traces memory leaks";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestLongString = buildPerlPackage rec {
    name = "Test-LongString-0.15";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "0r2i3a35l116ccwx88jwiii2fq4b8wm16sl1lkxm2kh44s4z7s5s";
    };
  };

  TestMemoryCycle = buildPerlPackage {
    name = "Test-Memory-Cycle-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Test-Memory-Cycle-1.04.tar.gz;
      sha256 = "09qj48gmj25xgm0k12n1xx7chdk9gdy3sck4pabvzs0v00nmv9p5";
    };
    propagatedBuildInputs = [ DevelCycle PadWalker ];
    meta = {
      description = "Verifies code hasn't left circular references";
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestMockClass = buildPerlPackage {
    name = "Test-Mock-Class-0.0303";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Test-Mock-Class-0.0303.tar.gz;
      sha256 = "00pkfqcz7b34q1mvx15k46sbxs22zcrvrbv15rnbn2na57z54bnd";
    };
    buildInputs = [ ClassInspector TestUnitLite ];
    propagatedBuildInputs = [ ExceptionBase FatalException Moose namespaceclean TestAssert ];
    meta = with stdenv.lib; {
      description = "Simulating other classes";
      license = licenses.lgpl2Plus;
      maintainers = with maintainers; [ ocharles ];
      platforms   = platforms.unix;
    };
  };

  TestMockModule = buildPerlPackage {
    name = "Test-MockModule-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SI/SIMONFLK/Test-MockModule-0.05.tar.gz;
      sha256 = "01vf75higpap5mwm5fyas08b3qcmy5bfq1c3wl4h0y3nihjibib7";
    };
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestMockObject = buildPerlPackage {
    name = "Test-MockObject-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/Test-MockObject-1.09.tar.gz;
      sha256 = "1cz385x0jrkj84nmfs6qyzwwvv8m9v8r2isagfj1zxvhdw49wdyy";
    };
    propagatedBuildInputs = [TestException UNIVERSALisa UNIVERSALcan];
  };

  TestMoose = Moose;

  TestMockTime = buildPerlPackage rec {
    name = "Test-MockTime-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DD/DDICK/${name}.tar.gz";
      sha256 = "104p9qsqcchfbxh6b6w7q9jhkwb4hc424js0cyivyanjm6bcqvj9";
    };
  };

  TestMojibake = buildPerlPackage {
    name = "Test-Mojibake-0.9";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SY/SYP/Test-Mojibake-0.9.tar.gz;
      sha256 = "0b7jamkmws6k3cvzwrz3r5vcpjrdhr8wndf82i5nx2z19xsy33ym";
    };
    meta = {
      homepage = https://github.com/creaktive/Test-Mojibake;
      description = "Check your source for encoding misbehavior";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestMore = TestSimple;

  TestMost = buildPerlPackage {
    name = "Test-Most-0.33";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OV/OVID/Test-Most-0.33.tar.gz;
      sha256 = "0jp4jcwk97bgf85wwyjpxfsx4165s6w1v4ymn9gnv03yn77inyij";
    };
    propagatedBuildInputs = [ ExceptionClass TestDeep TestDifferences TestException TestWarn ];
    meta = {
      description = "Most commonly needed test functions and features";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestNoTabs = buildPerlPackage {
    name = "Test-NoTabs-1.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BO/BOBTFISH/Test-NoTabs-1.3.tar.gz;
      sha256 = "06gvj0pgljc7n9rxhvwb0gq9wk51i3ks41lgh7a5ycqfkh9d0glw";
    };
    meta = {
      description = "Check the presence of tabs in your project";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestNoWarnings = buildPerlPackage {
    name = "Test-NoWarnings-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AD/ADAMK/Test-NoWarnings-1.04.tar.gz;
      sha256 = "0v385ch0hzz9naqwdw2az3zdqi15gka76pmiwlgsy6diiijmg2k3";
    };
    buildInputs = [ TestTester ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Make sure you didn't emit any warnings while testing";
      license = "open_source";
    };
  };

  TestObject = buildPerlPackage rec {
    name = "Test-Object-0.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "d142a91b039928dc5d616c7bd9bb62ffb06e58991f00c54e26ef7e62ed61032a";
    };
  };

  TestOutput = buildPerlPackage rec {
    name = "Test-Output-1.01";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Test/${name}.tar.gz";
      sha256 = "0hg2hv6sify6qcx4865m4gyfdfbi96aw7fx39zpvnrivk3i2jdcd";
    };
    buildInputs = [ TestTester ];
    propagatedBuildInputs = [ SubExporter ];
  };

  TestPerlCritic = buildPerlPackage rec {
    name = "Test-Perl-Critic-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/T/TH/THALJEF/${name}.tar.gz";
      sha256 = "89b242ff539034336ed87c11ef3e5ecac47c333a6ab8b46aab4cc449e3739a89";
    };
    propagatedBuildInputs = [ PerlCritic ];
  };

  TestPod = buildPerlPackage {
    name = "Test-Pod-1.48";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/Test-Pod-1.48.tar.gz;
      sha256 = "1hmwwhabyng4jrnll926b4ab73r40w3pfchlrvs0yx6kh6kwwy14";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Test-Pod/;
      description = "Check for POD errors in files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPodCoverage = buildPerlPackage rec {
    name = "Test-Pod-Coverage-1.08";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PETDANCE/${name}.tar.gz";
      sha256 = "0y2md932zhbxdjwzskx0vmw2qy7jxkn87f9lb5h3f3vxxg1kcqz0";
    };
    propagatedBuildInputs = [PodCoverage];
  };

  TestPodLinkCheck = buildPerlPackage {
    name = "Test-Pod-LinkCheck-0.007";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AP/APOCAL/Test-Pod-LinkCheck-0.007.tar.gz;
      sha256 = "de2992e756fca96824411bb3ab2b94b05567cb3f2c5e3ffd8162ffdfd1f77c88";
    };
    buildInputs = [ TestTester ];
    propagatedBuildInputs = [ CaptureTiny Moose TestPod podlinkcheck ];
    meta = {
      homepage = http://search.cpan.org/dist/Test-Pod-LinkCheck/;
      description = "Tests POD for invalid links";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestPortabilityFiles = buildPerlPackage {
    name = "Test-Portability-Files-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AB/ABRAXXA/Test-Portability-Files-0.06.tar.gz;
      sha256 = "3e0fd033387ab82df8aedd42a14a8e64200aebd59447ad62a3bc411ff4a808a8";
    };
    meta = {
      description = "Check file names portability";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestRequires = buildPerlPackage {
    name = "Test-Requires-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOKUHIROM/Test-Requires-0.06.tar.gz;
      sha256 = "1ksyg4npzx5faf2sj80rm74qjra4q679750vfqfvw3kg1d69wvwv";
    };
    meta = {
      description = "Checks to see if the module can be loaded";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestRoutine = buildPerlPackage {
    name = "Test-Routine-0.018";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Test-Routine-0.018.tar.gz;
      sha256 = "1slaljcija2pbsxdyrqsh09pgajxbln68gb47l9fwffb6gsp5f3m";
    };
    buildInputs = [ TestFatal ];
    propagatedBuildInputs = [ Moose namespaceautoclean namespaceclean ParamsUtil SubExporter ];
    meta = {
      homepage = https://github.com/rjbs/Test-Routine;
      description = "Composable units of assertion";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestScript = buildPerlPackage rec {
    name = "Test-Script-1.07";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "e21e5ee43a27b4c51b54ded5c92e60b817309778117a1d98ae6354abff27eb96";
    };
    propagatedBuildInputs = [ProbePerl IPCRun3];
  };

  TestSharedFork = buildPerlPackage {
    name = "Test-SharedFork-0.29";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EX/EXODIST/Test-SharedFork-0.29.tar.gz;
      sha256 = "63af7788cc35b9b7e6fa37c61220ca66abd6364d8bb90c20038e3d8241988a6e";
    };
    buildInputs = [ TestRequires ];
    meta = {
      homepage = https://github.com/tokuhirom/Test-SharedFork;
      description = "Fork test";
      license = "perl";
    };
  };

  TestSimple = null;

  TestSpec = buildPerlPackage {
    name = "Test-Spec-0.47";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PH/PHILIP/Test-Spec-0.47.tar.gz;
      sha256 = "e425c0b9efa3c7e21496d31a607d072a63e31988c3d298a8c1fd7d145cc0681e";
    };
    propagatedBuildInputs = [ PackageStash TestDeep TestTrap TieIxHash ];
    meta = {
      description = "Write tests in a declarative specification style";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestSubCalls = buildPerlPackage rec {
    name = "Test-SubCalls-1.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AD/ADAMK/${name}.tar.gz";
      sha256 = "a334b0457da338d79be2dbb62d403701fc90f7607df840115ff45ee1e2bd6e70";
    };
    propagatedBuildInputs = [ HookLexWrap ];
  };

  TestSynopsis = buildPerlPackage {
    name = "Test-Synopsis-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/Z/ZO/ZOFFIX/Test-Synopsis-0.10.tar.gz;
      sha256 = "0gbk4d2vwlldsj5shmbdar3a29vgrw84ldsvm26mflkr5ji34adv";
    };
    meta = {
      description = "Test your SYNOPSIS code";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestTableDriven = buildPerlPackage {
    name = "Test-TableDriven-0.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JR/JROCKWAY/Test-TableDriven-0.02.tar.gz;
      sha256 = "16l5n6sx3yqdir1rqq21d41znpwzbs8v34gqr93y051arypphn22";
    };
    meta = {
      description = "Write tests, not scripts that run them";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestTCP = buildPerlPackage {
    name = "Test-TCP-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOKUHIROM/Test-TCP-1.18.tar.gz;
      sha256 = "0flm7x0z7amppi9y6s8mxm0pkrgfihfpfjs0w4i6s80jiss1gfld";
    };
    propagatedBuildInputs = [ TestSharedFork ];
    meta = {
      description = "Testing TCP program";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestTester = buildPerlPackage {
    name = "Test-Tester-0.109";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FD/FDALY/Test-Tester-0.109.tar.gz;
      sha256 = "0m9n28z09kq455r5nydj1bnr85lvmbfpcbjdkjfbpmfb5xgciiyk";
    };
  };

  TestUnitLite = buildPerlPackage {
    name = "Test-Unit-Lite-0.1202";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DE/DEXTER/Test-Unit-Lite-0.1202.tar.gz;
      sha256 = "1a5jym9hjcpdf0rwyn7gwrzsx4xqzwgzx59rgspqlqiif7p2a79m";
    };
    meta = {
      description = "Unit testing without external dependencies";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  Testuseok = buildPerlPackage {
    name = "Test-use-ok-0.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AU/AUDREYT/Test-use-ok-0.11.tar.gz;
      sha256 = "8410438a2acf127bffcf1ab92205b747a615b487e80a48e8c3d0bb9fa0dbb2a8";
    };
    meta = {
      homepage = http://github.com/audreyt/Test-use-ok/tree;
      description = "Alternative to Test::More::use_ok";
      license = "unrestricted";
    };
  };

  TestWarn = buildPerlPackage {
    name = "Test-Warn-0.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Test-Warn-0.30.tar.gz;
      sha256 = "0haf2ii7br5z0psmkvlvmx2z2q9qz1c70gx0969r378qjidmb5w1";
    };
    propagatedBuildInputs = [ SubUplevel TreeDAGNode ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "Perl extension to test methods for warnings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWarnings = buildPerlPackage {
    name = "Test-Warnings-0.016";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/Test-Warnings-0.016.tar.gz;
      sha256 = "09ebc9afa29eb4d1d44fbd974dfcd52e0a2d9ce7ec3e3ee7602394157831aba9";
    };
    buildInputs = [ TestTester if_ ];
    meta = {
      homepage = https://github.com/karenetheridge/Test-Warnings;
      description = "Test for warnings and the lack of them";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWithoutModule = buildPerlPackage {
    name = "Test-Without-Module-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CO/CORION/Test-Without-Module-0.17.tar.gz;
      sha256 = "a691b0bf6d92dedbacfd547551021389ebc79c51937de2b914e792457da56ff7";
    };
    meta = {
      description = "Test fallback behaviour in absence of modules";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestWWWMechanize = buildPerlPackage {
    name = "Test-WWW-Mechanize-1.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PETDANCE/Test-WWW-Mechanize-1.44.tar.gz;
      sha256 = "062pj242vsc73bw11jqpap92ax9wzc9f2m4xhyp1wzrwkfchpl2q";
    };
    propagatedBuildInputs = [ CarpAssertMore HTMLTree HTTPServerSimple LWP TestLongString URI WWWMechanize ];
    meta = {
      homepage = https://github.com/petdance/test-www-mechanize;
      description = "Testing-specific WWW::Mechanize subclass";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  TestWWWMechanizeCatalyst = buildPerlPackage {
    name = "Test-WWW-Mechanize-Catalyst-0.59";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IL/ILMARI/Test-WWW-Mechanize-Catalyst-0.59.tar.gz;
      sha256 = "1hr1p8m3sv16ws8qb90nshza28qlmllnb6qxriwdvwddp2y517jv";
    };
    doCheck = false; # listens on an external port
    propagatedBuildInputs = [ CatalystRuntime LWP Moose namespaceclean TestWWWMechanize WWWMechanize ];
    meta = {
      description = "Test::WWW::Mechanize for Catalyst";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestWWWMechanizeCGI = buildPerlPackage {
    name = "Test-WWW-Mechanize-CGI-0.1";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/Test-WWW-Mechanize-CGI-0.1.tar.gz;
      sha256 = "0bwwdk0iai5dlvvfpja971qpgvmf6yq67iag4z4szl9v5sra0xm5";
    };
    propagatedBuildInputs = [ TestWWWMechanize WWWMechanizeCGI ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestWWWMechanizePSGI = buildPerlPackage {
    name = "Test-WWW-Mechanize-PSGI-0.35";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LB/LBROCARD/Test-WWW-Mechanize-PSGI-0.35.tar.gz;
      sha256 = "1hih8s49zf38bisvhnhzrrj0zwyiivkrbs7nmmdqm1qqy27wv7pc";
    };
    buildInputs = [ TestPod ];
    propagatedBuildInputs = [ Plack TestWWWMechanize TryTiny ];
    meta = {
      description = "Test PSGI programs using WWW::Mechanize";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestXPath = buildPerlModule {
    name = "Test-XPath-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/Test-XPath-0.16.tar.gz;
      sha256 = "09s47d5jcrx35dz623gjiqn0qmjrv0wb54czr7h01wffw1w8akxi";
    };
    propagatedBuildInputs = [ XMLLibXML ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TextAbbrev = buildPerlPackage {
    name = "Text-Abbrev-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Text-Abbrev-1.02.tar.gz;
      sha256 = "9cfb8bea2d5806b72fa1a0e1a3367ce662262eaa2701c6a3143a2a8076917433";
    };
    meta = {
      homepage = http://search.cpan.org/dist/Text-Abbrev;
      description = "Abbrev - create an abbreviation table from a list";
      license = "perl";
    };
  };

  TextAligner = buildPerlPackage {
    name = "Text-Aligner-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/Text-Aligner-0.10.tar.gz;
      sha256 = "0d80x5jrv5j9yi234rdnjvnsnmhm4jsssqv7bpkl1fhjd1kfc7v0";
    };
    meta = {
      description = "Align text in columns";
    };
  };

  TextAutoformat = buildPerlPackage {
    name = "Text-Autoformat-1.72";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/Text-Autoformat-1.72.tar.gz;
      sha256 = "b541152699fcd0f026322f283b7d9184839742aee0edb317a014c195ea26ae51";
    };
    propagatedBuildInputs = [ TextReform ];
    meta = {
      homepage = https://github.com/neilbowers/Text-Autoformat;
      description = "Automatic text wrapping and reformatting";
      license = "perl";
    };
  };

  TextBalanced = buildPerlPackage {
    name = "Text-Balanced-2.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHAY/Text-Balanced-2.03.tar.gz;
      sha256 = "057753f8f0568b53921f66a60a89c30092b73329bcc61a2c43339ab70c9792c8";
    };
    meta = {
      description = "Extract delimited text sequences from strings";
      license = "perl";
    };
  };

  TextBibTeX = buildPerlModule {
    name = "Text-BibTeX-0.69";
    buildInputs = [ ConfigAutoConf ExtUtilsLibBuilder ];
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AM/AMBS/Text/Text-BibTeX-0.69.tar.gz;
      sha256 = "1gzh5zh2ggfp15q5im7gpr1krq4mzmhbjdivyb2x03vcg0qdkk3z";
    };
    meta = {
      description = "Interface to read and parse BibTeX files";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextCSV = buildPerlPackage rec {
    name = "Text-CSV-1.32";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MA/MAKAMAKA/${name}.tar.gz";
      sha256 = "1bzrizyp8n2013nhd34j52bzdqcp9la30aqbdfkij52ssxkfm7xl";
    };
  };

  TextCSV_XS = buildPerlPackage {
    name = "Text-CSV_XS-1.19.tgz";
    src = fetchurl {
      url = mirror://cpan/authors/id/H/HM/HMBRAND/Text-CSV_XS-1.19.tgz;
      sha256 = "bcde887f613c6a50b0ce8f714cd2463570f5809f26581615690cfb424d2a7c16";
    };
    meta = {
      homepage = https://metacpan.org/pod/Text::CSV_XS;
      description = "Comma-Separated Values manipulation routines";
      license = "perl";
    };
  };

  TextDiff = buildPerlPackage {
    name = "Text-Diff-1.41";
    src = fetchurl {
      url = mirror://cpan/authors/id/O/OV/OVID/Text-Diff-1.41.tar.gz;
      sha256 = "1ynjsa4sr1yvyh65sdfvahaafglibz70j8b6rj01cg1iisj50zx6";
    };
    propagatedBuildInputs = [ AlgorithmDiff ];
    meta = {
      description = "Perform diffs on files and record sets";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextGlob = buildPerlPackage rec {
    name = "Text-Glob-0.09";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Text/${name}.tar.gz";
      sha256 = "0lr76wrsj8wcxrq4wi8z1640w4dmdbkznp06q744rg3g0bd238d5";
    };
  };

  TextIconv = buildPerlPackage {
    name = "Text-Iconv-1.7";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MP/MPIOTR/Text-Iconv-1.7.tar.gz;
      sha256 = "5b80b7d5e709d34393bcba88971864a17b44a5bf0f9e4bcee383d029e7d2d5c3";
    };
  };

  TestInter = buildPerlPackage {
    name = "Test-Inter-1.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SB/SBECK/Test-Inter-1.05.tar.gz;
      sha256 = "bda95ef503f1c1b39a5cd1ea686d18a67a63b56a8eb458f0614fc2acc51f7988";
    };
    meta = {
      description = "Framework for more readable interactive test scripts";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextMarkdown = buildPerlPackage rec {
    name = "Text-Markdown-1.0.26";
    src = fetchurl {
      url = "mirror://cpan/authors/id/B/BO/BOBTFISH/${name}.tar.gz";
      sha256 = "1ch8018yhn8mz38k0mrv5iljji1qqby2gfnvhvcm2vp65pjq2zdn";
    };
    buildInputs = [ FileSlurp ListMoreUtils Encode
      ExtUtilsMakeMaker TestException ];
  };

  TestMagpie = buildPerlPackage {
    name = "Test-Magpie-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CY/CYCLES/Test-Magpie-0.05.tar.gz;
      sha256 = "0a0c6vcj92spy6ngfdqn9yfym37jwxlds7hlw6xphkdmcklynh0b";
    };
    propagatedBuildInputs = [ aliased DevelPartialDump ListAllUtils Moose MooseXParamsValidate MooseXTypes MooseXTypesStructured namespaceautoclean SetObject SubExporter TestFatal ];
    meta = {
      description = "Spy on objects to achieve test doubles (mock testing)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TestMinimumVersion = buildPerlPackage {
    name = "Test-MinimumVersion-0.101081";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Test-MinimumVersion-0.101081.tar.gz;
      sha256 = "1javb92s0bl7gj2m3fsvzd0mn5r76clmayq8878mq12g4smdvpi2";
    };
    buildInputs = [ TestTester ];
    propagatedBuildInputs = [ FileFindRule FileFindRulePerl PerlMinimumVersion YAMLTiny ];
    meta = {
      description = "Does your code require newer perl than you think?";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TextMicroTemplate = buildPerlPackage {
    name = "Text-MicroTemplate-0.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/K/KA/KAZUHO/Text-MicroTemplate-0.20.tar.gz;
      sha256 = "0da44kd3z4n23wivy99583cscmiay2xv0wq9dzx6mg8vq874kx74";
    };
    meta = {
      description = "Micro template engine with Perl5 language";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TextPDF = buildPerlPackage rec {
    name = "Text-PDF-0.29a";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MH/MHOSKEN/${name}.tar.gz";
      sha256 = "11jig38vps957zyc9372q2g0jcabxgkql3b5vazc1if1ajhlvc4s";
    };
    propagatedBuildInputs = [ CompressZlib ];
  };

  TextRecordParser = buildPerlPackage rec {
    name = "Text-RecordParser-1.5.0";
    src = fetchurl {
      url = "mirror://cpan/authors/id/K/KC/KCLARK/Text-RecordParser-v1.5.0.tar.gz";
      sha256 = "0zlwpayjnpjani3v3hgi77207i3n5fppcxww20chdldx98dkj7jm";
    };

    # In a NixOS chroot build, the tests fail because the font configuration
    # at /etc/fonts/font.conf is not available.
    doCheck = false;

    propagatedBuildInputs = [ TestException IOStringy ClassAccessor Readonly ListMoreUtils
                              TestPod TestPodCoverage GraphViz ReadonlyXS TextTabularDisplay];
  };

  TextReform = buildPerlPackage {
    name = "Text-Reform-1.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Text-Reform-1.20.tar.gz;
      sha256 = "a8792dd8c1aac97001032337b36a356be96e2d74c4f039ef9a363b641db4ae61";
    };
    meta = {
      description = "Manual text wrapping and reformatting";
      license = "perl";
    };
  };

  TextSimpleTable = buildPerlPackage {
    name = "Text-SimpleTable-2.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/Text-SimpleTable-2.03.tar.gz;
      sha256 = "15hpry9jwrf1vbjyk21s65rllxrdvp2fdzzv9gsvczggby2yyzfs";
    };
    meta = {
      description = "Simple eyecandy ASCII tables";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  TextSoundex = buildPerlPackage {
    name = "Text-Soundex-3.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RJ/RJBS/Text-Soundex-3.04.tar.gz;
      sha256 = "2e56bb4324ee0186b908b3bd78463643affe7295624af0628e81491e910283d9";
    };
    propagatedBuildInputs = [ if_ ];
  };

  TextTable = buildPerlPackage {
    name = "Text-Table-1.129";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/Text-Table-1.129.tar.gz;
      sha256 = "1b8l86yvvsncnx0w45w095n1h7lff6nxjy87dzk7zgvkmr0ary7c";
    };
    buildInputs = [ TestPod TestPodCoverage ];
    propagatedBuildInputs = [ TextAligner ];
    meta = {
      homepage = http://www.shlomifish.org/open-source/projects/docmake/;
      description = "Organize Data in Tables";
      license = "bsd";
      platforms = stdenv.lib.platforms.linux;
    };
  };

  TextTabsWrap = buildPerlPackage {
    name = "Text-Tabs+Wrap-2013.0523";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MU/MUIR/modules/Text-Tabs+Wrap-2013.0523.tar.gz;
      sha256 = "b9cb056fffb737b9c12862099b952bf4ab4b1f599fd34935356ae57dab6f655f";
    };
    meta = {
      description = "Expand tabs and do simple line wrapping";
    };
  };

  TextTabularDisplay = buildPerlPackage rec {
    name = "Text-TabularDisplay-1.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/D/DA/DARREN/${name}.tar.gz";
      sha256 = "0sbyfdiln6q2g66mv64alayfcqnqg17kihdzgpslxdsn14vpvjq5";
    };
    propagatedBuildInputs = [TextAligner];
  };

  TextTemplate = buildPerlPackage {
    name = "Text-Template-1.46";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MJ/MJD/Text-Template-1.46.tar.gz;
      sha256 = "77d812cb86e48091bcd59aa8522ef887b33a0ff758f8a269da8c2b733889d580";
    };
    meta = {
      description = "Unknown";
      license = "unknown";
    };
  };

  TestTrap = buildPerlPackage {
    name = "Test-Trap-0.2.2";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/EB/EBHANSSEN/Test-Trap-v0.2.2.tar.gz;
      sha256 = "1ci5ag9pm850ww55n2929skvw3avy6xcrwmmi2yyn0hifxx9dybs";
    };
    buildInputs = [ TestTester ];
    propagatedBuildInputs = [ DataDump ];
    meta = {
      description = "Trap exit codes, exceptions, output, etc";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestVars = buildPerlModule {
    name = "Test-Vars-0.005";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GF/GFUJI/Test-Vars-0.005.tar.gz;
      sha256 = "2aec9787332dd2f12bd7b07e18530ff9c07954116bbaae8ae902a8befff57ae7";
    };
    meta = {
      homepage = https://github.com/gfx/p5-Test-Vars;
      description = "Detects unused variables";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TestVersion = buildPerlPackage {
    name = "Test-Version-1.002004";
    src = fetchurl {
      url = mirror://cpan/authors/id/X/XE/XENO/Test-Version-1.002004.tar.gz;
      sha256 = "1lvg1p6i159ssk5br5qb3gvrzdg59wchd97z7j44arnlkhfvwhgv";
    };
    buildInputs = [ TestException TestRequires TestTester ];
    propagatedBuildInputs = [ FileFindRulePerl ];
    meta = {
      homepage = http://search.cpan.org/dist/Test-Version/;
      description = "Check to see that version's in modules are sane";
      license = stdenv.lib.licenses.artistic2;
    };
  };

  TextTrim = buildPerlPackage {
    name = "Text-Trim-1.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MATTLAW/Text-Trim-1.02.tar.gz;
      sha256 = "1bnwjl5n04w8nnrzrm75ljn4pijqbijr9csfkjcs79h4gwn9lwqw";
    };
    meta = {
      description = "Remove leading and/or trailing whitespace from strings";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TextUnaccent = buildPerlPackage {
    name = "Text-Unaccent-1.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/L/LD/LDACHARY/Text-Unaccent-1.08.tar.gz;
      sha256 = "0avk50kia78kxryh2whmaj5l18q2wvmkdyqyjsf6kwr4kgy6x3i7";
    };
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  TextUnidecode = buildPerlPackage rec {
    name = "Text-Unidecode-0.04";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Text/${name}.tar.gz";
      sha256 = "01kbw5xshs906ikg0rgf51y9m6m26a4msv7ghcqwx7w2shgs0ga7";
    };
  };

  Testutf8 = buildPerlPackage {
    name = "Test-utf8-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKF/Test-utf8-1.01.tar.gz;
      sha256 = "ef371b1769cd8d36d2d657e8321723d94c8f8d89e7fd7437c6648c5dc6711b7a";
    };
    meta = {
      homepage = https://github.com/2shortplanks/Test-utf8/tree;
      description = "Handy utf8 tests";
      license = "perl";
    };
  };

  TextWikiFormat = buildPerlPackage {
    name = "Text-WikiFormat-0.81";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CY/CYCLES/Text-WikiFormat-0.81.tar.gz;
      sha256 = "0cxbgx879bsskmnhjzamgsa5862ddixyx4yr77lafmwimnaxjg74";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  threads = buildPerlPackage {
    name = "threads-2.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JD/JDHEDDEN/threads-2.01.tar.gz;
      sha256 = "429fea88757e0a347dac2cf9e414dfe8f06c8ca3c5445f6da4a95c2f883b6399";
    };
    meta = {
      description = "Perl interpreter-based threads";
      license = "perl";
    };
  };

  threadsshared = buildPerlPackage {
    name = "threads-shared-1.48";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JD/JDHEDDEN/threads-shared-1.48.tar.gz;
      sha256 = "7378a72bae424705e354476da69995fb8f62432bca8e98eab0fb9842da5120f8";
    };
    meta = {
      description = "Perl extension for sharing data structures between threads";
      license = "perl";
    };
  };

  ThreadQueue = buildPerlPackage {
    name = "Thread-Queue-3.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JD/JDHEDDEN/Thread-Queue-3.05.tar.gz;
      sha256 = "36bc1e50b5de47ff827fbaa1d7f028016e3ef115972cac84ed8cd73a0ef95300";
    };
    meta = {
      description = "Thread-safe queues";
      license = "perl";
    };
  };

  ThreadSemaphore = buildPerlPackage {
    name = "Thread-Semaphore-2.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JD/JDHEDDEN/Thread-Semaphore-2.12.tar.gz;
      sha256 = "e0f8e7057b073003e5a96a55b778abb8ee1cc1b279febedce0166526f2988965";
    };
    meta = {
      description = "Thread-safe semaphores";
      license = "perl";
    };
  };


  Throwable = buildPerlPackage rec {
    name = "Throwable-0.200010";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0qhq1f5bvgf5kjhmdg45vadq8dbc9gfms81hply5c6a71nmkv8yp";
    };
    propagatedBuildInputs = [ DevelStackTrace Moose Moo MooXTypesMooseLike ];
  };

  TieCycle = buildPerlPackage {
    name = "Tie-Cycle-1.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BD/BDFOY/Tie-Cycle-1.19.tar.gz;
      sha256 = "bd315874c85feaf8948eeb2f40fe2768a6ca00f089e35b32bfe88f3f384f9ca1";
    };
    meta = {
      description = "Cycle through a list of values via a scalar";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieFile = buildPerlPackage {
    name = "Tie-File-1.00";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/Tie-File-1.00.tar.gz;
      sha256 = "7ca9c8a957cf743d3a98d0eb5deb767b1e14b4f00bc9d03da83d466fcb76bd44";
    };
    meta = {
      description = "Access the lines of a disk file via a Perl array";
    };
  };

  TieIxHash = buildPerlPackage {
    name = "Tie-IxHash-1.23";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz;
      sha256 = "0mmg9iyh42syal3z1p2pn9airq65yrkfs66cnqs9nz76jy60pfzs";
    };
    meta = {
      description = "Ordered associative arrays for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieHashIndexed = buildPerlPackage {
    name = "Tie-Hash-Indexed-0.05";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MH/MHX/Tie-Hash-Indexed-0.05.tar.gz;
      sha256 = "a8862a4763d58a8c785e34b8b18e5db4ce5c3e36b9b5cf565a3088584eab361e";
    };
    meta = {
      description = "Ordered hashes for Perl";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TieRefHash = buildPerlPackage {
    name = "Tie-RefHash-1.39";
    src = fetchurl {
      url = mirror://cpan/authors/id/F/FL/FLORA/Tie-RefHash-1.39.tar.gz;
      sha256 = "b0b80ef571e7dadb726b8214f7352a932a8fa82af29072895aa1aadc89f48bec";
    };
  };

  TieToObject = buildPerlPackage {
    name = "Tie-ToObject-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NU/NUFFIN/Tie-ToObject-0.03.tar.gz;
      sha256 = "1x1smn1kw383xc5h9wajxk9dlx92bgrbf7gk4abga57y6120s6m3";
    };
    propagatedBuildInputs = [Testuseok];
  };

  TimeDate = buildPerlPackage {
    name = "TimeDate-2.30";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GB/GBARR/TimeDate-2.30.tar.gz;
      sha256 = "11lf54akr9nbivqkjrhvkmfdgkbhw85sq0q4mak56n6bf542bgbm";
    };
  };

  TimeDuration = buildPerlPackage {
    name = "Time-Duration-1.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/A/AV/AVIF/Time-Duration-1.06.tar.gz;
      sha256 = "0krzgxifghwir1ibxg147sfpqyyv8xpvipx0nwlwgyay46x4gdpp";
    };
    buildInputs = [ TestPod TestPodCoverage ];
    meta = {
      description = "Rounded or exact English expression of durations";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeDurationParse = buildPerlPackage {
    name = "Time-Duration-Parse-0.06";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIYAGAWA/Time-Duration-Parse-0.06.tar.gz;
      sha256 = "e88f0e1c322b477ec98fb295324bc78657ce25aa53cb353656f01241ea7fe4db";
    };
    buildInputs = [ TimeDuration ];
    propagatedBuildInputs = [ ExporterLite ];
    meta = {
      description = "Parse string that represents time duration";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TimeHiRes = buildPerlPackage rec {
    name = "Time-HiRes-1.9726";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Time/${name}.tar.gz";
      sha256 = "17hhd53p72z08l1riwz5f6rch6hngby1pympkla5miznn7cjlrpz";
    };
  };

  TimeLocal = buildPerlPackage {
    name = "Time-Local-1.2300";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/Time-Local-1.2300.tar.gz;
      sha256 = "b2acca03700a09f8ae737d3084f3f6287e983da9ab7b537c6599c291b669fb49";
    };
    meta = {
      description = "Efficiently compute time from local and GMT time";
      license = "perl";
    };
  };

  Tk = buildPerlPackage rec {
    name = "Tk-804.032_501";
    src = fetchurl {
      url = "http://search.cpan.org/CPAN/authors/id/S/SR/SREZIC/${name}.tar.gz";
      sha256 = "10fsvyr56gm59chc8b70n6bvhd3lh9c05sp8m4arcahid0rpgbwa";
    };
    makeMakerFlags = "X11LIB=${pkgs.xlibs.libX11}/lib";
    buildInputs = with pkgs; [ xlibs.libX11 libpng ];
    configurePhase = ''
      perl Makefile.PL PREFIX=$out $makeMakerFlags
    '';
    doCheck = false;
    meta ={
      homepage = "http://search.cpan.org/~srezic/Tk-804.032/Tk.pod";
      license = stdenv.lib.licenses.tcltk;
    };
  };

  TreeDAGNode = buildPerlPackage {
    name = "Tree-DAG_Node-1.09";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSAVAGE/Tree-DAG_Node-1.09.tgz;
      sha256 = "1k2byyk7dnm8l6i1igagpfr58b02zsq5hwd9jcdp8yrlih7dzii3";
    };
    buildInputs = [ TestPod ];
    meta = {
      homepage = http://search.cpan.org/perldoc?CPAN::Meta::Spec;
      description = "An N-ary tree";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TreeSimple = buildPerlPackage {
    name = "Tree-Simple-1.18";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/ST/STEVAN/Tree-Simple-1.18.tar.gz;
      sha256 = "0bb2hc8q5rwvz8a9n6f49kzx992cxczmrvq82d71757v087dzg6g";
    };
    buildInputs = [ TestException ];
    meta = {
      description = "A simple tree object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  TreeSimpleVisitorFactory = buildPerlPackage {
    name = "Tree-Simple-VisitorFactory-0.12";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RS/RSAVAGE/Tree-Simple-VisitorFactory-0.12.tgz;
      sha256 = "1g27xl48q1vr7aikhxg4vvcsj1si8allxz59vmnks61wsw4by7vg";
    };
    propagatedBuildInputs = [TreeSimple];
    buildInputs = [TestException];
  };

  TryTiny = buildPerlPackage {
    name = "Try-Tiny-0.22";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DO/DOY/Try-Tiny-0.22.tar.gz;
      sha256 = "60fba46f4693d33d54539104f9001df008dabb400b6837e9605c39a6ee6a1b19";
    };
    buildInputs = [ if_ ];
    meta = {
      homepage = http://metacpan.org/release/Try-Tiny;
      description = "Minimal try/catch with proper preservation of $@";
      license = stdenv.lib.licenses.mit;
    };
  };

  TypeTiny = buildPerlPackage {
    name = "Type-Tiny-1.000005";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TOBYINK/Type-Tiny-1.000005.tar.gz;
      sha256 = "42ed36c011825aa1e6995a4e8638621a1b2103a0970b15764ca3919368042365";
    };
    propagatedBuildInputs = [ ExporterTiny ];
    meta = {
      homepage = https://metacpan.org/release/Type-Tiny;
      description = "Tiny, yet Moo(se)-compatible type constraint";
      license = "perl";
    };
  };

  UNIVERSALcan = buildPerlPackage {
    name = "UNIVERSAL-can-1.20140328";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-can-1.20140328.tar.gz;
      sha256 = "522da9f274786fe2cba99bc77cc1c81d2161947903d7fad10bd62dfb7f11990f";
    };
    meta = {
      homepage = https://github.com/chromatic/UNIVERSAL-can;
      description = "Work around buggy code calling UNIVERSAL::can() as a function";
      license = "perl";
    };
  };

  UNIVERSALisa = buildPerlPackage {
    name = "UNIVERSAL-isa-1.20120726";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CH/CHROMATIC/UNIVERSAL-isa-1.20120726.tar.gz;
      sha256 = "1qal99sp888b50kwank9ffyprv7kqx42p4vyfahdabf915lyzc61";
    };
    meta = {
      homepage = https://github.com/chromatic/UNIVERSAL-isa;
      description = "Attempt to recover from people calling UNIVERSAL::isa as a function";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UNIVERSALrequire = buildPerlPackage {
    name = "UNIVERSAL-require-0.17";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEILB/UNIVERSAL-require-0.17.tar.gz;
      sha256 = "5dc9f13f2d2bbdf852387e2a63c0753728c2bea9125dd628c313db3ef66ec4c3";
    };
    meta = {
      description = "Require() modules from a variable";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeCheckUTF8 = buildPerlPackage {
    name = "Unicode-CheckUTF8-1.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/B/BR/BRADFITZ/Unicode-CheckUTF8-1.03.tar.gz;
      sha256 = "97f84daf033eb9b49cd8fe31db221fef035a5c2ee1d757f3122c88cf9762414c";
    };
    meta = {
      license = "unknown";
    };
  };

  UnicodeCollate = buildPerlPackage {
    name = "Unicode-Collate-1.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SADAHIRO/Unicode-Collate-1.04.tar.gz;
      sha256 = "4e3a2300b961d3aaf3789cdbfb95601edaaffb4109ed6cdb912a664d5c7bd706";
    };
    meta = {
      description = "Unicode Collation Algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeICUCollator = buildPerlPackage {
    name = "Unicode-ICU-Collator-0.002";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TONYC/Unicode-ICU-Collator-0.002.tar.gz;
      sha256 = "0gimwydam0mdgm6qjzzxny4gw8zda9kc2843kcl2xrpq7z7ww3f9";
    };
    meta = {
      description = "Wrapper around ICU collation services";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
    buildInputs = [ pkgs.icu ];
  };

  UnicodeLineBreak = buildPerlPackage {
    name = "Unicode-LineBreak-2013.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2013.11.tar.gz;
      sha256 = "8946b883ae687ff652e93d6185e23a936c7f337f2e115851fdfed72e1f73c7f9";
    };
    propagatedBuildInputs = [ MIMECharset ];
    meta = {
      description = "UAX #14 Unicode Line Breaking Algorithm";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  UnicodeNormalize = buildPerlPackage {
    name = "Unicode-Normalize-1.19";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SADAHIRO/Unicode-Normalize-1.19.tar.gz;
      sha256 = "ab16467692cb78ced706fb7bee4145ac09d9f14d9eed92be4a305de3172ce6c4";
    };
    meta = {
      description = "Unicode Normalization Forms";
      license = "perl";
    };
  };

  UnixGetrusage = buildPerlPackage {
    name = "Unix-Getrusage-0.03";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TA/TAFFY/Unix-Getrusage-0.03.tar.gz;
      sha256 = "76cde1cee2453260b85abbddc27cdc9875f01d2457e176e03dcabf05fb444d12";
    };
  };

  URI = buildPerlPackage {
    name = "URI-1.60";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/URI-1.60.tar.gz;
      sha256 = "0xr31mf7lfrwhyvlx4pzp6p7alls5gi4bj8pk5g89f5cckfd74hz";
    };
    meta = {
      description = "Uniform Resource Identifiers (absolute and relative)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIdb = buildPerlModule {
    name = "URI-db-0.15";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/URI-db-0.15.tar.gz;
      sha256 = "ac3dc3eeb8ca58dc4f7e1dfed6bca5bb8ebbc5dfacee63161490b09a4bfac982";
    };
    propagatedBuildInputs = [ URI URINested ];
    meta = {
      homepage = https://search.cpan.org/dist/URI-db/;
      description = "Database URIs";
      license = "perl";
    };
  };

  URIFind = buildPerlModule {
    name = "URI-Find-20111103";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSCHWERN/URI-Find-20111103.tar.gz;
      sha256 = "1igbbj14j5fssdqrbr60mg3w95wldfxdikplqdmqgf2zn5j65ibr";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      homepage = http://search.cpan.org/dist/URI-Find;
      description = "Find URIs in arbitrary text";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  URIFromHash = buildPerlPackage {
    name = "URI-FromHash-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DR/DROLSKY/URI-FromHash-0.04.tar.gz;
      sha256 = "03yckli4fj8cgsyh1l1lmyxj56q9qc04a3r8kv0whbnb37zz1j23";
    };
    propagatedBuildInputs = [ ParamsValidate URI ];
    meta = {
      description = "Build a URI from a set of named parameters";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  UriGoogleChart = buildPerlPackage rec {
    name = "URI-GoogleChart-1.02";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GA/GAAS/${name}.tar.gz";
      sha256 = "00hq5cpsk7sa04n0wg52qhpqf9i2849yyvw2zk83ayh1qqpc50js";
    };
    buildInputs = [URI TestMore];
  };

  URIIMAP = buildPerlPackage {
    name = "URI-imap-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/C/CW/CWEST/URI-imap-1.01.tar.gz;
      sha256 = "0bdv6mrdijcq46r3lmz801rscs63f8p9qqliy2safd6fds4rj55v";
    };
    propagatedBuildInputs = [URI];
  };

  URINested = buildPerlModule {
    name = "URI-Nested-0.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/D/DW/DWHEELER/URI-Nested-0.10.tar.gz;
      sha256 = "e1971339a65fbac63ab87142d4b59d3d259d51417753c77cb58ea31a8233efaf";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      homepage = https://metacpan.org/release/URI-Nested/;
      description = "Nested URIs";
      license = "perl";
    };
  };

  VariableMagic = buildPerlPackage rec {
    name = "Variable-Magic-0.53";
    src = fetchurl {
      url = "mirror://cpan/modules/by-module/Variable/${name}.tar.gz";
      sha256 = "1mxygb7q8n01klpzdmf8mvbm1i5zhazcm48yiw6dz0xk2fwrgz8q";
    };
  };

  version = buildPerlPackage rec {
    name = "version-0.9908";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JP/JPEACOCK/${name}.tar.gz";
      sha256 = "0nq84i1isk01ikwjxxynqyzz4g4g6hcbjq8l426n0hr42znlfmn4";
    };
  };

  VersionRequirements = buildPerlPackage rec {
    name = "Version-Requirements-0.101022";
    src = fetchurl {
      url = "mirror://cpan/authors/id/R/RJ/RJBS/${name}.tar.gz";
      sha256 = "0gn4cfx28sfsinxbf9lrxg4lzma8bsj99zb66lsg9irplrkx1pgl";
    };
  };

  W3CLinkChecker = buildPerlPackage rec {
    name = "W3C-LinkChecker-4.5";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SC/SCOP/${name}.tar.gz";
      sha256 = "0j2zlg57g0y9hqy8n35x5rfkpm7rnfjlwny5g0zaxwrl62ndkbm9";
    };
    propagatedBuildInputs = [
      LWP ConfigGeneral NetIP TermReadKey Perl5lib
      CryptSSLeay
    ];
    meta = {
      homepage = http://validator.w3.org/checklink;
      description = "A tool to check links and anchors in Web pages or full Web sites";
    };
  };

  WWWCurl = buildPerlPackage rec {
    name = "WWW-Curl-4.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SZ/SZBALINT/${name}.tar.gz";
      sha256 = "1fmp9aib1kaps9vhs4dwxn7b15kgnlz9f714bxvqsd1j1q8spzsj";
    };
    buildInputs = [ pkgs.curl ];
    preConfigure =
      ''
        substituteInPlace Makefile.PL --replace '"cpp"' '"gcc -E"'
      '';
    doCheck = false; # performs network access
  };

  WWWMechanize = buildPerlPackage {
    name = "WWW-Mechanize-1.73";
    src = fetchurl {
      url = mirror://cpan/authors/id/E/ET/ETHER/WWW-Mechanize-1.73.tar.gz;
      sha256 = "1zrw8aadhwy48q51x2z2rqlkwf17bya4j4h3hy89mw783j96rmg9";
    };
    propagatedBuildInputs = [ HTMLForm HTMLParser HTMLTree HTTPDaemon HTTPMessage HTTPServerSimple LWP LWPUserAgent TestWarn URI ];
    doCheck = false;
    meta = {
      homepage = https://github.com/bestpractical/www-mechanize;
      description = "Handy web browsing in a Perl object";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  WWWMechanizeCGI = buildPerlPackage {
    name = "WWW-Mechanize-CGI-0.3";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MR/MRAMBERG/WWW-Mechanize-CGI-0.3.tar.gz;
      sha256 = "046jm18liq7rwkdawdh9520cnalkfrk26yqryp7xgw71y65lvq61";
    };
    propagatedBuildInputs = [ HTTPRequestAsCGI WWWMechanize ];
    preConfigure = ''
      substituteInPlace t/cgi-bin/script.cgi \
        --replace '#!/usr/bin/perl' '#!${perl}/bin/perl'
    '';
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  WWWRobotRules = buildPerlPackage {
    name = "WWW-RobotRules-6.02";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz;
      sha256 = "07m50dp5n5jxv3m93i55qvnd67a6g7cvbvlik115kmc8lbkh5da6";
    };
    propagatedBuildInputs = [ URI ];
    meta = {
      description = "Database of robots.txt-derived permissions";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  Want = buildPerlPackage {
    name = "Want-0.26";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RO/ROBIN/Want-0.26.tar.gz;
      sha256 = "4951675e13de2b0b9792be2827b8ef46ef25a0b9a2d3e9132143444dac28e17c";
    };
  };

  Workflow = buildPerlPackage {
    name = "Workflow-1.41";
    src = fetchurl {
      url = mirror://cpan/authors/id/J/JO/JONASBN/Workflow-1.41.tar.gz;
      sha256 = "639fd428ddf186fdc7cad517cb7522b2bf092df26ef48470b2e8f747c4e8286e";
    };
    buildInputs = [ DBDMock ListMoreUtils TestException ];
    propagatedBuildInputs = [ ClassAccessor ClassFactory ClassObservable DBI DateTime DateTimeFormatStrptime ExceptionClass FileSlurp LogDispatch Log4Perl XMLSimple ];
    meta = {
      homepage = https://github.com/jonasbn/perl-workflow;
      description = "Simple, flexible system to implement workflows";
      license = "perl";
    };
  };

  Wx = buildPerlPackage rec {
    name = "Wx-0.9923";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MD/MDOOTSON/${name}.tar.gz";
      sha256 = "1ja2fkz0xabafyc6gnp3nnwsbkkjsf44kq9x5zz6cb5fsp3p9sck";
    };
    propagatedBuildInputs = [ ExtUtilsXSpp AlienWxWidgets ];
    # Testing requires an X server:
    #   Error: Unable to initialize GTK+, is DISPLAY set properly?"
    doCheck = false;
  };

  WxGLCanvas = buildPerlPackage rec {
    name = "Wx-GLCanvas-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBARBON/${name}.tar.gz";
      sha256 = "1q4gvj4gdx4l8k4mkgiix24p9mdfy1miv7abidf0my3gy2gw5lka";
    };
    propagatedBuildInputs = [ Wx OpenGL pkgs.mesa_glu ];
    doCheck = false;
  };

  X11IdleTime = buildPerlPackage rec {
    name = "X11-IdleTime-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AW/AWENDT/${name}.tar.gz";
      sha256 = "0j27cb9yy9ymni8cbiyxplbg086b8lv6b330nwqyx0briq3xrzfq";
    };
    buildInputs = [ pkgs.xlibs.libXext pkgs.xlibs.libXScrnSaver pkgs.xlibs.libX11 ];
    propagatedBuildInputs = [ InlineC ];
    patchPhase = ''sed -ie 's,-L/usr/X11R6/lib/,-L${pkgs.xlibs.libX11}/lib/ -L${pkgs.xlibs.libXext}/lib/ -L${pkgs.xlibs.libXScrnSaver}/lib/,' IdleTime.pm'';
    meta = {
      description = "Get the idle time of X11";
    };
  };

  X11Protocol = buildPerlPackage rec {
    name = "X11-Protocol-0.56";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SM/SMCCAM/${name}.tar.gz";
      sha256 = "1dq89bh6fqv7l5mbffqcismcljpq5f869bx7g8lg698zgindv5ny";
    };
    buildInputs = [pkgs.x11];
    NIX_CFLAGS_LINK = "-lX11";
    doCheck = false; # requires an X server
  };

  X11GUITest = buildPerlPackage rec {
    name = "X11-GUITest-0.28";
    src = fetchurl {
      url = "mirror://cpan/authors/id/C/CT/CTRONDLP/${name}.tar.gz";
      sha256 = "0jznws68skdzkhgkgcgjlj40qdyh9i75r7fw8bqzy406f19xxvnw";
    };
    buildInputs = [pkgs.x11 pkgs.xorg.libXtst pkgs.xorg.libXi];
    NIX_CFLAGS_LINK = "-lX11 -lXext -lXtst";
    doCheck = false; # requires an X server
  };

  X11XCB = buildPerlPackage rec {
    name = "X11-XCB-0.12";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MS/MSTPLBG/${name}.tar.gz";
      sha256 = "15jq55qcc27s5bn925pwry0vx2f4d42rlyz2hlfglnn2qnhsp37s";
    };
    AUTOMATED_TESTING = false;
    buildInputs = [
      ExtUtilsDepends ExtUtilsPkgConfig DataDump
      XMLSimple XMLDescent TestDeep TestException
      pkgs.xorg.libxcb pkgs.xorg.xcbproto pkgs.xorg.xcbutil pkgs.xorg.xcbutilwm
    ];
    propagatedBuildInputs = [ XSObjectMagic Mouse MouseXNativeTraits TryTiny ];
    NIX_CFLAGS_LINK = [ "-lxcb" "-lxcb-util" "-lxcb-xinerama" "-lxcb-icccm" ];
    doCheck = false; # requires an X server
    meta = {
      description = "XCB bindings for X";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLDescent = buildPerlPackage rec {
    name = "XML-Descent-1.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/A/AN/ANDYA/${name}.tar.gz";
      sha256 = "0l5xmw2hd95ypppz3lyvp4sn02ccsikzjwacli3ydxfdz1bbh4d7";
    };
    buildInputs = [ TestDifferences ];
    propagatedBuildInputs = [ XMLTokeParser ];
    meta = {
      description = "Recursive descent XML parsing";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLDOM = buildPerlPackage {
    name = "XML-DOM-1.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJMATHER/XML-DOM-1.44.tar.gz;
      sha256 = "1r0ampc88ni3sjpzr583k86076qg399arfm9xirv3cw49k3k5bzn";
    };
    propagatedBuildInputs = [XMLRegExp XMLParser LWP libxml_perl];
  };

  XMLFilterBufferText = buildPerlPackage {
    name = "XML-Filter-BufferText-1.01";
    src = fetchurl {
      url = mirror://cpan/authors/id/R/RB/RBERJON/XML-Filter-BufferText-1.01.tar.gz;
      sha256 = "8fd2126d3beec554df852919f4739e689202cbba6a17506e9b66ea165841a75c";
    };
    doCheck = false;
  };

  XMLFilterXInclude = buildPerlPackage {
    name = "XML-Filter-XInclude-1.0";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSERGEANT/XML-Filter-XInclude-1.0.tar.gz;
      sha256 = "98746f3c1f6f049491fec203d455bb8f8c9c6e250f041904dda5d78e21187f93";
    };
    doCheck = false;
  };

  XMLLibXML = buildPerlPackage rec {
    name = "XML-LibXML-2.0121";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "1j8d3kmkdlzvyx3khvrcrvp798h50i6zc5i3zm04d81prc8i0hzc";
    };
    SKIP_SAX_INSTALL = 1;
    buildInputs = [ pkgs.libxml2 ];
    propagatedBuildInputs = [ XMLSAX ];
  };

  XMLLibXMLSimple = buildPerlPackage {
    name = "XML-LibXML-Simple-0.93";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MA/MARKOV/XML-LibXML-Simple-0.93.tar.gz;
      sha256 = "f2eb1c1523d6414cf2a646a289b0325b489954382c862928d165a03a7cce767c";
    };
    propagatedBuildInputs = [ FileSlurp XMLLibXML ];
    meta = {
      description = "XML::LibXML based XML::Simple clone";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLLibXSLT = buildPerlPackage rec {
    name = "XML-LibXSLT-1.89";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SH/SHLOMIF/${name}.tar.gz";
      sha256 = "0py7ll5vj2k977l4r2g8bbz0hdy0hhkdq0mzblrwizify0825b12";
    };
    buildInputs = [ pkgs.zlib pkgs.libxml2 pkgs.libxslt ];
    propagatedBuildInputs = [ XMLLibXML ];
  };

  XMLNamespaceSupport = buildPerlPackage {
    name = "XML-NamespaceSupport-1.11";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.11.tar.gz;
      sha256 = "1sklgcldl3w6gn706vx1cgz6pm4y5lfgsjxnfqyk20pilgq530bd";
    };
  };

  XMLParser = buildPerlPackage {
    name = "XML-Parser-2.41";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/XML-Parser-2.41.tar.gz;
      sha256 = "1sadi505g5qmxr36lgcbrcrqh3a5gcdg32b405gnr8k54b6rg0dl";
    };
    patchPhase = if stdenv.isCygwin then ''
      sed -i"" -e "s@my \$compiler = File::Spec->catfile(\$path, \$cc\[0\]) \. \$Config{_exe};@my \$compiler = File::Spec->catfile(\$path, \$cc\[0\]) \. (\$^O eq 'cygwin' ? \"\" : \$Config{_exe});@" inc/Devel/CheckLib.pm
    '' else null;
    makeMakerFlags = "EXPATLIBPATH=${pkgs.expat}/lib EXPATINCPATH=${pkgs.expat}/include";
  };

  XMLXPath = buildPerlPackage {
    name = "XML-XPath-1.13";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MS/MSERGEANT/XML-XPath-1.13.tar.gz;
      sha256 = "0xjmfwda7m3apj7yrjzmkm4sjwnz4bqyaynzgcwqhx806kgw4j9a";
    };
    propagatedBuildInputs = [XMLParser];
  };

  XMLXPathEngine = buildPerlPackage {
    name = "XML-XPathEngine-0.14";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIROD/XML-XPathEngine-0.14.tar.gz;
      sha256 = "0r72na14bmsxfd16s9nlza155amqww0k8wsa9x2a3sqbpp5ppznj";
    };
    meta = {
      description = "A re-usable XPath engine for DOM-like trees";
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  XMLRegExp = buildPerlPackage {
    name = "XML-RegExp-0.04";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TJ/TJMATHER/XML-RegExp-0.04.tar.gz;
      sha256 = "0m7wj00a2kik7wj0azhs1zagwazqh3hlz4255n75q21nc04r06fz";
    };
  };

  XMLSAX = buildPerlPackage {
    name = "XML-SAX-0.96";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-0.96.tar.gz;
      sha256 = "024fbjgg6s87j0y3yik55plzf7d6qpn7slwd03glcb54mw9zdglv";
    };
    propagatedBuildInputs = [XMLNamespaceSupport];
    postInstall = ''
      perl -MXML::SAX -e "XML::SAX->add_parser(q(XML::SAX::PurePerl))->save_parsers()"
      '';
  };

  XMLSAXBase = buildPerlPackage {
    name = "XML-SAX-Base-1.08";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-SAX-Base-1.08.tar.gz;
      sha256 = "666270318b15f88b8427e585198abbc19bc2e6ccb36dc4c0a4f2d9807330219e";
    };
    meta = {
      description = "Base class for SAX Drivers and Filters";
      homepage = http://github.com/grantm/XML-SAX-Base;
      license = "perl";
    };
  };

  XMLSAXWriter = buildPerlPackage {
    name = "XML-SAX-Writer-0.56";
    src = fetchurl {
      url = mirror://cpan/authors/id/P/PE/PERIGRIN/XML-SAX-Writer-0.56.tar.gz;
      sha256 = "d073f7a25072c8150317b86b99d07031316a15bffab99e63e5afe591c8217d03";
    };
    propagatedBuildInputs = [ XMLFilterBufferText XMLNamespaceSupport XMLSAXBase ];
    meta = {
      homepage = https://github.com/perigrin/xml-sax-writer;
      description = "SAX2 XML Writer";
      license = "perl";
    };
  };

  XMLSemanticDiff = buildPerlPackage {
    name = "XML-SemanticDiff-1.0000";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SH/SHLOMIF/XML-SemanticDiff-1.0000.tar.gz;
      sha256 = "05rzm433vvndh49k8p4gqnyw4x4lxa4zr6qdlrlgplqkxvhvk6jk";
    };
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      maintainers = with maintainers; [ ocharles ];
      platforms   = stdenv.lib.platforms.unix;
    };
  };

  XMLSimple = buildPerlPackage {
    name = "XML-Simple-2.20";
    src = fetchurl {
      url = mirror://cpan/authors/id/G/GR/GRANTM/XML-Simple-2.20.tar.gz;
      sha256 = "0jj3jiray1l4pi9wkjcpxjc3v431whdwx5aqnhgdm4i7h3817zsw";
    };
    propagatedBuildInputs = [XMLParser];
  };

  XMLTokeParser = buildPerlPackage rec {
    name = "XML-TokeParser-0.05";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PO/PODMASTER/${name}.tar.gz";
      sha256 = "1hnpwb3lh6cbgwvjjgqzcp6jm4mp612qn6ili38adc9nhkwv8fc5";
    };
    propagatedBuildInputs = [ XMLParser ];
    meta = {
      description = "Simplified interface to XML::Parser";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XMLTwig = buildPerlPackage {
    name = "XML-Twig-3.44";
    src = fetchurl {
      url = mirror://cpan/authors/id/M/MI/MIROD/XML-Twig-3.44.tar.gz;
      sha256 = "1fi05ddq4dqpff7xvgsw2rr8p5bah401gmblyb3pvjg225ic2l96";
    };
    propagatedBuildInputs = [XMLParser];
    doCheck = false;  # requires lots of extra packages
  };

  XMLValidatorSchema = buildPerlPackage {
    name = "XML-Validator-Schema-1.10";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAMTREGAR/XML-Validator-Schema-1.10.tar.gz;
      sha256 = "6142679580150a891f7d32232b5e31e2b4e5e53e8a6fa9cbeecb5c23814f1422";
    };
    propagatedBuildInputs = [ TreeDAGNode XMLFilterBufferText XMLSAX ];
    meta = {
      description = "Validate XML against a subset of W3C XML Schema";
    };
  };

  XMLWriter = buildPerlPackage rec {
    name = "XML-Writer-0.625";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JO/JOSEPHW/${name}.tar.gz";
      sha256 = "1gjzs570i67ywbv967g8ylb5sg59clwmyrl2yix3jl70dhn55070";
    };
  };

  XSLoader = buildPerlPackage {
    name = "XSLoader-0.16";
    src = fetchurl {
      url = mirror://cpan/authors/id/S/SA/SAPER/XSLoader-0.16.tar.gz;
      sha256 = "96de61bad187919bf632cfa657f1b9957ad47defcc90dad8ee1f50c955eedb86";
    };
    meta = {
      homepage = https://metacpan.org/module/Math::BigInt;
      description = "Dynamically load C libraries into Perl code";
      license = "perl";
    };
  };

  XSObjectMagic = buildPerlPackage rec {
    name = "XS-Object-Magic-0.04";
    src = fetchurl {
      url = "mirror://cpan/authors/id/F/FL/FLORA/${name}.tar.gz";
      sha256 = "03fghj7hq0fiicmfdxhmzfm4mzv7s097pgkd32ji7jnljvhm9six";
    };
    buildInputs = [ ExtUtilsDepends TestFatal Testuseok ];
    meta = {
      description = "XS pointer backed objects using sv_magic";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  YAML = buildPerlPackage {
    name = "YAML-0.90";
    src = fetchurl {
      url = mirror://cpan/authors/id/I/IN/INGY/YAML-0.90.tar.gz;
      sha256 = "0kfsmhv1lmqw2g1038azpxkfb91valwkh4i4gfjvqrj2wsr2hzhq";
    };
    meta = {
      homepage = https://github.com/ingydotnet/yaml-pm/tree;
      description = "YAML Ain't Markup Language (tm)";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  YAMLSyck = buildPerlPackage {
    name = "YAML-Syck-1.27";
    src = fetchurl {
      url = mirror://cpan/authors/id/T/TO/TODDR/YAML-Syck-1.27.tar.gz;
      sha256 = "1y9dw18fz3s8v4n80wf858cjq4jlaza25wvsgv60a6z2l0sfax6y";
    };
    meta = {
      homepage = http://search.cpan.org/dist/YAML-Syck;
      description = "Fast, lightweight YAML loader and dumper";
      license = stdenv.lib.licenses.mit;
    };
  };

  YAMLTiny = buildPerlPackage rec {
    name = "YAML-Tiny-1.53";
    src = fetchurl {
      url = "mirror://cpan/authors/id/E/ET/ETHER/${name}.tar.gz";
      sha256 = "14p93i60x394ba6sdwpnckmv2vq7pfi9q7rzksp3nkxsz4484qmm";
    };
  };

  YAMLLibYAML = buildPerlPackage rec {
    name = "YAML-LibYAML-0.52";
    src = fetchurl {
      url = "mirror://cpan/authors/id/I/IN/INGY/${name}.tar.gz";
      sha256 = "14qajsfbi2syjz38iynj8c6qf0rv1zmy71kydzvvg9kcq1ib3h86";
    };
  };

}; in self
