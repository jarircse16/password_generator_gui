#!/usr/bin/perl

use strict;
use warnings;
use Tk;
use POSIX qw(strftime);

my $mw = MainWindow->new;
$mw->title("Password Generator");

# Create password length label and entry field
my $length_label = $mw->Label(-text => "Password Length:")->grid(-row => 0, -column => 0, -sticky => 'w');
my $length_entry = $mw->Entry(-width => 4)->grid(-row => 0, -column => 1, -sticky => 'w');
$length_entry->insert(0, "12"); # Default length is 12

# Create character type checkboxes
my $lowercase = $mw->Checkbutton(-text => "Lowercase Letters")->grid(-row => 1, -column => 0, -sticky => 'w');
my $uppercase = $mw->Checkbutton(-text => "Uppercase Letters")->grid(-row => 2, -column => 0, -sticky => 'w');
my $digits    = $mw->Checkbutton(-text => "Digits")->grid(-row => 3, -column => 0, -sticky => 'w');
my $symbols   = $mw->Checkbutton(-text => "Symbols")->grid(-row => 4, -column => 0, -sticky => 'w');

# Create number of passwords label and entry field
my $num_passwords_label = $mw->Label(-text => "Number of Passwords:")->grid(-row => 5, -column => 0, -sticky => 'w');
my $num_passwords_entry = $mw->Entry(-width => 4)->grid(-row => 5, -column => 1, -sticky => 'w');
$num_passwords_entry->insert(0, "1"); # Default number of passwords is 1

# Create generate button
my $generate_button = $mw->Button(-text => "Generate Password(s)", -command => \&generate_passwords)->grid(-row => 6, -columnspan => 2);

# Create output text widget
my $output = $mw->Scrolled('Text', -scrollbars => 'oe', -width => 30, -height => 10)->grid(-row => 7, -columnspan => 2);

MainLoop;

sub generate_passwords {
    my $length = $length_entry->get();
    my $num_passwords = $num_passwords_entry->get();
    my @chars = ();
    push @chars, 'a'..'z' if $lowercase->cget('-on');
    push @chars, 'A'..'Z' if $uppercase->cget('-on');
    push @chars, '0'..'9' if $digits->cget('-on');
    push @chars, qw(! @ # $ % ^ & * ( ) - _ = + [ ] { } | ; : " , < . > / ?) if $symbols->cget('-on');
    unless (@chars) {
        $output->delete('1.0', 'end');
        $output->insert('end', "Please select at least one character type");
        return;
    }
    my $passwords = "";
    for (1..$num_passwords) {
        my $password = '';
        for (1..$length) {
            $password .= $chars[int(rand(scalar(@chars)))];
        }
        $passwords .= "$password\n";
    }
    my $timestamp = strftime("%Y-%m-%d_%H-%M-%S", localtime);
    my $filename = "passwords_$timestamp.txt";
    open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
    print $fh $passwords;
    close $fh;
    $output->delete('1.0', 'end');
    $output->insert('end', $passwords);
}