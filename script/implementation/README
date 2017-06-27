Algorithm files are prepared for implementation in Dash.js v2.1.1 but can be implemented in different versions as well. 
The default varibale provided by Dash.js are not kept intact. 
These files can be implemented in the same way as BolaRule.js in the folder dash.js/src/streaming/rules/abr/
Buffer capacity can be changed in MediaPlayerModel.js file located at dash.js/src/streaming/models/  by changing BUFFER_TIME_AT_TOP_QUALITY_LONG_FORM (when content is more than 10 minutes), BUFFER_TO_KEEP(when content is less than 10 minutes)
Chnage RICH_BUFFER_THRESHOLD, BUFFER_PRUNING_INTERVAL, DEFAULT_MIN_BUFFER_TIME_FAST_SWITCH, BUFFER_TIME_AT_TOP_QUALITY by setting them equal to buffer capacity, as they are not applicable to ELASTIC,BBA, and QUETRA. 
Verify the actual buffer capity before running the expriment as changing the variables may cause bugs. 
Force install the dash.js player, if it shows error due to spacing and tabing. 
Keep track of Dash.js Github page https://github.com/Dash-Industry-Forum/dash.js for updates on bugs and their fixes. 
