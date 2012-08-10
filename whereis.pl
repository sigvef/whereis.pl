use strict;
use utf8;
use LWP::Simple;
use vars qw($VERSION %IRSSI);
use Irssi qw(command_bind command_runsub);

$VERSION = '1';
%IRSSI = (
    authors	=> 'Sigve Sebastian Farstad',
    contact	=> 'sigveseb@arkt.is',
    name	=> 'Whereis',
    description	=> 'Finds the approximate location of a user via geolocation.',
    license	=> 'GPLv2',
    url		=> 'http://arkt.is/whereis/',
);

Irssi::command_bind('whereis' => sub {
    my ($data, $server, $item) = @_;
    $data =~ s/ //;
    $server->redirect_event('userhost', 1, $data , -1, 'redir failure', {
            '' => 'redir whereis' } );
    print ("** WHEREIS $data **");
    $server->send_raw("USERHOST :$data");
});

sub sig_whereis {
    my($server,$data) = @_;
    $data =~ s/^.*@//;
    my $geo = get('http://freegeoip.net/json/'.$data);
    while($geo =~ /"([^"]*)": "([^"]*)"/g){
        my $len = 12;
        if($2){
            print(sprintf("%${len}s: $2", $1));
        }
    }
}

sub sig_failure { }

Irssi::signal_add({
        'redir whereis' => \&sig_whereis,
        'redir whereis failure' => \&sig_failure
    });




