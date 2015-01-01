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
use Encode qw(decode encode);
use List::Util qw(min max);
use strict;
use warnings;
use vars qw($VERSION %IRSSI);
use utf8;
$VERSION="1.1.0";

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
	'alpha' => 'α',
	'theta' => 'θ' ,
	'tau' => 'τ' ,
	'beta' => 'β' ,
	'vartheta' => 'ϑ' ,
	'pi' => 'π' ,
	'upsilon' => 'υ' ,
	'gamma' => 'γ' ,
	'iota' => 'ι' ,
	'phi' => 'φ' ,
	'delta' => 'δ' ,
	'kappa' => 'κ' ,
	'rho' => 'ρ' ,
	'varphi' => 'ϕ' ,
	'epsilon' => 'ϵ',
	'lambda' => 'λ' ,
	'chi' => 'χ' ,
	'varepsilon' => 'ε' ,
	'mu' => 'μ' ,
	'sigma' => 'σ' ,
	'psi' => 'ψ' ,
	'zeta' => 'ζ' ,
	'nu' => 'ν' ,
	'varsigma' => 'ς' ,
	'omega' => 'ω' ,
	'eta' => 'η' ,
	'xi' => 'ξ' ,
	'Gamma' => 'Γ' ,
	'Lambda' => 'Λ' ,
	'Sigma' => 'Σ' ,
	'Psi' => 'Ψ' ,
	'Delta' => 'Δ' ,
	'Xi' => 'Ξ' ,
	'Upsilon' => 'Υ' ,
	'Omega' => 'Ω' ,
	'Theta' => 'Θ' ,
	'Pi' => 'Π' ,
	'Phi' => 'Φ' ,
	'pm' => '±' ,
	'cap' => '∩' ,
	'oplus' => '⊕' ,
	'mp' => '∓' ,
	'cup' => '∪' ,
	'times' => '×' ,
	'otimes' => '⊗' ,
	'div' => '÷' ,
	'ast' => '∗' ,
	'star' => '★' ,
	'vee' => '∨' ,
	'lhd' => '✁' ,
	'circ' => '◦' ,
	'wedge' => '∧' ,
	'rhd' => '✄' ,
	'dagger' => '†' ,
	'bullet' => '•' ,
	'unlhd' => '✂' ,
	'ddagger' => '‡' ,
	'cdot' => '·' ,
	'unrhd' => '☎' ,
	'leq' => '≤' ,
	'geq' => '≥' ,
	'equiv' => '≡' ,
	'models' => '|=' ,
	'prec' => '≺' ,
	'sim' => '∼' ,
	'perp' => '⊥' ,
	'mid' => '|' ,
	'subset' => '⊂' ,
	'supset' => '⊃' ,
	'approx' => '≈' ,
	'subseteq' => '⊆' ,
	'supseteq' => '⊇' ,
	'neq' => '≠' ,
	'in' => '∈' ,
	'ni' => '∋' ,
	'propto' => '∝' ,
	'vdash' => '⊢' ,
	'dashv' => '⊣' ,
	'leftarrow' => '←' ,
	'longleftarrow' => '←−' ,
	'uparrow' => '↑' ,
	'Leftarrow' => '⇐' ,
	'Uparrow' => '⇑' ,
	'rightarrow' => '→' ,
	'downarrow' => '↓' ,
	'Rightarrow' => '⇒' ,
	'Downarrow' => '⇓' ,
	'leftrightarrow' => '↔' ,
	'Leftrightarrow' => '⇔' ,
	'Longleftrightarrow' => '⇐⇒' ,
	'leadsto' => '↪' ,
	'forall' => '∀' ,
	'infty' => '∞' ,
	'emptyset' => '∅' ,
	'exists' => '∃' ,
	'imath' => 'ı' ,
	'nabla' => '∇' ,
	'neg' => '¬' ,
	'surd' => '√' ,
	'natural' => '-' ,
	'clubsuit' => '♣' ,
	'bot' => '⊥' ,
	'diamondsuit' => '♦' ,
	'heartsuit' => '♥' ,
	'Im' => 'O' ,
	'angle' => '∠' ,
	'partial' => '∂' ,
	'spadesuit' => '♠' ,
	'mho' => '✵' ,
	'lll' => '≪' ,
	'lessgtr' => '≶' ,
	'ggg'        => '≫',
	'gtrless'    => '≷',
	'thicksim'   => '∼', 
	'thickapprox'=> '≈', 
	'varpropto'  => '∝', 
	'therefore'  => '∴',
	'because'    => '∵', 
);

sub convert {
	my $input = shift;
	$input = decode('UTF-8', $input, Encode::FB_CROAK);

	while (my ($name, $code) = each %symbols) {
		$input =~ s/(\W|^)\K($name)(?=\W|$)/$code/g;
	}

	encode('UTF-8', $input, Encode::FB_CROAK);
}

sub cmd_math {
	my ($data, $server, $witem) = @_;

	if (!$server || !$server->{connected}) {
		Irssi::print("Not connected to a server");
		return;
	}

	if (!$witem || 
            !($witem->{type} eq "CHANNEL" || $witem->{type} eq "QUERY")) {
		Irssi:print("Not on active channel or query, try mathp instead");
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

sub cmd_math_list {
	my $counter = 0;
	my $line = "";

	while (my ($name, $code) = each %symbols) {
		# List symbols in two columns
		if ($counter % 2 == 0) {
			$line =$line . "$name: $code " ;
		} else {
			$line =$line ." " x (max(0,20 - length($line))) . "$name: $code " ;
			Irssi::active_win->print($line);
			$line = "";
		}

		$counter++;
	}

	Irssi::active_win->print($line);
}

sub cmd_math_run{
	my ($data, $server, $witem) = @_;

	if (!$data) {
		return;
	}

	$_ = $data;

	if (m/^list/i) {
		cmd_math_list($data, $server, $witem);
		return;
	} elsif (m/^preview/i) {
		$_ =~ s/^\S+\s+//;
		cmd_math_preview($_, $server, $witem);
		return;
	}

	Irssi::active_win->print("spugtex: Unknown command.");
}

Irssi::command_bind('math', 'cmd_math');
Irssi::command_bind('mathp', 'cmd_math_preview');
Irssi::command_bind('spug', 'cmd_math_run');

