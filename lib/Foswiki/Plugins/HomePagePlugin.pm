# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# (c) 2009: Sven Dowideit, SvenDowideit@fosiki.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html

=pod

---+ package Foswiki::Plugins::HomePagePlugin

=cut


package Foswiki::Plugins::HomePagePlugin;

use strict;
require Foswiki::Func;    # The plugins API
require Foswiki::Plugins; # For the API version

our $VERSION = '$Rev: 1340 $';
our $RELEASE = '$Date: 2008-12-15 04:49:56 +1100 (Mon, 15 Dec 2008) $';
our $SHORTDESCRIPTION = 'Allow User specified home pages - on login';
our $NO_PREFS_IN_TOPIC = 1;

=begin TML

---++ initPlugin($topic, $web, $user) -> $boolean
   * =$topic= - the name of the topic in the current CGI query
   * =$web= - the name of the web in the current CGI query
   * =$user= - the login name of the user
   * =$installWeb= - the name of the web the plugin topic is in
     (usually the same as =$Foswiki::cfg{SystemWebName}=)

=cut

sub initPlugin {
    my( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if( $Foswiki::Plugins::VERSION < 2.0 ) {
        Foswiki::Func::writeWarning( 'Version mismatch between ',
                                     __PACKAGE__, ' and Plugins.pm' );
        return 0;
    }

    return 1;
}

sub initializeUserHandler {
    my ( $loginName, $url, $pathInfo ) = @_;

    return if ($Foswiki::Plugins::SESSION->inContext('viewfile'));
    
    my $gotoOnLogin = ($Foswiki::cfg{HomePagePlugin}{GotoHomePageOnLogin} and 
                                        $Foswiki::Plugins::SESSION->inContext('login'));
    if ($gotoOnLogin) {
        $loginName = $Foswiki::Plugins::SESSION->{request}->param('username');
        #pre-load the origurl with the 'login' url which forces templatelogin to use the requested web&topic
        $Foswiki::Plugins::SESSION->{request}->param( -name => 'origurl', 
                                            -value => $Foswiki::Plugins::SESSION->{request}->url());
    }

    #we don't know the user at this point so can only set up the site wide default
    my $path_info = $Foswiki::Plugins::SESSION->{request}->path_info();
    
    if (($path_info eq '' or $path_info eq '/') or 
        ($gotoOnLogin) ) {
        my $siteDefault = $Foswiki::cfg{HomePagePlugin}{SiteDefaultTopic};
        #$Foswiki::cfg{HomePagePlugin}{HostnameMapping}
        my $hostName = lc(Foswiki::Func::getUrlHost());
        if (defined($Foswiki::cfg{HomePagePlugin}{HostnameMapping}->{$hostName})) {
            $siteDefault = $Foswiki::cfg{HomePagePlugin}{HostnameMapping}->{$hostName};
        }
        
        if (Foswiki::Func::topicExists($Foswiki::cfg{UsersWebName}, 
                Foswiki::Func::getWikiName($loginName)) ) {
                    my( $meta, $text ) = Foswiki::Func::readTopic( $Foswiki::cfg{UsersWebName}, 
                Foswiki::Func::getWikiName($loginName) );
                    #TODO: make fieldname a setting.
                    my $field = $meta->get( 'FIELD', 'HomePage' );
                    my $userHomePage = $field->{value} if (defined($field));
                    $siteDefault = $userHomePage if ($userHomePage and ($userHomePage ne ''));
                }
        
        if (Foswiki::Func::webExists($siteDefault)) {
            #if they only set a webname, dwim
            $siteDefault .= '.'.$Foswiki::cfg{HomeTopicName};
        }
        my ( $web, $topic ) =
          $Foswiki::Plugins::SESSION->normalizeWebTopicName( '', $siteDefault );
        $Foswiki::Plugins::SESSION->{webName} = $web;
        $Foswiki::Plugins::SESSION->{topicName} = $topic;

    return undef;
}

}

1;
__END__
This copyright information applies to the HomePagePlugin:

# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# HomePagePlugin is  distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# For licensing info read LICENSE file in the Foswiki root.
