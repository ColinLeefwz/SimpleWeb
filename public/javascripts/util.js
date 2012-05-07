function onlyInNum(evt) {
    var charCode;
    if (window.event) {
        charCode = evt.code;
    } else if (evt.which) {
        charCode = evt.which;
    }
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}   

function onlyInFloat(evt) {
var charCode;
    if (window.event) {
        charCode = evt.code;
    } else if (evt.which) {
        charCode = evt.which;
    }
    if (((charCode > 31 && charCode < 46) || charCode > 46) && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

function onlyTel(evt) {
var charCode;
    if (window.event) {
	charCode = evt.code;
} else if (evt.which) {
	charCode = evt.which;
}
   if (((charCode > 31 && charCode < 45) || charCode > 45) && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

function returnChar(evt) {
var charCode;
    if (window.event) {
        charCode = evt.code;
    } else if (evt.which) {
        charCode = evt.which;
    }
    alert(charCode);
}

function phone_validate(p_id) {
    var p = document.getElementById(p_id).value;
    var patrn = /^0?1((3)|(5)|(8))\d{9}$/;
    if(!patrn.exec(p)) {
       return false;
    } else {
       return true;
    }
}

function clean_0text(ele) {
  if (parseInt(ele.value) == 0) {
     ele.value = '';
  }
}
