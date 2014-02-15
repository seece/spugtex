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
#lhd bigcirc ∗ 
	'circ' => '◦' ,
	'wedge' => '∧' ,
	'rhd' => '✄' ,
	'dagger' => '†' ,
	'bullet' => '•' ,
	'unlhd' => '✂' ,
	'ddagger' => '‡' ,
	'cdot' => '·' ,
	'unrhd' => '☎' ,
#  amalg
	'leq' => '≤' ,
	'geq' => '≥' ,
	'equiv' => '≡' ,
	'models' => '|=' ,
	'prec' => '≺' ,
# succ
	'sim' => '∼' ,
	'perp' => '⊥' ,
# preceq
#succeq
#simeq
	'mid' => '|' ,
# ll
#gg
# asymp
#" parallel
	'subset' => '⊂' ,
	'supset' => '⊃' ,
	'approx' => '≈' ,
# bowtie
	'subseteq' => '⊆' ,
	'supseteq' => '⊇' ,
# cong
#✶ Join
#❁ sqsubset
#∗ ❂ sqsupset
	'neq' => '≠' ,
#? smile
#  ) sqsubseteq
#* sqsupseteq
#.
# doteq
#" frown
	'in' => '∈' ,
	'ni' => '∋' ,
	'propto' => '∝' ,
#= =
	'vdash' => '⊢' ,
	'dashv' => '⊣' ,
#< < > >
	'leftarrow' => '←' ,
	'longleftarrow' => '←−' ,
	'uparrow' => '↑' ,
	'Leftarrow' => '⇐' ,
#⇐ Longleftarrow
	'Uparrow' => '⇑' ,
	'rightarrow' => '→' ,
#−→ longrightarrow
	'downarrow' => '↓' ,
	'Rightarrow' => '⇒' ,
#=⇒ Longrightarrow
	'Downarrow' => '⇓' ,
	'leftrightarrow' => '↔' ,
#←→ longleftrightarrow
#9 updownarrow
	'Leftrightarrow' => '⇔' ,
	'Longleftrightarrow' => '⇐⇒' ,
#; Updownarrow
#<→ mapsto
#<−→ longmapsto
#= nearrow
#← hookleftarrow
#$→ hookrightarrow
# searrow
#% leftharpoonup
#& rightharpoonup
#? swarrow
#' leftharpoondown
#( rightharpoondown
#  @ nwarrow
#  rightleftharpoons
	'leadsto' => '↪' ,
#  ∗
#ℵ aleph
#B prime
	'forall' => '∀' ,
	'infty' => '∞' ,
#hbar
	'emptyset' => '∅' ,
	'exists' => '∃' ,
#✷ Box
#∗
	'imath' => 'ı' ,
	'nabla' => '∇' ,
	'neg' => '¬' ,
#/✸ Diamond
#∗
#j jmath
	'surd' => '√' ,
#* flat
#I triangle
#+ ell
#J top
	'natural' => '-' ,
	'clubsuit' => '♣' ,
#wp ℘ 
	'bot' => '⊥' ,
#sharp 0 
	'diamondsuit' => '♦' ,
#Re M 
# \| \ backslash
	'heartsuit' => '♥' ,
	'Im' => 'O' ,
	'angle' => '∠' ,
	'partial' => '∂' ,
	'spadesuit' => '♠' ,
	'mho' => '✵' ,
# ∗
#sum
#bigcap
#bigodot
#prod
# bigcup
#bigotimes
#coprod
#bigsqcup
#bigoplus
#Üint  bigvee
#biguplus
#sub oint
#bigwedge
#leqq
#E leqslant
#F eqslantless
#G lesssim
#H lessapprox
#leqq
#E leqslant
#F eqslantless
#G lesssim
#H lessapprox
#pproxeq  lessdot
	'lll' => '≪' ,
	'lessgtr' => '≶' ,
#K lesseqgtr
#L lesseqqgtr
#M doteqdot
#N risingdotseq
#O fallingdotseq
#P backsim
#Q backsimeq
#R subseteqq
#S Subset
#❁ sqsubset
#T preccurlyeq
#U curlyeqprec
#V precsim
#precapprox
#W vartriangleleft
#X trianglelefteq
#Y vDash
#Z Vvdash
#[ smallsmile
#\ smallfrown
#] bumpeq
#^ Bumpeq
#_ geqq
#` geqslant
#a eqslantgtr
#b gtrsim
#c gtrapprox
	'≫' => 'ggg',
	'≷' => 'gtrless',
#f gtreqless
#g gtreqqless
	'∼' => 'thicksim',
	'≈' => 'thickapprox',
	'❂' => 'sqsupset',
#p vartriangleright
#q trianglerighteq
	'∝' => 'varpropto',
#v blacktriangleleft
	'∴' => 'therefore',
#x blacktriangleright
	'∵' => 'because',
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

