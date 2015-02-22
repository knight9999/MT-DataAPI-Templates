package DataAPITemplates::Callback::Template;

use strict;
use warnings;

use MT::Log;
#use Data::Dump qw(dump);


sub can_list {
    my ( $eh, $app, $terms, $args, $options ) = @_;

    if ( $app->user->is_anonymous )
    {
        return 0;
    }
    if ( ! $app->user->permissions( $app->blog->id )->can_edit_templates ) {
  	    return 0;
	  }
    
#    my $log = MT::Log->new;
#    $log->message("templates is ok" . dump( $app->blog->id ) );
#    $log->level(MT::Log::INFO());
#    $log->author_id($app->user->id);
#    $log->ip($app->remote_ip);
#    $log->save or die $log->errstr;
 
    1;
}

sub can_view {
		my ( $eh , $app, $id ,$objp ) = @_;
		my $obj = $objp->force();
    if ( ! $app->user->permissions( $obj->blog_id )->can_edit_templates ) {
	    return 0;
	  }
	  1;
}


1;
