
function SetDefaultTarget(target,i){
	try{
		document.getElementById(target+i).className="ha";
		document.getElementById(target+i).getElementsByTagName("span")[0].className="hb";
		document.getElementById(target+i).getElementsByTagName("a")[0].className="hc";
	}catch(e){}
}
function SetUserTarget(target, i) {
document.getElementById(target+i).className="selectedLava";
}
function SetDefault(i){
	SetDefaultTarget('tag',i);
}
function SetDefault2(i){
	SetDefaultTarget('tagg',i);
}
function SetUser(i) {
SetUserTarget('tagg',i);
}

function SetShopTarget(target, i) {
document.getElementById(target+i).className="selectedLava";
}
function SetShop(i) {
SetUserTarget('tags',i);
}
