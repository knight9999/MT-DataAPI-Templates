package DataAPITemplates::EndPoint::Template;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

require MT::TemplateMap;

#use Data::Dump qw(dump);

sub list {
	my ( $app, $endpoint ) = @_;
    my $res = filtered_list( $app, $endpoint, 'template' ) or return;

    {  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}


sub get {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $template ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'template', $template->id, obj_promise($template) )
        or return;

    $template;
}

sub templateMapListFromObject {
    my ($obj) = @_;
    my $app = MT->instance;

    my @maps = MT::TemplateMap->load( { blog_id => $obj->blog_id , template_id => $obj->id } );
		my $list = MT::DataAPI::Resource->from_object( \@maps );

		$list;
#    ["a","b"];		# dummy
}

sub templateMapListToObject {
	my ($hash,$obj) = @_;

	
	if (exists($hash->{'maps'})) {	

		my $maps = $hash->{'maps'};
	
		$obj->save;
    
    
		if ($obj->type eq 'page' || $obj->type eq 'individual' || $obj->type eq 'archive') {				
		  my $dest_maps = MT::DataAPI::Resource->to_object( "templatemap" , $maps  );
		  
		  my @src_maps = my @maps = MT::TemplateMap->load( { blog_id => $obj->blog_id , template_id => $obj->id } );
		  my $src_maps = \@src_maps;
		  
		  my $results = separateMap($dest_maps,$src_maps);
		  
		  my $adding_maps = $results->{'adding_maps'};
		  my $remove_maps = $results->{'remove_maps'};

#    open FH, ">/tmp/mttmpl.txt";
#    print FH dump( $results );
#    close FH;
		  
		  foreach my $remove_map (@$remove_maps) {
			  if (scalar( @$adding_maps ) > 0) {
				  my $map = pop( @$adding_maps );
				  copyMap( $map , $remove_map );	
				  $remove_map->save;
			  } else {
			   	$remove_map->remove or die "Removing foo failed: ", $remove_map->errstr;
			  }
		  }
		  
		  foreach my $dest_map (@$adding_maps) {
    		$dest_map->template_id( $obj->id );
    		$dest_map->blog_id( $obj->blog_id );
  			$dest_map->save;
		  }	
		  
		}
	}
		
	();  # dummy.
}


sub create {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_)
        or return;

    my $author = $app->user;

    my $orig_template = $app->model('template')->new;
    $orig_template->set_values(
        {   blog_id        => $blog->id,
#            author_id      => $author->id,
        }
    );

    my $new_template = $app->resource_object( 'template', $orig_template )
        or return;

    save_object( $app, 'template', $new_template )
        or return;

    $new_template;
}

sub update {

    my ( $app, $endpoint ) = @_;

    my ( $blog, $orig_template ) = context_objects(@_)
        or return;

    my $new_template = $app->resource_object( 'template', $orig_template )
        or return;

    save_object( $app, 'template', $new_template )
        or return;

    $new_template;

}

sub compareTemplateMap {
  my ( $map1 , $map2 ) = @_;
	my @list = ( 'archive_type' , 'build_interval' , 'build_type' , 'file_template' , 'is_preferred' );

# open FH, ">/tmp/mttmpl.txt";
#	print FH dump($map1);
#	print FH dump($map2);
	
    my $flag = 1;
	  foreach my $key (@list) {
#	    print FH $map1->$key . ":" . $map2->$key;
	
		  if ($map1->$key ne $map2->$key) {
			  $flag = 0;
		  }
	  }  

#	print FH "flag = " . $flag;
# close FH;

	return $flag;  
}

sub isIncludedMap {
  	my ( $map , $maps ) = @_;
  	my $index = -1;
  	for (my $i=0;$i<scalar(@$maps);$i++) {
  		my $tmp = $maps->[$i];
  		if ($tmp && compareTemplateMap($map,$tmp)) {
  		  $index = $i;
  		}
  	}
  	return $index;
}

sub separateMap {
	my ( $src_maps, $dest_maps ) = @_;
	my $preserved_maps = [];
	my $remove_maps = [];
	my $adding_maps = [];
	my $temp_maps = [];

	foreach my $map ( @$dest_maps ) {
		push( @$temp_maps , $map );
  }
	
	foreach my $map ( @$src_maps ) {
		my $index = isIncludedMap( $map , $temp_maps);
		if ($index >= 0) {
			push( @$preserved_maps , $temp_maps->[$index] );
			$temp_maps->[$index] = 0;
		} else {
			push ( @$adding_maps , $map );
		}
	}
	
	foreach my $map ( @$temp_maps ) { 
	  if ($map) {
	  	push( @$remove_maps , $map );
	  }
	}
	
	return { 'adding_maps' => $adding_maps , 
	         'remove_maps' => $remove_maps ,
	         'preserved_maps' => $preserved_maps };

}

sub copyMap {
	my ($src_map,$dest_map) = @_;
	$dest_map->archive_type($src_map->archive_type);
	$dest_map->build_interval($src_map->build_interval);
	$dest_map->build_type($src_map->build_type);
	$dest_map->file_template($src_map->file_template);
	$dest_map->is_preferred($src_map->is_preferred);
}

1;

