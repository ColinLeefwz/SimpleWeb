// -----------
dface_var={}

function dface_init(sid, uid){
    dface_var.sid = sid;
    dface_var.uid = uid;
    dface_var.gid = 3;
}

function dface_close(){
    try{
        window.location = "dface://close";
    }catch(e){
        alert(e)
    }
}

function dface_restart(){
    $('#gameRank').remove();
    window.close();
    restartgame();
}

function rank_close(){
  $('#Main').css("display","none");
  restartgame();
}

function close_window(){
  $('#Main').css("display","none");
}


//---------------------- 