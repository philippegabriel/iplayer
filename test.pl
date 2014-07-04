#!/usr/bin/perl
#extracted from get-iplayer at: 
#https://github.com/dinkypumpkin/get_iplayer/blob/master/get_iplayer
use File::stat;
use MP3::Tag;
$debug=1;
%tags;
($filename) = @ARGV;
@m4aTags=qw(cprt      ©nam  ©ART   aART        ©alb  ©grp     ©wrt     ©gen  trkn     ©lyr   ©cmt    ©day);
@hashTag=qw(copyright title artist albumArtist album grouping composer genre tracknum lyrics comment date);
@m4aHash{@hashTag}=@m4aTags;
#fetch tags from tag file
foreach(@hashTag){
	 $tags{$_}= `sed -n -e 's/^Atom "$m4aHash{$_}" contains: //p' < $filename.tag`;
}
#fetch EPISODE & SERIES
$tags{lyrics}.=`sed -n '/EPISODE/,+2p' < $filename.tag`;
$tags{lyrics}.=`sed -n '/SERIES/,+2p'  < $filename.tag`;

#extract year,date,time
($year,$month,$day,$hour,$min)= $tags{date} =~ m/^(\d\d\d\d)-(\d\d)-(\d\d).(\d\d):(\d\d):/g;
$tags{year}=$year;$tags{date}=$day.$month;$tags{time}=$hour.$min;
#$debug and map{print "$_ => $tags{$_}\n";}keys %tags;
push(@hashTag,qw(year time));
@mp3tags=('TCOP','TIT2','TPE1','TPE2','TALB','TIT1','TCOM','TCON','TRCK','USLT','COMM(eng,#0)[]','TDAT','TYER','TIME');
@mp3Hash{@hashTag}=@mp3tags;
#$debug and map{print "$_ => $mp3Hash{$_}\n";}keys %mp3Hash;
#
# remove existing tag(s) from mp3 to avoid decoding errors
my $mp3 = MP3::Tag->new("$filename.mp3");
$mp3->get_tags();
$mp3->{ID3v1}->remove_tag() if exists $mp3->{ID3v1};
$mp3->{ID3v2}->remove_tag() if exists $mp3->{ID3v2};
$mp3->close();
# add tags to mp3
$mp3 = MP3::Tag->new("$filename.mp3");
foreach(@hashTag){
	$mp3->select_id3v2_frame_by_descr($mp3Hash{$_}, $tags{$_})
};
# add artwork if available
if ( -f "$filename.jpg") {
	my $data;
	open(THUMB, "<:raw", "$filename.jpg");
	read(THUMB, $data, stat("$filename.jpg")->size());
	close(THUMB);
	$mp3->select_id3v2_frame_by_descr('APIC', $data);
}
# write metadata to file
$mp3->update_tags();
$mp3->close();
exit 0;




