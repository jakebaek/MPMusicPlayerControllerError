# 테스트 환경
1. Xcode v4.3.1 (4E1019)
2. iPhone 3GS iOS v5.1 (9B176)

# 정상 시나리오
##1 MPMusicPlayerControllerError 단독 실행
1. 하단의 play 버튼을 누르면 test.mp3가 재생된다.

##2 iPod 앱에서 노래 재생 후 MPMusicPlayerControllerError 실행
1. iPod 앱(음악)에서 노래 재생
2. MPMusicPlayerControllerError 실행
3. iPod에서 재생중인 음악은 계속 재생되고 있는 상황에서, MPMusicPlayerControllerError 하단의 play 버튼을 누르면 iPod에서 재생되던 곡은 잠시 pause되고 => MPMusicPlayerControllerError의 test.mp3가 재생되고, 재생이 끝나면 => iPod에서 pause된 곡을 resume 시킨다.


# 오류 재현 스텝
1. MPMusicPlayerControllerError 실행
2. iPod 앱 실행
3. iPod 앱 / 앨범 탭(현재 재생 화면이라면 백버튼을 누르고) / 노래 제목 클릭하여 / 노래 재생화면 진입 / 좌상단의 repeatMode를 눌러 1곡 연속재생으로 맞춤(현재 1곡 연속재생이라면 버튼을 다시 눌러 1곡 연속 재생으로 맞춤) / 재생 시간 슬라이더를 중간쯤으로 이동 / 재생 중이던 곡 일시 정지시킴
4. MPMusicPlayerControllerError 으로 돌아옴
5. play 버튼을 누르면 test.mp3가 재생되고 쌩뚱맞게 iPod 앱에서 일시정지 해놓은 음악이 재생됨
6. 실제 코드상에서는 MPMusicPlayerControllerPlaybackStateDidChangeNotification 으로 playbackState의 변경을 감지하는데, 위 시나리오를 수행하면 MPMusicPlayerController 인스턴스의 playbackState값을 MPMusicPlaybackStatePlaying로 가져오고 있음 (실제로 iPod 앱의 음악은 일시정지인 상태임에도 불구하고)
7. 한번에 재현이 안될수도 있으며, 이 때는 3번을 다시 시도하면 됨

# 관련 링크
* http://stackoverflow.com/questions/8854923/did-mpmusicplayercontroller-change-with-ios-5
* https://devforums.apple.com/message/417780#417780
* https://devforums.apple.com/message/560013#560013
