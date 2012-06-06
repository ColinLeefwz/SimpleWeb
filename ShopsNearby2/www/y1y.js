var acc_watchID = null;

function acc_startWatch(shakedCallback) {
    var oldx=null,oldy=null,oldz=null,oldt=null;
    var yiy_status="init";
    acc_watchID = navigator.accelerometer.watchAcceleration(
                            acc_onSuccess, acc_onError, { frequency: 500 });
    //alert(acc_watchID);
    
    function report_acc(acceleration){
        var element = document.getElementById('accelerometer');
        element.innerHTML = 'Acceleration X: ' + acceleration.x + '<br />' +
        'Acceleration Y: ' + acceleration.y + '<br />' +
        'Acceleration Z: ' + acceleration.z + '<br />' + 
        'Timestamp: '      + acceleration.timestamp + '<br />'+
        'status:' + yiy_status;
    }
    
    function diff_acc(acceleration){
        var ret = Math.abs(acceleration.x - oldx)+Math.abs(acceleration.y - oldy)+ Math.abs(acceleration.z - oldz);
        //alert(ret);
        return ret;
    }
    
    function shaked(acceleration){
        if(device.platform=="Android"){
            diff_acc(acceleration)>10;
        }
        return diff_acc(acceleration)>1;
    }
	
    function save_acc(acceleration) {
        oldx=acceleration.x;
        oldy=acceleration.y;
        oldz=acceleration.z
        oldt=acceleration.timestamp;
    }
    function acc_onSuccess(acceleration) {
        if(yiy_status=="init"){
            save_acc(acceleration);
            yiy_status="listen";
        }else if(yiy_status=="listen"){
            if(shaked(acceleration)){
                yiy_status="active"
            }
            save_acc(acceleration);
        }else if(yiy_status=="active"){
            if(shaked(acceleration)){
                yiy_status="done";
                if(shakedCallback()){
                   acc_stopWatch(); 
                }else{
                    yiy_status="init";
                }
            }else{
                //if(acceleration.timestamp-oldt>1000) yiy_status="init";
                save_acc(acceleration);
            }
        }
        //report_acc(acceleration);
    }
    
    function acc_onError() {
        alert('no acceleremeter!');
    }
}

function acc_stopWatch() {
    if (acc_watchID) {
        navigator.accelerometer.clearWatch(watchID);
        watchID = null;
    }
}
            

