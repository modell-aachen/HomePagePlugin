# ---+ Extensions
# ---++ HomePagePlugin
# **Text**
#the web or topic to when none is specified, or on login/logoff
$Foswiki::cfg{HomePagePlugin}{SiteDefaultTopic} = '';


# **BOOLEAN**
#Always show user's HomePage (from the UserForm field in their User topic.)
#when they log in (makes sense if users have personalised home pages.) 
#but will mean that any URL's emailed to them will only be useful after login
$Foswiki::cfg{HomePagePlugin}{GotoHomePageOnLogin} = $FALSE;

# **PERL EXPERT**
# a hash mapping hostnames to DefaultTopics
# (so http://home.org.au and http://dowideit.org can use the same foswiki, but show different webs)
# defaults to {SiteDefaultTopic} above. *make sure the domain portion is specified in lower case*
$Foswiki::cfg{HomePagePlugin}{HostnameMapping} = {
    'http://home.org.au' => 'HomeOrgAu',
    'http://www.home.org.au' => 'HomeOrgAu',
    'http://dowideit.org' => 'Blog',
    'http://www.dowideit.org' => 'Blog',
    };


