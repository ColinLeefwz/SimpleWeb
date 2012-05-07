iws=false;
function shlist(){
    document.getElementById("t_select-list").style.display=document.getElementById("t_select-list").style.display=="block"?"none":"block";
}
function changesever(ts, login_by){
    document.getElementById("t_selected").innerHTML=""+ts.innerHTML+"";
    shlist();
    document.getElementById("login_by").value=login_by;
}
function cws(val){
    iws=val;
}
function hlist(){
    if(!iws)document.getElementById("t_select-list").style.display="none";
}
