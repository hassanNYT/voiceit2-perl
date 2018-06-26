package voiceIt2;

require LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use HTTP::Request::Common qw(DELETE);
use HTTP::Request::Common qw(PUT);
use HTTP::Request::Common qw(GET);

my $self;
my $baseUrl = 'https://api.voiceit.io';
my $apiKey;
my $apiToken;
use strict;

sub new {
    my $package = shift;
    ($apiKey, $apiToken) = @_;
    $self = bless({apiKey => $apiKey, apiToken => $apiToken}, $package);
    return $self;
  }

  sub getAllUsers() {
    shift;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/users';
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub createUser() {
    shift;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/users';
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub getUser(){
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/users/'.$usrId;
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub deleteUser(){
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = DELETE $baseUrl.'/users/'.$usrId;
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub getGroupsForUser(){
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/users/'.$usrId.'/groups';
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub getAllGroups(){
    shift;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/groups';
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }


  sub getGroup(){
    shift;
    my ($groupId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/groups/'.$groupId;
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
}

sub groupExists(){
  shift;
  my ($groupId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = GET $baseUrl.'/groups/'.$groupId.'/exists';
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub createGroup(){
  shift;
  my ($des)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/groups', Content => [
      description => $des
  ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub addUserToGroup(){
  shift;
  my ($grpId, $usrId)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = PUT $baseUrl.'/groups/addUser',
    Content => [
        groupId => $grpId,
        userId => $usrId,
    ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub removeUserFromGroup(){
  shift;
  my ($grpId, $usrId)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = PUT $baseUrl.'/groups/removeUser',
    Content => [
        groupId => $grpId,
        userId => $usrId,
    ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub deleteGroup(){
  shift;
  my ($grpId)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = DELETE $baseUrl.'/groups/'.$grpId;
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub getAllEnrollmentsForUser(){
  shift;
  my ($usrId)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = GET $baseUrl.'/enrollments/'.$usrId;
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub getAllFaceEnrollmentsForUser(){
  shift;
  my ($usrId)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = GET $baseUrl.'/enrollments/face/'.$usrId;
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub createVoiceEnrollment(){
  shift;
  my ($usrId, $lang, $filePath) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/enrollments', Content_Type => 'form-data',  Content => [
        recording => [$filePath],
        userId => $usrId,
        contentLanguage => $lang,
    ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub createVoiceEnrollmentByUrl(){
  shift;
  my ($usrId, $lang, $fileUrl) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/enrollments/byUrl', Content_Type => 'form-data',  Content => [
        fileUrl => $fileUrl,
        userId => $usrId,
        contentLanguage => $lang,
    ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub createFaceEnrollment(){
  shift;
  my $blink = 0;
  my ($usrId, $filePath, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/enrollments/face', Content_Type => 'form-data',  Content => [
        video => [$filePath],
        userId => $usrId,
        doBlinkDetection => $blink
    ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub createVideoEnrollment(){
  shift;
  my $blink = 0;
  my ($usrId, $lang, $filePath, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/enrollments/video', Content_Type => 'form-data', Content => [
        video => [$filePath],
        userId => $usrId,
        contentLanguage => $lang,
        doBlinkDetection => $blink
  ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub deleteAllEnrollmentsForUser() {
  shift;
  my ($usrId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = DELETE $baseUrl.'/enrollments/'.$usrId."/all", Content_Type => 'form-data';
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub deleteFaceEnrollment(){
  shift;
  my ($usrId, $faceEnrollmentId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = DELETE $baseUrl.'/enrollments/face/'.$usrId."/".$faceEnrollmentId, Content_Type => 'form-data';
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}


sub deleteEnrollment(){
  shift;
  my ($usrId, $enrollmentId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = DELETE $baseUrl.'/enrollments/'.$usrId."/".$enrollmentId, Content_Type => 'form-data';
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub voiceVerification(){
  shift;
  my ($usrId, $lang, $filePath) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/verification', Content_Type => 'form-data', Content => [
        recording => [$filePath],
        userId => $usrId,
        contentLanguage => $lang,
  ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub voiceVerificationByUrl(){
  shift;
  my ($usrId, $lang, $fileUrl) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/verification/byUrl', Content_Type => 'form-data', Content => [
        fileUrl => $fileUrl,
        userId => $usrId,
        contentLanguage => $lang,
  ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub faceVerification(){
  shift;
  my $blink = 0;
  my ($usrId, $filePath, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/verification/face', Content_Type => 'form-data', Content => [
        video => [$filePath],
        userId => $usrId,
        doBlinkDetection => $blink
  ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub videoVerification(){
  shift;
  my $blink = 0;
  my ($usrId, $lang, $filePath, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/verification/video', Content_Type => 'form-data', Content => [
        video => [$filePath],
        userId => $usrId,
        contentLanguage => $lang,
        doBlinkDetection => $blink
  ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}


sub videoVerificationByUrl(){
  shift;
  my $blink = 0;
  my ($usrId, $lang, $fileUrl, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/verification/video/byUrl', Content_Type => 'form-data', Content => [
        fileUrl => $fileUrl,
        userId => $usrId,
        contentLanguage => $lang,
        doBlinkDetection => $blink
  ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub voiceIdentification(){
  shift;
  my ($grpId, $lang, $filePath) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/identification', Content_Type => 'form-data', Content => [
        recording => [$filePath],
        groupId => $grpId,
        contentLanguage => $lang,
  ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub voiceIdentificationByUrl(){
  shift;
  my ($grpId, $lang, $fileUrl) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/identification/byUrl', Content_Type => 'form-data', Content => [
        fileUrl => $fileUrl,
        groupId => $grpId,
        contentLanguage => $lang,
  ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub videoIdentification(){
  shift;
  my $blink = 0;
  my ($grpId, $lang, $filePath, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/identification/video', Content_Type => 'form-data', Content => [
        video => [$filePath],
        groupId => $grpId,
        contentLanguage => $lang,
        doBlinkDetection => $blink
  ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}


sub videoIdentificationByUrl(){
  shift;
  my $blink = 0;
  my ($grpId, $lang, $fileUrl, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/identification/video/byUrl', Content_Type => 'form-data', Content => [
        fileUrl => $fileUrl,
        groupId => $grpId,
        contentLanguage => $lang,
        doBlinkDetection => $blink
  ];
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

1;
