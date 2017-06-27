import SwitchRequest from '../SwitchRequest.js';
import BufferController from '../../controllers/BufferController.js';
import AbrController from '../../controllers/AbrController.js';
import SwitchRequest from '../SwitchRequest.js';
import BufferController from '../../controllers/BufferController.js';
import AbrController from '../../controllers/AbrController.js';
import {HTTPRequest} from '../../vo/metrics/HTTPRequest'; //Variable name is different in different version of Dash.js
import FactoryMaker from '../../../core/FactoryMaker.js';
import Debug from '../../../core/Debug.js';
import DashAdapter from '../../../dash/DashAdapter.js';
import BufferLevel from '../../vo/metrics/BufferLevel.js';
import MediaPlayerModel from '../../models/MediaPlayerModel.js';


function Quetra(config) {

    let context = this.context; //Default 
    let log = Debug(context).getInstance().log; //To write debug log 
    let dashMetrics = config.dashMetrics; //Default 
    let metricsModel = config.metricsModel; //Default 
    let bufferMax; //To store buffer capacity 
    let mediaPlayerModel; //Default 
    let instance,
        throughputArray, //Array to store segment download throughput 
        fragmentDict, //Default 
        av, //last throughput 
        adapter, //Default 
        qT, //Variable as in ELASTIC paper 
        qI; //Variable as in ELASTIC paper 


  
    
    function setup() {
        throughputArray = [];
        throughputTimeArray = [];
        fragmentDict = {};
        adapter = DashAdapter(context).getInstance();
        qT=0;
        qI=0;
                 
        
    }

    //Store throughput in array 
    function storeLastRequestThroughputByType(type, throughput) {
      
        throughputArray[type] = throughputArray[type] || [];
        if(throughput < 100000000) //Due to bug in Dash.js, some very high flase throughput were getting reported. Remove it, if bug is fixed in thee impremented version. 
        {
         throughputArray[type].push(throughput);
        }
    }
     /* Retuen last throughput as required in ELASTIC */ 
     function averageThroughputByType(type) {
        var arrThroughput = throughputArray[type];
        var lenThroughput = arrThroughput.length;
        av= (arrThroughput[lenThroughput-1]);
        return (av); 
    }








    function execute (rulesContext, callback) {
        var downloadTime; //Default 
        var bytes; //Default 
        var averageThroughput; //Default 
        var lastRequestThroughput; //Default 
        var mediaInfo = rulesContext.getMediaInfo(); //Default 
        var mediaType = mediaInfo.type; //Default 
        var current = rulesContext.getCurrentValue(); //Default 
        var metrics = metricsModel.getReadOnlyMetricsFor(mediaType); //Default 
        var streamProcessor = rulesContext.getStreamProcessor(); //Default 
        var abrController = streamProcessor.getABRController(); //Default 
        var isDynamic = streamProcessor.isDynamic(); //Default 
        var lastRequest = dashMetrics.getCurrentHttpRequest(metrics);
        var bufferStateVO = (metrics.BufferState.length > 0) ? metrics.BufferState[metrics.BufferState.length - 1] : null; //Default 
        var bufferLevelVO = (metrics.BufferLevel.length > 0) ? metrics.BufferLevel[metrics.BufferLevel.length - 1] : null; //Default 
        var switchRequest = SwitchRequest(context).create(SwitchRequest.NO_CHANGE, SwitchRequest.WEAK);
        let streamInfo = rulesContext.getStreamInfo(); //Stram information       
        let duration = streamInfo.manifestInfo.duration; //Duration of video 
        let tt = adapter.getIndexHandlerTime(rulesContext.getStreamProcessor()).toFixed(3); //Currently Playing time 
        let bestR; // the bitrate suggested 
        var fragmentInfo; //Default 
        var newQuality; //Bitrate requested 
        var buff = dashMetrics.getCurrentBufferLevel(metrics) ? dashMetrics.getCurrentBufferLevel(metrics) : 0.0; //Current Buffer Occupancy 
        let bitrate = mediaInfo.bitrateList.map(b => b.bandwidth); //Array containing list of available bitrates in sorted order
        let bitrateCount = bitrate.length; //Bitrate array length 
        var i,j,s,X,buffI,play,d, getQ; //Temp variables
        
        let trackInfo = rulesContext.getTrackInfo();
        let fragmentDuration = trackInfo.fragmentDuration;
        mediaPlayerModel = MediaPlayerModel(context).getInstance();
        playbackController = PlaybackController(context).getInstance();

        if (duration >= mediaPlayerModel.getLongFormContentDurationThreshold()) {
            bufferMax = mediaPlayerModel.getBufferTimeAtTopQualityLongForm();
         } else {
            bufferMax = mediaPlayerModel.getBufferTimeAtTopQuality();
         }

         
         play = playbackController.isPaused();
         /*Value of d(t) as in ELAASTIC paper */
         if (play == false)
         {
            d=1;
          }
         else
          {
            d=0;
          }
       
          qT = bufferMax/(2*fragmentDuration); //Target buffer as half of buffer capacity in terms of number of segments 
          getQ = buff/fragmentDuration;
           

          //DASH.js way of getting throughput//
        if (!metrics || !lastRequest || lastRequest.type !== HTTPRequest.MEDIA_SEGMENT_TYPE ||
            !bufferStateVO || !bufferLevelVO ) {
            callback(switchRequest);
            return;
        }

    
        let downloadTimeInMilliseconds;

        if (lastRequest.trace && lastRequest.trace) {

            downloadTimeInMilliseconds = lastRequest._tfinish.getTime() - lastRequest.tresponse.getTime() + 1; 
  
            const bytes = lastRequest.trace.reduce((a, b) => a + b.b[0], 0);
            lastRequestThroughput = Math.round((bytes * 8) / (downloadTimeInMilliseconds / 1000));
            storeLastRequestThroughputByType(mediaType, lastRequestThroughput);
              }

        av=averageThroughputByType(mediaType)/1000;
        qI = qI + downloadTime *(getQ-qT);
        bestR = (lastRequestThroughput/(d-(0.01*getQ)-(0.0001*qI))); /*kp value i.e 0.01 is same as in paper. ki is modified as 0.0001 to vaois negative values of bitrate*/
		
     	if (abrController.getAbandonmentStateFor(mediaType) !== AbrController.ABANDON_LOAD) {
		    if (bufferStateVO.state === BufferController.BUFFER_LOADED || isDynamic) {
             newQuality = abrController.getQualityForBitrate(mediaInfo, bestR);
             streamProcessor.getScheduleController().setTimeToLoadDelay(0); // TODO Watch out for seek event - no delay when seeking.!!
			 switchRequest = SwitchRequest(context).create(newQuality, SwitchRequest.STRONG);
			 callback(switchRequest);
		    }

		    if (switchRequest.value !== SwitchRequest.NO_CHANGE && switchRequest.value !== current) {
		        log('ELASTIC requesting switch to index: ', switchRequest.value, 'type: ',mediaType, ' Priority: ',
		            switchRequest.priority === SwitchRequest.DEFAULT ? 'Default' :
		                switchRequest.priority === SwitchRequest.STRONG ? 'Strong' : 'Weak', 'Average throughput', Math.round(averageThroughput), 'kbps');
		    }
        }

        
    }




    function reset() {
        setup();
    }

    instance = {
        execute: execute,
        reset: reset
    };

    setup();
    return instance;

}

ELASTIC.__dashjs_factory_name = 'ELASTIC';
export default FactoryMaker.getClassFactory(ELASTIC);
