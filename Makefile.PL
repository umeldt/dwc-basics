use 5.024004;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'DwC::Plugin::Basics',
    VERSION_FROM      => 'lib/DwC/Plugin/Basics.pm',
    PREREQ_PM         => { DwC => 0.01 },
    ABSTRACT_FROM     => 'lib/DwC/Plugin/Basics.pm',
    AUTHOR            => 'umeldt <chris@svindseth.jp>',
    LICENSE           => 'perl',
);

