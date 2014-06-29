use 5.010001;
use ExtUtils::MakeMaker;
my $CC = 'g++';
WriteMakefile(
    NAME              => 'Osadmin',
    VERSION_FROM      => 'lib/Osadmin.pm',
    PREREQ_PM         => {},
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Osadmin.pm',
       AUTHOR         => 'Magyarevity Miroszlav <perl@osadmin.com>') : ()),
    LIBS              => [''],
    DEFINE            => '',
    INC               => '-I. -I/opt/osadmin/src_ext/include',
    CC                => $CC,
    LD                => '$(CC)',
    XSOPT             => '-C++',
    TYPEMAPS          => ['perlobject.map' ],    
);
