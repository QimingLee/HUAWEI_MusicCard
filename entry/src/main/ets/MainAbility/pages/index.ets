import Sing from '../data/Sing';
import formProvider from '@ohos.application.formProvider';
import formBindingData from '@ohos.application.formBindingData';
import commonEvent from '@ohos.commonEvent';
import media from '@ohos.multimedia.media';


@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  player: media.AudioPlayer;
  mySubscriber;
  playList: Sing[] = [new Sing('song 1', 'singer1', '/system/media/audio/ringtones/Bounce.ogg', '/common/album.png'),
  new Sing('song 2', 'singer2', '/system/media/audio/ringtones/Dream.ogg', '/common/album2.png')];
  index: number = 0;

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }

  aboutToAppear() {
    console.info('aboutToAppear start');
    this.player = media.createAudioPlayer();
    this.player.src = this.playList[this.index].singSrc;
    this.player.on('play', () => {
      console.info('play back');
    });
    this.player.on('pause', () => {
      console.info('pause back');
    })
    if (this.mySubscriber == null) {
      this.createSubscriber();
    }
  }

  aboutToDisappear() {
    console.info('aboutToDisappear start');
    commonEvent.unsubscribe(this.mySubscriber, (err) => {
      if (err != null) {
        console.error('UnsubscribeCallBack err: ' + JSON.stringify(err));
      } else {
        console.log("Unsubscribe success")
        this.mySubscriber = null;
      }
    })
  }

  createSubscriber() {
    console.info('createSubscriber start');
    var subscribeInfo = {
      events: ["event.musicLab"],
    }
    commonEvent.createSubscriber(subscribeInfo).then((data) => {
      console.info('createSubscriber success');
      this.mySubscriber = data;
      this.subscribe();
    }).catch((error) => {
      console.error('createSubscriber failed because: ' + JSON.stringify(error));
    });
  }

  subscribe() {
    if (this.mySubscriber != null) {
      console.info("commonEvent subscribe start ");
      commonEvent.subscribe(this.mySubscriber, (err, data) => {
        if (err != null) {
          console.error("commonEvent.subscribe error because: " + JSON.stringify(err));
          return;
        } else {
          console.info("commonEvent subscribe success data:" + JSON.stringify(data));
          let params = data.parameters;
          let updateData;
          if (params.message === "play") {
            console.info("play music");
            updateData = {
              "isPause": "false"
            };
            this.player.play();
          }
          ;
          if (params.message === "pause") {
            console.info("pause music");
            updateData = {
              "isPause": "true"
            };
            this.player.pause();
          }
          ;
          if (params.message === "play_next") {
            this.playNext();
            updateData = {
              "songName": this.playList[this.index].songName,
              "singerName": this.playList[this.index].singerName,
              "songAlbum": this.playList[this.index].songAlbum,
              "isPause": "true"
            };
          }
          ;
          if (params.message === "play_pre") {
            this.playPre();
            updateData = {
              "songName": this.playList[this.index].songName,
              "singerName": this.playList[this.index].singerName,
              "songAlbum": this.playList[this.index].songAlbum,
              "isPause": "true"
            };
          }
          ;

          let obj = formBindingData.createFormBindingData(updateData);
          return formProvider.updateForm(params.formId, obj)
        }
      })
    } else {
      console.info("this.mySubscriber is null");
    }
  }

  onInit() {
    console.info('page onInit');
    this.player = media.createAudioPlayer();
    this.player.src = this.playList[this.index].singSrc;
    this.player.on('play', () => {
      console.info('play back');
    });
    this.player.on('pause', () => {
      console.info('pause back');
    });
    if (this.mySubscriber === null) {
      this.createSubscriber();
    }
  }

  playPre() {
    this.player.reset();
    console.info('previous music');
    if (this.index === 0) {
      this.index = this.playList.length - 1;
    } else {
      this.index--;
    }
    this.player.src = this.playList[this.index].singSrc;
  }

  playNext() {
    this.player.reset();
    console.info('next music');
    if (this.index === this.playList.length - 1) {
      this.index = 0;
    } else {
      this.index++;
    }
    this.player.src = this.playList[this.index].singSrc;
  }

//  onDestroy() {
//    console.info('page onDestroy');
//    if (this.mySubscriber != null) {
//      commonEvent.unsubscribe(this.mySubscriber, (err, data) => {
//        if (err != null) {
//          console.error('commonEvent unsubscribe failed because: ' + JSON.stringify(err));
//        } else {
//          console.info('unsubscribe success ' + JSON.stringify(data));
//        }
//      });
//    }
//  }
}