## spugtex.pl: a LaTeX symbol plugin for irssi
#
# USAGE:
# /math <some nice math>
# Replaces the symbol keywords in your message with unicode codepoints.
#
# /mathp <some nice math>
# Prints a preview of the message to the current window.
#
# Example:
#
#     command: /math Lambda = alpha/omega
#     result:  Λ = α/ω
#
# INSTALLATION:
#
# Copy this file to your irssi scripts directory:
#  
#     $ wget -O ~/.irssi/scripts/spugtex.pl https://raw.github.com/seece/spugtex/master/spugtex.pl 
#
# and load the script in irssi with
#
#     /script load spugtex.pl
#
#

use Irssi;
use Irssi::Irc;
use strict;
use warnings;
use vars qw($VERSION %IRSSI);
$VERSION="1.0.5";

%IRSSI = (
	authors => 'Pekka Väänänen',
	contact => 'pekka.vaananen\@iki.fi',
	name => 'spugtex',
	description => 'Replaces LaTeX symbol keywords in your message with unicode codepoints.
	',
	license => 'MIT',
	url => 'http://www.lofibucket.com'
);

# LaTeX symbol names
our %symbols = (
	'Gamma' => 915,
	'Delta' => 8710,
	'Lambda' => 923,
	'Phi' => 934,
	'Pi' => 928,
	'Psi' => 936,
	'Sigma' => 931,
	'Theta' => 920,
	'Upsilon' => 933,
	'Xi' => 926,
	'Omega' => 8486,
	'alpha' => 945,
	'beta' => 946,
	'gamma' => 947,
	'delta' => 948,
	'epsilon' => 15,
	'zeta' => 950,
	'eta' => 951,
	'theta' => 952,
	'iota' => 953,
	'kappa' => 954,
	'lambda' => 955,
	'mu' => 181,
	'nu' => 957,
	'xi' => 958,
	'pi' => 960,
	'rho' => 961,
	'sigma' => 963,
	'tau' => 964,
	'upsilon' => 965,
	'phi' => 966,

	'chi' => 967,
	'psi' => 968,
	'omega' => 969,
	'digamma' => 122,
	'varepsilon' => 949,
	'varkappa' => 954,
	'varphi' => 981,
	'varpi' => 36,
	'varrho' => 37,
	'varsigma' => 962,
	'vartheta' => 977,
	'aleph' => 8501,
	'beth' => 105,
	'daleth' => 107,
	'complement' => 123,
	'ell' => 96,
	'eth' => 240,
	'hbar' => 126,
	'hslash' => 125,
	'mho' => 102,
	'partial' => 8706,
	'wp' => 8472,
	'circledS' => 115,
	'Bbbk' => 107,
	'Finv' => 96,
	'Game' => 97,
	'angle' => 8736,
	'backprime' => 56,
	'bigstar' => 70,
	'blacklozenge' => 7,
	'blacksquare' => 4,
	'blacktriangle' => 78,
	'blacktriangledown' => 72,
	'bot' => 8869,
	'clubsuit' => 9827,
	'diagdown' => 31,
	'diagup' => 30,
	'diamondsuit' => 9830,
	'emptyset' => 8709,
	'exists' => 8707,
	'flat' => 91,
	'forall' => 8704,
	'heartsuit' => 9829,
	'infty' => 8734,
	'lozenge' => 9830,
	'measuredangle' => 93,
	'nabla' => 8711,
	'natural' => 92,
	'neg' => 172,
	'nexists' => 64,
	'prime' => 48,
	'sharp' => 93,
	'spadesuit' => 9824,
	'sphericalangle' => 94,
	'surd' => 8730,
	'top' => 62,
	'triangle' => 52,
	'triangledown' => 79,
	'varnothing' => 8709,

);

sub convert {
	my $input = shift;

	while (my ($name, $code) = each %symbols) {
		my $kode = chr($code);
		$input =~ s/(?<=\W|^)($name)(?=\W|$)/$kode/g;
	}

	$input;
}

sub cmd_math {
	my ($data, $server, $witem) = @_;

	if (!$server || !$server->{connected}) {
		Irssi::print("Not connected to a server");
		return;
	}

	if (!$data) {
		return;
	}

	my $result = convert($data);
	$witem->command("/SAY $result");
}

sub cmd_math_preview {
	my ($data, $server, $witem) = @_;

	if (!$data) {
		return;
	}

	my $result = convert($data);
	Irssi::active_win->print("Preview: $result");
}

Irssi::command_bind('math', 'cmd_math');
Irssi::command_bind('mathp', 'cmd_math_preview');

