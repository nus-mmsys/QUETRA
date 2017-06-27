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
        bitrateArray, //Array to store bitrate of downloaded segment 
       	av, // last value of throughput 
        bv, // last value of bitrate  
        adapter; //Default 
		
    var slack = []; //Array for storing Buffer slack 
    var slack30 = []; //Array for storing Buffer slack 
    var slack60 = []; //Array for storing Buffer slack 
    var slack120 = []; //Array for storing Buffer slack 
    var slack240 = [];  //Array for storing Buffer slack 
    var count; //For counting number of segments arrived to take decison on every 5th arrival 
    var newQuality; //the requested bitrate 

    function setup() {
        throughputArray = [];
         bitrateArray = [];
        adapter = DashAdapter(context).getInstance();
        count = -1;
        av = 0;
        bv = 0;
        //Array storing Buffer slack according to different buffer capacity for rho in range of 0.5 to 1.2 at the interval of 0.01//
        slack30=[29.25,29.2246,29.1983,29.1712,29.143,29.1139,29.0836,29.0522,29.0195,28.9855,28.95,28.9129,28.8742,28.8336,28.7911,28.7464,28.6994,28.6498,28.5975,28.5421,28.4833,28.4209,28.3543,28.2832,28.2069,28.125,28.0367,27.9411,27.8373,27.7241,27.6001,27.4636,27.3125,27.1444,26.9562,26.744,26.5031,26.2277,25.9103,25.542,25.1119,24.6069,24.0121,23.3115,22.4893,21.5325,20.4347,19.1998,17.8455,16.4048,14.9228,13.451,12.039,10.7266,9.54002,8.4909,7.57875,6.79468,6.12517,5.55493,5.06895,4.65353,4.29676,3.9886,3.72075,3.48639,3.28001,3.09712,2.93406,2.78786,2.65609];
        slack60=[59.25,59.2246,59.1983,59.1712,59.143,59.1139,59.0836,59.0522,59.0195,58.9855,58.95,58.9129,58.8742,58.8336,58.7911,58.7464,58.6994,58.6498,58.5975,58.5421,58.4833,58.4209,58.3543,58.2831,58.2069,58.125,58.0367,57.9411,57.8373,57.7241,57.6,57.4634,57.3122,57.1438,56.955,56.7417,56.4986,56.2189,55.8934,55.5096,55.0503,54.4904,53.7932,52.9034,51.736,50.1614,47.9911,44.984,40.9181,35.7703,29.92,24.1077,19.0476,15.0712,12.1288,9.99749,8.44445,7.2892,6.40712,5.71575,5.16083,4.70615,4.32698,4.006,3.73079,3.49221,3.28339,3.09909,2.93521,2.78854,2.65649];
        slack120=[119.25,119.225,119.198,119.171,119.143,119.114,119.084,119.052,119.02,118.985,118.95,118.913,118.874,118.834,118.791,118.746,118.699,118.65,118.598,118.542,118.483,118.421,118.354,118.283,118.207,118.125,118.037,117.941,117.837,117.724,117.6,117.463,117.312,117.144,116.955,116.742,116.499,116.219,115.893,115.51,115.05,114.489,113.79,112.892,111.697,110.026,107.527,103.433,95.9794,81.9,59.9193,38.0624,24.1326,16.7349,12.6553,10.1631,8.49674,7.3058,6.41242,5.71746,5.16138,4.70633,4.32703,4.00602,3.7308,3.49221,3.28339,3.09909,2.93521,2.78854,2.65649];
        slack240=[239.25,239.225,239.198,239.171,239.143,239.114,239.084,239.052,239.02,238.985,238.95,238.913,238.874,238.834,238.791,238.746,238.699,238.65,238.598,238.542,238.483,238.421,238.354,238.283,238.207,238.125,238.037,237.941,237.837,237.724,237.6,237.463,237.312,237.144,236.955,236.742,236.499,236.219,235.893,235.51,235.05,234.489,233.79,232.892,231.697,230.025,227.52,223.349,215.026,191.972,119.922,48.139,25.1488,16.8318,12.6646,10.1641,8.49683,7.30581,6.41242,5.71746,5.16138,4.70633,4.32703,4.00602,3.7308,3.49221,3.28339,3.09909,2.93521,2.78854,2.65649];


                  

    }


    //Store throughput in array 
    function storeLastRequestThroughputByType(type, throughput) {
      
        throughputArray[type] = throughputArray[type] || [];
        if(throughput < 100000000) //Due to bug in Dash.js, some very high flase throughput were getting reported. Remove it, if bug is fixed in thee impremented version. 
        {
         throughputArray[type].push(throughput);
        }
    }
    
	//Throughput Predection and smoothing 
	/*Just the last throughput*/
     function averageThroughputByType(type) {
        var arrThroughput = throughputArray[type];
        var lenThroughput = arrThroughput.length;
        av = arrThroughput[lenThroughput-1];
        return (av); 
    }
	/////////////////////////////////////////////////////////////////////////
    /*  Average of last three throughput 
	  if (lenThroughput <2) {
             av = arrThroughput[lenThroughput-1];
        }
        else if(lenThroughput == 2){
           av=(arrThroughput[0] +arrThroughput[1])/2;
        }    
       else{
             
             av= (arrThroughput[lenThroughput-1]+arrThroughput[lenThroughput-2]+arrThroughput[lenThroughput-3])/3;
             log ('@@@@@@@@av@@@@@ ' +av + 'length ' + lenThroughput + ' alpha ' + alpha +'curr throughput' + arrThroughput[lenThroughput-1]);
          }
	*/
	//////////////////////////////////////////////////////////////////////////
	/* KAMA
	   if (lenThroughput <2) {
             av = arrThroughput[lenThroughput-1];
        }
 
        else if(lenThroughput == 2){
           av=(arrThroughput[0] +arrThroughput[1])/2;
        } 
      
       else{
             if(lenThroughput<10)
              {
                window = lenThroughput;
              }
              else
              {
                window = 10;
               }
             change = Math.abs(arrThroughput[lenThroughput-1]-arrThroughput[lenThroughput-window]);
             valatality = 0;
             ssc = 0.06452;
             fsc = 0.66667;
              for (let k = lenThroughput-1; k > lenThroughput-window; k--) { 
               valatality = valatality + Math.abs(arrThroughput[k] - arrThroughput[k-1]);
           
               }
               er = Math.abs(change/valatality);
               sc = Math.pow((er*(fsc-ssc)+ssc) ,2)
               av = av + (sc*(arrThroughput[lenThroughput-1] - av));
               
              log ('@@@@@@@@av@@@@@ ' +av + 'length ' + lenThroughput + ' sc ' + sc + ' fsc '+ fsc + ' ssc '+ ssc+  ' change ' + change+ ' volatality '+ valatality + ' curr throughput ' +arrThroughput[lenThroughput-1]);
          }
	*/
	//////////////////////////////////////////////
	/* EMA
	  alpha =0.1;
	  av= (alpha * av) + ( (1 - alpha)* arrThroughput[lenThroughput-1]);
	*/
	/////////////////////////////////////////////
	/* Gradient adaptive EMA
	   for(let i=0;i<lenThroughput;i++)
        {
         sumT = sumT + arrThroughput[i];
        }
        avgT = sumT/lenThroughput;
        mNorm = avgT/(arrTimeThroughput[lenThroughput-1] - arrTimeThroughput[0]);
        mInst = Math.abs(arrThroughput[lenThroughput-1]-arrThroughput[lenThroughput-2])/(arrTimeThroughput[lenThroughput-1]-arrTimeThroughput[lenThroughput-2]);
        alpha = Math.pow(alphaMax,(mInst/mNorm));
	*/
	/////////////////////////////////////////////////////
	/* LOW Pass EMA 
	   for(let i=0;i<lenThroughput;i++)
        {
               sumT = sumT + arrThroughput[i];
        }
        avgT = sumT/lenThroughput;
        mNorm = avgT/(arrTimeThroughput[lenThroughput-1] - arrTimeThroughput[0]);
        mInst = Math.abs(arrThroughput[lenThroughput-1]-arrThroughput[lenThroughput-2])/(arrTimeThroughput[lenThroughput-1]-arrTimeThroughput[lenThroughput-2]);
        alpha = (1/(1+(mInst/mNorm)));
	  
	*/

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
        let bestR; // the bitrate to be requested 
        var buff = dashMetrics.getCurrentBufferLevel(metrics) ? dashMetrics.getCurrentBufferLevel(metrics) : 0.0; //buffer occupancy 
        let bitrate = mediaInfo.bitrateList.map(b => b.bandwidth); //Array containing list of available bitrates in sorted order
        let bitrateCount = bitrate.length; //Bitrate array length 
        var rhoArray = []; // Array to store RHO value corresponds to available bitrates
        var buffArray = [];  // Array to store buffer slack value corresponds to available bitrates
        var rho,rhof = 0; //temperoray variables 
        var i,j,s,X,minDiff,minIndex; //temperoray variables 
        let trackInfo = rulesContext.getTrackInfo();
        let fragmentDuration = trackInfo.fragmentDuration; //Default 
        mediaPlayerModel = MediaPlayerModel(context).getInstance(); //Default 
         
        count = count + 1; //Counting number of segments arrived to take decison on every 5th arrival 

        if (duration >= mediaPlayerModel.getLongFormContentDurationThreshold()) {
            bufferMax = mediaPlayerModel.getBufferTimeAtTopQualityLongForm();
         } else {
            bufferMax = mediaPlayerModel.getBufferTimeAtTopQuality();
         }
     
   
           //Chose correct slack array//
          if(bufferMax==30)
          {
            slack=slack30;
          }
          else if(bufferMax==60)
          {
            slack=slack60;
          }
          else if(bufferMax==120)
          {
            slack=slack120;
          }
          else if(bufferMax==240)
          {
            slack=slack240;
          }

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
       
        
    //////////////////////////////////////////////////////////////////////rho for ach avalable bitrate ////////////////////		
		
		
		
		for (i = 0; i < bitrate.length; i++) { 
              let ab = (bitrate[i]/1000);
              rhoArray[i] = av/ab;
             }  

           
    
             

 
    /////////////////////////////////Slack for each bitrate/////////////////////////////////////////////////////////////////////////////////////////////// 
    
        for (i = 0; i < bitrate.length; i++) {
        rho =rhoArray[i];
        var slackIndex=0
         
         if(rho<0.5)
         {
          buffArray[i]=bufferMax;
         }
         else if(rho >=1.2)
         {
          buffArray[i] = 0;
         }
         else{
          slackIndex=Math.floor((rho-0.5)/0.01);
           buffArray[i] = slack[slackIndex];
         }
   
        }
    ////////////////////////////////////////Selecting Bitrate whos slack is neares to current buffer occupancy////////////////////////////////////////////////////////////////////////////////////



        for (i = 0; i < bitrate.length; i++) { 
            
           log('$$$$$$  rho i ' + rhoArray[i] + ' predected array ' + buffArray[i]);
        }
            
        minIndex = 0;
        minDiff =Math.abs(buff-buffArray[minIndex]);
        for (i = 1; i < bitrate.length; i++) { 
           if( Math.abs(buff-buffArray[i])<=minDiff)
           {
             minIndex = i;
             minDiff =Math.abs(buff-buffArray[minIndex]);
             log('$$$$$$  newmin ' + minIndex + ' predected array ' + buffArray[minIndex]);
           }
           
        } 

        if( buffArray[minIndex]== bufferMax && buffArray[bitrate.length-1] == buffArray[0]) //If slack for all bitrate is equal to max buffer capacity, choose minimum bitrate as it means buffer is empty
         {
              minIndex=0;
         }
    
        if( buff<(90/240)*bufferMax) //Same lower resrvior maintainence as  BBA
         {
              minIndex=0;
              log('underflow prevention, Current Buffer '+buff)
         }

         rhof = rhoArray[minIndex];
         abrController.setAverageThroughput(mediaType, lastRequestThroughput);
 
     

        if (abrController.getAbandonmentStateFor(mediaType) !== AbrController.ABANDON_LOAD) {
		    if (bufferStateVO.state === BufferController.BUFFER_LOADED || isDynamic) {
                if (count % 5 == 0 || buff<(90/240)*bufferMax){               
                    bestR = Math.ceil(bitrate[minIndex]/1000);
                    newQuality = abrController.getQualityForBitrate(mediaInfo, bestR);
                }
                streamProcessor.getScheduleController().setTimeToLoadDelay(0); // TODO Watch out for seek event - no delay when seeking.!!
			    switchRequest = SwitchRequest(context).create(newQuality, SwitchRequest.STRONG);
			    callback(switchRequest);
		    }

		    if (switchRequest.value !== SwitchRequest.NO_CHANGE && switchRequest.value !== current) {
		        log('Quetra requesting switch to index: ', switchRequest.value, 'type: ',mediaType, ' Priority: ',
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

Quetra.__dashjs_factory_name = 'Quetra';
export default FactoryMaker.getClassFactory(Quetra);
