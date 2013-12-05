#!/usr/bin/perl
# dhcpsync.pl
# Oct 8, 2013 2:25:00 PM
# David Rice (rice.davida@gmail.com)
# synchronize files on a keepalived cluster

use strict;
use Getopt::Long;
use Config::IniFiles;

# Printing the options
my $script_name = $0; $script_name =~ s/.*\///;
my $usage = sprintf <<EOF;
$script_name OPTIONS
  Required:  
    -c, --config
        path to config file
  Optional:
    -s, --status
        show the keepalived run status
    -h, --help
        this help message
EOF

# Defining the options
my $num_args = scalar(@ARGV);
my $status;
my $help;
my $config;
GetOptions(
    "status"=>\$status,
    "help"=>\$help,
    "config=s"=>\$config,
) or die "Error processing arguments\n$usage";
die $usage if ($help || !$num_args || !$config);


# Connecting to the config file
my $cfg = Config::IniFiles->new( -file => $config );
my @sections = $cfg->Sections();
my %ini;
tie %ini, 'Config::IniFiles', ( -file => $config );

# returns 0 if current node is the master, returns 1 if it is a backup
sub is_master {
    my $vip = $cfg->val('server', 'vip');
    my $device = $cfg->val('server', 'device');
    my $eth = `ip addr list $device`;
    
    print $eth;
    if ($eth =~ /$vip/) {
        print "MASTER\n";
        return 0;
    } elsif (!$eth) {
        die "Device \"$device\" does not exist.";
        print "Device \"$device\" does not exist.";
    } else {
        print "BACKUP\n";
        return 1;
    }
}

# will copy the file from the MASTER node
sub copy_file {
    my $filename = $cfg->val('server', 'file');
    my $vip = $cfg->val('server', 'vip');
    system("scp root\@$vip:$filename $filename");
}

# will start designated service
sub start_services {
    my $service = $cfg->val('server', 'service');
    my $status = `/bin/ps cax | /bin/grep $service`;
    if ( !$status ) {
        system("service $service start");
    }
}

# Main 
{
    # Just show the status of the current node and what would happen
    # If it is not the current master, it will copy the file.
    if ( $status ) {
        is_master();
        if ( is_master() == 1 ) {
            print "Syncing file with MASTER\n";
        } else {
            print "File would not be copied\n";
        }
    } # Run the script as is
    elsif( is_master() == 1 ) {
        copy_file();
        start_services();
    }
}
